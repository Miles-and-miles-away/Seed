import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/fact_games/domain/game_fact.dart';

import '../fact_games_fixtures.dart';

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
    });

    test('skips facts without a figure', () {
      expect(ecoGameFacts([unplayableFact(1)], 'en'), isEmpty);
    });
  });
}
