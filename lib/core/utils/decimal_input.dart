import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';

/// Keeps a quantity field to digits and separators; ',' is allowed
/// because locale keypads emit it. A second separator is kept so the
/// parser can flag it instead of silently joining the groups.
/// Full-width input becomes ASCII. Any other character refuses the edit.
final decimalInputFormatter = TextInputFormatter.withFunction((
  oldValue,
  newValue,
) {
  final text = String.fromCharCodes(
    newValue.text.trim().runes.map(_asciiFromFullWidth),
  );
  if (!_allowedDecimalText.hasMatch(text)) return oldValue;
  if (text.length == newValue.text.length) return newValue.copyWith(text: text);
  return TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );
});

final _allowedDecimalText = RegExp(r'^[\d.,]*$');

const _fullWidthZero = 0xFF10;
const _fullWidthNine = 0xFF19;
const _fullWidthComma = 0xFF0C;
const _fullWidthStop = 0xFF0E;

int _asciiFromFullWidth(int rune) => switch (rune) {
  >= _fullWidthZero && <= _fullWidthNine => rune - _fullWidthZero + 0x30,
  _fullWidthComma => 0x2C,
  _fullWidthStop => 0x2E,
  _ => rune,
};

/// Above any real quantity, below any calculator overflow to infinity.
const _maxDecimalInput = 1e9;

/// Whether [text] reads as a thousands-grouped number in [locale]
/// ("1.500" in Spanish, "1,500" in English), which the field would
/// otherwise take as a decimal. Flag it rather than guess. A leading zero
/// never starts a thousands group, so "0.500" stays a decimal. More
/// than one separator ("1.234,5") is ambiguous too.
bool isAmbiguousDecimalInput(String text, String locale) {
  final trimmed = text.trim();
  if (RegExp('[.,]').allMatches(trimmed).length > 1) return true;
  final group = RegExp.escape(_symbols(locale).GROUP_SEP);
  return RegExp('^[1-9]\\d{0,2}$group\\d{3}\$').hasMatch(trimmed);
}

/// [text] as a number from 0 to 1e9, or null when it is not one
/// or is ambiguous in [locale] (see [isAmbiguousDecimalInput]).
///
/// Locale keypads emit ',' as the decimal separator, so normalize
/// before parsing ("12,5" reads as 12.5). tryParse also accepts "NaN"
/// and "Infinity"; the range check rejects those and negatives too.
double? parseDecimalInput(String text, String locale) {
  if (isAmbiguousDecimalInput(text, locale)) return null;
  final value = double.tryParse(text.trim().replaceAll(',', '.'));
  return value != null && value >= 0 && value <= _maxDecimalInput
      ? value
      : null;
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
