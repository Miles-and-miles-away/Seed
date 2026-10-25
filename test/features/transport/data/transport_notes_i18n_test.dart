import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/calculation_notes_i18n.dart';

void main() {
  group('spanishNumber', () {
    test('uses a decimal comma and groups thousands with a period', () {
      expect(spanishNumber('2.43'), '2,43');
      expect(spanishNumber('1,000'), '1.000');
      expect(spanishNumber('1167'), '1.167');
      expect(spanishNumber('458'), '458');
    });

    test('leaves a year as it is but groups a quantity', () {
      expect(spanishNumber('2025'), '2025');
      expect(spanishNumber('2000', hasUnit: true), '2.000');
    });
  });

  group('numberMismatches', () {
    List<String> es(String english, String spanish) =>
        numberMismatches(english, spanish, locale: 'es');

    test('accepts converted numbers, mapped units and references', () {
      expect(
        es(
          'SAP 10.1 gives 1.5 kWh at 40 C, 2.2x and 83.8%, section 3.1.',
          'SAP 10.1 da 1,5 kWh a 40 °C, 2,2 veces y 83,8 %, sección 3.1.',
        ),
        isEmpty,
      );
      expect(
        numberMismatches(
          'heats 1 L by 27.2 K in 10 minutes, 2.2x more',
          '1 Lを10分で27.2 K加熱し、2.2倍多くなります',
          locale: 'ja',
        ),
        isEmpty,
      );
    });

    test('flags an English mark, a unit, a sign and an added number', () {
      expect(es('gives 1.5 kWh', 'da 1.5 kWh'), [
        'missing 1,5 kWh',
        'extra 1.5 kWh',
      ]);
      expect(es('0.113 kWh/L', '0,113 Wh/L'), [
        'missing 0,113 kWh',
        'extra 0,113 Wh',
      ]);
      expect(es('capped at -2 C', 'límite de +2 °C'), [
        'missing -2 °C',
        'extra +2 °C',
      ]);
      expect(es('differ by 2.2x', 'difieren un 2,2 %'), [
        'missing 2,2 x',
        'extra 2,2 %',
      ]);
      expect(es('16 g/km', '16 g/km (~90 g/km)'), ['extra 90 g']);
    });

    test('exempts a code but never a decimal after a hyphen', () {
      expect(es('Panasonic CS-227VB', 'Panasonic CS-227VB'), isEmpty);
      expect(es('the 10th-to-90.5th band', 'la banda 10th-to-90.5th'), [
        'missing 90,5',
        'extra 90.5',
      ]);
    });
  });

  calculationNotesI18nTests(
    'data/app/transport_modes.json',
    'modes',
    complete: true,
  );
}
