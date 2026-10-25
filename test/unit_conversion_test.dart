import 'package:flutter_test/flutter_test.dart';
import 'package:fuel_tracker/utils/unit_conversion.dart';

void main() {
  group('convertDistance', () {
    test('km to miles', () {
      expect(convertDistance(160.9344, 'km', 'miles'), closeTo(100, 1e-9));
    });

    test('miles to km', () {
      expect(convertDistance(100, 'miles', 'km'), closeTo(160.9344, 1e-9));
    });

    test('a null unit counts as km', () {
      expect(convertDistance(100, null, 'miles'), closeTo(62.1371, 1e-3));
      expect(convertDistance(100, 'miles', null), closeTo(160.9344, 1e-9));
    });

    test('same unit is identity', () {
      expect(convertDistance(42.5, 'km', 'km'), 42.5);
    });
  });

  group('convertCapacity', () {
    test('L to gal', () {
      expect(convertCapacity(37.85411784, 'L', 'gal'), closeTo(10, 1e-9));
    });

    test('gal to L', () {
      expect(convertCapacity(10, 'gal', 'L'), closeTo(37.85411784, 1e-9));
    });

    test('mL to L is a 1000x factor', () {
      expect(convertCapacity(1000, 'mL', 'L'), 1.0);
      expect(convertCapacity(1, 'L', 'mL'), 1000.0);
      expect(convertCapacity(3785.411784, 'mL', 'gal'), closeTo(1, 1e-9));
    });

    test('kWh only passes through when both sides are kWh', () {
      expect(convertCapacity(50, 'kWh', 'kWh'), 50);
      expect(convertCapacity(50, 'kWh', 'L'), 50);
      expect(convertCapacity(50, 'L', 'kWh'), 50);
    });

    test('a null unit counts as L', () {
      expect(convertCapacity(37.85411784, null, 'gal'), closeTo(10, 1e-9));
    });
  });

  group('convertCurrencyAmount', () {
    final ratesByBase = {
      'EUR': {'USD': 1.08, 'GBP': 0.85},
      'USD': {'EUR': 1 / 1.08},
    };

    test('converts with a known rate', () {
      expect(convertCurrencyAmount(100, 'EUR', 'USD', ratesByBase: ratesByBase),
          closeTo(108, 1e-9));
    });

    test('identity when both codes match', () {
      expect(convertCurrencyAmount(100, 'USD', 'USD', ratesByBase: ratesByBase), 100);
    });

    test('null when the rate is missing', () {
      expect(convertCurrencyAmount(100, 'EUR', 'JPY', ratesByBase: ratesByBase), isNull);
      expect(convertCurrencyAmount(100, 'JPY', 'USD', ratesByBase: ratesByBase), isNull);
      expect(convertCurrencyAmount(100, 'EUR', 'USD'), isNull);
    });
  });
}
