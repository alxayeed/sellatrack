import 'package:intl/intl.dart';

extension NumFormattingExtensions on num? {
  String toFormattedCurrency({
    String currencySymbol =
        '\$', // Default, should be configurable or from locale
    int decimalDigits = 2,
    String? locale,
    String fallback = '\$0.00', // Fallback if num is null
  }) {
    if (this == null) return fallback;
    final format = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    );
    return format.format(this!);
  }

  String toCompactFormat({String? locale, String fallback = '0'}) {
    if (this == null) return fallback;
    final format = NumberFormat.compact(locale: locale);
    return format.format(this!);
  }

  String toDecimalFormat({
    int decimalDigits = 2,
    String? locale,
    String fallback = '0.00', // Fallback if num is null
  }) {
    if (this == null) return fallback;
    final format = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    );
    return format.format(this!);
  }
}
