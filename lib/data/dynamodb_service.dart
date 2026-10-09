import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/fill_entry.dart';
import '../services/settings_service.dart';
import 'database.dart';

class DynamoDBService {
  static const String _service = 'dynamodb';
  static const int _batchSize = 25; // DynamoDB BatchWriteItem limit

  final SettingsService _settingsService;
  final http.Client _httpClient;

  DynamoDBService(this._settingsService, [http.Client? httpClient])
      : _httpClient = httpClient ?? http.Client();

  /// Check that AWS credentials and configuration are present
  Future<bool> initialize() async {
    try {
      return await _settingsService.validateAwsConfiguration();
    } catch (_) {
      return false;
    }
  }

  /// Put an entry in DynamoDB, retrying transient failures with backoff
  Future<DynamoDbOpResult> putItem(FillEntry entry) =>
      _withRetry(() => _putItemOnce(entry));

  Future<DynamoDbOpResult> _putItemOnce(FillEntry entry) async {
    final request = await _buildSignedRequest(
      body: _createPutItemPayload(entry, _settingsService.getDynamoDbTableName()),
      target: 'DynamoDB_20120810.PutItem',
    );
    final response = await _send(request);
    if (response.statusCode == 200) {
      return const DynamoDbOpResult(success: true);
    }
    return DynamoDbOpResult(
      success: false,
      error: _describeAwsError(
        response,
        tableName: _settingsService.getDynamoDbTableName(),
        region: _settingsService.getAwsRegion(),
      ),
    );
  }

  /// Get an entry by id
  Future<FillEntry?> getItem(String id) async {
    try {
      final request = await _buildSignedRequest(
        body: _createGetItemPayload(id, _settingsService.getDynamoDbTableName()),
        target: 'DynamoDB_20120810.GetItem',
      );
      final response = await _send(request);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('Item')) {
          return _fillEntryFromDynamoDBItem(data['Item']);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Query entries for a partition key
  Future<List<FillEntry>> queryItems({String? partitionKey}) async {
    try {
      final request = await _buildSignedRequest(
        body: _createQueryPayload(
          tableName: _settingsService.getDynamoDbTableName(),
          partitionKey: partitionKey,
        ),
        target: 'DynamoDB_20120810.Query',
      );
      final response = await _send(request);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('Items')) {
          return (data['Items'] as List)
              .map((item) => _fillEntryFromDynamoDBItem(item))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Verify credentials and table via DescribeTable; the result message is
  /// safe to show verbatim (this is a developer-facing feature).
  Future<DynamoDbTestResult> testConnection() async {
    final tableName = _settingsService.getDynamoDbTableName();
    final region = _settingsService.getAwsRegion();
    try {
      final request = await _buildSignedRequest(
        body: jsonEncode({'TableName': tableName}),
        target: 'DynamoDB_20120810.DescribeTable',
      );
      final response = await _send(request);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = (data['Table']?['TableStatus'] ?? 'ACTIVE').toString();
        return DynamoDbTestResult(
          success: true,
          message: "Connected. Table '$tableName' is $status in $region.",
          statusCode: 200,
        );
      }
      return DynamoDbTestResult(
        success: false,
        statusCode: response.statusCode,
        message: _describeAwsError(response, tableName: tableName, region: region),
      );
    } on StateError catch (e) {
      return DynamoDbTestResult(
        success: false,
        message: '$e — enter the key ID and secret access key and press '
            'Save before testing.',
      );
    } catch (e) {
      // Network-level failures (SocketException, TimeoutException, TLS, ...)
      return DynamoDbTestResult(
        success: false,
        message: 'Request did not reach AWS: $e',
      );
    }
  }

  /// Turn a non-200 DynamoDB response into a message a user can act on.
  String _describeAwsError(
    http.Response response, {
    String? tableName,
    String? region,
  }) {
    var type = '';
    var message = response.body;
    try {
      final data = jsonDecode(response.body);
      type = (data['__type'] ?? '').toString();
      message = (data['message'] ?? message).toString();
    } catch (_) {
      // Non-JSON body (e.g. a proxy error page); show the raw body below.
    }
    final shortType = type.split('#').last;

    if (response.statusCode == 400 &&
        message.contains('not found') &&
        tableName != null) {
      return "Table '$tableName' not found in $region (HTTP 400 "
          "$shortType). Check the table name and that the region matches "
          "where the table was created — the table must exist in the "
          "account that owns these credentials. AWS said: $message";
    }
    if (response.statusCode == 403 &&
        (shortType.contains('SignatureDoesNotMatch') ||
            shortType.contains('UnrecognizedClient') ||
            shortType.contains('InvalidAccessKeyId'))) {
      return 'AWS rejected the credentials ($shortType). The key ID and '
          'secret should be a matching pair with no stray whitespace, and '
          'a still-active access key. AWS said: $message';
    }
    if (response.statusCode == 403) {
      return 'Access denied ($shortType). The IAM user likely lacks the '
          'required DynamoDB permission on the table ARN (re-apply the '
          'policy from terraform/ if it predates this app version). '
          'AWS said: $message';
    }
    return 'AWS returned HTTP ${response.statusCode}'
        '${type.isEmpty ? '' : ' ($shortType)'}: $message';
  }

  /// Push all unsynced entries; returns the number synced plus the first
  /// error hit (stops there, since the rest would fail the same way).
  Future<({int synced, String? error})> syncUnsyncedEntries(
      DatabaseService databaseService) async {
    final unsyncedEntries = await databaseService.getUnsyncedEntries();
    var syncedCount = 0;
    for (final entry in unsyncedEntries) {
      final result = await putItem(entry);
      if (result.success) {
        await databaseService.markEntryAsSynced(entry.id, DateTime.now());
        syncedCount++;
      } else {
        return (synced: syncedCount, error: result.error);
      }
    }
    return (synced: syncedCount, error: null);
  }

  /// Push pending deletions to DynamoDB; returns the number deleted plus
  /// the first error hit.
  Future<({int deleted, String? error})> syncPendingDeletions(
      DatabaseService databaseService) async {
    final ids = await databaseService.getPendingDeletionIds();
    if (ids.isEmpty) return (deleted: 0, error: null);
    final result = await batchDeleteItems(ids);
    if (result.success) {
      await databaseService.clearPendingDeletions(ids);
      return (deleted: ids.length, error: null);
    }
    return (deleted: 0, error: result.error);
  }

  /// Delete items via BatchWriteItem (chunks of 25), retrying unprocessed
  /// items with backoff. Succeeds only if every item was confirmed.
  Future<({bool success, String? error})> batchDeleteItems(List<String> ids) async {
    var remaining = ids;
    var lastError = 'Deletions did not complete after 3 attempts';
    for (var attempt = 0; attempt < 3 && remaining.isNotEmpty; attempt++) {
      final unprocessed = <String>[];
      for (var start = 0; start < remaining.length; start += _batchSize) {
        final end = min(start + _batchSize, remaining.length);
        final chunk = await _sendBatchDelete(remaining.sublist(start, end));
        unprocessed.addAll(chunk.unprocessed);
        lastError = chunk.error ?? lastError;
      }
      if (unprocessed.isEmpty) return (success: true, error: null);
      remaining = unprocessed;
      await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
    }
    return (success: false, error: lastError);
  }

  /// One BatchWriteItem request; returns the ids not processed (empty on
  /// full success, the whole chunk plus an error if the request failed).
  Future<({List<String> unprocessed, String? error})> _sendBatchDelete(
      List<String> ids) async {
    final tableName = _settingsService.getDynamoDbTableName();
    final body = jsonEncode({
      'RequestItems': {
        tableName: [
          for (final id in ids)
            {
              'DeleteRequest': {
                'Key': {
                  'id': {'S': id}
                }
              }
            }
        ]
      }
    });
    try {
      final request = await _buildSignedRequest(
        body: body,
        target: 'DynamoDB_20120810.BatchWriteItem',
      );
      final response = await _send(request);
      if (response.statusCode != 200) {
        return (
          unprocessed: ids,
          error: _describeAwsError(response,
              tableName: tableName, region: _settingsService.getAwsRegion())
        );
      }
      final data = jsonDecode(response.body);
      final items = data['UnprocessedItems']?[tableName] as List?;
      if (items == null) return (unprocessed: const <String>[], error: null);
      return (
        unprocessed: items
            .map((item) =>
                (item['DeleteRequest'] as Map)['Key']['id']['S'] as String)
            .toList(),
        error: null
      );
    } catch (e) {
      return (unprocessed: ids, error: 'Request did not reach AWS: $e');
    }
  }

  /// Close the HTTP client
  void close() {
    _httpClient.close();
  }

  // ---- AWS Signature V4 ----

  Future<DynamoDbOpResult> _withRetry(
      Future<DynamoDbOpResult> Function() attempt,
      {int retries = 3}) async {
    var last =
        const DynamoDbOpResult(success: false, error: 'Request failed');
    for (var i = 0; i < retries; i++) {
      try {
        last = await attempt();
        if (last.success) return last;
      } on StateError catch (e) {
        // Missing credentials will not fix itself; don't burn retries.
        return DynamoDbOpResult(
            success: false,
            error:
                '$e — enter the key ID and secret access key and press Save '
                    'in Settings.');
      } catch (e) {
        // Network-level failure (SocketException, TimeoutException, TLS, ...).
        last = DynamoDbOpResult(
            success: false, error: 'Request did not reach AWS: $e');
      }
      if (i < retries - 1) {
        await Future.delayed(Duration(seconds: 2 * (i + 1)));
      }
    }
    return last;
  }

  Future<_SignedRequest> _buildSignedRequest({
    required String body,
    required String target,
  }) async {
    final accessKeyId = await _settingsService.getAwsAccessKeyId();
    final secretAccessKey = await _settingsService.getAwsSecretAccessKey();
    if (accessKeyId == null || secretAccessKey == null) {
      throw StateError('AWS credentials not configured');
    }

    final region = _settingsService.getAwsRegion();
    final now = DateTime.now().toUtc();
    final dateStamp = DateFormat('yyyyMMdd').format(now);
    final amzDate = DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(now);

    final headers = <String, String>{
      'Host': 'dynamodb.$region.amazonaws.com',
      'Content-Type': 'application/x-amz-json-1.0',
      'X-Amz-Date': amzDate,
      'X-Amz-Target': target,
    };

    final uri = Uri.parse('https://dynamodb.$region.amazonaws.com/');
    final canonicalRequest =
        _canonicalRequest('POST', uri, headers, body);
    final stringToSign = _stringToSign(canonicalRequest, region, amzDate, dateStamp);
    final signature = _hex(
      crypto.Hmac(crypto.sha256, _signingKey(secretAccessKey, region, dateStamp))
          .convert(utf8.encode(stringToSign))
          .bytes,
    );

    // Signed headers are frozen before the Authorization header exists.
    final signedHeaders = _signedHeaders(headers);
    headers['Authorization'] = 'AWS4-HMAC-SHA256 '
        'Credential=$accessKeyId/$dateStamp/$region/$_service/aws4_request, '
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';

    return _SignedRequest(url: uri.toString(), headers: headers, body: body);
  }

  String _canonicalRequest(
      String method, Uri uri, Map<String, String> headers, String body) {
    return [
      method,
      uri.path.isEmpty ? '/' : uri.path,
      uri.query,
      _canonicalHeaders(headers),
      '',
      _signedHeaders(headers),
      crypto.sha256.convert(utf8.encode(body)).toString(),
    ].join('\n');
  }

  String _canonicalHeaders(Map<String, String> headers) {
    final names = headers.keys.map((k) => k.toLowerCase()).toList()..sort();
    final lookup = {for (final e in headers.entries) e.key.toLowerCase(): e.value};
    return names.map((n) => '$n:${lookup[n]!.trim()}').join('\n');
  }

  String _signedHeaders(Map<String, String> headers) {
    final names = headers.keys.map((k) => k.toLowerCase()).toList()..sort();
    return names.join(';');
  }

  String _stringToSign(
      String canonicalRequest, String region, String amzDate, String dateStamp) {
    return [
      'AWS4-HMAC-SHA256',
      amzDate,
      '$dateStamp/$region/$_service/aws4_request',
      crypto.sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');
  }

  List<int> _signingKey(String secretAccessKey, String region, String dateStamp) {
    final kDate = crypto.Hmac(crypto.sha256, utf8.encode('AWS4$secretAccessKey'))
        .convert(utf8.encode(dateStamp))
        .bytes;
    final kRegion = crypto.Hmac(crypto.sha256, kDate)
        .convert(utf8.encode(region))
        .bytes;
    final kService = crypto.Hmac(crypto.sha256, kRegion)
        .convert(utf8.encode(_service))
        .bytes;
    return crypto.Hmac(crypto.sha256, kService)
        .convert(utf8.encode('aws4_request'))
        .bytes;
  }

  String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  Future<http.Response> _send(_SignedRequest request) {
    return _httpClient.post(
      Uri.parse(request.url),
      headers: request.headers,
      body: request.body,
    );
  }

  // ---- Payloads ----
  // DynamoDB's x-amz-json-1.0 protocol requires typed attribute values
  // ({"S": str}, {"N": num-as-string}); plain scalars are rejected with a
  // ValidationException.

  /// Create PutItem payload
  String _createPutItemPayload(FillEntry entry, String tableName) {
    final item = <String, dynamic>{
      'id': {'S': entry.id},
      'timestamp': {'S': entry.timestamp.toIso8601String()},
      'fuelType': {'S': entry.fuelType},
      'totalCost': {'N': entry.totalCost.toString()},
      'currency': {'S': entry.currency},
      'deviceId': {'S': entry.deviceId},
    };

    // Optional attributes are omitted entirely when null/empty.
    void addString(String field, String? value) {
      if (value != null && value.isNotEmpty) item[field] = {'S': value};
    }

    void addNumber(String field, double? value) {
      if (value != null) item[field] = {'N': value.toString()};
    }

    addString('distanceUnit', entry.distanceUnit);
    addString('capacityUnit', entry.capacityUnit);
    addString('vehicleId', entry.vehicleId);
    addString('syncedAt', entry.syncedAt?.toIso8601String());
    addNumber('odometer', entry.odometer);
    addNumber('fuelAmount', entry.fuelAmount);
    addNumber('batteryLevelBefore', entry.batteryLevelBefore);
    addNumber('batteryLevelAfter', entry.batteryLevelAfter);
    addNumber('energyAdded', entry.energyAdded);
    addString('notes', entry.notes);

    return jsonEncode({
      'TableName': tableName,
      'Item': item,
    });
  }

  /// Create GetItem payload
  String _createGetItemPayload(String id, String tableName) {
    return jsonEncode({
      'TableName': tableName,
      'Key': {
        'id': {'S': id},
      }
    });
  }

  /// Create Query payload
  String _createQueryPayload({
    required String tableName,
    String? partitionKey,
  }) {
    final query = <String, dynamic>{'TableName': tableName};

    if (partitionKey != null) {
      query['KeyConditionExpression'] = 'id = :id';
      query['ExpressionAttributeValues'] = {
        ':id': {'S': partitionKey},
      };
    }

    return jsonEncode(query);
  }

  /// Convert DynamoDB item to FillEntry (unwraps typed attribute values)
  FillEntry _fillEntryFromDynamoDBItem(Map<String, dynamic> item) {
    String string(String field) =>
        (item[field] as Map<String, dynamic>)['S'] as String;
    String? stringOrNull(String field) =>
        (item[field] as Map<String, dynamic>?)?['S'] as String?;
    double? numberOrNull(String field) {
      final value = (item[field] as Map<String, dynamic>?)?['N'];
      return value == null ? null : double.parse(value as String);
    }

    final syncedAt = stringOrNull('syncedAt');
    return FillEntry(
      id: string('id'),
      timestamp: DateTime.parse(string('timestamp')),
      fuelType: string('fuelType'),
      odometer: numberOrNull('odometer'),
      fuelAmount: numberOrNull('fuelAmount'),
      batteryLevelBefore: numberOrNull('batteryLevelBefore'),
      batteryLevelAfter: numberOrNull('batteryLevelAfter'),
      energyAdded: numberOrNull('energyAdded'),
      totalCost: numberOrNull('totalCost') ?? 0.0,
      currency: string('currency'),
      distanceUnit: stringOrNull('distanceUnit'),
      capacityUnit: stringOrNull('capacityUnit'),
      notes: stringOrNull('notes'),
      syncedAt: syncedAt == null ? null : DateTime.parse(syncedAt),
      deviceId: string('deviceId'),
      vehicleId: stringOrNull('vehicleId') ?? '',
    );
  }
}

/// Result of a connection test; [message] is user-facing and debug-ready.
class DynamoDbTestResult {
  final bool success;
  final String message;
  final int? statusCode;

  DynamoDbTestResult({required this.success, required this.message, this.statusCode});
}

/// Result of a single DynamoDB write; [error] is user-facing on failure.
class DynamoDbOpResult {
  final bool success;
  final String? error;

  const DynamoDbOpResult({required this.success, this.error});
}

/// Simple class to hold signed request details
class _SignedRequest {
  final String url;
  final Map<String, String> headers;
  final String body;

  _SignedRequest({
    required this.url,
    required this.headers,
    required this.body,
  });
}
