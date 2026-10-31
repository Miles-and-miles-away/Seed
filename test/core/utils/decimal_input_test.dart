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

    test('rejects negatives and non-finite values', () {
      expect(parseDecimalInput('-1', 'en'), isNull);
      expect(parseDecimalInput('NaN', 'en'), isNull);
      expect(parseDecimalInput('', 'en'), isNull);
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
