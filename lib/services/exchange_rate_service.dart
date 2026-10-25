import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Daily forex rates from a keyless API, cached in [SharedPreferences] with a
/// TTL so the UI can read them synchronously during build.
class ExchangeRateService {
  static const String _endpoint = 'https://open.er-api.com/v6/latest/';
  static const Duration cacheTtl = Duration(hours: 12);

  /// Offered by currency pickers when no rate table has been fetched yet.
  static const List<String> fallbackCurrencyCodes = [
    'USD', 'EUR', 'GBP', 'JPY', 'CNY', 'AUD', 'CAD', 'CHF', 'KRW', 'INR',
  ];

  final http.Client _httpClient;
  final SharedPreferences _preferences;

  ExchangeRateService(this._preferences, [http.Client? httpClient])
      : _httpClient = httpClient ?? http.Client();

  static Future<ExchangeRateService> create([http.Client? httpClient]) async {
    final preferences = await SharedPreferences.getInstance();
    return ExchangeRateService(preferences, httpClient);
  }

  /// Rates for [base] (code to units per one base unit). Fresh cache is
  /// returned without a network call; on miss/stale it fetches and on
  /// failure falls back to the stale cache. Null when no table was ever
  /// fetched.
  Future<Map<String, double>?> getRates(String base) async {
    final cached = _readCache(base);
    if (cached != null && DateTime.now().difference(cached.fetchedAt) <= cacheTtl) {
      return cached.rates;
    }
    try {
      final response = await _httpClient.get(Uri.parse('$_endpoint${base.toUpperCase()}'));
      final rates = _parseResponse(response);
      if (rates != null) {
        await _writeCache(base, rates);
        return rates;
      }
    } catch (_) {}
    return cached?.rates;
  }

  /// Synchronous accessor for the build path: latest cached table, or null
  /// when no rates for [base] were ever fetched.
  Map<String, double>? cachedRates(String base) => _readCache(base)?.rates;

  /// Currency codes for pickers: the fetched rate keys, else the fallback.
  Future<List<String>> currencyCodes({String base = 'USD'}) async {
    final rates = await getRates(base);
    if (rates == null || rates.isEmpty) return fallbackCurrencyCodes;
    return rates.keys.toList()..sort();
  }

  /// Isolated parse so the vendor endpoint can be swapped in one place.
  Map<String, double>? _parseResponse(http.Response response) {
    if (response.statusCode != 200) return null;
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['result'] != 'success') return null;
      final rates = (json['rates'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k.toUpperCase(), (v as num).toDouble()),
      );
      return (rates == null || rates.isEmpty) ? null : rates;
    } catch (_) {
      return null;
    }
  }

  _RateCache? _readCache(String base) {
    final raw = _preferences.getString(_cacheKey(base));
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return _RateCache(
        fetchedAt: DateTime.fromMillisecondsSinceEpoch(json['fetchedAt'] as int),
        rates: (json['rates'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as num).toDouble()),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(String base, Map<String, double> rates) async {
    await _preferences.setString(_cacheKey(base), jsonEncode({
      'fetchedAt': DateTime.now().millisecondsSinceEpoch,
      'rates': rates,
    }));
  }

  static String _cacheKey(String base) => 'fx_rates_${base.toUpperCase()}';
}

class _RateCache {
  final DateTime fetchedAt;
  final Map<String, double> rates;

  _RateCache({required this.fetchedAt, required this.rates});
}
