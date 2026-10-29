import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';

const _locales = ['en', 'ja', 'es'];
const _blank = '____';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, List<GameFact>> playable;

  setUpAll(() async {
    final facts = await loadEcoFacts();
    playable = {for (final l in _locales) l: ecoGameFacts(facts, l)};
  });

  test('every playable figure has two valid decoys in each language', () {
    final unaskable = [
      for (final locale in _locales)
        for (final fact in playable[locale]!)
          if (decoyPairs(fact, playable[locale]!, _blank).isEmpty)
            '${fact.id} $locale: ${fact.figure}',
    ];
    expect(unaskable, isEmpty);
  });

  test("every figure's unit key is in a family", () {
    final unplaced = {
      for (final fact in playable['en']!)
        if (!figureFamilies.containsKey(figureUnitKey(fact.figureEn)))
          '${fact.id}: ${figureUnitKey(fact.figureEn)}',
    };
    expect(unplaced, isEmpty);
  });

  test('no decoy pair shares a shape the answer lacks', () {
    final oddOnesOut = [
      for (final locale in _locales)
        for (final fact in playable[locale]!)
          for (final (a, b) in decoyPairs(fact, playable[locale]!, _blank))
            if (figureShape(a.figure) case final shape
                when shape == figureShape(b.figure) &&
                    shape != figureShape(fact.figure))
              '${fact.id} $locale: ${a.id}, ${b.id}',
    ];
    expect(oddOnesOut, isEmpty);
  });

  test('no decoy reads the same as the answer or the other decoy', () {
    final clashes = [
      for (final locale in _locales)
        for (final fact in playable[locale]!)
          for (final (a, b) in decoyPairs(fact, playable[locale]!, _blank))
            if ({fact.figure, a.figure, b.figure}.length < 3)
              '${fact.id} $locale: ${a.id}, ${b.id}',
    ];
    expect(clashes, isEmpty);
  });
}
