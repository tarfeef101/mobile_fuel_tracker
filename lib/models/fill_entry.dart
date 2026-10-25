/// User-facing labels for the stored fuel type values.
const Map<String, String> fuelTypeLabels = {
  'liquid': 'Fuel',
  'electric': 'Electric',
  'both': 'Both',
};

String fuelTypeLabel(String fuelType) => fuelTypeLabels[fuelType] ?? fuelType;

class FillEntry {
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
  final String vehicleId; // Foreign key to Vehicle table
  // Exchange rate pinned at record time so displayed values don't drift as
  // live rates change: units of [currency] per unit of
  // [defaultCurrencyAtEntry]. Both null when the entry's currency was the
  // default (no conversion needed) or no rate was available at the time.
  final double? exchangeRateAtEntry;
  final String? defaultCurrencyAtEntry;

  FillEntry({
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

  /// The pinned rate to use when converting into [to] — the stored rate
  /// only applies to the default currency it was recorded against.
  double? pinnedRateFor(String to) =>
      defaultCurrencyAtEntry == to ? exchangeRateAtEntry : null;

  // Factory constructor for creating from JSON
  factory FillEntry.fromJson(Map<String, dynamic> json) {
    return FillEntry(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      fuelType: json['fuelType'] as String,
      odometer: json['odometer'] as double?,
      fuelAmount: json['fuelAmount'] as double?,
      batteryLevelBefore: json['batteryLevelBefore'] as double?,
      batteryLevelAfter: json['batteryLevelAfter'] as double?,
      energyAdded: json['energyAdded'] as double?,
      totalCost: json['totalCost'] as double,
      currency: json['currency'] as String,
      distanceUnit: json['distanceUnit'] as String?,
      capacityUnit: json['capacityUnit'] as String?,
      notes: json['notes'] as String?,
      syncedAt: json['syncedAt'] == null ? null : DateTime.parse(json['syncedAt'] as String),
      deviceId: json['deviceId'] as String,
      vehicleId: json['vehicleId'] as String,
      exchangeRateAtEntry: (json['exchangeRateAtEntry'] as num?)?.toDouble(),
      defaultCurrencyAtEntry: json['defaultCurrencyAtEntry'] as String?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'fuelType': fuelType,
      'odometer': odometer,
      'fuelAmount': fuelAmount,
      'batteryLevelBefore': batteryLevelBefore,
      'batteryLevelAfter': batteryLevelAfter,
      'energyAdded': energyAdded,
      'totalCost': totalCost,
      'currency': currency,
      'distanceUnit': distanceUnit,
      'capacityUnit': capacityUnit,
      'notes': notes,
      'syncedAt': syncedAt?.toIso8601String(),
      'deviceId': deviceId,
      'vehicleId': vehicleId,
      'exchangeRateAtEntry': exchangeRateAtEntry,
      'defaultCurrencyAtEntry': defaultCurrencyAtEntry,
    };
  }

  // Copy with method for creating modified instances
  FillEntry copyWith({
    String? id,
    DateTime? timestamp,
    String? fuelType,
    double? odometer,
    double? fuelAmount,
    double? batteryLevelBefore,
    double? batteryLevelAfter,
    double? energyAdded,
    double? totalCost,
    String? currency,
    String? distanceUnit,
    String? capacityUnit,
    String? notes,
    DateTime? syncedAt,
    String? deviceId,
    String? vehicleId,
    double? exchangeRateAtEntry,
    String? defaultCurrencyAtEntry,
  }) {
    return FillEntry(
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
      defaultCurrencyAtEntry: defaultCurrencyAtEntry ?? this.defaultCurrencyAtEntry,
    );
  }

  // Calculate segment distance (odometer difference)
  double? getSegmentDistance() {
    if (odometer != null && fuelType == 'liquid') {
      // This would require previous entry data to calculate properly
      // For now, just return the odometer value as a placeholder
      return odometer;
    }
    return null;
  }

  // Calculate consumption per 100 units
  double? getConsumptionPer100() {
    if (fuelType == 'liquid' && fuelAmount != null && odometer != null) {
      // For this implementation, we'll just return a placeholder
      // Actual implementation would require previous entry to calculate distance
      return null;
    }
    return null;
  }

  // Calculate cost per distance unit
  double? getCostPerDistance() {
    if (odometer != null) {
      // For this implementation, we'll just return a placeholder
      // Actual implementation would require previous entry to calculate distance
      return null;
    }
    return null;
  }
}
