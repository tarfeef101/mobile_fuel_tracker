import '../models/fill_entry.dart';

/// Aggregated fuel-economy metrics for a set of entries. Distances come from
/// consecutive odometer readings, corrected by the tire size offset, and are
/// converted to km; fuel amounts are converted to liters.
class EconomyMetrics {
  final double? consumptionPer100Km;
  final double totalDistanceKm;
  final double totalCost;
  final double totalFuelLiters;
  final int fillCount;
  final double averageCostPerFill;

  EconomyMetrics({
    required this.consumptionPer100Km,
    required this.totalDistanceKm,
    required this.totalCost,
    required this.totalFuelLiters,
    required this.fillCount,
    required this.averageCostPerFill,
  });
}

const double _kmPerMile = 1.609344;
const double _litersPerGallon = 3.785411784;

double _kmFactor(String? unit) => unit == 'miles' ? _kmPerMile : 1.0;

double _litersFactor(String? unit) => unit == 'gal' ? _litersPerGallon : 1.0;

List<FillEntry> _sortedChronological(List<FillEntry> entries) {
  final sorted = [...entries]..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  return sorted;
}

double? _entryFuelAmount(FillEntry entry) {
  return entry.fuelAmount ?? (entry.fuelType == 'electric' ? entry.energyAdded : null);
}

/// Segment distance in km from the previous odometer reading (null if unknown).
double? _segmentDistanceKm(FillEntry entry, double? previousOdometer, double tireOffset) {
  if (entry.odometer == null || previousOdometer == null) return null;
  final distance =
      (entry.odometer! - previousOdometer) * (1 + tireOffset) * _kmFactor(entry.distanceUnit);
  return distance > 0 ? distance : null;
}

/// [tireOffsetByVehicle] maps vehicleId to that vehicle's tire size offset;
/// entries without a configured offset use 0.
EconomyMetrics computeEconomy(
  List<FillEntry> entries, {
  Map<String, double> tireOffsetByVehicle = const {},
}) {
  var distanceKm = 0.0;
  var fuelLiters = 0.0;
  var cost = 0.0;
  double? previousOdometer;

  for (final entry in _sortedChronological(entries)) {
    cost += entry.totalCost;
    final amount = _entryFuelAmount(entry);
    if (amount != null) {
      final distance = _segmentDistanceKm(entry, previousOdometer, tireOffsetByVehicle[entry.vehicleId] ?? 0);
      if (distance != null) {
        distanceKm += distance;
        fuelLiters += amount * _litersFactor(entry.capacityUnit);
      }
    }
    if (entry.odometer != null) previousOdometer = entry.odometer;
  }

  return EconomyMetrics(
    consumptionPer100Km: distanceKm > 0 ? fuelLiters / distanceKm * 100 : null,
    totalDistanceKm: distanceKm,
    totalCost: cost,
    totalFuelLiters: fuelLiters,
    fillCount: entries.length,
    averageCostPerFill: entries.isEmpty ? 0.0 : cost / entries.length,
  );
}

/// Per-fill consumption (L/100km equivalent), chronological, for trend charts.
List<double> economyTrend(
  List<FillEntry> entries, {
  Map<String, double> tireOffsetByVehicle = const {},
}) {
  final values = <double>[];
  double? previousOdometer;

  for (final entry in _sortedChronological(entries)) {
    final amount = _entryFuelAmount(entry);
    if (amount != null) {
      final distance = _segmentDistanceKm(entry, previousOdometer, tireOffsetByVehicle[entry.vehicleId] ?? 0);
      if (distance != null) {
        values.add(amount * _litersFactor(entry.capacityUnit) / distance * 100);
      }
    }
    if (entry.odometer != null) previousOdometer = entry.odometer;
  }

  return values;
}

/// Format L/100km consumption as mpg when the user works in miles.
String formatConsumption(double per100Km, {required bool miles}) {
  return miles
      ? '${(235.215 / per100Km).toStringAsFixed(1)} mpg'
      : '${per100Km.toStringAsFixed(1)} L/100km';
}
