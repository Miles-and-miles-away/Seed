import 'package:flutter/services.dart';

/// Limits a text field to [maxUnits] UTF-16 code units.
///
/// Firestore security rules measure string length with `String.size()`,
/// which counts UTF-16 code units (the same unit as Dart's `String.length`)
/// -- verified against the emulator. Flutter's
/// [LengthLimitingTextInputFormatter] instead counts grapheme clusters, so a
/// value with emoji or other multi-unit characters can pass the client yet be
/// rejected by the rules (and, with optimistic writes, be applied locally
/// then reverted on sync). Capping on UTF-16 units keeps the two in step.
///
/// Over-long edits are truncated rather than rejected wholesale, and the
/// truncation never splits a surrogate pair, so the result is always valid
/// text no longer than [maxUnits] units.
class Utf16LengthLimitingTextInputFormatter extends TextInputFormatter {
  Utf16LengthLimitingTextInputFormatter(this.maxUnits)
    : assert(maxUnits > 0, 'maxUnits must be positive');

  /// The maximum number of UTF-16 code units allowed.
  final int maxUnits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.length <= maxUnits) return newValue;

    // Back off one unit if the cut would land inside a surrogate pair (a high
    // surrogate at the boundary whose low surrogate is beyond the limit).
    var end = maxUnits;
    final boundary = text.codeUnitAt(end - 1);
    final isHighSurrogate = boundary >= 0xD800 && boundary <= 0xDBFF;
    if (isHighSurrogate) end -= 1;

    final truncated = text.substring(0, end);
    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncated.length),
    );
  }
}
