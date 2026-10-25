import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/fill_entry.dart';
import '../models/vehicle.dart';

part 'database.g.dart';

// Generated data classes are renamed so they don't clash with the
// hand-written FillEntry/Vehicle models used across the app.
@DataClassName('FillEntryRow')
class FillEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get fuelType => text()();
  RealColumn get odometer => real().nullable()();
  RealColumn get fuelAmount => real().nullable()();
  RealColumn get batteryLevelBefore => real().nullable()();
  RealColumn get batteryLevelAfter => real().nullable()();
  RealColumn get energyAdded => real().nullable()();
  RealColumn get totalCost => real()();
  TextColumn get currency => text()();
  TextColumn get distanceUnit => text().nullable()();
  TextColumn get capacityUnit => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get deviceId => text()();
  TextColumn get vehicleId => text()();
  RealColumn get exchangeRateAtEntry => real().nullable()();
  TextColumn get defaultCurrencyAtEntry => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VehicleRow')
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get fuelType => text()();
  TextColumn get make => text().nullable()();
  TextColumn get model => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get vin => text().nullable()();
  TextColumn get licensePlate => text().nullable()();
  TextColumn get tireSizeStock => text().nullable()();
  TextColumn get tireSizeRunning => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PendingDeletionRow')
class PendingDeletions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get deletedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [FillEntries, Vehicles, PendingDeletions])
class DatabaseService extends _$DatabaseService {
  DatabaseService(super.executor);

  static Future<DatabaseService> create() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'fuel_tracker.db'));
    final key = await _getOrCreateKey();
    return DatabaseService(
      NativeDatabase(
        file,
        // SQLCipher must be unlocked before any other statement runs.
        setup: (db) => db.execute("PRAGMA key = '$key';"),
      ),
    );
  }

  static Future<String> _getOrCreateKey() async {
    const storage = FlutterSecureStorage();
    const keyName = 'sqlcipher_key';
    final existing = await storage.read(key: keyName);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final random = Random.secure();
    final bytes =
        Uint8List.fromList(List.generate(32, (_) => random.nextInt(256)));
    final key = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    await storage.write(key: keyName, value: key);
    return key;
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(vehicles, vehicles.tireSizeStock);
            await m.addColumn(vehicles, vehicles.tireSizeRunning);
          }
          if (from < 3) {
            await m.createTable(pendingDeletions);
          }
          if (from < 4) {
            await m.addColumn(fillEntries, fillEntries.exchangeRateAtEntry);
            await m.addColumn(fillEntries, fillEntries.defaultCurrencyAtEntry);
          }
        },
      );

  /// Pin the exchange rate on entries saved before rate pinning existed
  /// (their [FillEntries.exchangeRateAtEntry] is still null), using the
  /// current rate so history stops drifting. Idempotent — runs at every
  /// start and self-heals entries that were offline on a previous pass.
  /// [rateFor] takes a base currency code and returns that rate table (or
  /// null when no rate is available).
  Future<void> pinExchangeRates({
    required String defaultCurrency,
    required Future<Map<String, double>?> Function(String base) rateFor,
  }) async {
    final rows = await (select(fillEntries)
          ..where((t) => t.exchangeRateAtEntry.isNull()))
        .map((row) => (id: row.id, currency: row.currency.toUpperCase()))
        .get();
    if (rows.isEmpty) return;

    final defaultKey = defaultCurrency.toUpperCase();
    final rateByBase = <String, double?>{};
    for (final currency in {
      for (final row in rows) row.currency
    }..remove(defaultKey)) {
      rateByBase[currency] = (await rateFor(currency))?[defaultKey];
    }

    for (final row in rows) {
      final rate = rateByBase[row.currency];
      if (rate == null) continue;
      await (update(fillEntries)..where((t) => t.id.equals(row.id)))
          .write(FillEntriesCompanion(
        exchangeRateAtEntry: Value(rate),
        defaultCurrencyAtEntry: Value(defaultKey),
      ));
    }
  }

  FillEntry _entryFromRow(FillEntryRow row) {
    return FillEntry(
      id: row.id,
      timestamp: row.timestamp,
      fuelType: row.fuelType,
      odometer: row.odometer,
      fuelAmount: row.fuelAmount,
      batteryLevelBefore: row.batteryLevelBefore,
      batteryLevelAfter: row.batteryLevelAfter,
      energyAdded: row.energyAdded,
      totalCost: row.totalCost,
      currency: row.currency,
      distanceUnit: row.distanceUnit,
      capacityUnit: row.capacityUnit,
      notes: row.notes,
      syncedAt: row.syncedAt,
      deviceId: row.deviceId,
      vehicleId: row.vehicleId,
      exchangeRateAtEntry: row.exchangeRateAtEntry,
      defaultCurrencyAtEntry: row.defaultCurrencyAtEntry,
    );
  }

  Vehicle _vehicleFromRow(VehicleRow row) {
    return Vehicle(
      id: row.id,
      name: row.name,
      fuelType: row.fuelType,
      make: row.make,
      model: row.model,
      year: row.year,
      vin: row.vin,
      licensePlate: row.licensePlate,
      tireSizeStock: row.tireSizeStock,
      tireSizeRunning: row.tireSizeRunning,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  FillEntriesCompanion _entryCompanion(FillEntry entry) {
    return FillEntriesCompanion(
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
      vehicleId: Value(entry.vehicleId),
      exchangeRateAtEntry: Value(entry.exchangeRateAtEntry),
      defaultCurrencyAtEntry: Value(entry.defaultCurrencyAtEntry),
    );
  }

  Future<FillEntry> insertFillEntry(FillEntry entry) async {
    await into(fillEntries).insertOnConflictUpdate(_entryCompanion(entry));
    return entry;
  }

  Future<List<FillEntry>> getAllFillEntries() async {
    final rows = await (select(fillEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .get();
    return rows.map(_entryFromRow).toList();
  }

  Future<List<FillEntry>> getFillEntriesPaginated(int limit, int offset) async {
    final rows = await (select(fillEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)])
          ..limit(limit, offset: offset))
        .get();
    return rows.map(_entryFromRow).toList();
  }

  Future<List<FillEntry>> getFillEntriesByFuelType(String fuelType) async {
    final rows =
        await (select(fillEntries)..where((t) => t.fuelType.equals(fuelType)))
            .get();
    return rows.map(_entryFromRow).toList();
  }

  Future<List<FillEntry>> getFillEntriesByDateRange(
      DateTime start, DateTime end) async {
    final rows = await (select(fillEntries)
          ..where((t) => t.timestamp.isBetweenValues(start, end)))
        .get();
    return rows.map(_entryFromRow).toList();
  }

  Future<void> updateFillEntry(FillEntry entry) async {
    await (update(fillEntries)..where((t) => t.id.equals(entry.id)))
        .write(_entryCompanion(entry));
  }

  Future<void> deleteFillEntry(String id) async {
    await recordDeletions([id]);
    await (delete(fillEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteFillEntriesByVehicle(String vehicleId) async {
    final ids = await (select(fillEntries)
          ..where((t) => t.vehicleId.equals(vehicleId)))
        .map((row) => row.id)
        .get();
    await recordDeletions(ids);
    await (delete(fillEntries)..where((t) => t.vehicleId.equals(vehicleId))).go();
  }

  Future<void> deleteAllFillEntries() async {
    final ids = await select(fillEntries).map((row) => row.id).get();
    await recordDeletions(ids);
    await delete(fillEntries).go();
  }

  Future<double> getTotalCost(DateTime start, DateTime end) async {
    final costs = await (select(fillEntries)
          ..where((t) => t.timestamp.isBetweenValues(start, end)))
        .map((row) => row.totalCost)
        .get();
    return costs.fold<double>(0.0, (sum, cost) => sum + cost);
  }

  Future<double> getTotalFuelAmount(DateTime start, DateTime end) async {
    final amounts = await (select(fillEntries)
          ..where((t) =>
              t.timestamp.isBetweenValues(start, end) & t.fuelAmount.isNotNull()))
        .map((row) => row.fuelAmount!)
        .get();
    return amounts.fold<double>(0.0, (sum, amount) => sum + amount);
  }

  Future<double> getAverageCostPerFill() async {
    final costs = await select(fillEntries).map((row) => row.totalCost).get();
    if (costs.isEmpty) return 0.0;
    return costs.fold(0.0, (sum, cost) => sum + cost) / costs.length;
  }

  Future<FillEntry?> getMostRecentFillEntry() async {
    final rows = await (select(fillEntries)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : _entryFromRow(rows.first);
  }

  Future<int> getFillEntryCount() async {
    final result =
        await (selectOnly(fillEntries)..addColumns([countAll()])).getSingle();
    return result.read(countAll()) ?? 0;
  }

  Future<void> markEntryAsSynced(String id, DateTime syncedAt) async {
    await (update(fillEntries)..where((t) => t.id.equals(id)))
        .write(FillEntriesCompanion(syncedAt: Value(syncedAt)));
  }

  Future<List<FillEntry>> getUnsyncedEntries() async {
    final rows =
        await (select(fillEntries)..where((t) => t.syncedAt.isNull())).get();
    return rows.map(_entryFromRow).toList();
  }

  Future<void> recordDeletions(List<String> ids) async {
    if (ids.isEmpty) return;
    await pendingDeletions.insertAll(
      ids.map((id) => PendingDeletionsCompanion(
            id: Value(id),
            deletedAt: Value(DateTime.now()),
          )),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<List<String>> getPendingDeletionIds() async {
    return (select(pendingDeletions)
          ..orderBy([(t) => OrderingTerm(expression: t.deletedAt)]))
        .map((row) => row.id)
        .get();
  }

  Future<void> clearPendingDeletions(List<String> ids) async {
    if (ids.isEmpty) return;
    await (delete(pendingDeletions)..where((t) => t.id.isIn(ids))).go();
  }

  Future<Vehicle> insertVehicle(Vehicle vehicle) async {
    await into(vehicles).insertOnConflictUpdate(
      VehiclesCompanion(
        id: Value(vehicle.id),
        name: Value(vehicle.name),
        fuelType: Value(vehicle.fuelType),
        make: Value(vehicle.make),
        model: Value(vehicle.model),
        year: Value(vehicle.year),
        vin: Value(vehicle.vin),
        licensePlate: Value(vehicle.licensePlate),
        tireSizeStock: Value(vehicle.tireSizeStock),
        tireSizeRunning: Value(vehicle.tireSizeRunning),
        createdAt: Value(vehicle.createdAt),
        updatedAt: Value(vehicle.updatedAt),
      ),
    );
    return vehicle;
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final rows = await select(vehicles).get();
    return rows.map(_vehicleFromRow).toList();
  }

  Future<Vehicle?> getVehicleById(String id) async {
    final rows =
        await (select(vehicles)..where((t) => t.id.equals(id))).get();
    return rows.isEmpty ? null : _vehicleFromRow(rows.first);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await (update(vehicles)..where((t) => t.id.equals(vehicle.id))).write(
      VehiclesCompanion(
        name: Value(vehicle.name),
        fuelType: Value(vehicle.fuelType),
        make: Value(vehicle.make),
        model: Value(vehicle.model),
        year: Value(vehicle.year),
        vin: Value(vehicle.vin),
        licensePlate: Value(vehicle.licensePlate),
        tireSizeStock: Value(vehicle.tireSizeStock),
        tireSizeRunning: Value(vehicle.tireSizeRunning),
        updatedAt: Value(vehicle.updatedAt),
      ),
    );
  }

  Future<void> deleteVehicle(String id) async {
    await (delete(vehicles)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteAllVehicles() async {
    await delete(vehicles).go();
  }

  Future<List<Vehicle>> getVehiclesPaginated(int limit, int offset) async {
    final rows = await (select(vehicles)..limit(limit, offset: offset)).get();
    return rows.map(_vehicleFromRow).toList();
  }

  Future<Vehicle?> getVehicleByName(String name) async {
    final rows =
        await (select(vehicles)..where((t) => t.name.equals(name))).get();
    return rows.isEmpty ? null : _vehicleFromRow(rows.first);
  }
}
