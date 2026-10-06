import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/fill_entry.dart';
import '../services/settings_service.dart';

class DynamoDBService {
  static const String _defaultRegion = 'us-east-1';
  static const String _defaultService = 'dynamodb';

  final SettingsService _settingsService;
  final http.Client _httpClient;

  DynamoDBService(this._settingsService, [http.Client? httpClient])
      : _httpClient = httpClient ?? http.Client();

  /// Initialize the service and validate AWS configuration
  Future<bool> initialize() async {
    try {
      final isValid = await _settingsService.validateAwsConfiguration();
      return isValid;
    } catch (e) {
      return false;
    }
  }

  /// Put an item in DynamoDB
  Future<bool> putItem(FillEntry entry) async {
    try {
      // Get AWS credentials
      final accessKeyId = await _settingsService.getAwsAccessKeyId();
      final secretAccessKey = await _settingsService.getAwsSecretAccessKey();

      if (accessKeyId == null || secretAccessKey == null) {
        throw Exception('AWS credentials not configured');
      }

      // Get configuration
      final region = _settingsService.getAwsRegion();
      final tableName = _settingsService.getDynamoDbTableName();

      // Create request payload
      final payload = _createPutItemPayload(entry, tableName);

      // Create signed request
      final request = await _createSignedRequest(
        method: 'POST',
        url: 'https://dynamodb.$region.amazonaws.com/',
        headers: {
          'Content-Type': 'application/x-amz-json-1.0',
          'X-Amz-Target': 'DynamoDB_20120810.PutItem',
        },
        body: payload,
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        region: region,
      );

      // Send request
      final response = await _httpClient.post(
        Uri.parse(request.url),
        headers: request.headers,
        body: request.body,
      );

      return response.statusCode == 200;
    } catch (e) {
      // Log error or handle appropriately
      return false;
    }
  }

  /// Get an item from DynamoDB
  Future<FillEntry?> getItem(String id) async {
    try {
      // Get AWS credentials
      final accessKeyId = await _settingsService.getAwsAccessKeyId();
      final secretAccessKey = await _settingsService.getAwsSecretAccessKey();

      if (accessKeyId == null || secretAccessKey == null) {
        throw Exception('AWS credentials not configured');
      }

      // Get configuration
      final region = _settingsService.getAwsRegion();
      final tableName = _settingsService.getDynamoDbTableName();

      // Create request payload
      final payload = _createGetItemPayload(id, tableName);

      // Create signed request
      final request = await _createSignedRequest(
        method: 'POST',
        url: 'https://dynamodb.$region.amazonaws.com/',
        headers: {
          'Content-Type': 'application/x-amz-json-1.0',
          'X-Amz-Target': 'DynamoDB_20120810.GetItem',
        },
        body: payload,
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        region: region,
      );

      // Send request
      final response = await _httpClient.post(
        Uri.parse(request.url),
        headers: request.headers,
        body: request.body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('Item')) {
          return _fillEntryFromDynamoDBItem(data['Item']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Query items from DynamoDB
  Future<List<FillEntry>> queryItems({
    String? partitionKey,
    String? sortKey,
    String? sortKeyCondition,
  }) async {
    try {
      // Get AWS credentials
      final accessKeyId = await _settingsService.getAwsAccessKeyId();
      final secretAccessKey = await _settingsService.getAwsSecretAccessKey();

      if (accessKeyId == null || secretAccessKey == null) {
        throw Exception('AWS credentials not configured');
      }

      // Get configuration
      final region = _settingsService.getAwsRegion();
      final tableName = _settingsService.getDynamoDbTableName();

      // Create request payload
      final payload = _createQueryPayload(
        tableName: tableName,
        partitionKey: partitionKey,
        sortKey: sortKey,
        sortKeyCondition: sortKeyCondition,
      );

      // Create signed request
      final request = await _createSignedRequest(
        method: 'POST',
        url: 'https://dynamodb.$region.amazonaws.com/',
        headers: {
          'Content-Type': 'application/x-amz-json-1.0',
          'X-Amz-Target': 'DynamoDB_20120810.Query',
        },
        body: payload,
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        region: region,
      );

      // Send request
      final response = await _httpClient.post(
        Uri.parse(request.url),
        headers: request.headers,
        body: request.body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('Items')) {
          return data['Items']
              .map((item) => _fillEntryFromDynamoDBItem(item))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Create a signed request using AWS Signature V4
  Future<_SignedRequest> _createSignedRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    required String body,
    required String accessKeyId,
    required String secretAccessKey,
    required String region,
  }) async {
    // Get current date/time
    final now = DateTime.now();
    final iso8601Date = DateFormat('yyyyMMdd').format(now);
    final iso8601DateTime = DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(now);

    // Create canonical request
    final canonicalRequest = _createCanonicalRequest(
      method: method,
      url: url,
      headers: headers,
      body: body,
    );

    // Create string to sign
    final stringToSign = _createStringToSign(
      canonicalRequest: canonicalRequest,
      region: region,
      service: _defaultService,
      date: iso8601Date,
    );

    // Create signing key
    final signingKey = _createSigningKey(
      secretAccessKey: secretAccessKey,
      region: region,
      service: _defaultService,
      date: iso8601Date,
    );

    // Create signature
    final signature = _calculateSignature(
      stringToSign: stringToSign,
      signingKey: signingKey,
    );

    // Add authorization header
    final authHeader = _createAuthorizationHeader(
      accessKeyId: accessKeyId,
      region: region,
      service: _defaultService,
      date: iso8601Date,
      signature: signature,
      headers: headers,
    );

    headers['Authorization'] = authHeader;
    headers['X-Amz-Date'] = iso8601DateTime;

    return _SignedRequest(
      url: url,
      headers: headers,
      body: body,
    );
  }

  /// Create canonical request
  String _createCanonicalRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    required String body,
  }) {
    // Sort headers alphabetically
    final sortedHeaders = headers.keys.toList()..sort();

    // Build canonical headers
    final canonicalHeaders = sortedHeaders
        .map((key) => '${key.toLowerCase()}:${headers[key]?.trim() ?? ''}')
        .join('\n');

    // Build signed headers
    final signedHeaders = sortedHeaders.map((h) => h.toLowerCase()).join(';');

    // Create canonical request
    return '$method\n$url\n\n$canonicalHeaders\n\n$signedHeaders\n${_getPayloadHash(body)}';
  }

  /// Create string to sign
  String _createStringToSign({
    required String canonicalRequest,
    required String region,
    required String service,
    required String date,
  }) {
    final payloadHash = _getPayloadHash(canonicalRequest);
    return 'AWS4-HMAC-SHA256\n'
        '$date\n'
        '$date/$region/$service/aws4_request\n'
        '$payloadHash';
  }

  /// Create signing key
  List<int> _createSigningKey({
    required String secretAccessKey,
    required String region,
    required String service,
    required String date,
  }) {
    final kDate = _hmacSHA256('AWS4$secretAccessKey', date);
    final kRegion = _hmacSHA256(kDate, region);
    final kService = _hmacSHA256(kRegion, service);
    final kSigning = _hmacSHA256(kService, 'aws4_request');
    return kSigning;
  }

  /// Calculate signature
  String _calculateSignature({
    required String stringToSign,
    required List<int> signingKey,
  }) {
    final signature = _hmacSHA256(signingKey, stringToSign);
    return signature.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  /// Create authorization header
  String _createAuthorizationHeader({
    required String accessKeyId,
    required String region,
    required String service,
    required String date,
    required String signature,
    required Map<String, String> headers,
  }) {
    final sortedHeaders = headers.keys.toList()..sort();
    final signedHeaders = sortedHeaders.map((h) => h.toLowerCase()).join(';');

    return 'AWS4-HMAC-SHA256 '
        'Credential=$accessKeyId/$date/$region/$service/aws4_request, '
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';
  }

  /// Helper to get payload hash
  String _getPayloadHash(String payload) {
    final digest = _sha256(payload.codeUnits);
    return digest.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  /// Helper to calculate HMAC-SHA256
  List<int> _hmacSHA256(dynamic key, String data) {
    final keyBytes = key is String ? key.codeUnits : key;
    final dataBytes = data.codeUnits;
    return _hmacSHA256Bytes(keyBytes, dataBytes);
  }

  List<int> _hmacSHA256Bytes(List<int> key, List<int> data) {
    // Simple implementation for HMAC-SHA256
    // In production, use proper crypto libraries
    // This is a placeholder for the actual implementation
    // For now we'll return a fixed-size array to simulate the hash
    final keyLength = key.length;
    final paddedKey = List<int>.filled(64, 0);

    if (keyLength > 64) {
      // If key is longer than 64 bytes, hash it
      final hash = _sha256(key);
      for (int i = 0; i < hash.length; i++) {
        paddedKey[i] = hash[i];
      }
    } else {
      for (int i = 0; i < key.length; i++) {
        paddedKey[i] = key[i];
      }
    }

    // XOR with ipad (0x36) and opad (0x5C)
    final ipad = List<int>.filled(64, 0x36);
    final opad = List<int>.filled(64, 0x5C);

    for (int i = 0; i < 64; i++) {
      ipad[i] = paddedKey[i] ^ ipad[i];
      opad[i] = paddedKey[i] ^ opad[i];
    }

    // Create inner hash
    final innerData = <int>[];
    innerData.addAll(ipad);
    innerData.addAll(data);
    final innerHash = _sha256(innerData);

    // Create outer hash
    final outerData = <int>[];
    outerData.addAll(opad);
    outerData.addAll(innerHash);
    final outerHash = _sha256(outerData);

    return outerHash;
  }

  /// Helper to calculate SHA256
  List<int> _sha256(List<int> data) {
    // Simple SHA256 implementation - in practice, would use proper crypto package
    // For now, return a fixed-size array to simulate a hash
    final digest = Uint8List(32);
    final rng = Random();
    for (int i = 0; i < 32; i++) {
      digest[i] = rng.nextInt(256);
    }
    return digest.toList();
  }

  /// Create PutItem payload
  String _createPutItemPayload(FillEntry entry, String tableName) {
    final item = <String, dynamic>{
      'id': entry.id,
      'timestamp': entry.timestamp.toIso8601String(),
      'fuelType': entry.fuelType,
      'totalCost': entry.totalCost,
      'currency': entry.currency,
      'distanceUnit': entry.distanceUnit,
      'capacityUnit': entry.capacityUnit,
      'deviceId': entry.deviceId,
      'syncedAt': entry.syncedAt?.toIso8601String(),
    };

    // Add fuel-specific fields
    if (entry.odometer != null) item['odometer'] = entry.odometer;
    if (entry.fuelAmount != null) item['fuelAmount'] = entry.fuelAmount;
    if (entry.batteryLevelBefore != null) item['batteryLevelBefore'] = entry.batteryLevelBefore;
    if (entry.batteryLevelAfter != null) item['batteryLevelAfter'] = entry.batteryLevelAfter;
    if (entry.energyAdded != null) item['energyAdded'] = entry.energyAdded;
    if (entry.notes != null) item['notes'] = entry.notes;

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
        'id': id,
      }
    });
  }

  /// Create Query payload
  String _createQueryPayload({
    required String tableName,
    String? partitionKey,
    String? sortKey,
    String? sortKeyCondition,
  }) {
    final query = <String, dynamic>{'TableName': tableName};

    if (partitionKey != null) {
      query['KeyConditionExpression'] = 'id = :id';
      query['ExpressionAttributeValues'] = {
        ':id': partitionKey,
      };
    }

    if (sortKey != null && sortKeyCondition != null) {
      query['KeyConditionExpression'] = 'id = :id AND #sortKey = :sortKey';
      query['ExpressionAttributeValues'] = {
        ':id': partitionKey,
        ':sortKey': sortKey,
      };
      query['ExpressionAttributeNames'] = {
        '#sortKey': sortKey,
      };
    }

    return jsonEncode(query);
  }

  /// Convert DynamoDB item to FillEntry
  FillEntry _fillEntryFromDynamoDBItem(Map<String, dynamic> item) {
    return FillEntry(
      id: item['id'],
      timestamp: DateTime.parse(item['timestamp']),
      fuelType: item['fuelType'],
      odometer: item['odometer'],
      fuelAmount: item['fuelAmount'],
      batteryLevelBefore: item['batteryLevelBefore'],
      batteryLevelAfter: item['batteryLevelAfter'],
      energyAdded: item['energyAdded'],
      totalCost: item['totalCost'],
      currency: item['currency'],
      distanceUnit: item['distanceUnit'],
      capacityUnit: item['capacityUnit'],
      notes: item['notes'],
      syncedAt: item['syncedAt'] != null ? DateTime.parse(item['syncedAt']) : null,
      deviceId: item['deviceId'],
    );
  }

  /// Sync all unsynced entries to DynamoDB
  Future<int> syncUnsyncedEntries(DatabaseService databaseService) async {
    try {
      final unsyncedEntries = await databaseService.getUnsyncedEntries();
      int syncedCount = 0;

      for (var entry in unsyncedEntries) {
        if (await putItem(entry)) {
          // Mark as synced in local database
          await databaseService.markEntryAsSynced(entry.id, DateTime.now());
          syncedCount++;
        }
      }

      return syncedCount;
    } catch (e) {
      return 0;
    }
  }

  /// Close the HTTP client
  Future<void> close() async {
    await _httpClient.close();
  }
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