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

    test('matches a JA 万 or 億 figure to its English scale by value', () {
      List<String> ja(String english, String japanese) =>
          numberMismatches(english, japanese, locale: 'ja');
      expect(ja('61.4 million tonnes', '6140万トン'), isEmpty);
      expect(
        ja('16 billion trees, 350 million in one day', '160億本、1日で3億5000万本'),
        isEmpty,
      );
      expect(ja('a 12 thousand km trip', '1.2万 kmの旅'), isEmpty);
      expect(ja('61.4 million tonnes', '614万トン'), [
        'missing 61400000',
        'extra 6140000',
      ]);
      expect(ja('16 billion trees', '16億本'), [
        'missing 16000000000',
        'extra 1600000000',
      ]);
    });

    test('reads JA digits after 万 or 億, 千 and grouping commas', () {
      List<String> ja(String english, String japanese) =>
          numberMismatches(english, japanese, locale: 'ja');
      expect(ja('a 12 thousand km trip', '1万2000 kmの旅'), isEmpty);
      expect(ja('a 12,000 km trip', '1万2千 kmの旅'), isEmpty);
      expect(ja('a 12,000 km trip', '1.2万 kmの旅'), isEmpty);
      expect(ja('12 million', '1,200万'), isEmpty);
      expect(ja('350 million', '3億5,000万'), isEmpty);
      expect(ja('321,752 tonnes', '32万1752トン'), isEmpty);
      expect(ja('321,752 tonnes', '321,752トン'), isEmpty);
      expect(ja('a 12,500 km trip', '1万2000 kmの旅'), [
        'missing 12500 km',
        'extra 12000 km',
      ]);
      expect(ja('305 million', '3億5,000万'), [
        'missing 305000000',
        'extra 350000000',
      ]);
    });

    test('allows a repeat of an English number but not a new one', () {
      expect(
        numberMismatches(
          'palm oil at 7.96 per kg, which is 1.41',
          '1 kgあたり7.96で1.41です（7.96は「パーム油」の値）',
          locale: 'ja',
        ),
        isEmpty,
      );
      expect(es('at 7.96 per kg', 'a 7,96 por kg (no 7,69)'), ['extra 7,69']);
    });

    test('exempts a code but never a decimal after a hyphen', () {
      expect(es('Panasonic CS-227VB', 'Panasonic CS-227VB'), isEmpty);
      expect(es('the 10th-to-90.5th band', 'la banda 10th-to-90.5th'), [
        'missing 90,5',
        'extra 90.5',
      ]);
    });

    test('reads "N times" and "N-fold" as ratios', () {
      expect(
        es(
          '2 to 3.5 times low, a 16- to 19-fold range',
          'de 2 a 3,5 veces, de 16 a 19 veces',
        ),
        isEmpty,
      );
      expect(
        numberMismatches(
          '2 to 3.5 times low, a 16- to 19-fold range',
          '2〜3.5倍低く、16〜19倍の幅',
          locale: 'ja',
        ),
        isEmpty,
      );
      expect(es('nearly 14 times', 'casi un 14%'), [
        'missing 14 x',
        'extra 14 %',
      ]);
    });

    test('keeps a version number as written', () {
      expect(es('Agribalyse version 3.2', 'Agribalyse versión 3.2'), isEmpty);
      expect(es('version 3.2', 'versión 3,2'), ['missing 3.2', 'extra 3,2']);
    });
  });

  test('a partial completeness check needs a floor', () {
    expect(
      () => calculationNotesI18nTests('x.json', 'items', complete: false),
      throwsArgumentError,
    );
  });

  calculationNotesI18nTests(
    'data/app/transport_modes.json',
    'modes',
    complete: true,
  );
}
