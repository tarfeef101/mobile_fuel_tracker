import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Display preferences. Extends [ChangeNotifier] so screens can rebuild when
/// a default unit or currency changes (mirrors [ThemeModeNotifier]).
class SettingsService extends ChangeNotifier {
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
  static const String _themeModeKey = 'theme_mode';
  static const String _syncFrequencyKey = 'sync_frequency';
  static const String _historyPeriodKey = 'history_period';

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
    notifyListeners();
  }

  // Get current capacity unit
  String getCapacityUnit() {
    return _preferences.getString(_capacityUnitKey) ?? 'L';
  }

  // Set current capacity unit
  Future<void> setCapacityUnit(String capacityUnit) async {
    await _preferences.setString(_capacityUnitKey, capacityUnit);
    notifyListeners();
  }

  // Get current currency
  String getCurrency() {
    return _preferences.getString(_currencyKey) ?? 'USD';
  }

  // Set current currency
  Future<void> setCurrency(String currency) async {
    await _preferences.setString(_currencyKey, currency);
    notifyListeners();
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

  // Get theme mode
  String getThemeMode() {
    return _preferences.getString(_themeModeKey) ?? 'system';
  }

  // Set theme mode
  Future<void> setThemeMode(String mode) async {
    await _preferences.setString(_themeModeKey, mode);
  }

  // Get sync frequency
  String getSyncFrequency() {
    return _preferences.getString(_syncFrequencyKey) ?? 'manual';
  }

  // Set sync frequency
  Future<void> setSyncFrequency(String frequency) async {
    await _preferences.setString(_syncFrequencyKey, frequency);
  }

  // Get dashboard history period (days, or 'all')
  String getHistoryPeriod() {
    return _preferences.getString(_historyPeriodKey) ?? '30';
  }

  // Set dashboard history period
  Future<void> setHistoryPeriod(String period) async {
    await _preferences.setString(_historyPeriodKey, period);
  }

  // Clear all settings (useful for resetting the app)
  Future<void> clearAllSettings() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
    notifyListeners();
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
}
