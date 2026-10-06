import 'package:drift/drift.dart';
import 'package:drift_sqlcipher/drift_sqlcipher.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../models/fill_entry.dart';

// Define the database tables
class FillEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get fuelType => text()();
  DoubleColumn get odometer => double_()();
  DoubleColumn get fuelAmount => double_()();
  DoubleColumn get batteryLevelBefore => double_()();
  DoubleColumn get batteryLevelAfter => double_()();
  DoubleColumn get energyAdded => double_()();
  DoubleColumn get totalCost => double_()();
  TextColumn get currency => text()();
  TextColumn get distanceUnit => text()();
  TextColumn get capacityUnit => text()();
  TextColumn get notes => text()();
  DateTimeColumn get syncedAt => dateTime()();
  TextColumn get deviceId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// Database class for handling operations
class DatabaseService extends _$DatabaseService {
  static Future<DatabaseService> create() async {
    final db = DatabaseService();
    await db.open();
    return db;
  }

  DatabaseService._internal() : super(_openDatabase());

  factory DatabaseService() {
    return DatabaseService._internal();
  }

  static Database _openDatabase() {
    // Initialize SQLite3 for Flutter
    sqlite3FlutterLibsInit();

    // Get the database file path
    final dbPath = 'fuel_tracker.db';

    // Create the database with encryption (using SQLCipher)
    final db = Database.withPath(dbPath);

    return db;
  }

  // Insert a new fill entry
  Future<FillEntry> insertFillEntry(FillEntry entry) async {
    final result = await into(fillEntries).insertOnConflict(
      FillEntriesCompanion(
        id: Value(entry.id),
        timestamp: Value(entry.timestamp),
        fuelType: Value(entry.fuelType),
        odometer: Value(entry.odometer),
        fuelAmount: Value(entry.fuelAmount),
        batteryLevelBefore: Value(entry.batteryLevelBefore),
        batteryLevelAfter: Value(entry.batteryLevelAfter),
        energyAdded: Value(entry.energyAdded),
        totalCost: Value(entry.totalCost),
        currency: Value(entry.currency),
        distanceUnit: Value(entry.distanceUnit),
        capacityUnit: Value(entry.capacityUnit),
        notes: Value(entry.notes),
        syncedAt: Value(entry.syncedAt),
        deviceId: Value(entry.deviceId),
      ),
    );

    return result;
  }

  // Get all fill entries
  Future<List<FillEntry>> getAllFillEntries() async {
    return select(fillEntries).get();
  }

  // Get fill entries with pagination
  Future<List<FillEntry>> getFillEntriesPaginated(int limit, int offset) async {
    return select(fillEntries).limit(limit, offset: offset).get();
  }

  // Get fill entries by fuel type
  Future<List<FillEntry>> getFillEntriesByFuelType(String fuelType) async {
    return (select(fillEntries)..where((t) => t.fuelType.equals(fuelType))).get();
  }

  // Get fill entries by date range
  Future<List<FillEntry>> getFillEntriesByDateRange(DateTime start, DateTime end) async {
    return (select(fillEntries)..where((t) => t.timestamp.isBetween(start, end))).get();
  }

  // Update a fill entry
  Future<void> updateFillEntry(FillEntry entry) async {
    await (update(fillEntries)..where((t) => t.id.equals(entry.id))).write(
      FillEntriesCompanion(
        timestamp: Value(entry.timestamp),
        fuelType: Value(entry.fuelType),
        odometer: Value(entry.odometer),
        fuelAmount: Value(entry.fuelAmount),
        batteryLevelBefore: Value(entry.batteryLevelBefore),
        batteryLevelAfter: Value(entry.batteryLevelAfter),
        energyAdded: Value(entry.energyAdded),
        totalCost: Value(entry.totalCost),
        currency: Value(entry.currency),
        distanceUnit: Value(entry.distanceUnit),
        capacityUnit: Value(entry.capacityUnit),
        notes: Value(entry.notes),
        syncedAt: Value(entry.syncedAt),
        deviceId: Value(entry.deviceId),
      ),
    );
  }

  // Delete a fill entry
  Future<void> deleteFillEntry(String id) async {
    await (delete(fillEntries)..where((t) => t.id.equals(id))).go();
  }

  // Get total cost for a given time period
  Future<double> getTotalCost(DateTime start, DateTime end) async {
    final result = await (select(fillEntries)
      ..where((t) => t.timestamp.isBetween(start, end))
      ..map((row) => row.totalCost))
      .get();

    return result.fold(0.0, (sum, cost) => sum + cost);
  }

  // Get total fuel amount for a given time period
  Future<double> getTotalFuelAmount(DateTime start, DateTime end) async {
    final result = await (select(fillEntries)
      ..where((t) => t.timestamp.isBetween(start, end) && t.fuelAmount.isNotNull())
      ..map((row) => row.fuelAmount!))
      .get();

    return result.fold(0.0, (sum, amount) => sum + amount);
  }

  // Get average cost per fill
  Future<double> getAverageCostPerFill() async {
    final result = await (select(fillEntries)
      ..map((row) => row.totalCost))
      .get();

    if (result.isEmpty) return 0.0;
    return result.fold(0.0, (sum, cost) => sum + cost) / result.length;
  }

  // Get most recent fill entry
  Future<FillEntry?> getMostRecentFillEntry() async {
    final result = await (select(fillEntries)..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]).limit(1)).get();
    return result.isEmpty ? null : result.first;
  }

  // Get count of fill entries
  Future<int> getFillEntryCount() async {
    final result = await (select(fillEntries)..map((row) => 1)).get();
    return result.length;
  }

  // Mark entry as synced
  Future<void> markEntryAsSynced(String id, DateTime syncedAt) async {
    await (update(fillEntries)..where((t) => t.id.equals(id))).write(
      FillEntriesCompanion(
        syncedAt: Value(syncedAt),
      ),
    );
  }

  // Get unsynced entries
  Future<List<FillEntry>> getUnsyncedEntries() async {
    return (select(fillEntries)..where((t) => t.syncedAt.isNull())).get();
  }
}

// Generated database class
class _$DatabaseService extends Database {
  _$DatabaseService._internal(super.delegate);

  factory _$DatabaseService() {
    return _$DatabaseService._internal(_openDatabase());
  }

  static Database _openDatabase() {
    // Initialize SQLite3 for Flutter
    sqlite3FlutterLibsInit();

    // Get the database file path
    final dbPath = 'fuel_tracker.db';

    // Create the database with encryption
    final db = Database.withPath(dbPath);

    return db;
  }
}