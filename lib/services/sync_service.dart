import 'package:workmanager/workmanager.dart';

import '../models/fill_entry.dart';
import '../data/database.dart';
import '../data/dynamodb_service.dart';
import '../services/settings_service.dart';

class SyncService {
  static const String _taskName = 'fuel_tracker_cloud_sync';

  final DatabaseService databaseService;
  final DynamoDBService dynamoDBService;
  final SettingsService settingsService;

  SyncService({
    required this.databaseService,
    required this.dynamoDBService,
    required this.settingsService,
  });

  /// Sync a single entry to DynamoDB
  Future<SyncResult> syncEntry(FillEntry entry) async {
    if (!settingsService.getEnableCloudSync()) {
      return const SyncResult(entries: 0, deletions: 0);
    }

    final result = await dynamoDBService.putItem(entry);
    if (result.success) {
      // Mark as synced in local database
      await databaseService.markEntryAsSynced(entry.id, DateTime.now());
      await settingsService.setLastSync(DateTime.now());
    }
    return SyncResult(
      entries: result.success ? 1 : 0,
      deletions: 0,
      error: result.error,
    );
  }

  /// Sync all unsynced entries and pending deletions
  Future<SyncResult> syncAllUnsyncedEntries() async {
    if (!settingsService.getEnableCloudSync()) {
      return const SyncResult(entries: 0, deletions: 0);
    }

    final entries = await dynamoDBService.syncUnsyncedEntries(databaseService);
    final deletions = await dynamoDBService.syncPendingDeletions(databaseService);
    if (entries.synced > 0 || deletions.deleted > 0) {
      await settingsService.setLastSync(DateTime.now());
    }
    return SyncResult(
      entries: entries.synced,
      deletions: deletions.deleted,
      error: entries.error ?? deletions.error,
    );
  }

  /// Register or cancel the periodic background sync based on settings
  /// ('on_close' syncs from the app lifecycle instead, so it needs no worker)
  Future<void> scheduleBackgroundSync() async {
    final frequency = settingsService.getSyncFrequency();
    if (!settingsService.getEnableCloudSync() ||
        frequency == 'manual' ||
        frequency == 'on_close') {
      await Workmanager().cancelByUniqueName(_taskName);
      return;
    }

    await Workmanager().registerPeriodicTask(
      _taskName,
      _taskName,
      constraints: Constraints(networkType: NetworkType.connected),
      frequency: frequency == 'hourly'
          ? const Duration(hours: 1)
          : const Duration(hours: 24),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  /// Test AWS connection with a real DynamoDB call (DescribeTable)
  Future<DynamoDbTestResult> testAwsConnection() =>
      dynamoDBService.testConnection();
}

/// Outcome of a sync run; [error] is user-facing and actionable.
class SyncResult {
  final int entries;
  final int deletions;
  final String? error;

  const SyncResult({required this.entries, required this.deletions, this.error});

  bool get hadWork => entries > 0 || deletions > 0;
  bool get failed => error != null;
}

/// Background sync entry point, run in a separate isolate by workmanager.
@pragma('vm:entry-point')
Future<void> runBackgroundSync() async {
  final settings = await SettingsService.create();
  if (!settings.getEnableCloudSync()) return;

  final database = await DatabaseService.create();
  final dynamo = DynamoDBService(settings);
  try {
    final entries = await dynamo.syncUnsyncedEntries(database);
    final deletions = await dynamo.syncPendingDeletions(database);
    if (entries.synced > 0 || deletions.deleted > 0) {
      await settings.setLastSync(DateTime.now());
    }
  } catch (_) {
    // No network or invalid credentials; entries stay unsynced for the next run
  } finally {
    dynamo.close();
    await database.close();
  }
}
