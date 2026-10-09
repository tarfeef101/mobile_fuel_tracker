import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_tracker/models/fill_entry.dart';
import 'package:fuel_tracker/utils/economy.dart';

FillEntry _entry({
  required String id,
  required DateTime timestamp,
  required String vehicleId,
  double? odometer,
  double? fuelAmount,
  String distanceUnit = 'km',
  String capacityUnit = 'L',
}) {
  return FillEntry(
    id: id,
    timestamp: timestamp,
    fuelType: 'liquid',
    odometer: odometer,
    fuelAmount: fuelAmount,
    totalCost: 10.0,
    currency: 'USD',
    distanceUnit: distanceUnit,
    capacityUnit: capacityUnit,
    deviceId: 'device',
    vehicleId: vehicleId,
  );
}

void main() {
  group('fillEconomies', () {
    test('computes the trip from the previous fill of the same vehicle', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', odometer: 1000, fuelAmount: 10),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', odometer: 1400, fuelAmount: 40),
      ];
      final economies = fillEconomies(entries);

      expect(economies.containsKey('a1'), isFalse, reason: 'first fill has no previous fill');
      expect(economies['a2']!.distanceKm, 400.0);
      expect(economies['a2']!.consumptionPer100Km, 10.0);
    });

    test('does not span segments across vehicles', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', odometer: 1000, fuelAmount: 10),
        _entry(id: 'b1', timestamp: DateTime(2026, 1, 2), vehicleId: 'B', odometer: 5000, fuelAmount: 10),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 3), vehicleId: 'A', odometer: 1400, fuelAmount: 40),
        _entry(id: 'b2', timestamp: DateTime(2026, 1, 4), vehicleId: 'B', odometer: 5100, fuelAmount: 10),
      ];
      final economies = fillEconomies(entries);

      expect(economies['a2']!.distanceKm, 400.0);
      expect(economies['b2']!.distanceKm, 100.0);
      expect(economies['b2']!.consumptionPer100Km, 10.0);
    });

    test('applies the tire size offset', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', odometer: 1000, fuelAmount: 10),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', odometer: 1400, fuelAmount: 40),
      ];
      final economies = fillEconomies(entries, tireOffsetByVehicle: {'A': 0.25});

      expect(economies['a2']!.distanceKm, 500.0);
      expect(economies['a2']!.consumptionPer100Km, 8.0);
    });

    test('converts miles and gallons to km and liters', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', odometer: 0, fuelAmount: 1, distanceUnit: 'miles', capacityUnit: 'gal'),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', odometer: 100, fuelAmount: 2, distanceUnit: 'miles', capacityUnit: 'gal'),
      ];
      final economies = fillEconomies(entries);

      // 2 gal / 100 mi == 50 mpg == 4.704 L/100km
      expect(economies['a2']!.distanceKm, closeTo(160.9344, 1e-4));
      expect(economies['a2']!.consumptionPer100Km, closeTo(4.7043, 1e-3));
    });

    test('skips entries without odometer or fuel amount', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', odometer: 1000, fuelAmount: 10),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 10), vehicleId: 'A', fuelAmount: 10),
        _entry(id: 'a3', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', odometer: 1400),
      ];
      final economies = fillEconomies(entries);

      expect(economies, isEmpty);
    });
  });
}
