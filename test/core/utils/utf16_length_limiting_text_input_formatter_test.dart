import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/utf16_length_limiting_text_input_formatter.dart';

void main() {
  TextEditingValue value(String text) => TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );

  group('Utf16LengthLimitingTextInputFormatter', () {
    test('leaves a value within the limit unchanged', () {
      final formatter = Utf16LengthLimitingTextInputFormatter(5);
      final input = value('abcd');

      expect(formatter.formatEditUpdate(TextEditingValue.empty, input), input);
    });

    test('allows a value exactly at the limit', () {
      final formatter = Utf16LengthLimitingTextInputFormatter(5);

      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        value('abcde'),
      );

      expect(result.text, 'abcde');
    });

    test(
      'truncates an over-long ASCII value and moves the cursor to the end',
      () {
        final formatter = Utf16LengthLimitingTextInputFormatter(3);

        final result = formatter.formatEditUpdate(
          TextEditingValue.empty,
          value('abcdef'),
        );

        expect(result.text, 'abc');
        expect(result.selection.baseOffset, 3);
      },
    );

    test('counts UTF-16 units, matching the rule (BMP chars are one unit)', () {
      // 'あ' is one UTF-16 unit; a 5-unit cap allows exactly 5 of them.
      final formatter = Utf16LengthLimitingTextInputFormatter(5);

      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        value('あ' * 6),
      );

      expect(result.text, 'あ' * 5);
      expect(result.text.length, 5);
    });

    test('never splits a surrogate pair at the limit', () {
      // U+1D11E is two UTF-16 units. With a 3-unit cap, only one whole clef
      // fits (2 units); the cut must not leave a lone high surrogate.
      const clef = '\u{1D11E}';
      final formatter = Utf16LengthLimitingTextInputFormatter(3);

      final result = formatter.formatEditUpdate(
        TextEditingValue.empty,
        value(clef * 2),
      );

      expect(result.text, clef);
      expect(result.text.length, 2);
    });
  });
}
