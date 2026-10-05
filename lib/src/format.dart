import 'package:intl/intl.dart';

/// Formats an amount in [currency]: "1.250.000 ₫" in Vietnamese,
/// "₫1,250,000" in English. VND has no minor unit.
String formatMoney(
  int amount,
  String languageCode, {
  String currency = 'VND',
}) => NumberFormat.currency(
  locale: languageCode,
  name: currency,
  symbol: currency == 'VND' ? '₫' : currency,
  decimalDigits: currency == 'VND' ? 0 : 2,
).format(amount);

/// A compact amount for chart labels and KPI tiles: "1,2 Tr" / "1.2M".
String formatCompactMoney(int amount, String languageCode) =>
    NumberFormat.compact(locale: languageCode).format(amount);

String formatDate(DateTime? value, String languageCode) =>
    value == null ? '' : DateFormat.yMd(languageCode).format(value);

String formatDateTime(DateTime? value, String languageCode) =>
    value == null ? '' : DateFormat.yMd(languageCode).add_Hm().format(value);

/// A quantity without a trailing ".0": "2", "1.5".
String formatQuantity(String value) {
  final number = double.tryParse(value);
  if (number == null) return value;
  return number == number.roundToDouble()
      ? number.toInt().toString()
      : number.toString();
}
