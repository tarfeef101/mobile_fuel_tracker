import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  static const String _fuelTypeKey = 'fuel_type';
  static const String _distanceUnitKey = 'distance_unit';
  static const String _capacityUnitKey = 'capacity_unit';
  static const String _currencyKey = 'currency';
  static const String _awsAccessKeyIdKey = 'aws_access_key_id';
  static const String _awsSecretAccessKeyKey = 'aws_secret_access_key';
  static const String _awsRegionKey = 'aws_region';
  static const String _dynamoDbTableKey = 'dynamo_db_table';
  static const String _enableCloudSyncKey = 'enable_cloud_sync';
  static const String _lastSyncKey = 'last_sync';
  static const String _deviceIdKey = 'device_id';
  static const String _tireSizeStockKey = 'tire_size_stock';
  static const String _tireSizeRunningKey = 'tire_size_running';

  final SharedPreferences _preferences;
  final FlutterSecureStorage _secureStorage;

  SettingsService._internal(this._preferences, this._secureStorage);

  static Future<SettingsService> create() async {
    final preferences = await SharedPreferences.getInstance();
    final secureStorage = FlutterSecureStorage();
    return SettingsService._internal(preferences, secureStorage);
  }

  // Get current fuel type
  String getFuelType() {
    return _preferences.getString(_fuelTypeKey) ?? 'liquid';
  }

  // Set current fuel type
  Future<void> setFuelType(String fuelType) async {
    await _preferences.setString(_fuelTypeKey, fuelType);
  }

  // Get current distance unit
  String getDistanceUnit() {
    return _preferences.getString(_distanceUnitKey) ?? 'km';
  }

  // Set current distance unit
  Future<void> setDistanceUnit(String distanceUnit) async {
    await _preferences.setString(_distanceUnitKey, distanceUnit);
  }

  // Get current capacity unit
  String getCapacityUnit() {
    return _preferences.getString(_capacityUnitKey) ?? 'L';
  }

  // Set current capacity unit
  Future<void> setCapacityUnit(String capacityUnit) async {
    await _preferences.setString(_capacityUnitKey, capacityUnit);
  }

  // Get current currency
  String getCurrency() {
    return _preferences.getString(_currencyKey) ?? 'USD';
  }

  // Set current currency
  Future<void> setCurrency(String currency) async {
    await _preferences.setString(_currencyKey, currency);
  }

  // Get AWS access key ID
  Future<String?> getAwsAccessKeyId() async {
    return await _secureStorage.read(key: _awsAccessKeyIdKey);
  }

  // Set AWS access key ID
  Future<void> setAwsAccessKeyId(String accessKeyId) async {
    await _secureStorage.write(key: _awsAccessKeyIdKey, value: accessKeyId);
  }

  // Get AWS secret access key
  Future<String?> getAwsSecretAccessKey() async {
    return await _secureStorage.read(key: _awsSecretAccessKeyKey);
  }

  // Set AWS secret access key
  Future<void> setAwsSecretAccessKey(String secretAccessKey) async {
    await _secureStorage.write(key: _awsSecretAccessKeyKey, value: secretAccessKey);
  }

  // Get AWS region
  String getAwsRegion() {
    return _preferences.getString(_awsRegionKey) ?? 'us-east-1';
  }

  // Set AWS region
  Future<void> setAwsRegion(String region) async {
    await _preferences.setString(_awsRegionKey, region);
  }

  // Get DynamoDB table name
  String getDynamoDbTableName() {
    return _preferences.getString(_dynamoDbTableKey) ?? 'FuelTrackerEntries';
  }

  // Set DynamoDB table name
  Future<void> setDynamoDbTableName(String tableName) async {
    await _preferences.setString(_dynamoDbTableKey, tableName);
  }

  // Check if cloud sync is enabled
  bool getEnableCloudSync() {
    return _preferences.getBool(_enableCloudSyncKey) ?? false;
  }

  // Enable/disable cloud sync
  Future<void> setEnableCloudSync(bool enable) async {
    await _preferences.setBool(_enableCloudSyncKey, enable);
  }

  // Get last sync timestamp
  DateTime? getLastSync() {
    final timestamp = _preferences.getString(_lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.parse(timestamp);
  }

  // Set last sync timestamp
  Future<void> setLastSync(DateTime timestamp) async {
    await _preferences.setString(_lastSyncKey, timestamp.toIso8601String());
  }

  // Get device ID
  String getDeviceId() {
    final deviceId = _preferences.getString(_deviceIdKey);
    if (deviceId != null) return deviceId;

    // Generate new device ID if not exists
    final newDeviceId = DateTime.now().millisecondsSinceEpoch.toString();
    _preferences.setString(_deviceIdKey, newDeviceId);
    return newDeviceId;
  }

  // Get stock tire size
  String getTireSizeStock() {
    return _preferences.getString(_tireSizeStockKey) ?? '';
  }

  // Set stock tire size
  Future<void> setTireSizeStock(String tireSize) async {
    await _preferences.setString(_tireSizeStockKey, tireSize);
  }

  // Get running tire size
  String getTireSizeRunning() {
    return _preferences.getString(_tireSizeRunningKey) ?? '';
  }

  // Set running tire size
  Future<void> setTireSizeRunning(String tireSize) async {
    await _preferences.setString(_tireSizeRunningKey, tireSize);
  }

  // Calculate tire size offset
  double? getTireSizeOffset() {
    final stockSize = getTireSizeStock();
    final runningSize = getTireSizeRunning();

    if (stockSize.isEmpty || runningSize.isEmpty) {
      return null;
    }

    try {
      final stockDiameter = _calculateTireDiameter(stockSize);
      final runningDiameter = _calculateTireDiameter(runningSize);

      if (stockDiameter != null && runningDiameter != null) {
        // Calculate offset as the ratio of diameters
        return (runningDiameter / stockDiameter) - 1.0;
      }
    } catch (e) {
      // If there's an error in calculation, return null
      return null;
    }

    return null;
  }

  // Parse tire size string (e.g., "225/65R17") and return diameter in inches
  double? _calculateTireDiameter(String tireSize) {
    // Handle direct diameter input (like "26 inches")
    if (tireSize.contains('in') || tireSize.contains('inch')) {
      return double.tryParse(tireSize.replaceAll(RegExp(r'[^0-9.]'), ''));
    }

    // Handle standard tire size format (e.g., "225/65R17")
    final regex = RegExp(r'^(\d+)\/(\d+)[Rr](\d+)$');
    final match = regex.firstMatch(tireSize);

    if (match != null) {
      final width = double.parse(match.group(1)!);
      final aspectRatio = double.parse(match.group(2)!);
      final rimDiameter = double.parse(match.group(3)!);

      // Calculate tire diameter in inches
      // Formula: (width * aspect ratio * 2) + (rim diameter * 12)
      final sidewallHeight = width * aspectRatio / 100; // In mm
      final totalDiameter = (sidewallHeight * 2 + rimDiameter * 25.4) / 25.4; // Convert to inches
      return totalDiameter;
    }

    return null;
  }

  // Clear all settings (useful for resetting the app)
  Future<void> clearAllSettings() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
  }

  // Check if AWS credentials are set
  Future<bool> areAwsCredentialsSet() async {
    final accessKeyId = await getAwsAccessKeyId();
    final secretAccessKey = await getAwsSecretAccessKey();
    return accessKeyId != null && secretAccessKey != null;
  }

  // Validate AWS configuration
  Future<bool> validateAwsConfiguration() async {
    return await areAwsCredentialsSet() && getAwsRegion().isNotEmpty && getDynamoDbTableName().isNotEmpty;
  }

  // Test AWS connection with basic operation
  Future<bool> testAwsConnection() async {
    try {
      // In a real implementation, we would test by making a simple DynamoDB call
      // For now, we'll just check if credentials are properly set
      final accessKeyId = await getAwsAccessKeyId();
      final secretAccessKey = await getAwsSecretAccessKey();

      // In a production app, this would actually make a call to DynamoDB
      // to verify credentials work
      return accessKeyId != null && secretAccessKey != null;
    } catch (e) {
      return false;
    }
  }
}