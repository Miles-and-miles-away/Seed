import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';

const _locales = ['en', 'ja', 'es'];
const _blank = '____';

/// The first sentences of three seeded action texts, verbatim from the seed.
const _actions = [
  ActionModel(
    id: 'train_vs_flight',
    nameEn: 'Train instead of flight',
    nameJa: '飛行機の代わりに鉄道',
    category: 'transport',
    points: 1,
    co2Grams: 110000,
    descriptionLongEn:
        'Choosing a train over a domestic flight for a 500km journey saves '
        'roughly **110,000g** of CO2.',
    descriptionLongJa:
        '500kmの移動で国内線の代わりに鉄道を選ぶと約**110,000g**のCO2を削減'
        'できます。',
    descriptionLongEs:
        'Elegir tren en vez de vuelo doméstico para un viaje de 500km ahorra '
        'aproximadamente **110.000g** de CO2.',
  ),
  ActionModel(
    id: 'electric_car_purchase',
    nameEn: 'Electric car',
    nameJa: '電気自動車',
    category: 'transport',
    points: 1,
    co2Grams: 3400000,
    descriptionLongEn:
        'Choosing an electric vehicle over a comparable petrol car avoids '
        'roughly **3.4 tonnes** of CO2 per year in tailpipe and fuel-cycle '
        'emissions.',
    descriptionLongJa:
        '同等のガソリン車の代わりに電気自動車を選ぶと、排気ガスと燃料サイクルの'
        '排出を合わせ年間約**3.4トン**のCO2を回避できます。',
    descriptionLongEs:
        'Elegir un vehículo eléctrico en vez de un coche de gasolina comparable '
        'evita unas **3,4 toneladas** de CO2 al año en emisiones del tubo de '
        'escape y del ciclo de combustible.',
  ),
  ActionModel(
    id: 'heat_person_not_room',
    nameEn: 'Heat the person, not the room',
    nameJa: '部屋ではなく人を暖める',
    category: 'energy',
    points: 1,
    co2Grams: 1900,
    descriptionLongEn:
        'Spending an evening under a kotatsu, heated blanket or heated carpet '
        'instead of running a portable electric heater saves about **1.9kg** '
        'of CO2.',
    descriptionLongJa:
        '電気ストーブの代わりにこたつ・電気毛布・電気カーペットで一晩過ごすと、'
        '約**1.9kg**のCO2を削減できます。',
    descriptionLongEs:
        'Pasar la noche bajo un kotatsu, una manta eléctrica o una alfombra '
        'eléctrica en lugar de encender un calefactor portátil ahorra unos '
        '**1,9kg** de CO2.',
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, List<GameFact>> playable;

  /// Every bundled text fact: eco-facts, SDG goals and Eco-Dex entries.
  /// Action text lives in Firestore, so `actionGameFacts` skips what it
  /// cannot deal.
  setUpAll(() async {
    final facts = await loadEcoFacts();
    final goals = (await loadSdgGoals()).goals;
    final entries = (await loadEcoDexData()).entries;
    playable = {
      for (final l in _locales)
        l: [
          ...ecoGameFacts(facts, l),
          ...sdgGameFacts(goals, l),
          ...ecoDexGameFacts(entries, l),
        ],
    };
  });

  group('action facts from the seed text', () {
    const figures = {
      'en': ['110,000g', '3.4 tonnes', '1.9kg'],
      'ja': ['110,000g', '3.4トン', '1.9kg'],
      'es': ['110.000g', '3,4 toneladas', '1,9kg'],
    };
    for (final locale in _locales) {
      test('extract, state the figure once and take decoys in $locale', () {
        final facts = actionGameFacts(_actions, locale);
        expect(facts.map((f) => f.figure), figures[locale]);
        expect(facts.map((f) => f.figureEn), [
          '110,000g',
          '3.4 tonnes',
          '1.9kg',
        ]);
        final candidates = [...playable[locale]!, ...facts];
        for (final fact in facts) {
          expect(fact.text, isNot(contains('**')), reason: fact.id);
          expect(fact.figure.allMatches(fact.text), hasLength(1));
          expect(
            fact.text.replaceAll(fact.figure, _blank),
            isNot(contains(fact.figure)),
          );
          expect(
            decoyPairs(fact, candidates, _blank),
            isNotEmpty,
            reason: '${fact.id} $locale',
          );
        }
      });
    }
  });

  test('each source keeps its floor of playable facts in every language', () {
    for (final locale in _locales) {
      final byKind = <GameFactKind, int>{};
      for (final fact in playable[locale]!) {
        byKind[fact.kind] = (byKind[fact.kind] ?? 0) + 1;
      }
      expect(byKind[GameFactKind.ecoFact], greaterThanOrEqualTo(193));
      expect(byKind[GameFactKind.sdg], 8, reason: locale);
      expect(byKind[GameFactKind.ecoDex], greaterThanOrEqualTo(70));
    }
  });

  test('every text states its figure once, and no title has a digit', () {
    final bad = [
      for (final locale in _locales)
        for (final fact in playable[locale]!)
          if (fact.figure.allMatches(fact.text).length != 1 ||
              RegExp(r'\d').hasMatch(fact.title))
            '${fact.id} $locale',
    ];
    expect(bad, isEmpty);
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

  test('no decoy puts a number below 1 before a scale word', () {
    final belowOne = RegExp(
      r'(?<![\d.,])0[.,]\d+\s*(?:million|billion|trillion|mill|bill)',
    );
    final bad = [
      for (final locale in _locales)
        for (final fact in playable[locale]!)
          for (final (a, b) in decoyPairs(fact, playable[locale]!, _blank))
            for (final decoy in [a, b])
              if (belowOne.hasMatch(decoy)) '${fact.id} $locale: $decoy',
    ];
    expect(bad, isEmpty);
  });

  test('no English decoy has 1,000 or more of a scale word', () {
    final uncarried = RegExp(r'\d,\d{3}(?:\.\d+)? (?:million|billion)');
    final bad = [
      for (final fact in playable['en']!)
        for (final (a, b) in decoyPairs(fact, playable['en']!, _blank))
          for (final decoy in [a, b])
            if (uncarried.hasMatch(decoy)) '${fact.id}: $decoy',
    ];
    expect(bad, isEmpty);
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
            if (figureShape(a) case final shape
                when shape == figureShape(b) &&
                    shape != figureShape(fact.figure))
              '${fact.id} $locale: $a, $b',
    ];
    expect(oddOnesOut, isEmpty);
  });

  test('no decoy reads the same as the answer or the other decoy', () {
    final clashes = [
      for (final locale in _locales)
        for (final fact in playable[locale]!)
          for (final (a, b) in decoyPairs(fact, playable[locale]!, _blank))
            if ({fact.figure, a, b}.length < 3) '${fact.id} $locale: $a, $b',
    ];
    expect(clashes, isEmpty);
  });

  test('range answers get range decoys in each language', () {
    for (final id in ['fact:125', 'fact:166', 'fact:343']) {
      for (final locale in _locales) {
        final fact = playable[locale]!.firstWhere((f) => f.id == id);
        final pairs = decoyPairs(fact, playable[locale]!, _blank);
        expect(pairs, isNotEmpty, reason: '$id $locale');
        for (final (a, b) in pairs) {
          expect(
            [figureShape(a), figureShape(b)],
            everyElement(figureShape(fact.figure)),
            reason: '$id $locale: $a, $b',
          );
        }
      }
    }
  });
}
