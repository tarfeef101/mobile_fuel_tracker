/// ISO 4217 codes whose smallest transacted unit is the unit itself (no cents).
const Set<String> zeroFractionCurrencies = {
  'BIF', 'CLP', 'DJF', 'GNF', 'ISK', 'JPY', 'KMF', 'KRW',
  'MGA', 'PYG', 'RWF', 'UGX', 'VND', 'VUV', 'XAF', 'XOF', 'XPF',
};

/// Fraction digits of the most granular unit used in transactions
/// (e.g. 2 for USD, 0 for JPY). Unknown codes default to 2.
int currencyFractionDigits(String code) =>
    zeroFractionCurrencies.contains(code) ? 0 : 2;
