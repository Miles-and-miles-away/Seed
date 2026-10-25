import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';

const _locales = ['en', 'ja', 'es'];
const _blank = '____';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<EcoFact> playable;

  setUpAll(() async {
    playable = (await loadEcoFacts()).where((f) => f.isPlayable).toList();
  });

  test('every playable figure has two valid decoys in each language', () {
    final unaskable = [
      for (final fact in playable)
        for (final locale in _locales)
          if (decoyPairs(fact, playable, locale, _blank).isEmpty)
            '${fact.dayOfYear} $locale: ${fact.keyFigure(locale)}',
    ];
    expect(unaskable, isEmpty);
  });

  test("every figure's unit key is in a family", () {
    final unplaced = {
      for (final fact in playable)
        if (!figureFamilies.containsKey(figureUnitKey(fact.keyFigureEn)))
          '${fact.dayOfYear}: ${figureUnitKey(fact.keyFigureEn)}',
    };
    expect(unplaced, isEmpty);
  });

  test('no decoy pair shares a shape the answer lacks', () {
    final oddOnesOut = [
      for (final fact in playable)
        for (final locale in _locales)
          for (final (a, b) in decoyPairs(fact, playable, locale, _blank))
            if (figureShape(a.keyFigure(locale)!) case final shape
                when shape == figureShape(b.keyFigure(locale)!) &&
                    shape != figureShape(fact.keyFigure(locale)!))
              '${fact.dayOfYear} $locale: ${a.dayOfYear}, ${b.dayOfYear}',
    ];
    expect(oddOnesOut, isEmpty);
  });

  test('no decoy reads the same as the answer or the other decoy', () {
    final clashes = [
      for (final fact in playable)
        for (final locale in _locales)
          for (final (a, b) in decoyPairs(fact, playable, locale, _blank))
            if ({
                  fact.keyFigure(locale),
                  a.keyFigure(locale),
                  b.keyFigure(locale),
                }.length <
                3)
              '${fact.dayOfYear} $locale: ${a.dayOfYear}, ${b.dayOfYear}',
    ];
    expect(clashes, isEmpty);
  });
}
