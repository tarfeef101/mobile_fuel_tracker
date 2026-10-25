import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_tracker/models/fill_entry.dart';
import 'package:fuel_tracker/utils/economy.dart';

FillEntry _entry({
  required String id,
  required DateTime timestamp,
  required String vehicleId,
  double? odometer,
  double? fuelAmount,
  double? totalCost,
  String currency = 'USD',
  String distanceUnit = 'km',
  String capacityUnit = 'L',
  double? exchangeRateAtEntry,
  String? defaultCurrencyAtEntry,
}) {
  return FillEntry(
    id: id,
    timestamp: timestamp,
    fuelType: 'liquid',
    odometer: odometer,
    fuelAmount: fuelAmount,
    totalCost: totalCost ?? 10.0,
    currency: currency,
    distanceUnit: distanceUnit,
    capacityUnit: capacityUnit,
    deviceId: 'device',
    vehicleId: vehicleId,
    exchangeRateAtEntry: exchangeRateAtEntry,
    defaultCurrencyAtEntry: defaultCurrencyAtEntry,
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

  group('averageCostPerUnit', () {
    test('weights by fuel volume instead of counting fills', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', fuelAmount: 5, totalCost: 10.0),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', fuelAmount: 15, totalCost: 45.0),
      ];

      // Simple mean of per-fill prices is 2.5; weighted is 55 / 20.
      expect(averageCostPerUnit(entries), 2.75);
    });

    test('skips entries without a usable volume', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A'),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', fuelAmount: 0),
      ];

      expect(averageCostPerUnit(entries), isNull);
    });
  });

  group('mixed currency and units', () {
    final ratesByBase = {'EUR': {'USD': 1.08}};

    test('computeEconomy converts costs into the requested currency', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', odometer: 1000, fuelAmount: 10, totalCost: 10.0),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', odometer: 1400, fuelAmount: 40, totalCost: 100.0, currency: 'EUR'),
      ];

      final metrics = computeEconomy(entries, currency: 'USD', ratesByBase: ratesByBase);
      expect(metrics.totalCost, closeTo(118.0, 1e-9));
      expect(metrics.averageCostPerFill, closeTo(59.0, 1e-9));
    });

    test('falls back to the raw cost when no rate is available', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', totalCost: 10.0),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', totalCost: 100.0, currency: 'EUR'),
      ];

      expect(computeEconomy(entries, currency: 'USD').totalCost, 110.0);
      expect(computeEconomy(entries, currency: 'USD', ratesByBase: {'EUR': {'GBP': 0.85}}).totalCost, 110.0);
    });

    test('averageCostPerUnit converts cost and volume into the default units', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', fuelAmount: 10, totalCost: 108.0, currency: 'EUR'),
      ];

      // 108 EUR at 1.08 => 116.64 USD for 10 L => 11.664 USD/L.
      expect(
          averageCostPerUnit(entries, currency: 'USD', capacityUnit: 'L', ratesByBase: ratesByBase),
          closeTo(11.664, 1e-9));
      // The same cost spread over 10 L = 2.642 gal => 44.15 USD/gal.
      expect(
          averageCostPerUnit(entries, currency: 'USD', capacityUnit: 'gal', ratesByBase: ratesByBase),
          closeTo(44.15, 0.01));
    });

    test('mL entries convert to liters instead of being treated as L', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', odometer: 0, fuelAmount: 10000, capacityUnit: 'mL'),
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', odometer: 1000, fuelAmount: 10000, capacityUnit: 'mL'),
      ];

      // 10 L over 1000 km == 1.0 L/100km (was 1000 L/100km before the fix).
      expect(fillEconomies(entries)['a2']!.consumptionPer100Km, closeTo(1.0, 1e-9));
      expect(computeEconomy(entries).totalFuelLiters, closeTo(10.0, 1e-9));
    });

    test('a pinned rate wins over the live rate map', () {
      final entries = [
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', totalCost: 10.0),
        // Pinned at 1.20 when recorded; the live map says 1.08.
        _entry(id: 'a2', timestamp: DateTime(2026, 1, 15), vehicleId: 'A', fuelAmount: 10, totalCost: 100.0, currency: 'EUR', exchangeRateAtEntry: 1.20, defaultCurrencyAtEntry: 'USD'),
      ];

      expect(computeEconomy(entries, currency: 'USD', ratesByBase: ratesByBase).totalCost, 130.0);
      expect(
          averageCostPerUnit(entries, currency: 'USD', capacityUnit: 'L', ratesByBase: ratesByBase),
          closeTo(12.0, 1e-9));
    });

    test('a pin against another default currency falls back to the live map', () {
      final entries = [
        // Pinned for EUR as the default, but the app now shows USD.
        _entry(id: 'a1', timestamp: DateTime(2026, 1, 1), vehicleId: 'A', totalCost: 100.0, currency: 'EUR', exchangeRateAtEntry: 1.20, defaultCurrencyAtEntry: 'GBP'),
      ];

      expect(computeEconomy(entries, currency: 'USD', ratesByBase: ratesByBase).totalCost, closeTo(108.0, 1e-9));
    });
  });
}
