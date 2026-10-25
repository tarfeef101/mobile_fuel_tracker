// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FillEntriesTable extends FillEntries
    with TableInfo<$FillEntriesTable, FillEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FillEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<double> odometer = GeneratedColumn<double>(
    'odometer',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelAmountMeta = const VerificationMeta(
    'fuelAmount',
  );
  @override
  late final GeneratedColumn<double> fuelAmount = GeneratedColumn<double>(
    'fuel_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _batteryLevelBeforeMeta =
      const VerificationMeta('batteryLevelBefore');
  @override
  late final GeneratedColumn<double> batteryLevelBefore =
      GeneratedColumn<double>(
        'battery_level_before',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _batteryLevelAfterMeta = const VerificationMeta(
    'batteryLevelAfter',
  );
  @override
  late final GeneratedColumn<double> batteryLevelAfter =
      GeneratedColumn<double>(
        'battery_level_after',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _energyAddedMeta = const VerificationMeta(
    'energyAdded',
  );
  @override
  late final GeneratedColumn<double> energyAdded = GeneratedColumn<double>(
    'energy_added',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceUnitMeta = const VerificationMeta(
    'distanceUnit',
  );
  @override
  late final GeneratedColumn<String> distanceUnit = GeneratedColumn<String>(
    'distance_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _capacityUnitMeta = const VerificationMeta(
    'capacityUnit',
  );
  @override
  late final GeneratedColumn<String> capacityUnit = GeneratedColumn<String>(
    'capacity_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exchangeRateAtEntryMeta =
      const VerificationMeta('exchangeRateAtEntry');
  @override
  late final GeneratedColumn<double> exchangeRateAtEntry =
      GeneratedColumn<double>(
        'exchange_rate_at_entry',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _defaultCurrencyAtEntryMeta =
      const VerificationMeta('defaultCurrencyAtEntry');
  @override
  late final GeneratedColumn<String> defaultCurrencyAtEntry =
      GeneratedColumn<String>(
        'default_currency_at_entry',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    fuelType,
    odometer,
    fuelAmount,
    batteryLevelBefore,
    batteryLevelAfter,
    energyAdded,
    totalCost,
    currency,
    distanceUnit,
    capacityUnit,
    notes,
    syncedAt,
    deviceId,
    vehicleId,
    exchangeRateAtEntry,
    defaultCurrencyAtEntry,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fill_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FillEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    }
    if (data.containsKey('fuel_amount')) {
      context.handle(
        _fuelAmountMeta,
        fuelAmount.isAcceptableOrUnknown(data['fuel_amount']!, _fuelAmountMeta),
      );
    }
    if (data.containsKey('battery_level_before')) {
      context.handle(
        _batteryLevelBeforeMeta,
        batteryLevelBefore.isAcceptableOrUnknown(
          data['battery_level_before']!,
          _batteryLevelBeforeMeta,
        ),
      );
    }
    if (data.containsKey('battery_level_after')) {
      context.handle(
        _batteryLevelAfterMeta,
        batteryLevelAfter.isAcceptableOrUnknown(
          data['battery_level_after']!,
          _batteryLevelAfterMeta,
        ),
      );
    }
    if (data.containsKey('energy_added')) {
      context.handle(
        _energyAddedMeta,
        energyAdded.isAcceptableOrUnknown(
          data['energy_added']!,
          _energyAddedMeta,
        ),
      );
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('distance_unit')) {
      context.handle(
        _distanceUnitMeta,
        distanceUnit.isAcceptableOrUnknown(
          data['distance_unit']!,
          _distanceUnitMeta,
        ),
      );
    }
    if (data.containsKey('capacity_unit')) {
      context.handle(
        _capacityUnitMeta,
        capacityUnit.isAcceptableOrUnknown(
          data['capacity_unit']!,
          _capacityUnitMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('exchange_rate_at_entry')) {
      context.handle(
        _exchangeRateAtEntryMeta,
        exchangeRateAtEntry.isAcceptableOrUnknown(
          data['exchange_rate_at_entry']!,
          _exchangeRateAtEntryMeta,
        ),
      );
    }
    if (data.containsKey('default_currency_at_entry')) {
      context.handle(
        _defaultCurrencyAtEntryMeta,
        defaultCurrencyAtEntry.isAcceptableOrUnknown(
          data['default_currency_at_entry']!,
          _defaultCurrencyAtEntryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FillEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FillEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer'],
      ),
      fuelAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_amount'],
      ),
      batteryLevelBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}battery_level_before'],
      ),
      batteryLevelAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}battery_level_after'],
      ),
      energyAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energy_added'],
      ),
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      distanceUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distance_unit'],
      ),
      capacityUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}capacity_unit'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      exchangeRateAtEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exchange_rate_at_entry'],
      ),
      defaultCurrencyAtEntry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_currency_at_entry'],
      ),
    );
  }

  @override
  $FillEntriesTable createAlias(String alias) {
    return $FillEntriesTable(attachedDatabase, alias);
  }
}

class FillEntryRow extends DataClass implements Insertable<FillEntryRow> {
  final String id;
  final DateTime timestamp;
  final String fuelType;
  final double? odometer;
  final double? fuelAmount;
  final double? batteryLevelBefore;
  final double? batteryLevelAfter;
  final double? energyAdded;
  final double totalCost;
  final String currency;
  final String? distanceUnit;
  final String? capacityUnit;
  final String? notes;
  final DateTime? syncedAt;
  final String deviceId;
  final String vehicleId;
  final double? exchangeRateAtEntry;
  final String? defaultCurrencyAtEntry;
  const FillEntryRow({
    required this.id,
    required this.timestamp,
    required this.fuelType,
    this.odometer,
    this.fuelAmount,
    this.batteryLevelBefore,
    this.batteryLevelAfter,
    this.energyAdded,
    required this.totalCost,
    required this.currency,
    this.distanceUnit,
    this.capacityUnit,
    this.notes,
    this.syncedAt,
    required this.deviceId,
    required this.vehicleId,
    this.exchangeRateAtEntry,
    this.defaultCurrencyAtEntry,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['fuel_type'] = Variable<String>(fuelType);
    if (!nullToAbsent || odometer != null) {
      map['odometer'] = Variable<double>(odometer);
    }
    if (!nullToAbsent || fuelAmount != null) {
      map['fuel_amount'] = Variable<double>(fuelAmount);
    }
    if (!nullToAbsent || batteryLevelBefore != null) {
      map['battery_level_before'] = Variable<double>(batteryLevelBefore);
    }
    if (!nullToAbsent || batteryLevelAfter != null) {
      map['battery_level_after'] = Variable<double>(batteryLevelAfter);
    }
    if (!nullToAbsent || energyAdded != null) {
      map['energy_added'] = Variable<double>(energyAdded);
    }
    map['total_cost'] = Variable<double>(totalCost);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || distanceUnit != null) {
      map['distance_unit'] = Variable<String>(distanceUnit);
    }
    if (!nullToAbsent || capacityUnit != null) {
      map['capacity_unit'] = Variable<String>(capacityUnit);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['vehicle_id'] = Variable<String>(vehicleId);
    if (!nullToAbsent || exchangeRateAtEntry != null) {
      map['exchange_rate_at_entry'] = Variable<double>(exchangeRateAtEntry);
    }
    if (!nullToAbsent || defaultCurrencyAtEntry != null) {
      map['default_currency_at_entry'] = Variable<String>(
        defaultCurrencyAtEntry,
      );
    }
    return map;
  }

  FillEntriesCompanion toCompanion(bool nullToAbsent) {
    return FillEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      fuelType: Value(fuelType),
      odometer: odometer == null && nullToAbsent
          ? const Value.absent()
          : Value(odometer),
      fuelAmount: fuelAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(fuelAmount),
      batteryLevelBefore: batteryLevelBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(batteryLevelBefore),
      batteryLevelAfter: batteryLevelAfter == null && nullToAbsent
          ? const Value.absent()
          : Value(batteryLevelAfter),
      energyAdded: energyAdded == null && nullToAbsent
          ? const Value.absent()
          : Value(energyAdded),
      totalCost: Value(totalCost),
      currency: Value(currency),
      distanceUnit: distanceUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceUnit),
      capacityUnit: capacityUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(capacityUnit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      deviceId: Value(deviceId),
      vehicleId: Value(vehicleId),
      exchangeRateAtEntry: exchangeRateAtEntry == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRateAtEntry),
      defaultCurrencyAtEntry: defaultCurrencyAtEntry == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCurrencyAtEntry),
    );
  }

  factory FillEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FillEntryRow(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      odometer: serializer.fromJson<double?>(json['odometer']),
      fuelAmount: serializer.fromJson<double?>(json['fuelAmount']),
      batteryLevelBefore: serializer.fromJson<double?>(
        json['batteryLevelBefore'],
      ),
      batteryLevelAfter: serializer.fromJson<double?>(
        json['batteryLevelAfter'],
      ),
      energyAdded: serializer.fromJson<double?>(json['energyAdded']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      currency: serializer.fromJson<String>(json['currency']),
      distanceUnit: serializer.fromJson<String?>(json['distanceUnit']),
      capacityUnit: serializer.fromJson<String?>(json['capacityUnit']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      exchangeRateAtEntry: serializer.fromJson<double?>(
        json['exchangeRateAtEntry'],
      ),
      defaultCurrencyAtEntry: serializer.fromJson<String?>(
        json['defaultCurrencyAtEntry'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'fuelType': serializer.toJson<String>(fuelType),
      'odometer': serializer.toJson<double?>(odometer),
      'fuelAmount': serializer.toJson<double?>(fuelAmount),
      'batteryLevelBefore': serializer.toJson<double?>(batteryLevelBefore),
      'batteryLevelAfter': serializer.toJson<double?>(batteryLevelAfter),
      'energyAdded': serializer.toJson<double?>(energyAdded),
      'totalCost': serializer.toJson<double>(totalCost),
      'currency': serializer.toJson<String>(currency),
      'distanceUnit': serializer.toJson<String?>(distanceUnit),
      'capacityUnit': serializer.toJson<String?>(capacityUnit),
      'notes': serializer.toJson<String?>(notes),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'exchangeRateAtEntry': serializer.toJson<double?>(exchangeRateAtEntry),
      'defaultCurrencyAtEntry': serializer.toJson<String?>(
        defaultCurrencyAtEntry,
      ),
    };
  }

  FillEntryRow copyWith({
    String? id,
    DateTime? timestamp,
    String? fuelType,
    Value<double?> odometer = const Value.absent(),
    Value<double?> fuelAmount = const Value.absent(),
    Value<double?> batteryLevelBefore = const Value.absent(),
    Value<double?> batteryLevelAfter = const Value.absent(),
    Value<double?> energyAdded = const Value.absent(),
    double? totalCost,
    String? currency,
    Value<String?> distanceUnit = const Value.absent(),
    Value<String?> capacityUnit = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> syncedAt = const Value.absent(),
    String? deviceId,
    String? vehicleId,
    Value<double?> exchangeRateAtEntry = const Value.absent(),
    Value<String?> defaultCurrencyAtEntry = const Value.absent(),
  }) => FillEntryRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    fuelType: fuelType ?? this.fuelType,
    odometer: odometer.present ? odometer.value : this.odometer,
    fuelAmount: fuelAmount.present ? fuelAmount.value : this.fuelAmount,
    batteryLevelBefore: batteryLevelBefore.present
        ? batteryLevelBefore.value
        : this.batteryLevelBefore,
    batteryLevelAfter: batteryLevelAfter.present
        ? batteryLevelAfter.value
        : this.batteryLevelAfter,
    energyAdded: energyAdded.present ? energyAdded.value : this.energyAdded,
    totalCost: totalCost ?? this.totalCost,
    currency: currency ?? this.currency,
    distanceUnit: distanceUnit.present ? distanceUnit.value : this.distanceUnit,
    capacityUnit: capacityUnit.present ? capacityUnit.value : this.capacityUnit,
    notes: notes.present ? notes.value : this.notes,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
    deviceId: deviceId ?? this.deviceId,
    vehicleId: vehicleId ?? this.vehicleId,
    exchangeRateAtEntry: exchangeRateAtEntry.present
        ? exchangeRateAtEntry.value
        : this.exchangeRateAtEntry,
    defaultCurrencyAtEntry: defaultCurrencyAtEntry.present
        ? defaultCurrencyAtEntry.value
        : this.defaultCurrencyAtEntry,
  );
  FillEntryRow copyWithCompanion(FillEntriesCompanion data) {
    return FillEntryRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      fuelAmount: data.fuelAmount.present
          ? data.fuelAmount.value
          : this.fuelAmount,
      batteryLevelBefore: data.batteryLevelBefore.present
          ? data.batteryLevelBefore.value
          : this.batteryLevelBefore,
      batteryLevelAfter: data.batteryLevelAfter.present
          ? data.batteryLevelAfter.value
          : this.batteryLevelAfter,
      energyAdded: data.energyAdded.present
          ? data.energyAdded.value
          : this.energyAdded,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      currency: data.currency.present ? data.currency.value : this.currency,
      distanceUnit: data.distanceUnit.present
          ? data.distanceUnit.value
          : this.distanceUnit,
      capacityUnit: data.capacityUnit.present
          ? data.capacityUnit.value
          : this.capacityUnit,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      exchangeRateAtEntry: data.exchangeRateAtEntry.present
          ? data.exchangeRateAtEntry.value
          : this.exchangeRateAtEntry,
      defaultCurrencyAtEntry: data.defaultCurrencyAtEntry.present
          ? data.defaultCurrencyAtEntry.value
          : this.defaultCurrencyAtEntry,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FillEntryRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('fuelType: $fuelType, ')
          ..write('odometer: $odometer, ')
          ..write('fuelAmount: $fuelAmount, ')
          ..write('batteryLevelBefore: $batteryLevelBefore, ')
          ..write('batteryLevelAfter: $batteryLevelAfter, ')
          ..write('energyAdded: $energyAdded, ')
          ..write('totalCost: $totalCost, ')
          ..write('currency: $currency, ')
          ..write('distanceUnit: $distanceUnit, ')
          ..write('capacityUnit: $capacityUnit, ')
          ..write('notes: $notes, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('exchangeRateAtEntry: $exchangeRateAtEntry, ')
          ..write('defaultCurrencyAtEntry: $defaultCurrencyAtEntry')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    fuelType,
    odometer,
    fuelAmount,
    batteryLevelBefore,
    batteryLevelAfter,
    energyAdded,
    totalCost,
    currency,
    distanceUnit,
    capacityUnit,
    notes,
    syncedAt,
    deviceId,
    vehicleId,
    exchangeRateAtEntry,
    defaultCurrencyAtEntry,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FillEntryRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.fuelType == this.fuelType &&
          other.odometer == this.odometer &&
          other.fuelAmount == this.fuelAmount &&
          other.batteryLevelBefore == this.batteryLevelBefore &&
          other.batteryLevelAfter == this.batteryLevelAfter &&
          other.energyAdded == this.energyAdded &&
          other.totalCost == this.totalCost &&
          other.currency == this.currency &&
          other.distanceUnit == this.distanceUnit &&
          other.capacityUnit == this.capacityUnit &&
          other.notes == this.notes &&
          other.syncedAt == this.syncedAt &&
          other.deviceId == this.deviceId &&
          other.vehicleId == this.vehicleId &&
          other.exchangeRateAtEntry == this.exchangeRateAtEntry &&
          other.defaultCurrencyAtEntry == this.defaultCurrencyAtEntry);
}

class FillEntriesCompanion extends UpdateCompanion<FillEntryRow> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<String> fuelType;
  final Value<double?> odometer;
  final Value<double?> fuelAmount;
  final Value<double?> batteryLevelBefore;
  final Value<double?> batteryLevelAfter;
  final Value<double?> energyAdded;
  final Value<double> totalCost;
  final Value<String> currency;
  final Value<String?> distanceUnit;
  final Value<String?> capacityUnit;
  final Value<String?> notes;
  final Value<DateTime?> syncedAt;
  final Value<String> deviceId;
  final Value<String> vehicleId;
  final Value<double?> exchangeRateAtEntry;
  final Value<String?> defaultCurrencyAtEntry;
  final Value<int> rowid;
  const FillEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.odometer = const Value.absent(),
    this.fuelAmount = const Value.absent(),
    this.batteryLevelBefore = const Value.absent(),
    this.batteryLevelAfter = const Value.absent(),
    this.energyAdded = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.currency = const Value.absent(),
    this.distanceUnit = const Value.absent(),
    this.capacityUnit = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.exchangeRateAtEntry = const Value.absent(),
    this.defaultCurrencyAtEntry = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FillEntriesCompanion.insert({
    required String id,
    required DateTime timestamp,
    required String fuelType,
    this.odometer = const Value.absent(),
    this.fuelAmount = const Value.absent(),
    this.batteryLevelBefore = const Value.absent(),
    this.batteryLevelAfter = const Value.absent(),
    this.energyAdded = const Value.absent(),
    required double totalCost,
    required String currency,
    this.distanceUnit = const Value.absent(),
    this.capacityUnit = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncedAt = const Value.absent(),
    required String deviceId,
    required String vehicleId,
    this.exchangeRateAtEntry = const Value.absent(),
    this.defaultCurrencyAtEntry = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timestamp = Value(timestamp),
       fuelType = Value(fuelType),
       totalCost = Value(totalCost),
       currency = Value(currency),
       deviceId = Value(deviceId),
       vehicleId = Value(vehicleId);
  static Insertable<FillEntryRow> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? fuelType,
    Expression<double>? odometer,
    Expression<double>? fuelAmount,
    Expression<double>? batteryLevelBefore,
    Expression<double>? batteryLevelAfter,
    Expression<double>? energyAdded,
    Expression<double>? totalCost,
    Expression<String>? currency,
    Expression<String>? distanceUnit,
    Expression<String>? capacityUnit,
    Expression<String>? notes,
    Expression<DateTime>? syncedAt,
    Expression<String>? deviceId,
    Expression<String>? vehicleId,
    Expression<double>? exchangeRateAtEntry,
    Expression<String>? defaultCurrencyAtEntry,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (fuelType != null) 'fuel_type': fuelType,
      if (odometer != null) 'odometer': odometer,
      if (fuelAmount != null) 'fuel_amount': fuelAmount,
      if (batteryLevelBefore != null)
        'battery_level_before': batteryLevelBefore,
      if (batteryLevelAfter != null) 'battery_level_after': batteryLevelAfter,
      if (energyAdded != null) 'energy_added': energyAdded,
      if (totalCost != null) 'total_cost': totalCost,
      if (currency != null) 'currency': currency,
      if (distanceUnit != null) 'distance_unit': distanceUnit,
      if (capacityUnit != null) 'capacity_unit': capacityUnit,
      if (notes != null) 'notes': notes,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (exchangeRateAtEntry != null)
        'exchange_rate_at_entry': exchangeRateAtEntry,
      if (defaultCurrencyAtEntry != null)
        'default_currency_at_entry': defaultCurrencyAtEntry,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FillEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? timestamp,
    Value<String>? fuelType,
    Value<double?>? odometer,
    Value<double?>? fuelAmount,
    Value<double?>? batteryLevelBefore,
    Value<double?>? batteryLevelAfter,
    Value<double?>? energyAdded,
    Value<double>? totalCost,
    Value<String>? currency,
    Value<String?>? distanceUnit,
    Value<String?>? capacityUnit,
    Value<String?>? notes,
    Value<DateTime?>? syncedAt,
    Value<String>? deviceId,
    Value<String>? vehicleId,
    Value<double?>? exchangeRateAtEntry,
    Value<String?>? defaultCurrencyAtEntry,
    Value<int>? rowid,
  }) {
    return FillEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      fuelType: fuelType ?? this.fuelType,
      odometer: odometer ?? this.odometer,
      fuelAmount: fuelAmount ?? this.fuelAmount,
      batteryLevelBefore: batteryLevelBefore ?? this.batteryLevelBefore,
      batteryLevelAfter: batteryLevelAfter ?? this.batteryLevelAfter,
      energyAdded: energyAdded ?? this.energyAdded,
      totalCost: totalCost ?? this.totalCost,
      currency: currency ?? this.currency,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      capacityUnit: capacityUnit ?? this.capacityUnit,
      notes: notes ?? this.notes,
      syncedAt: syncedAt ?? this.syncedAt,
      deviceId: deviceId ?? this.deviceId,
      vehicleId: vehicleId ?? this.vehicleId,
      exchangeRateAtEntry: exchangeRateAtEntry ?? this.exchangeRateAtEntry,
      defaultCurrencyAtEntry:
          defaultCurrencyAtEntry ?? this.defaultCurrencyAtEntry,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<double>(odometer.value);
    }
    if (fuelAmount.present) {
      map['fuel_amount'] = Variable<double>(fuelAmount.value);
    }
    if (batteryLevelBefore.present) {
      map['battery_level_before'] = Variable<double>(batteryLevelBefore.value);
    }
    if (batteryLevelAfter.present) {
      map['battery_level_after'] = Variable<double>(batteryLevelAfter.value);
    }
    if (energyAdded.present) {
      map['energy_added'] = Variable<double>(energyAdded.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (distanceUnit.present) {
      map['distance_unit'] = Variable<String>(distanceUnit.value);
    }
    if (capacityUnit.present) {
      map['capacity_unit'] = Variable<String>(capacityUnit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (exchangeRateAtEntry.present) {
      map['exchange_rate_at_entry'] = Variable<double>(
        exchangeRateAtEntry.value,
      );
    }
    if (defaultCurrencyAtEntry.present) {
      map['default_currency_at_entry'] = Variable<String>(
        defaultCurrencyAtEntry.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FillEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('fuelType: $fuelType, ')
          ..write('odometer: $odometer, ')
          ..write('fuelAmount: $fuelAmount, ')
          ..write('batteryLevelBefore: $batteryLevelBefore, ')
          ..write('batteryLevelAfter: $batteryLevelAfter, ')
          ..write('energyAdded: $energyAdded, ')
          ..write('totalCost: $totalCost, ')
          ..write('currency: $currency, ')
          ..write('distanceUnit: $distanceUnit, ')
          ..write('capacityUnit: $capacityUnit, ')
          ..write('notes: $notes, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('exchangeRateAtEntry: $exchangeRateAtEntry, ')
          ..write('defaultCurrencyAtEntry: $defaultCurrencyAtEntry, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles
    with TableInfo<$VehiclesTable, VehicleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
    'make',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
    'vin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _licensePlateMeta = const VerificationMeta(
    'licensePlate',
  );
  @override
  late final GeneratedColumn<String> licensePlate = GeneratedColumn<String>(
    'license_plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tireSizeStockMeta = const VerificationMeta(
    'tireSizeStock',
  );
  @override
  late final GeneratedColumn<String> tireSizeStock = GeneratedColumn<String>(
    'tire_size_stock',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tireSizeRunningMeta = const VerificationMeta(
    'tireSizeRunning',
  );
  @override
  late final GeneratedColumn<String> tireSizeRunning = GeneratedColumn<String>(
    'tire_size_running',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    fuelType,
    make,
    model,
    year,
    vin,
    licensePlate,
    tireSizeStock,
    tireSizeRunning,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fuelTypeMeta);
    }
    if (data.containsKey('make')) {
      context.handle(
        _makeMeta,
        make.isAcceptableOrUnknown(data['make']!, _makeMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('vin')) {
      context.handle(
        _vinMeta,
        vin.isAcceptableOrUnknown(data['vin']!, _vinMeta),
      );
    }
    if (data.containsKey('license_plate')) {
      context.handle(
        _licensePlateMeta,
        licensePlate.isAcceptableOrUnknown(
          data['license_plate']!,
          _licensePlateMeta,
        ),
      );
    }
    if (data.containsKey('tire_size_stock')) {
      context.handle(
        _tireSizeStockMeta,
        tireSizeStock.isAcceptableOrUnknown(
          data['tire_size_stock']!,
          _tireSizeStockMeta,
        ),
      );
    }
    if (data.containsKey('tire_size_running')) {
      context.handle(
        _tireSizeRunningMeta,
        tireSizeRunning.isAcceptableOrUnknown(
          data['tire_size_running']!,
          _tireSizeRunningMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      make: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      vin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vin'],
      ),
      licensePlate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_plate'],
      ),
      tireSizeStock: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tire_size_stock'],
      ),
      tireSizeRunning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tire_size_running'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class VehicleRow extends DataClass implements Insertable<VehicleRow> {
  final String id;
  final String name;
  final String fuelType;
  final String? make;
  final String? model;
  final int? year;
  final String? vin;
  final String? licensePlate;
  final String? tireSizeStock;
  final String? tireSizeRunning;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const VehicleRow({
    required this.id,
    required this.name,
    required this.fuelType,
    this.make,
    this.model,
    this.year,
    this.vin,
    this.licensePlate,
    this.tireSizeStock,
    this.tireSizeRunning,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['fuel_type'] = Variable<String>(fuelType);
    if (!nullToAbsent || make != null) {
      map['make'] = Variable<String>(make);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || vin != null) {
      map['vin'] = Variable<String>(vin);
    }
    if (!nullToAbsent || licensePlate != null) {
      map['license_plate'] = Variable<String>(licensePlate);
    }
    if (!nullToAbsent || tireSizeStock != null) {
      map['tire_size_stock'] = Variable<String>(tireSizeStock);
    }
    if (!nullToAbsent || tireSizeRunning != null) {
      map['tire_size_running'] = Variable<String>(tireSizeRunning);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      fuelType: Value(fuelType),
      make: make == null && nullToAbsent ? const Value.absent() : Value(make),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      vin: vin == null && nullToAbsent ? const Value.absent() : Value(vin),
      licensePlate: licensePlate == null && nullToAbsent
          ? const Value.absent()
          : Value(licensePlate),
      tireSizeStock: tireSizeStock == null && nullToAbsent
          ? const Value.absent()
          : Value(tireSizeStock),
      tireSizeRunning: tireSizeRunning == null && nullToAbsent
          ? const Value.absent()
          : Value(tireSizeRunning),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory VehicleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      make: serializer.fromJson<String?>(json['make']),
      model: serializer.fromJson<String?>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      vin: serializer.fromJson<String?>(json['vin']),
      licensePlate: serializer.fromJson<String?>(json['licensePlate']),
      tireSizeStock: serializer.fromJson<String?>(json['tireSizeStock']),
      tireSizeRunning: serializer.fromJson<String?>(json['tireSizeRunning']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'fuelType': serializer.toJson<String>(fuelType),
      'make': serializer.toJson<String?>(make),
      'model': serializer.toJson<String?>(model),
      'year': serializer.toJson<int?>(year),
      'vin': serializer.toJson<String?>(vin),
      'licensePlate': serializer.toJson<String?>(licensePlate),
      'tireSizeStock': serializer.toJson<String?>(tireSizeStock),
      'tireSizeRunning': serializer.toJson<String?>(tireSizeRunning),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  VehicleRow copyWith({
    String? id,
    String? name,
    String? fuelType,
    Value<String?> make = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> vin = const Value.absent(),
    Value<String?> licensePlate = const Value.absent(),
    Value<String?> tireSizeStock = const Value.absent(),
    Value<String?> tireSizeRunning = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => VehicleRow(
    id: id ?? this.id,
    name: name ?? this.name,
    fuelType: fuelType ?? this.fuelType,
    make: make.present ? make.value : this.make,
    model: model.present ? model.value : this.model,
    year: year.present ? year.value : this.year,
    vin: vin.present ? vin.value : this.vin,
    licensePlate: licensePlate.present ? licensePlate.value : this.licensePlate,
    tireSizeStock: tireSizeStock.present
        ? tireSizeStock.value
        : this.tireSizeStock,
    tireSizeRunning: tireSizeRunning.present
        ? tireSizeRunning.value
        : this.tireSizeRunning,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  VehicleRow copyWithCompanion(VehiclesCompanion data) {
    return VehicleRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      vin: data.vin.present ? data.vin.value : this.vin,
      licensePlate: data.licensePlate.present
          ? data.licensePlate.value
          : this.licensePlate,
      tireSizeStock: data.tireSizeStock.present
          ? data.tireSizeStock.value
          : this.tireSizeStock,
      tireSizeRunning: data.tireSizeRunning.present
          ? data.tireSizeRunning.value
          : this.tireSizeRunning,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fuelType: $fuelType, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('vin: $vin, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('tireSizeStock: $tireSizeStock, ')
          ..write('tireSizeRunning: $tireSizeRunning, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    fuelType,
    make,
    model,
    year,
    vin,
    licensePlate,
    tireSizeStock,
    tireSizeRunning,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.fuelType == this.fuelType &&
          other.make == this.make &&
          other.model == this.model &&
          other.year == this.year &&
          other.vin == this.vin &&
          other.licensePlate == this.licensePlate &&
          other.tireSizeStock == this.tireSizeStock &&
          other.tireSizeRunning == this.tireSizeRunning &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VehiclesCompanion extends UpdateCompanion<VehicleRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> fuelType;
  final Value<String?> make;
  final Value<String?> model;
  final Value<int?> year;
  final Value<String?> vin;
  final Value<String?> licensePlate;
  final Value<String?> tireSizeStock;
  final Value<String?> tireSizeRunning;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.vin = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.tireSizeStock = const Value.absent(),
    this.tireSizeRunning = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required String name,
    required String fuelType,
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.vin = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.tireSizeStock = const Value.absent(),
    this.tireSizeRunning = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       fuelType = Value(fuelType),
       createdAt = Value(createdAt);
  static Insertable<VehicleRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? fuelType,
    Expression<String>? make,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? vin,
    Expression<String>? licensePlate,
    Expression<String>? tireSizeStock,
    Expression<String>? tireSizeRunning,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (fuelType != null) 'fuel_type': fuelType,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (vin != null) 'vin': vin,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (tireSizeStock != null) 'tire_size_stock': tireSizeStock,
      if (tireSizeRunning != null) 'tire_size_running': tireSizeRunning,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? fuelType,
    Value<String?>? make,
    Value<String?>? model,
    Value<int?>? year,
    Value<String?>? vin,
    Value<String?>? licensePlate,
    Value<String?>? tireSizeStock,
    Value<String?>? tireSizeRunning,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      fuelType: fuelType ?? this.fuelType,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      vin: vin ?? this.vin,
      licensePlate: licensePlate ?? this.licensePlate,
      tireSizeStock: tireSizeStock ?? this.tireSizeStock,
      tireSizeRunning: tireSizeRunning ?? this.tireSizeRunning,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (vin.present) {
      map['vin'] = Variable<String>(vin.value);
    }
    if (licensePlate.present) {
      map['license_plate'] = Variable<String>(licensePlate.value);
    }
    if (tireSizeStock.present) {
      map['tire_size_stock'] = Variable<String>(tireSizeStock.value);
    }
    if (tireSizeRunning.present) {
      map['tire_size_running'] = Variable<String>(tireSizeRunning.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('fuelType: $fuelType, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('vin: $vin, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('tireSizeStock: $tireSizeStock, ')
          ..write('tireSizeRunning: $tireSizeRunning, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingDeletionsTable extends PendingDeletions
    with TableInfo<$PendingDeletionsTable, PendingDeletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingDeletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_deletions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingDeletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_deletedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingDeletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingDeletionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      )!,
    );
  }

  @override
  $PendingDeletionsTable createAlias(String alias) {
    return $PendingDeletionsTable(attachedDatabase, alias);
  }
}

class PendingDeletionRow extends DataClass
    implements Insertable<PendingDeletionRow> {
  final String id;
  final DateTime deletedAt;
  const PendingDeletionRow({required this.id, required this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deleted_at'] = Variable<DateTime>(deletedAt);
    return map;
  }

  PendingDeletionsCompanion toCompanion(bool nullToAbsent) {
    return PendingDeletionsCompanion(
      id: Value(id),
      deletedAt: Value(deletedAt),
    );
  }

  factory PendingDeletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingDeletionRow(
      id: serializer.fromJson<String>(json['id']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
    };
  }

  PendingDeletionRow copyWith({String? id, DateTime? deletedAt}) =>
      PendingDeletionRow(
        id: id ?? this.id,
        deletedAt: deletedAt ?? this.deletedAt,
      );
  PendingDeletionRow copyWithCompanion(PendingDeletionsCompanion data) {
    return PendingDeletionRow(
      id: data.id.present ? data.id.value : this.id,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingDeletionRow(')
          ..write('id: $id, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingDeletionRow &&
          other.id == this.id &&
          other.deletedAt == this.deletedAt);
}

class PendingDeletionsCompanion extends UpdateCompanion<PendingDeletionRow> {
  final Value<String> id;
  final Value<DateTime> deletedAt;
  final Value<int> rowid;
  const PendingDeletionsCompanion({
    this.id = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingDeletionsCompanion.insert({
    required String id,
    required DateTime deletedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deletedAt = Value(deletedAt);
  static Insertable<PendingDeletionRow> custom({
    Expression<String>? id,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingDeletionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? deletedAt,
    Value<int>? rowid,
  }) {
    return PendingDeletionsCompanion(
      id: id ?? this.id,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingDeletionsCompanion(')
          ..write('id: $id, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DatabaseService extends GeneratedDatabase {
  _$DatabaseService(QueryExecutor e) : super(e);
  $DatabaseServiceManager get managers => $DatabaseServiceManager(this);
  late final $FillEntriesTable fillEntries = $FillEntriesTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $PendingDeletionsTable pendingDeletions = $PendingDeletionsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    fillEntries,
    vehicles,
    pendingDeletions,
  ];
}

typedef $$FillEntriesTableCreateCompanionBuilder =
    FillEntriesCompanion Function({
      required String id,
      required DateTime timestamp,
      required String fuelType,
      Value<double?> odometer,
      Value<double?> fuelAmount,
      Value<double?> batteryLevelBefore,
      Value<double?> batteryLevelAfter,
      Value<double?> energyAdded,
      required double totalCost,
      required String currency,
      Value<String?> distanceUnit,
      Value<String?> capacityUnit,
      Value<String?> notes,
      Value<DateTime?> syncedAt,
      required String deviceId,
      required String vehicleId,
      Value<double?> exchangeRateAtEntry,
      Value<String?> defaultCurrencyAtEntry,
      Value<int> rowid,
    });
typedef $$FillEntriesTableUpdateCompanionBuilder =
    FillEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      Value<String> fuelType,
      Value<double?> odometer,
      Value<double?> fuelAmount,
      Value<double?> batteryLevelBefore,
      Value<double?> batteryLevelAfter,
      Value<double?> energyAdded,
      Value<double> totalCost,
      Value<String> currency,
      Value<String?> distanceUnit,
      Value<String?> capacityUnit,
      Value<String?> notes,
      Value<DateTime?> syncedAt,
      Value<String> deviceId,
      Value<String> vehicleId,
      Value<double?> exchangeRateAtEntry,
      Value<String?> defaultCurrencyAtEntry,
      Value<int> rowid,
    });

class $$FillEntriesTableFilterComposer
    extends Composer<_$DatabaseService, $FillEntriesTable> {
  $$FillEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get batteryLevelBefore => $composableBuilder(
    column: $table.batteryLevelBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get batteryLevelAfter => $composableBuilder(
    column: $table.batteryLevelAfter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get energyAdded => $composableBuilder(
    column: $table.energyAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distanceUnit => $composableBuilder(
    column: $table.distanceUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get capacityUnit => $composableBuilder(
    column: $table.capacityUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exchangeRateAtEntry => $composableBuilder(
    column: $table.exchangeRateAtEntry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultCurrencyAtEntry => $composableBuilder(
    column: $table.defaultCurrencyAtEntry,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FillEntriesTableOrderingComposer
    extends Composer<_$DatabaseService, $FillEntriesTable> {
  $$FillEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get batteryLevelBefore => $composableBuilder(
    column: $table.batteryLevelBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get batteryLevelAfter => $composableBuilder(
    column: $table.batteryLevelAfter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get energyAdded => $composableBuilder(
    column: $table.energyAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distanceUnit => $composableBuilder(
    column: $table.distanceUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get capacityUnit => $composableBuilder(
    column: $table.capacityUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleId => $composableBuilder(
    column: $table.vehicleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exchangeRateAtEntry => $composableBuilder(
    column: $table.exchangeRateAtEntry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultCurrencyAtEntry => $composableBuilder(
    column: $table.defaultCurrencyAtEntry,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FillEntriesTableAnnotationComposer
    extends Composer<_$DatabaseService, $FillEntriesTable> {
  $$FillEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<double> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<double> get fuelAmount => $composableBuilder(
    column: $table.fuelAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get batteryLevelBefore => $composableBuilder(
    column: $table.batteryLevelBefore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get batteryLevelAfter => $composableBuilder(
    column: $table.batteryLevelAfter,
    builder: (column) => column,
  );

  GeneratedColumn<double> get energyAdded => $composableBuilder(
    column: $table.energyAdded,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get distanceUnit => $composableBuilder(
    column: $table.distanceUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get capacityUnit => $composableBuilder(
    column: $table.capacityUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get vehicleId =>
      $composableBuilder(column: $table.vehicleId, builder: (column) => column);

  GeneratedColumn<double> get exchangeRateAtEntry => $composableBuilder(
    column: $table.exchangeRateAtEntry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultCurrencyAtEntry => $composableBuilder(
    column: $table.defaultCurrencyAtEntry,
    builder: (column) => column,
  );
}

class $$FillEntriesTableTableManager
    extends
        RootTableManager<
          _$DatabaseService,
          $FillEntriesTable,
          FillEntryRow,
          $$FillEntriesTableFilterComposer,
          $$FillEntriesTableOrderingComposer,
          $$FillEntriesTableAnnotationComposer,
          $$FillEntriesTableCreateCompanionBuilder,
          $$FillEntriesTableUpdateCompanionBuilder,
          (
            FillEntryRow,
            BaseReferences<_$DatabaseService, $FillEntriesTable, FillEntryRow>,
          ),
          FillEntryRow,
          PrefetchHooks Function()
        > {
  $$FillEntriesTableTableManager(_$DatabaseService db, $FillEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FillEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FillEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FillEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<double?> odometer = const Value.absent(),
                Value<double?> fuelAmount = const Value.absent(),
                Value<double?> batteryLevelBefore = const Value.absent(),
                Value<double?> batteryLevelAfter = const Value.absent(),
                Value<double?> energyAdded = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> distanceUnit = const Value.absent(),
                Value<String?> capacityUnit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<double?> exchangeRateAtEntry = const Value.absent(),
                Value<String?> defaultCurrencyAtEntry = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FillEntriesCompanion(
                id: id,
                timestamp: timestamp,
                fuelType: fuelType,
                odometer: odometer,
                fuelAmount: fuelAmount,
                batteryLevelBefore: batteryLevelBefore,
                batteryLevelAfter: batteryLevelAfter,
                energyAdded: energyAdded,
                totalCost: totalCost,
                currency: currency,
                distanceUnit: distanceUnit,
                capacityUnit: capacityUnit,
                notes: notes,
                syncedAt: syncedAt,
                deviceId: deviceId,
                vehicleId: vehicleId,
                exchangeRateAtEntry: exchangeRateAtEntry,
                defaultCurrencyAtEntry: defaultCurrencyAtEntry,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime timestamp,
                required String fuelType,
                Value<double?> odometer = const Value.absent(),
                Value<double?> fuelAmount = const Value.absent(),
                Value<double?> batteryLevelBefore = const Value.absent(),
                Value<double?> batteryLevelAfter = const Value.absent(),
                Value<double?> energyAdded = const Value.absent(),
                required double totalCost,
                required String currency,
                Value<String?> distanceUnit = const Value.absent(),
                Value<String?> capacityUnit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
                required String deviceId,
                required String vehicleId,
                Value<double?> exchangeRateAtEntry = const Value.absent(),
                Value<String?> defaultCurrencyAtEntry = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FillEntriesCompanion.insert(
                id: id,
                timestamp: timestamp,
                fuelType: fuelType,
                odometer: odometer,
                fuelAmount: fuelAmount,
                batteryLevelBefore: batteryLevelBefore,
                batteryLevelAfter: batteryLevelAfter,
                energyAdded: energyAdded,
                totalCost: totalCost,
                currency: currency,
                distanceUnit: distanceUnit,
                capacityUnit: capacityUnit,
                notes: notes,
                syncedAt: syncedAt,
                deviceId: deviceId,
                vehicleId: vehicleId,
                exchangeRateAtEntry: exchangeRateAtEntry,
                defaultCurrencyAtEntry: defaultCurrencyAtEntry,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FillEntriesTable, FillEntryRow>(table),
                  BaseReferences<
                    _$DatabaseService,
                    $FillEntriesTable,
                    FillEntryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FillEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseService,
      $FillEntriesTable,
      FillEntryRow,
      $$FillEntriesTableFilterComposer,
      $$FillEntriesTableOrderingComposer,
      $$FillEntriesTableAnnotationComposer,
      $$FillEntriesTableCreateCompanionBuilder,
      $$FillEntriesTableUpdateCompanionBuilder,
      (
        FillEntryRow,
        BaseReferences<_$DatabaseService, $FillEntriesTable, FillEntryRow>,
      ),
      FillEntryRow,
      PrefetchHooks Function()
    >;
typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      required String id,
      required String name,
      required String fuelType,
      Value<String?> make,
      Value<String?> model,
      Value<int?> year,
      Value<String?> vin,
      Value<String?> licensePlate,
      Value<String?> tireSizeStock,
      Value<String?> tireSizeRunning,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> fuelType,
      Value<String?> make,
      Value<String?> model,
      Value<int?> year,
      Value<String?> vin,
      Value<String?> licensePlate,
      Value<String?> tireSizeStock,
      Value<String?> tireSizeRunning,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$VehiclesTableFilterComposer
    extends Composer<_$DatabaseService, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tireSizeStock => $composableBuilder(
    column: $table.tireSizeStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tireSizeRunning => $composableBuilder(
    column: $table.tireSizeRunning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$DatabaseService, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get make => $composableBuilder(
    column: $table.make,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tireSizeStock => $composableBuilder(
    column: $table.tireSizeStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tireSizeRunning => $composableBuilder(
    column: $table.tireSizeRunning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$DatabaseService, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get vin =>
      $composableBuilder(column: $table.vin, builder: (column) => column);

  GeneratedColumn<String> get licensePlate => $composableBuilder(
    column: $table.licensePlate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tireSizeStock => $composableBuilder(
    column: $table.tireSizeStock,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tireSizeRunning => $composableBuilder(
    column: $table.tireSizeRunning,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$DatabaseService,
          $VehiclesTable,
          VehicleRow,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (
            VehicleRow,
            BaseReferences<_$DatabaseService, $VehiclesTable, VehicleRow>,
          ),
          VehicleRow,
          PrefetchHooks Function()
        > {
  $$VehiclesTableTableManager(_$DatabaseService db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<String?> make = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                Value<String?> licensePlate = const Value.absent(),
                Value<String?> tireSizeStock = const Value.absent(),
                Value<String?> tireSizeRunning = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                fuelType: fuelType,
                make: make,
                model: model,
                year: year,
                vin: vin,
                licensePlate: licensePlate,
                tireSizeStock: tireSizeStock,
                tireSizeRunning: tireSizeRunning,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String fuelType,
                Value<String?> make = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                Value<String?> licensePlate = const Value.absent(),
                Value<String?> tireSizeStock = const Value.absent(),
                Value<String?> tireSizeRunning = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                fuelType: fuelType,
                make: make,
                model: model,
                year: year,
                vin: vin,
                licensePlate: licensePlate,
                tireSizeStock: tireSizeStock,
                tireSizeRunning: tireSizeRunning,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiclesTable, VehicleRow>(table),
                  BaseReferences<_$DatabaseService, $VehiclesTable, VehicleRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseService,
      $VehiclesTable,
      VehicleRow,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (
        VehicleRow,
        BaseReferences<_$DatabaseService, $VehiclesTable, VehicleRow>,
      ),
      VehicleRow,
      PrefetchHooks Function()
    >;
typedef $$PendingDeletionsTableCreateCompanionBuilder =
    PendingDeletionsCompanion Function({
      required String id,
      required DateTime deletedAt,
      Value<int> rowid,
    });
typedef $$PendingDeletionsTableUpdateCompanionBuilder =
    PendingDeletionsCompanion Function({
      Value<String> id,
      Value<DateTime> deletedAt,
      Value<int> rowid,
    });

class $$PendingDeletionsTableFilterComposer
    extends Composer<_$DatabaseService, $PendingDeletionsTable> {
  $$PendingDeletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingDeletionsTableOrderingComposer
    extends Composer<_$DatabaseService, $PendingDeletionsTable> {
  $$PendingDeletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingDeletionsTableAnnotationComposer
    extends Composer<_$DatabaseService, $PendingDeletionsTable> {
  $$PendingDeletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$PendingDeletionsTableTableManager
    extends
        RootTableManager<
          _$DatabaseService,
          $PendingDeletionsTable,
          PendingDeletionRow,
          $$PendingDeletionsTableFilterComposer,
          $$PendingDeletionsTableOrderingComposer,
          $$PendingDeletionsTableAnnotationComposer,
          $$PendingDeletionsTableCreateCompanionBuilder,
          $$PendingDeletionsTableUpdateCompanionBuilder,
          (
            PendingDeletionRow,
            BaseReferences<
              _$DatabaseService,
              $PendingDeletionsTable,
              PendingDeletionRow
            >,
          ),
          PendingDeletionRow,
          PrefetchHooks Function()
        > {
  $$PendingDeletionsTableTableManager(
    _$DatabaseService db,
    $PendingDeletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingDeletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingDeletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingDeletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingDeletionsCompanion(
                id: id,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime deletedAt,
                Value<int> rowid = const Value.absent(),
              }) => PendingDeletionsCompanion.insert(
                id: id,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingDeletionsTable, PendingDeletionRow>(
                    table,
                  ),
                  BaseReferences<
                    _$DatabaseService,
                    $PendingDeletionsTable,
                    PendingDeletionRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingDeletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$DatabaseService,
      $PendingDeletionsTable,
      PendingDeletionRow,
      $$PendingDeletionsTableFilterComposer,
      $$PendingDeletionsTableOrderingComposer,
      $$PendingDeletionsTableAnnotationComposer,
      $$PendingDeletionsTableCreateCompanionBuilder,
      $$PendingDeletionsTableUpdateCompanionBuilder,
      (
        PendingDeletionRow,
        BaseReferences<
          _$DatabaseService,
          $PendingDeletionsTable,
          PendingDeletionRow
        >,
      ),
      PendingDeletionRow,
      PrefetchHooks Function()
    >;

class $DatabaseServiceManager {
  final _$DatabaseService _db;
  $DatabaseServiceManager(this._db);
  $$FillEntriesTableTableManager get fillEntries =>
      $$FillEntriesTableTableManager(_db, _db.fillEntries);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$PendingDeletionsTableTableManager get pendingDeletions =>
      $$PendingDeletionsTableTableManager(_db, _db.pendingDeletions);
}
