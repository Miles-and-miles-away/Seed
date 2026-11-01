import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';

/// Keeps a quantity field to digits with at most one decimal
/// separator; ',' is allowed because locale keypads emit it (the
/// anchored pattern keeps the longest valid prefix).
final decimalInputFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*[.,]?\d*'),
);

/// Whether [text] reads as a thousands-grouped number in [locale]
/// ("1.500" in Spanish, "1,500" in English), which the field would
/// otherwise take as a decimal. Flag it rather than guess. A leading zero
/// never starts a thousands group, so "0.500" stays a decimal.
bool isAmbiguousDecimalInput(String text, String locale) {
  final group = RegExp.escape(_symbols(locale).GROUP_SEP);
  return RegExp('^[1-9]\\d{0,2}$group\\d{3}\$').hasMatch(text.trim());
}

/// [text] as a non-negative finite number, or null when it is not one
/// or is ambiguous in [locale] (see [isAmbiguousDecimalInput]).
///
/// Locale keypads emit ',' as the decimal separator, so normalize
/// before parsing ("12,5" reads as 12.5). tryParse also accepts "NaN"
/// and "Infinity"; reject those and negatives too.
double? parseDecimalInput(String text, String locale) {
  if (isAmbiguousDecimalInput(text, locale)) return null;
  final value = double.tryParse(text.trim().replaceAll(',', '.'));
  return (value == null || !value.isFinite || value < 0) ? null : value;
}

/// [value] as text to seed an editable quantity field, in [locale]'s
/// decimal separator, dropping a trailing ".0" so whole numbers read
/// cleanly.
///
/// Full precision and no grouping on purpose: the field is reparsed on
/// submit, so rounding here would silently store the rounded value.
/// Display formatters round; this is not one.
String decimalSeedText(double value, String locale) {
  final text = value.toString();
  final trimmed = text.endsWith('.0')
      ? text.substring(0, text.length - 2)
      : text;
  return trimmed.replaceFirst('.', _symbols(locale).DECIMAL_SEP);
}

NumberSymbols _symbols(String locale) =>
    NumberFormat.decimalPattern(locale).symbols;
