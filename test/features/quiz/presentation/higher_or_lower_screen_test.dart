import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/energy.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/serving_preset_model.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/quiz/quiz.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

import '../../../helpers/test_helpers.dart';
import '../../energy/energy_fixtures.dart';

final _ledBulb = behavior(
  'led_bulb',
  'lighting',
  EnergyCarrier.electricity,
  0.0085,
);
final _dryer = behavior('dryer', 'laundry_dry', EnergyCarrier.electricity, 4.5);

/// Two cards 529x apart: the hidden card is always the other one, so a
/// test knows the right answer without depending on the shuffle.
final _pair = [_ledBulb, _dryer];

final _mixed = [
  _ledBulb,
  _dryer,
  behavior('kettle', 'boil', EnergyCarrier.electricity, 0.116278),
  behavior('oven', 'cook', EnergyCarrier.electricity, 0.82),
  behavior('line_dry', 'laundry_dry', EnergyCarrier.none, 0),
  behavior('bath_gas', 'hot_water', EnergyCarrier.gas, 7.526854),
  behavior('shower_gas', 'hot_water', EnergyCarrier.gas, 1.64018),
];

/// One long name against one short one: without stretched tokens the
/// wrapped title made its card visibly taller than the other.
final _unevenPair = [
  _ledBulb,
  behavior(
    'Tumble dryer, vented or condenser',
    'laundry_dry',
    EnergyCarrier.electricity,
    4.5,
  ),
];

FoodItem _food(String id, double kgPerKg, double grams) => FoodItem(
  id: id,
  group: 'g',
  nameEn: id,
  nameJa: '',
  nameEs: '',
  kgCo2ePerKg: kgPerKg,
  servings: [
    ServingPreset(
      id: 'one',
      nameEn: '1 serving',
      nameJa: '',
      nameEs: '',
      grams: grams,
    ),
  ],
  defaultServingId: 'one',
);

TransportMode _mode(String id, double gPerKm, {bool perVehicle = false}) =>
    TransportMode(
      id: id,
      group: 'g',
      nameEn: id,
      nameJa: '',
      nameEs: '',
      gCo2ePerKm: gPerKm,
      perVehicle: perVehicle,
    );

final _foods = [_food('beef', 60, 150), _food('lentils', 0.9, 150)];
final _modes = [_mode('flight', 229.28), _mode('coach', 27.76)];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Food and transport default to empty decks, which cannot deal, so
  // every round of the cases below is an energy round.
  Widget buildApp({
    List<EnergyBehavior>? behaviors,
    List<FoodItem> items = const [],
    List<TransportMode> modes = const [],
    int seed = 1,
  }) => createTestWidget(
    overrides: [
      energyBehaviorsProvider.overrideWith((_) async => behaviors ?? _pair),
      energyCarrierFactorsProvider.overrideWith(
        (_) async => const CarrierFactors(grid: 458, gas: 182),
      ),
      foodItemsProvider.overrideWith((_) async => items),
      transportModesProvider.overrideWith((_) async => modes),
    ],
    child: HigherOrLowerScreen(random: Random(seed)),
  );

  /// The left card's name. Read off the first Card rather than searched
  /// by text, because a revealed card also appears in the ladder below.
  String leftTitle(WidgetTester tester) => tester
      .widget<Text>(
        find
            .descendant(
              of: find.byType(Card).first,
              matching: find.byType(Text),
            )
            .first,
      )
      .data!;

  /// Answers by dragging: up claims "this one uses more". With a
  /// two-card deck the other card is always the alternative, so the
  /// right answer is known without depending on the shuffle.
  /// Drags a token, scrolling it into view first: the play area
  /// reserves room for the swing, so a token can sit below the fold.
  Future<void> dragToken(WidgetTester tester, int index) async {
    final token = find.byType(Card).at(index);
    await tester.ensureVisible(token);
    await tester.pumpAndSettle();
    await tester.drag(token, const Offset(0, -150));
    await tester.pumpAndSettle();
  }

  Future<void> answer(WidgetTester tester, {required bool correctly}) async {
    final leftIsBigger = leftTitle(tester) == 'dryer';
    final dragLeft = correctly ? leftIsBigger : !leftIsBigger;
    await dragToken(tester, dragLeft ? 0 : 1);
  }

  // A phone-shaped, tall window: the play area reserves room for the
  // wheel's swing, so at the default 800x600 the tokens and the streak
  // row cannot both be on screen and every assertion turns into a
  // scrolling exercise. The narrow width also makes a long title wrap,
  // which the equal-size check depends on.
  setUp(
    () => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..physicalSize = const Size(420, 2400)
      ..devicePixelRatio = 1.0,
  );

  tearDown(
    () => TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio(),
  );

  group('HigherOrLowerScreen', () {
    testWidgets('deals no gas card, however long the run goes', (tester) async {
      await tester.pumpWidget(buildApp(behaviors: _mixed, seed: 5));
      await tester.pumpAndSettle();

      // A gas row's rank moves with the user's grid, so it has no right
      // answer and must never be dealt (rule 28).
      for (var round = 0; round < 15; round++) {
        expect(find.text('bath_gas'), findsNothing);
        expect(find.text('shower_gas'), findsNothing);
        await dragToken(tester, 0);
        expect(find.text('bath_gas'), findsNothing);
        expect(find.text('shower_gas'), findsNothing);
        await tester.ensureVisible(find.text('Keep going'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Keep going'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('a right answer adds to the streak', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Streak: 0'), findsOneWidget);
      await answer(tester, correctly: true);
      expect(find.text('Right!'), findsOneWidget);
      expect(find.text('Streak: 1'), findsOneWidget);

      await tester.ensureVisible(find.text('Keep going'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep going'));
      await tester.pumpAndSettle();
      await answer(tester, correctly: true);
      expect(find.text('Streak: 2'), findsOneWidget);
    });

    testWidgets('a wrong answer resets the streak, the best holds', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await answer(tester, correctly: true);
      await tester.ensureVisible(find.text('Keep going'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep going'));
      await tester.pumpAndSettle();
      await answer(tester, correctly: true);
      expect(find.text('Streak: 2'), findsOneWidget);
      // Recorded as the streak grows, so leaving mid-run keeps it.
      expect(find.text('Best: 2'), findsOneWidget);

      await tester.ensureVisible(find.text('Keep going'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep going'));
      await tester.pumpAndSettle();
      await answer(tester, correctly: false);

      expect(find.text('Not this time'), findsOneWidget);
      expect(find.text('Streak: 0'), findsOneWidget);
      expect(find.text('Best: 2'), findsOneWidget);
    });

    testWidgets('an exhausted deck offers a restart, not an error', (
      tester,
    ) async {
      // Two cards inside the 20% bar: nothing can be dealt against the
      // first, so the run has nowhere to go.
      final nearTies = [
        _ledBulb,
        behavior('led_twin', 'lighting', EnergyCarrier.electricity, 0.0086),
      ];
      await tester.pumpWidget(buildApp(behaviors: nearTies));
      await tester.pumpAndSettle();

      expect(find.byType(ErrorDisplay), findsNothing);
      expect(find.text('Start again'), findsOneWidget);

      await tester.tap(find.text('Start again'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Start again'), findsOneWidget);
    });

    testWidgets('the ladder collects the cards revealed so far', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Ladder so far'), findsNothing);
      await answer(tester, correctly: true);

      // The play area is tall, so the ladder sits below the fold.
      await tester.scrollUntilVisible(find.text('Ladder so far'), 200);
      expect(find.text('Ladder so far'), findsOneWidget);
      // Both cards of a correct pair are listed.
      expect(find.text('dryer'), findsAtLeast(1));
      expect(find.text('led_bulb'), findsAtLeast(1));

      // A wrong answer ends the run, so the ladder goes with it.
      await tester.ensureVisible(find.text('Keep going'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep going'));
      await tester.pumpAndSettle();
      await answer(tester, correctly: false);
      expect(find.text('Ladder so far'), findsNothing);
    });

    testWidgets('no figures until the answer is in', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Showing a card's multiple up front handed over most of the
      // answer, so both cards are names only until the drag commits.
      expect(find.textContaining('an hour of LED light'), findsNothing);
      expect(find.text('2.1kg'), findsNothing);
      expect(find.text('dryer'), findsOneWidget);
      expect(find.text('led_bulb'), findsOneWidget);
      expect(
        find.text('Drag the one with the bigger footprint to the top'),
        findsOneWidget,
      );

      // A drag too short to clear the threshold is not an answer.
      await tester.drag(find.byType(Card).first, const Offset(0, -20));
      await tester.pumpAndSettle();
      expect(find.textContaining('an hour of LED light'), findsNothing);
    });

    testWidgets('the reveal leads with the multiple, grams follow smaller', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await answer(tester, correctly: true);

      // Scoped to the cards: the ladder repeats a revealed multiple.
      Finder onCard(String text) =>
          find.descendant(of: find.byType(Card), matching: find.text(text));

      // 4.5 / 0.0085 = 529x; 4.5 kWh x 458 g = 2.1kg (rule 26).
      expect(onCard('529x an hour of LED light'), findsOneWidget);
      expect(onCard('2.1kg'), findsOneWidget);
      expect(onCard('1.0x an hour of LED light'), findsOneWidget);
      expect(onCard('4g'), findsOneWidget);

      // Coloured by the round's domain. The figure is large text, so
      // it takes the vivid 3:1 tone; the raw category colour is a fill
      // and fails contrast either way.
      expect(
        tester.widget<Text>(onCard('529x an hour of LED light')).style!.color,
        ActionCategory.energy.textColorOn(Brightness.light, large: true),
      );

      final multipleSize = tester
          .widget<Text>(onCard('529x an hour of LED light'))
          .style!
          .fontSize!;
      final gramsSize = tester.widget<Text>(onCard('2.1kg')).style!.fontSize!;
      expect(gramsSize, lessThan(multipleSize));
      // The basis note only claims any-grid validity for the multiple.
      await tester.scrollUntilVisible(
        find.textContaining('the multiple holds on any grid'),
        300,
      );
      expect(
        find.textContaining('the multiple holds on any grid'),
        findsOneWidget,
      );
    });

    testWidgets('the tokens match in size and ride one wheel', (tester) async {
      await tester.pumpWidget(buildApp(behaviors: _unevenPair));
      await tester.pumpAndSettle();

      // Filled with the round's domain colour, so a food round and an
      // energy round do not look like the same game.
      for (var i = 0; i < 2; i++) {
        expect(
          tester.widget<Card>(find.byType(Card).at(i)).color,
          ActionCategory.energy.color.withValues(alpha: opacityLight),
        );
      }

      final leftBefore = tester.getRect(find.byType(Card).at(0));
      final rightBefore = tester.getRect(find.byType(Card).at(1));
      // Stretched to a common height: a wrapped title used to leave one
      // token visibly taller than the other.
      expect(leftBefore.size, rightBefore.size);

      // Turning the wheel by the right token has to lower the left one,
      // and both swing inward rather than straight up and down.
      await tester.drag(find.byType(Card).at(1), const Offset(0, -150));
      await tester.pumpAndSettle();

      final leftAfter = tester.getRect(find.byType(Card).at(0));
      final rightAfter = tester.getRect(find.byType(Card).at(1));
      // Vertically by the top edge, not the centre: the reveal makes
      // both cards taller, which drags a centre downward even as the
      // token rises.
      expect(rightAfter.top, lessThan(rightBefore.top));
      expect(leftAfter.top, greaterThan(leftBefore.top));

      // A committed quarter turn leaves a clean vertical stack: both
      // tokens on the centre line, the lifted one wholly above the
      // other, and neither rotated -- a tilted card would widen its
      // bounding box beyond the width it was laid out at.
      expect(leftAfter.center.dx, closeTo(rightAfter.center.dx, 0.5));
      expect(rightAfter.bottom, lessThanOrEqualTo(leftAfter.top));
      expect(leftAfter.width, closeTo(leftBefore.width, 0.5));
      expect(rightAfter.width, closeTo(rightBefore.width, 0.5));
    });

    // Rounds rotate between the three datasets, but a PAIR never does:
    // a serving of beef against an hour of LED light would set a
    // lifecycle figure beside an operational one (decision E8).
    testWidgets('rounds rotate by domain and never mix a pair', (tester) async {
      const bases = {
        'Home energy, one typical use': {'led_bulb', 'dryer'},
        'Food, one serving': {'beef', 'lentils'},
        'Transport, one passenger-kilometre': {'flight', 'coach'},
      };
      await tester.pumpWidget(buildApp(items: _foods, modes: _modes, seed: 4));
      await tester.pumpAndSettle();

      final seen = <String>{};
      for (var round = 0; round < 24; round++) {
        final basis = bases.keys.firstWhere(
          (label) => find.text(label).evaluate().isNotEmpty,
          orElse: () => fail('no basis label on screen'),
        );
        seen.add(basis);
        final titles = {
          leftTitle(tester),
          tester
              .widget<Text>(
                find
                    .descendant(
                      of: find.byType(Card).at(1),
                      matching: find.byType(Text),
                    )
                    .first,
              )
              .data!,
        };
        expect(
          titles.difference(bases[basis]!),
          isEmpty,
          reason: '$titles is not one $basis pair',
        );

        await dragToken(tester, 0);
        await tester.ensureVisible(find.text('Keep going'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Keep going'));
        await tester.pumpAndSettle();
      }
      expect(seen, hasLength(3));
    });

    testWidgets('never deals a row its dataset cannot rank', (tester) async {
      // Each deck drops what it cannot compare: a per-vehicle transport
      // figure is a vehicle-km, not a passenger-km, and a tier-2 food
      // row is measured to a narrower boundary than the rest, so the
      // ordinary 20% bar would not hold against it.
      final modes = [..._modes, _mode('car_petrol', 170, perVehicle: true)];
      final items = [
        ..._foods,
        _food('prawns', 27, 150).copyWith(sourceTier: 2),
      ];
      await tester.pumpWidget(buildApp(items: items, modes: modes, seed: 6));
      await tester.pumpAndSettle();

      for (var round = 0; round < 24; round++) {
        expect(find.text('car_petrol'), findsNothing);
        expect(find.text('prawns'), findsNothing);
        await dragToken(tester, 0);
        expect(find.text('car_petrol'), findsNothing);
        expect(find.text('prawns'), findsNothing);
        await tester.ensureVisible(find.text('Keep going'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Keep going'));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('awards nothing and says so', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text('Just for fun. No points, and nothing is logged.'),
        findsOneWidget,
      );
      expect(find.textContaining('pts'), findsNothing);
      expect(find.byIcon(Icons.add), findsNothing);
      // The drag zones are labelled, so the gesture is discoverable.
      expect(find.text('HIGHER'), findsOneWidget);
      expect(find.text('LOWER'), findsOneWidget);
    });

    testWidgets('a dataset without the LED anchor states grams instead', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(
          behaviors: [
            _dryer,
            behavior('oven', 'cook', EnergyCarrier.electricity, 0.82),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Any drag past the threshold is an answer; which card is right
      // does not matter here.
      await dragToken(tester, 0);

      expect(find.textContaining('an hour of LED light'), findsNothing);
      // Grams lead when no invariant multiple can be stated, and the
      // note drops the any-grid claim with them. Scoped to the cards:
      // a revealed figure repeats in the ladder.
      expect(
        find.descendant(of: find.byType(Card), matching: find.text('2.1kg')),
        findsOneWidget,
      );
      // Scrolled to the footer, so the absent claim is really absent
      // rather than merely unbuilt.
      await tester.scrollUntilVisible(
        find.textContaining('No points, and nothing is logged'),
        300,
      );
      expect(
        find.textContaining('the multiple holds on any grid'),
        findsNothing,
      );
      expect(find.textContaining('world-average grid, 458'), findsOneWidget);
    });
  });
}
