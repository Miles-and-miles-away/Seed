import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/decimal_input.dart';

void main() {
  group('parseDecimalInput', () {
    test('reads either separator as a decimal', () {
      expect(parseDecimalInput('12,5', 'es'), 12.5);
      expect(parseDecimalInput('1,5', 'en'), 1.5);
      expect(parseDecimalInput('12.5', 'en'), 12.5);
    });

    test('rejects group-shaped input instead of guessing', () {
      // "1.500" is 1500 to a Spanish reader; "1,500" is 1500 in English.
      expect(parseDecimalInput('1.500', 'es'), isNull);
      expect(parseDecimalInput('1,500', 'en'), isNull);
      expect(parseDecimalInput('1,500', 'ja'), isNull);
      expect(isAmbiguousDecimalInput('1.500', 'es'), isTrue);
      expect(isAmbiguousDecimalInput('1.5', 'es'), isFalse);
      expect(isAmbiguousDecimalInput('1500', 'es'), isFalse);
      expect(parseDecimalInput('12.500', 'es'), isNull);
      expect(parseDecimalInput('12,500', 'en'), isNull);
    });

    test('a leading zero is a decimal, never a thousands group', () {
      expect(parseDecimalInput('0.500', 'es'), 0.5);
      expect(parseDecimalInput('0,500', 'en'), 0.5);
      expect(parseDecimalInput('0,250', 'ja'), 0.25);
    });

    test('a grouped number with a decimal part is flagged', () {
      var value = TextEditingValue.empty;
      for (final char in '1.234,5'.split('')) {
        final typed = value.text + char;
        value = decimalInputFormatter.formatEditUpdate(
          value,
          TextEditingValue(
            text: typed,
            selection: TextSelection.collapsed(offset: typed.length),
          ),
        );
      }

      expect(value.text, '1.234,5');
      expect(parseDecimalInput(value.text, 'es'), isNull);
      expect(isAmbiguousDecimalInput(value.text, 'es'), isTrue);
    });

    test('rejects negatives, non-finite and overflowing values', () {
      expect(parseDecimalInput('-1', 'en'), isNull);
      expect(parseDecimalInput('NaN', 'en'), isNull);
      expect(parseDecimalInput('Infinity', 'en'), isNull);
      expect(parseDecimalInput('', 'en'), isNull);
      expect(parseDecimalInput('1' * 308, 'en'), isNull);
      expect(parseDecimalInput('1000000000', 'en'), 1e9);
    });
  });

  group('decimalInputFormatter', () {
    String apply(String old, String typed) => decimalInputFormatter
        .formatEditUpdate(
          TextEditingValue(text: old),
          TextEditingValue(
            text: typed,
            selection: TextSelection.collapsed(offset: typed.length),
          ),
        )
        .text;

    test('reads full-width digits and separators as ASCII', () {
      expect(apply('', '\uFF11\uFF12\uFF0E\uFF15'), '12.5');
      expect(apply('', '\uFF13\uFF0C\uFF14'), '3,4');
    });

    test('refuses a sign or exponent whole instead of keeping a part', () {
      expect(apply('', '-5'), '');
      expect(apply('', '1e308'), '');
      expect(apply('12', '12-'), '12');
    });

    test('trims pasted spaces', () {
      expect(apply('', ' 12.5 '), '12.5');
    });
  });

  group('decimalSeedText', () {
    test("writes the locale's decimal separator without grouping", () {
      expect(decimalSeedText(12.5, 'es'), '12,5');
      expect(decimalSeedText(12.5, 'en'), '12.5');
      expect(decimalSeedText(1500, 'es'), '1500');
      expect(decimalSeedText(3, 'ja'), '3');
    });

    test('round-trips through the parser in every locale', () {
      for (final locale in ['en', 'ja', 'es']) {
        for (final value in [0.5, 3.0, 12.25, 1500.0, 1.35783]) {
          final text = decimalSeedText(value, locale);
          expect(
            parseDecimalInput(text, locale),
            value,
            reason: '$locale $text',
          );
        }
      }
    });
  });
}
