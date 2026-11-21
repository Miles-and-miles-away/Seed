import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';

import '../fact_games_fixtures.dart';

ActionModel _action(
  String en, {
  String ja = '',
  String es = '',
  int co2Grams = 100,
}) => ActionModel(
  id: 'cycle',
  nameEn: 'Cycle',
  nameJa: '自転車',
  nameEs: 'Bici',
  category: 'transport',
  points: 1,
  co2Grams: co2Grams,
  descriptionLongEn: en,
  descriptionLongJa: ja,
  descriptionLongEs: es,
);

void main() {
  group('ecoGameFacts', () {
    test('resolves title, text and figure in the locale', () {
      final fact = playableFact(4, figure: '4 kg', figureJa: '4キロ');
      final [en] = ecoGameFacts([fact], 'en');
      final [ja] = ecoGameFacts([fact], 'ja');
      expect((en.id, en.kind), ('fact:4', GameFactKind.ecoFact));
      expect(
        (en.title, en.text, en.figure),
        (fact.nameEn, fact.factEn, '4 kg'),
      );
      expect((ja.title, ja.text, ja.figure), (fact.nameJa, fact.factJa, '4キロ'));
      expect(ja.figureEn, '4 kg');
      expect(en.recallOnly, isFalse);
    });

    test('skips facts without a figure', () {
      expect(ecoGameFacts([unplayableFact(1)], 'en'), isEmpty);
    });
  });

  group('sdgGameFacts', () {
    const goal = SdgGoal(
      number: 2,
      titleEn: 'End hunger',
      shortTitleEn: 'Zero Hunger',
      shortTitleJa: '飢餓をゼロに',
      descriptionEn:
          'End hunger. Hunger peaked in 2022. An estimated 645 million '
          'people faced hunger in 2025. Farming employs 1.5 billion.',
      descriptionJa: '飢餓をなくす。2025年には推定6億4,500万人が飢餓に直面しました。農業は重要です。',
      color: Color(0xFF000000),
      keyFigureEn: '645 million',
      keyFigureJa: '6億4,500万',
    );

    test('takes the sentence that carries the figure, per locale', () {
      final [en] = sdgGameFacts([goal], 'en');
      final [ja] = sdgGameFacts([goal], 'ja');
      expect(
        (en.id, en.kind, en.title),
        ('sdg:2', GameFactKind.sdg, 'Zero Hunger'),
      );
      expect(en.text, 'An estimated 645 million people faced hunger in 2025.');
      expect(ja.text, '2025年には推定6億4,500万人が飢餓に直面しました。');
      expect((ja.figure, ja.figureEn), ('6億4,500万', '645 million'));
    });

    test('skips goals without a figure', () {
      const plain = SdgGoal(
        number: 3,
        titleEn: 'Health',
        shortTitleEn: 'Good Health',
        descriptionEn: 'Ensure healthy lives.',
        color: Color(0xFF000000),
      );
      expect(sdgGameFacts([plain], 'en'), isEmpty);
    });
  });

  group('ecoDexGameFacts', () {
    EcoDexEntry entry({String figure = '50%'}) => EcoDexEntry(
      id: 'climate_01',
      category: 'climate',
      nameEn: 'The Greenhouse Effect',
      nameEs: 'El efecto invernadero',
      nameJa: '温室効果',
      factEn: 'CO2 is 50% above its old level.',
      factEs: 'El CO2 está un 50% por encima.',
      iconName: 'climate_01',
      condition: const EcoDexCondition.totalActions(count: 1),
      hintEn: 'Log an action',
      keyFigureEn: figure,
      keyFigureJa: figure,
      keyFigureEs: figure,
    );

    test('resolves the entry in the locale', () {
      final [es] = ecoDexGameFacts([entry()], 'es');
      expect((es.id, es.kind), ('ecodex:climate_01', GameFactKind.ecoDex));
      expect(
        (es.title, es.text, es.figure),
        ('El efecto invernadero', 'El CO2 está un 50% por encima.', '50%'),
      );
    });

    test('skips entries without a figure', () {
      expect(ecoDexGameFacts([entry(figure: '')], 'en'), isEmpty);
    });
  });

  group('actionGameFacts', () {
    test('takes the first sentence and its bold figure, links and bold '
        'removed, in each language', () {
      final action = _action(
        'Cycling 5 km saves about **1.1 kg** of CO2 '
        '([DEFRA](https://www.gov.uk/x.y)). A second sentence.',
        ja: '自転車で5km走ると約**1.1kg**のCO2を削減できます。二文目です。',
        es: 'Ir en bici 5 km ahorra unos **1,1 kg** de CO2. Otra frase.',
      );
      final [en] = actionGameFacts([action], 'en');
      final [ja] = actionGameFacts([action], 'ja');
      final [es] = actionGameFacts([action], 'es');
      expect(
        (en.id, en.kind, en.title),
        ('action:cycle', GameFactKind.action, 'Cycle'),
      );
      expect(en.text, 'Cycling 5 km saves about 1.1 kg of CO2 (DEFRA).');
      expect((en.figure, ja.figure, es.figure), ('1.1 kg', '1.1kg', '1,1 kg'));
      expect(ja.text, '自転車で5km走ると約1.1kgのCO2を削減できます。');
      expect(es.figureEn, '1.1 kg');
    });

    test('skips an action without exactly one bold run in its first '
        'sentence, or with no CO2 value', () {
      for (final action in [
        _action('No bold here. **5 kg** later.'),
        _action('Two **5 kg** and **6 kg** runs.'),
        _action('Saves **5 kg** of CO2.', co2Grams: 0),
        _action('Saves **5 kg** of CO2 and 5 kg again.'),
      ]) {
        expect(actionGameFacts([action], 'en'), isEmpty);
      }
    });
  });
}
