import 'package:flutter/services.dart';

/// Keeps a quantity field to digits with at most one decimal
/// separator; ',' is allowed because locale keypads emit it (the
/// anchored pattern keeps the longest valid prefix).
final decimalInputFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*[.,]?\d*'),
);

/// [text] as a non-negative finite number, or null when it is not one.
///
/// Locale keypads emit ',' as the decimal separator, so normalize
/// before parsing ("12,5" reads as 12.5). tryParse also accepts "NaN"
/// and "Infinity"; reject those and negatives too.
double? parseDecimalInput(String text) {
  final value = double.tryParse(text.trim().replaceAll(',', '.'));
  return (value == null || !value.isFinite || value < 0) ? null : value;
}

/// [value] as text to seed an editable quantity field, dropping a
/// trailing ".0" so whole numbers read cleanly.
///
/// Full precision on purpose: the field is reparsed on submit, so
/// rounding here would silently store the rounded value. Display
/// formatters round; this is not one.
String decimalSeedText(double value) {
  final text = value.toString();
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}
