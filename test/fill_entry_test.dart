import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_tracker/models/fill_entry.dart';

void main() {
  group('FillEntry Model Tests', () {
    test('FillEntry creation with all parameters', () {
      final entry = FillEntry(
        id: 'test-id-123',
        timestamp: DateTime.now(),
        fuelType: 'liquid',
        odometer: 1000.5,
        fuelAmount: 45.2,
        totalCost: 50.0,
        currency: 'USD',
        deviceId: 'device-123',
        vehicleId: 'vehicle-123',
      );

      expect(entry.id, 'test-id-123');
      expect(entry.fuelType, 'liquid');
      expect(entry.odometer, 1000.5);
      expect(entry.fuelAmount, 45.2);
      expect(entry.totalCost, 50.0);
      expect(entry.currency, 'USD');
      expect(entry.deviceId, 'device-123');
    });

    test('FillEntry from JSON', () {
      final json = {
        'id': 'test-id-456',
        'timestamp': '2023-01-01T10:00:00.000Z',
        'fuelType': 'electric',
        'batteryLevelBefore': 25.0,
        'batteryLevelAfter': 80.0,
        'energyAdded': 15.5,
        'totalCost': 25.0,
        'currency': 'EUR',
        'deviceId': 'device-456',
        'vehicleId': 'vehicle-456',
      };

      final entry = FillEntry.fromJson(json);

      expect(entry.id, 'test-id-456');
      expect(entry.fuelType, 'electric');
      expect(entry.batteryLevelBefore, 25.0);
      expect(entry.batteryLevelAfter, 80.0);
      expect(entry.energyAdded, 15.5);
      expect(entry.totalCost, 25.0);
      expect(entry.currency, 'EUR');
      expect(entry.deviceId, 'device-456');
    });

    test('FillEntry to JSON', () {
      final entry = FillEntry(
        id: 'test-id-789',
        timestamp: DateTime.parse('2023-01-01T10:00:00.000Z'),
        fuelType: 'both',
        odometer: 500.0,
        fuelAmount: 25.0,
        batteryLevelBefore: 30.0,
        batteryLevelAfter: 70.0,
        energyAdded: 10.0,
        totalCost: 35.0,
        currency: 'GBP',
        deviceId: 'device-789',
        vehicleId: 'vehicle-789',
      );

      final json = entry.toJson();

      expect(json['id'], 'test-id-789');
      expect(json['fuelType'], 'both');
      expect(json['odometer'], 500.0);
      expect(json['fuelAmount'], 25.0);
      expect(json['batteryLevelBefore'], 30.0);
      expect(json['batteryLevelAfter'], 70.0);
      expect(json['energyAdded'], 10.0);
      expect(json['totalCost'], 35.0);
      expect(json['currency'], 'GBP');
      expect(json['deviceId'], 'device-789');
    });

    test('pinnedRateFor only matches its own default currency', () {
      final entry = FillEntry(
        id: 'pinned-1',
        timestamp: DateTime.parse('2023-01-01T10:00:00.000Z'),
        fuelType: 'liquid',
        totalCost: 100.0,
        currency: 'EUR',
        deviceId: 'device',
        vehicleId: 'vehicle',
        exchangeRateAtEntry: 1.2,
        defaultCurrencyAtEntry: 'USD',
      );

      expect(entry.pinnedRateFor('USD'), 1.2);
      expect(entry.pinnedRateFor('EUR'), isNull);

      final unpinned = FillEntry(
        id: 'pinned-2',
        timestamp: DateTime.parse('2023-01-01T10:00:00.000Z'),
        fuelType: 'liquid',
        totalCost: 100.0,
        currency: 'EUR',
        deviceId: 'device',
        vehicleId: 'vehicle',
      );
      expect(unpinned.pinnedRateFor('USD'), isNull);
    });

    test('exchange rate pin fields round-trip through JSON', () {
      final entry = FillEntry.fromJson({
        'id': 'pinned-3',
        'timestamp': '2023-01-01T10:00:00.000Z',
        'fuelType': 'liquid',
        'totalCost': 100.0,
        'currency': 'EUR',
        'deviceId': 'device',
        'vehicleId': 'vehicle',
        'exchangeRateAtEntry': 1.15,
        'defaultCurrencyAtEntry': 'USD',
      });

      expect(entry.exchangeRateAtEntry, 1.15);
      expect(entry.defaultCurrencyAtEntry, 'USD');
      expect(entry.toJson()['exchangeRateAtEntry'], 1.15);
      expect(entry.toJson()['defaultCurrencyAtEntry'], 'USD');

      // Legacy payloads without the fields stay null.
      final legacy = FillEntry.fromJson({
        'id': 'legacy-1',
        'timestamp': '2023-01-01T10:00:00.000Z',
        'fuelType': 'liquid',
        'totalCost': 10.0,
        'currency': 'EUR',
        'deviceId': 'device',
        'vehicleId': 'vehicle',
      });
      expect(legacy.exchangeRateAtEntry, isNull);
      expect(legacy.defaultCurrencyAtEntry, isNull);
    });
  });
}
