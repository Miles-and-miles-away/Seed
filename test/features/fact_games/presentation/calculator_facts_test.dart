import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/energy/data/energy_behaviors_data.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/domain/figure_text.dart';
import 'package:seed_app/features/fact_games/domain/game_fact.dart';
import 'package:seed_app/features/fact_games/presentation/calculator_facts.dart';
import 'package:seed_app/features/food/data/food_items_data.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/quiz/presentation/quiz_cards.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/data/transport_modes_data.dart';

const _locales = ['en', 'ja', 'es'];
const _blank = '____';

AppLocalizations _l10n(String locale) => lookupAppLocalizations(Locale(locale));

/// Each comparison's figure in EN, JA and ES, from the shipped data.
const _figures = {
  'food:beef-tofu': ('22 times', '22倍', '22 veces'),
  'food:chicken-beans': ('5.5 times', '5.5倍', '5,5 veces'),
  'food:beef-chicken': ('7.1 times', '7.1倍', '7,1 veces'),
  'food:lamb-pork': ('3.2 times', '3.2倍', '3,2 veces'),
  'food:milk-oat': ('3.5 times', '3.5倍', '3,5 veces'),
  'transport:flight-shinkansen': ('11 times', '11倍', '11 veces'),
  'transport:jet-longhaul': ('15 times', '15倍', '15 veces'),
  'transport:ferry-car-foot': ('6.9 times', '6.9倍', '6,9 veces'),
  'transport:car-coach': ('5.9 times', '5.9倍', '5,9 veces'),
  'transport:car-bus': ('57%', '57%', '57%'),
  'transport:car-rail': ('4.6 times', '4.6倍', '4,6 veces'),
  'energy:bulbs': ('7.1 times', '7.1倍', '7,1 veces'),
  'energy:showers': ('4.3 times', '4.3倍', '4,3 veces'),
  'energy:washes': ('4.9 times', '4.9倍', '4,9 veces'),
  'energy:cooling': ('7.6 times', '7.6倍', '7,6 veces'),
  'energy:dryers': ('2.2 times', '2.2倍', '2,2 veces'),
  'energy:dishwasher': ('32%', '32%', '32%'),
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<FoodItem> foods;
  late List<TransportMode> modes;
  late List<EnergyBehavior> behaviors;
  late Map<String, double> ratios;
  late Map<String, List<GameFact>> facts;

  setUpAll(() async {
    foods = await loadFoodItems();
    modes = await loadTransportModes();
    behaviors = await loadEnergyBehaviors();
    ratios = comparisonRatios(foods: foods, modes: modes, behaviors: behaviors);
    facts = {
      for (final l in _locales)
        l: calculatorGameFacts(ratios, _l10n(l), _l10n('en')),
    };
  });

  group('the shipped data', () {
    test('builds every comparison', () {
      expect(ratios.keys, [for (final c in calculatorComparisons) c.id]);
    });

    test('each side is on the deck and on one basis', () {
      final food = {for (final i in foods) i.id: i};
      final transport = {for (final m in modes) m.id: m};
      final energy = {for (final b in behaviors) b.id: b};
      for (final c in calculatorComparisons) {
        final (more, less, ratio) = switch (c.kind) {
          GameFactKind.food => (
            isQuizFood(food[c.more]!),
            isQuizFood(food[c.less]!),
            food[c.more]!.kgCo2ePerKg / food[c.less]!.kgCo2ePerKg,
          ),
          // A car is per vehicle, so its sentence says it is driven alone.
          GameFactKind.transport => (
            isQuizTransport(transport[c.more]!) ||
                (transport[c.more]!.perVehicle &&
                    c.sentence(_l10n('en'), '').contains('driving alone')),
            isQuizTransport(transport[c.less]!),
            transport[c.more]!.gCo2ePerKm / transport[c.less]!.gCo2ePerKm,
          ),
          _ => (
            energy[c.more]!.carrier == EnergyCarrier.electricity &&
                energy[c.more]!.unit == energy[c.less]!.unit,
            energy[c.less]!.carrier == EnergyCarrier.electricity,
            energy[c.more]!.kwhPerUnit / energy[c.less]!.kwhPerUnit,
          ),
        };
        expect((more, less), (true, true), reason: c.id);
        expect(ratios[c.id], ratio, reason: c.id);
      }
    });

    for (final (i, locale) in _locales.indexed) {
      test('every comparison in $locale', () {
        final l10n = _l10n(locale);
        final byId = {for (final f in facts[locale]!) f.id: f};
        expect(byId.keys, _figures.keys);
        for (final MapEntry(key: id, value: figures) in _figures.entries) {
          final fact = byId[id]!;
          final figure = [figures.$1, figures.$2, figures.$3][i];
          expect(fact.figure, figure, reason: id);
          expect(fact.figureEn, figures.$1, reason: id);
          expect(fact.recallOnly, isTrue);
          expect(fact.locale, locale);
          expect(figure.allMatches(fact.text), hasLength(1), reason: id);
          expect(fact.title, switch (fact.kind) {
            GameFactKind.food => l10n.foodCalculatorTitle,
            GameFactKind.transport => l10n.transportCalculatorTitle,
            _ => l10n.energyCalculatorTitle,
          });
        }
      });
    }

    test('chicken is compared with dried beans and lentils', () {
      for (final (locale, words) in [
        ('en', 'dried beans and lentils'),
        ('ja', '乾燥豆・レンズ豆'),
        ('es', 'alubias y lentejas secas'),
      ]) {
        final fact = facts[locale]!.firstWhere(
          (f) => f.id == 'food:chicken-beans',
        );
        expect(fact.text, contains(words), reason: locale);
      }
    });

    test('Spanish reads «CO2e» with no «de» and «un N%» for shares', () {
      for (final fact in facts['es']!) {
        expect(fact.text, contains('más CO2e que'), reason: fact.id);
        expect(fact.text, isNot(contains('de CO2e')), reason: fact.id);
        if (fact.figure.endsWith('%')) {
          expect(fact.text, contains('un ${fact.figure} más'));
        }
      }
    });

    test('every comparison has scaled decoys in each language, apart and '
        'never a multiple below 2x', () {
      for (final locale in _locales) {
        for (final fact in facts[locale]!) {
          final pairs = decoyPairs(fact, const [], _blank);
          expect(pairs, isNotEmpty, reason: '${fact.id} $locale');
          final shape = figureShape(fact.figure);
          for (final (a, b) in pairs) {
            final values = [
              for (final figure in [fact.figure, a, b]) _number(figure, locale),
            ];
            expect(
              [figureShape(a), figureShape(b)],
              [shape, shape],
              reason: '${fact.id} $locale',
            );
            for (var x = 0; x < 3; x++) {
              for (var y = x + 1; y < 3; y++) {
                final ratio =
                    max(values[x], values[y]) / min(values[x], values[y]);
                expect(ratio, greaterThanOrEqualTo(1.4), reason: '$a $b');
              }
            }
            if (!fact.figure.endsWith('%')) {
              expect(values.skip(1), everyElement(greaterThanOrEqualTo(2)));
            }
          }
        }
      }
    });

    test('dryers never offer a decoy under 2 times', () {
      final dryers = facts['en']!.firstWhere((f) => f.id == 'energy:dryers');
      expect(dryers.figure, '2.2 times');
      expect(decoyPairs(dryers, const [], _blank), [
        ('4.4 times', '8.8 times'),
        ('3.3 times', '5 times'),
      ]);
    });

    test('from 3x every comparison can put its answer in the middle', () {
      for (final locale in _locales) {
        for (final fact in facts[locale]!) {
          if (ratios[fact.id]! < 3) continue;
          final answer = _number(fact.figure, locale);
          expect(
            decoyPairs(fact, const [], _blank).any(
              (pair) =>
                  _number(pair.$1, locale) < answer &&
                  _number(pair.$2, locale) > answer,
            ),
            isTrue,
            reason: '${fact.id} $locale',
          );
        }
      }
    });
  });

  group('comparisonFigure', () {
    test('Spanish agrees in number: 1 vez, 2 veces, 2,5 veces', () {
      final es = _l10n('es');
      expect(es.factRecallTimes(1, '1'), '1 vez');
      expect(es.factRecallTimes(2, '2'), '2 veces');
      expect(es.factRecallTimes(1.5, '1,5'), '1,5 veces');
      expect(comparisonFigure(es, 2.5), '2,5 veces');
      expect(_l10n('en').factRecallTimes(1, '1'), '1 time');
    });

    test('a share under 2x, one decimal under 10x, whole above', () {
      for (final (ratio, en, ja, es) in [
        (1.4, '40%', '40%', '40%'),
        (2.5, '2.5 times', '2.5倍', '2,5 veces'),
        (4.979, '5 times', '5倍', '5 veces'),
        (22.27, '22 times', '22倍', '22 veces'),
        (1300.0, '1,300 times', '1,300倍', '1.300 veces'),
      ]) {
        expect(
          [for (final l in _locales) comparisonFigure(_l10n(l), ratio)],
          [en, ja, es],
        );
      }
    });
  });

  group('comparisonRatios', () {
    test('drops a comparison whose ratio no longer fits its sentence', () {
      final out = comparisonRatios(
        foods: _replaced(foods, 'lamb', (i) => i.copyWith(kgCo2ePerKg: 13)),
        modes: modes,
        behaviors: behaviors,
      );
      expect(out.keys, isNot(contains('food:lamb-pork')));
      expect(out, hasLength(calculatorComparisons.length - 1));
    });

    test('drops items off the deck and energy on different units', () {
      final out = comparisonRatios(
        foods: _replaced(foods, 'tofu', (i) => i.copyWith(sourceTier: 2)),
        modes: _replaced(modes, 'coach', (m) => m.copyWith(perVehicle: true)),
        behaviors: _replaced(
          behaviors,
          'led_bulb',
          (b) => b.copyWith(unit: EnergyUnit.use),
        ),
      );
      expect(
        out.keys,
        isNot(
          anyOf(
            contains('food:beef-tofu'),
            contains('transport:car-coach'),
            contains('energy:bulbs'),
          ),
        ),
      );
    });

    test('a missing calculator gives the other calculators', () {
      final out = comparisonRatios(
        foods: const [],
        modes: modes,
        behaviors: behaviors,
      );
      expect(out.keys.where((id) => id.startsWith('food:')), isEmpty);
      expect(out.keys.where((id) => id.startsWith('transport:')), hasLength(6));
    });
  });
}

/// The first number of [figure] in [locale]'s number style.
double _number(String figure, String locale) {
  final raw = figureNumber.firstMatch(figure)![0]!;
  final (group, decimal) = locale == 'es' ? ('.', ',') : (',', '.');
  return double.parse(raw.replaceAll(group, '').replaceAll(decimal, '.'));
}

/// [items] with the one whose id is [id] changed by [change].
List<T> _replaced<T>(List<T> items, String id, T Function(T) change) => [
  for (final item in items)
    if ((item as dynamic).id == id) change(item) else item,
];
