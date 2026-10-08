import '../models/fill_entry.dart';
import '../data/database.dart';
import '../data/dynamodb_service.dart';
import '../services/settings_service.dart';

class SyncService {
  final DatabaseService databaseService;
  final DynamoDBService dynamoDBService;
  final SettingsService settingsService;

  SyncService({
    required this.databaseService,
    required this.dynamoDBService,
    required this.settingsService,
  });

  /// Sync a single entry to DynamoDB
  Future<bool> syncEntry(FillEntry entry) async {
    if (!settingsService.getEnableCloudSync()) {
      return false;
    }

    try {
      final success = await dynamoDBService.putItem(entry);
      if (success) {
        // Mark as synced in local database
        await databaseService.markEntryAsSynced(entry.id, DateTime.now());
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// Sync all unsynced entries
  Future<int> syncAllUnsyncedEntries() async {
    if (!settingsService.getEnableCloudSync()) {
      return 0;
    }

    try {
      final syncedCount = await dynamoDBService.syncUnsyncedEntries(databaseService);
      return syncedCount;
    } catch (e) {
      return 0;
    }
  }

  /// Test AWS connection
  Future<bool> testAwsConnection() async {
    try {
      // In a real implementation, we would make a simple DynamoDB call
      // For now, we'll just check if credentials are set
      return await settingsService.validateAwsConfiguration();
    } catch (e) {
      return false;
    }
  }
}