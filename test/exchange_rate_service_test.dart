import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fuel_tracker/services/exchange_rate_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final rateBody = jsonEncode({
    'result': 'success',
    'rates': {'EUR': 0.89, 'usd': 1.0},
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  http.Response ok(String body) => http.Response(body, 200);

  MockClient failingClient() =>
      MockClient((request) async => throw Exception('offline'));

  Future<ExchangeRateService> makeService(MockClient client) async =>
      ExchangeRateService(await SharedPreferences.getInstance(), client);

  group('getRates', () {
    test('parses the response and uppercases the keys', () async {
      var requests = 0;
      final client = MockClient((request) async {
        requests++;
        return ok(rateBody);
      });
      final service = await makeService(client);

      expect(await service.getRates('EUR'), {'EUR': 0.89, 'USD': 1.0});
      expect(requests, 1);
    });

    test('returns the fresh cache without a second network call', () async {
      var requests = 0;
      final client = MockClient((request) async {
        requests++;
        return ok(rateBody);
      });
      final service = await makeService(client);

      await service.getRates('EUR');
      expect(service.cachedRates('EUR'), {'EUR': 0.89, 'USD': 1.0});
      expect(await service.getRates('EUR'), {'EUR': 0.89, 'USD': 1.0});
      expect(requests, 1);
    });

    test('refetches when the cache is older than the TTL', () async {
      SharedPreferences.setMockInitialValues({
        'fx_rates_EUR': jsonEncode({
          'fetchedAt':
              DateTime.now().subtract(const Duration(hours: 13)).millisecondsSinceEpoch,
          'rates': {'USD': 1.0},
        }),
      });
      var requests = 0;
      final client = MockClient((request) async {
        requests++;
        return ok(rateBody);
      });
      final service = await makeService(client);

      expect(await service.getRates('EUR'), {'EUR': 0.89, 'USD': 1.0});
      expect(requests, 1);
    });

    test('returns the stale cache when the network fails', () async {
      SharedPreferences.setMockInitialValues({
        'fx_rates_EUR': jsonEncode({
          'fetchedAt':
              DateTime.now().subtract(const Duration(hours: 13)).millisecondsSinceEpoch,
          'rates': {'USD': 1.0},
        }),
      });
      final service = await makeService(failingClient());

      expect(await service.getRates('EUR'), {'USD': 1.0});
    });

    test('returns null when the network fails and nothing was cached', () async {
      final service = await makeService(failingClient());

      expect(await service.getRates('EUR'), isNull);
    });

    test('rejects a non-success response', () async {
      final client = MockClient(
          (request) async => ok(jsonEncode({'result': 'error', 'rates': {}})));
      final service = await makeService(client);

      expect(await service.getRates('EUR'), isNull);
    });
  });

  group('currencyCodes', () {
    test('returns the sorted fetched keys', () async {
      final client = MockClient((request) async => ok(rateBody));
      final service = await makeService(client);

      expect(await service.currencyCodes(base: 'EUR'), ['EUR', 'USD']);
    });

    test('falls back to the default list when nothing was fetched', () async {
      final service = await makeService(failingClient());

      expect(await service.currencyCodes(), ExchangeRateService.fallbackCurrencyCodes);
    });
  });
}
