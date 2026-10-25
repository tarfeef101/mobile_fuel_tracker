/// Fixed-factor and rate-based unit conversion. All functions are pure;
/// forex rates are injected by the caller so no I/O happens here.

const double kmPerMile = 1.609344;
const double litersPerGallon = 3.785411784;

/// Convert a distance value between km and miles; null units count as km.
double convertDistance(double value, String? from, String? to) {
  if (from == to) return value;
  final toKm = from == 'miles' ? value * kmPerMile : value;
  return to == 'miles' ? toKm / kmPerMile : toKm;
}

/// Convert a capacity value between L, gal, and mL. kWh passes through only
/// when both sides are kWh — there is no L<->kWh rate.
double convertCapacity(double value, String? from, String? to) {
  if (from == to) return value;
  if (from == 'kWh' || to == 'kWh') return value;
  final toLiters = _toLiters(value, from);
  return _fromLiters(toLiters, to);
}

double _toLiters(double value, String? unit) {
  switch (unit) {
    case 'gal':
      return value * litersPerGallon;
    case 'mL':
      return value / 1000;
    default:
      return value;
  }
}

double _fromLiters(double liters, String? unit) {
  switch (unit) {
    case 'gal':
      return liters / litersPerGallon;
    case 'mL':
      return liters * 1000;
    default:
      return liters;
  }
}

/// Convert a currency amount using [ratesByBase] (base code to table of
/// target code to rate). Identity when both codes match; null when no rate
/// is available.
double? convertCurrencyAmount(
  double amount,
  String from,
  String to, {
  Map<String, Map<String, double>>? ratesByBase,
}) {
  if (from == to) return amount;
  final rate = ratesByBase?[from]?[to];
  return rate == null ? null : amount * rate;
}
