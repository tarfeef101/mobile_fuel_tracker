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

/// Chronological entries paired with the previous odometer reading of the
/// same vehicle, so segment distances never span across vehicles.
Iterable<({FillEntry entry, double? previousOdometer})> _segments(List<FillEntry> entries) sync* {
  final previousByVehicle = <String, double>{};
  for (final entry in _sortedChronological(entries)) {
    yield (entry: entry, previousOdometer: previousByVehicle[entry.vehicleId]);
    if (entry.odometer != null) {
      previousByVehicle[entry.vehicleId] = entry.odometer!;
    }
  }
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

  for (final segment in _segments(entries)) {
    final entry = segment.entry;
    cost += entry.totalCost;
    final amount = _entryFuelAmount(entry);
    if (amount != null) {
      final distance = _segmentDistanceKm(entry, segment.previousOdometer, tireOffsetByVehicle[entry.vehicleId] ?? 0);
      if (distance != null) {
        distanceKm += distance;
        fuelLiters += amount * _litersFactor(entry.capacityUnit);
      }
    }
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

  for (final segment in _segments(entries)) {
    final entry = segment.entry;
    final amount = _entryFuelAmount(entry);
    if (amount != null) {
      final distance = _segmentDistanceKm(entry, segment.previousOdometer, tireOffsetByVehicle[entry.vehicleId] ?? 0);
      if (distance != null) {
        values.add(amount * _litersFactor(entry.capacityUnit) / distance * 100);
      }
    }
  }

  return values;
}

/// Economy of the trip ending at a single fill, i.e. the segment from the
/// previous fill of the same vehicle (by odometer) to this fill.
class FillEconomy {
  final double consumptionPer100Km;
  final double distanceKm;

  const FillEconomy({required this.consumptionPer100Km, required this.distanceKm});
}

/// Per-fill trip economy keyed by entry id. Only fills with a previous
/// odometer reading for the same vehicle and a positive segment distance
/// appear in the map.
Map<String, FillEconomy> fillEconomies(
  List<FillEntry> entries, {
  Map<String, double> tireOffsetByVehicle = const {},
}) {
  final economies = <String, FillEconomy>{};

  for (final segment in _segments(entries)) {
    final entry = segment.entry;
    final amount = _entryFuelAmount(entry);
    if (amount == null) continue;
    final distance = _segmentDistanceKm(entry, segment.previousOdometer, tireOffsetByVehicle[entry.vehicleId] ?? 0);
    if (distance != null) {
      economies[entry.id] = FillEconomy(
        consumptionPer100Km: amount * _litersFactor(entry.capacityUnit) / distance * 100,
        distanceKm: distance,
      );
    }
  }

  return economies;
}

/// Format L/100km consumption as mpg when the user works in miles.
String formatConsumption(double per100Km, {required bool miles}) {
  return miles
      ? '${(235.215 / per100Km).toStringAsFixed(1)} mpg'
      : '${per100Km.toStringAsFixed(1)} L/100km';
}

/// Format a km distance in the user's distance unit.
String formatDistance(double km, {required bool miles}) {
  return miles ? '${(km / _kmPerMile).toStringAsFixed(1)} mi' : '${km.toStringAsFixed(1)} km';
}
