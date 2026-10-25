import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/energy.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/serving_preset_model.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/quiz/quiz.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

import '../../../helpers/dataset_helpers.dart';
import '../../../helpers/test_helpers.dart';
import '../../energy/energy_fixtures.dart';
import '../../walkthrough/walkthrough_test_support.dart';

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
    Locale? locale,
    ThemeData? theme,
  }) => createTestWidget(
    locale: locale,
    theme: theme,
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
      expect(find.text('2.1${unitSpace}kg'), findsNothing);
      expect(find.text('dryer'), findsOneWidget);
      expect(find.text('led_bulb'), findsOneWidget);
      expect(
        find.text('Tap or drag up the one that produces more'),
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
      expect(onCard('2.1${unitSpace}kg'), findsOneWidget);
      expect(onCard('1.0x an hour of LED light'), findsOneWidget);
      expect(onCard('4${unitSpace}g'), findsOneWidget);

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
      final gramsSize = tester
          .widget<Text>(onCard('2.1${unitSpace}kg'))
          .style!
          .fontSize!;
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
        find.descendant(
          of: find.byType(Card),
          matching: find.text('2.1${unitSpace}kg'),
        ),
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

  /// The [index] token's title, the first text on its card.
  Finder tokenTitle(int index) => find
      .descendant(
        of: find.byType(QuizTokenCard).at(index),
        matching: find.byType(Text),
      )
      .first;

  Future<void> tapToken(WidgetTester tester, int index) async {
    await tester.ensureVisible(tokenTitle(index));
    await tester.pumpAndSettle();
    await tester.tap(tokenTitle(index));
    await tester.pumpAndSettle();
  }

  Future<void> keepGoing(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Keep going'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep going'));
    await tester.pumpAndSettle();
  }

  int dryerIndex(WidgetTester tester) => leftTitle(tester) == 'dryer' ? 0 : 1;

  final arrows = find.byIcon(Icons.keyboard_double_arrow_up);

  group('tap to choose', () {
    testWidgets('tapping a token answers it', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tapToken(tester, dryerIndex(tester));
      expect(find.text('Right!'), findsOneWidget);
      expect(find.text('Streak: 1'), findsOneWidget);

      await keepGoing(tester);
      await tapToken(tester, 1 - dryerIndex(tester));
      expect(find.text('Not this time'), findsOneWidget);
      expect(find.text('Streak: 0'), findsOneWidget);
      expect(find.text('Best: 1'), findsOneWidget);
    });

    testWidgets('a tap after the reveal does nothing', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tapToken(tester, dryerIndex(tester));
      expect(find.text('Streak: 1'), findsOneWidget);
      // The wrong one now: an answer would end the run.
      await tapToken(tester, 1 - dryerIndex(tester));
      expect(find.text('Right!'), findsOneWidget);
      expect(find.text('Streak: 1'), findsOneWidget);
    });
  });

  group('info sheet', () {
    Finder inSheet(Finder finder) =>
        find.descendant(of: find.byType(QuizItemSheet), matching: finder);

    Future<void> openInfo(WidgetTester tester, String title) async {
      final button = find.byTooltip('About $title');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();
    }

    testWidgets('opens without answering and hides the figure', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await openInfo(tester, 'dryer');
      expect(find.text('Streak: 0'), findsOneWidget);
      expect(find.text('Right!'), findsNothing);
      expect(inSheet(find.text('dryer')), findsOneWidget);
      expect(inSheet(find.text('Type')), findsOneWidget);
      expect(inSheet(find.text('Laundry: drying')), findsOneWidget);
      expect(inSheet(find.text('Amount compared')), findsOneWidget);
      expect(inSheet(find.text('1 use')), findsOneWidget);
      expect(
        inSheet(find.textContaining('the multiple holds on any grid')),
        findsOneWidget,
      );
      expect(
        inSheet(find.textContaining('an hour of LED light')),
        findsNothing,
      );
      expect(inSheet(find.text('2.1${unitSpace}kg')), findsNothing);
      expect(find.text('Where this number comes from'), findsNothing);

      // Closing it leaves the round as it was.
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byType(QuizItemSheet), findsNothing);
      expect(find.text('Right!'), findsNothing);
      expect(find.text('Not this time'), findsNothing);
    });

    testWidgets('after the answer it shows the figure and the science', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tapToken(tester, dryerIndex(tester));

      await openInfo(tester, 'dryer');
      expect(inSheet(find.text('529x an hour of LED light')), findsOneWidget);
      expect(inSheet(find.text('2.1${unitSpace}kg')), findsOneWidget);

      await tester.tap(inSheet(find.text('Where this number comes from')));
      await tester.pumpAndSettle();
      expect(find.byType(QuizItemSheet), findsNothing);
      expect(find.byType(ScienceSheet), findsOneWidget);
    });

    testWidgets('the lowered token still opens its sheet', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tapToken(tester, dryerIndex(tester));

      // The swing has carried it below the row it was laid out in.
      await openInfo(tester, 'led_bulb');
      expect(inSheet(find.text('1.0x an hour of LED light')), findsOneWidget);
    });
  });

  group('swipe arrows', () {
    double tokenTop(WidgetTester tester) =>
        tester.getTopLeft(find.byType(QuizTokenCard).first).dy;

    /// How far the first arrow sits above its resting place.
    double lift(WidgetTester tester) =>
        tokenTop(tester) - spacingXs - tester.getRect(arrows.first).bottom;

    testWidgets('bob a few times on a new visit, then rest', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();
      await tester.pump();
      expect(arrows, findsNWidgets(2));

      // The bob starts a frame after the arrows first show.
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 150));
      expect(lift(tester), greaterThan(1));

      // Finite, so this settles with the arrows still on screen.
      await tester.pumpAndSettle();
      expect(arrows, findsNWidgets(2));
      expect(lift(tester), closeTo(0, 0.01));
      await tester.pump(const Duration(seconds: 2));
      expect(lift(tester), closeTo(0, 0.01));
      expect(find.text('Streak: 0'), findsOneWidget);
    });

    for (final (name, features) in [
      (
        'animations off',
        const FakeAccessibilityFeatures(disableAnimations: true),
      ),
      ('reduced motion', const FakeAccessibilityFeatures(reduceMotion: true)),
    ]) {
      testWidgets('never move with $name', (tester) async {
        tester.platformDispatcher.accessibilityFeaturesTestValue = features;
        addTearDown(
          tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
        );
        await tester.pumpWidget(buildApp());
        await tester.pump();
        await tester.pump();
        expect(arrows, findsNWidgets(2));

        // Frame by frame: animations off still runs a controller, 20x
        // faster.
        for (var frame = 0; frame < 40; frame++) {
          await tester.pump(const Duration(milliseconds: 16));
          expect(lift(tester), closeTo(0, 0.01), reason: 'frame $frame');
        }
      });
    }

    testWidgets('go on the first drag and nothing below moves', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      final lower = tester.getTopLeft(find.text('LOWER')).dy;
      final top = tokenTop(tester);

      // Too short to answer, but the player has found the gesture.
      await tester.drag(find.byType(Card).first, const Offset(0, -20));
      await tester.pumpAndSettle();
      expect(arrows, findsNothing);
      expect(find.text('Streak: 0'), findsOneWidget);
      expect(find.text('Right!'), findsNothing);
      expect(tester.getTopLeft(find.text('LOWER')).dy, lower);
      expect(tokenTop(tester), top);
    });

    testWidgets('going mid-drag does not drop the drag', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Frames between the moves, as on a device: the hint goes on the
      // first, and the same drag must still commit.
      final drag = await tester.startGesture(
        tester.getCenter(find.byType(Card).at(1)),
      );
      for (var step = 0; step < 6; step++) {
        await drag.moveBy(const Offset(0, -30));
        await tester.pump();
      }
      await drag.up();
      await tester.pumpAndSettle();
      expect(arrows, findsNothing);
      expect(find.text('Keep going'), findsOneWidget);
    });

    testWidgets('go on a tap answer and stay gone for the visit', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tapToken(tester, dryerIndex(tester));
      expect(arrows, findsNothing);
      await keepGoing(tester);
      expect(arrows, findsNothing);

      // A new visit shows them again.
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      expect(arrows, findsNWidgets(2));
    });

    testWidgets('do not come back with Start again', (tester) async {
      var behaviors = [
        _ledBulb,
        behavior('led_twin', 'lighting', EnergyCarrier.electricity, 0.0086),
      ];
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            energyBehaviorsProvider.overrideWith((_) async => behaviors),
            energyCarrierFactorsProvider.overrideWith(
              (_) async => const CarrierFactors(grid: 458, gas: 182),
            ),
            foodItemsProvider.overrideWith((_) async => const []),
            transportModesProvider.overrideWith((_) async => const []),
          ],
          child: HigherOrLowerScreen(random: Random(1)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Start again'), findsOneWidget);

      behaviors = _pair;
      ProviderScope.containerOf(
        tester.element(find.byType(HigherOrLowerScreen)),
      ).invalidate(energyBehaviorsProvider);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start again'));
      await tester.pumpAndSettle();

      expect(find.byType(QuizTokenCard), findsNWidgets(2));
      expect(arrows, findsNothing);
    });
  });

  group('semantics', () {
    testWidgets('each token is one button that a tap answers', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      final left = leftTitle(tester);

      final token = find.semantics.byLabel('$left, 1 use');
      expect(token, findsOne);
      expect(
        token.evaluate().single,
        isSemantics(
          label: '$left, 1 use',
          hint: 'Choose this one',
          isButton: true,
          hasTapAction: true,
          hasScrollUpAction: false,
          hasScrollDownAction: false,
        ),
      );
      // Read once, by the button, and the info button apart from it.
      expect(find.semantics.byLabel(RegExp('^$left')), findsOne);
      expect(
        find.semantics
            .byPredicate((node) => node.tooltip == 'About $left')
            .evaluate()
            .single,
        isSemantics(isButton: true, hasTapAction: true),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      tester.semantics.tap(token);
      await tester.pumpAndSettle();
      expect(find.text('Keep going'), findsOneWidget);

      final multiple = left == 'dryer'
          ? '529x an hour of LED light'
          : '1.0x an hour of LED light';
      final grams = left == 'dryer' ? '2.1${unitSpace}kg' : '4${unitSpace}g';
      final revealed = find.semantics.byLabel('$left: $multiple, $grams');
      expect(revealed, findsOne);
      expect(
        revealed.evaluate().single,
        isSemantics(isButton: false, hasTapAction: false),
      );
      semantics.dispose();
    });
  });

  group('warm-up', () {
    // Two clusters: every pair across them is at least 3x apart, and
    // every pair inside one is closer than 3x but clears the 20% bar.
    const kwh = {
      'a': 1.0,
      'b': 1.3,
      'c': 1.7,
      'd': 2.2,
      'e': 7.0,
      'f': 9.0,
      'g': 12.0,
    };
    final clusters = [
      for (final MapEntry(:key, :value) in kwh.entries)
        behavior(key, 'g', EnergyCarrier.electricity, value),
    ];

    String titleAt(WidgetTester tester, int index) =>
        tester.widget<Text>(tokenTitle(index)).data!;

    /// The round's ratio, and the index of the bigger card.
    (double, int) round(WidgetTester tester) {
      final left = kwh[titleAt(tester, 0)]!;
      final right = kwh[titleAt(tester, 1)]!;
      return (max(left, right) / min(left, right), left > right ? 0 : 1);
    }

    testWidgets('opens each run with clear pairs, then the usual bar', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(behaviors: clusters, seed: 3));
      await tester.pumpAndSettle();

      final later = <double>[];
      for (var streak = 0; streak < 12; streak++) {
        final (ratio, bigger) = round(tester);
        if (streak < 3) {
          expect(ratio, greaterThanOrEqualTo(3), reason: 'streak $streak');
        } else {
          later.add(ratio);
        }
        await tapToken(tester, bigger);
        expect(find.text('Streak: ${streak + 1}'), findsOneWidget);
        await keepGoing(tester);
      }
      expect(later.where((r) => r < 3), isNotEmpty);
      expect(later.every((r) => r >= 1.25), isTrue);

      // A miss starts a new run, and the warm-up with it.
      await tapToken(tester, 1 - round(tester).$2);
      expect(find.text('Streak: 0'), findsOneWidget);
      await keepGoing(tester);
      for (var streak = 0; streak < 3; streak++) {
        final (ratio, bigger) = round(tester);
        expect(ratio, greaterThanOrEqualTo(3), reason: 'after a miss');
        await tapToken(tester, bigger);
        await keepGoing(tester);
      }
    });

    testWidgets('falls back to the usual bar with no clear pair', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildApp(behaviors: clusters.take(3).toList(), seed: 3),
      );
      await tester.pumpAndSettle();

      expect(find.text('Start again'), findsNothing);
      expect(find.byType(QuizTokenCard), findsNWidgets(2));
      expect(round(tester).$1, lessThan(3));
    });
  });

  group('copy', () {
    setUpAll(loadTestFonts);

    for (final (language, subtitle, instruction) in [
      (
        'en',
        'Which produces more carbon?',
        'Tap or drag up the one that produces more',
      ),
      ('ja', 'どちらがCO2を多く出す？', '多く出すほうをタップするか、上にドラッグ'),
      (
        'es',
        '¿Cuál emite más CO2?',
        'Toca o arrastra hacia arriba la que emite más',
      ),
    ]) {
      testWidgets('asks one question on one line at 320pt in $language', (
        tester,
      ) async {
        sizeViewport(
          tester,
          size: Size(language == 'es' ? 320 * robotoToSfWidthFactor : 320, 900),
        );
        await tester.pumpWidget(
          buildApp(
            locale: Locale(language),
            theme: language == 'ja'
                ? ThemeData(fontFamily: 'FlutterTest')
                : null,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(subtitle), findsOneWidget);
        expect(renderedLines(tester, find.text(subtitle)), hasLength(1));
        await tester.scrollUntilVisible(find.text(instruction), 200);
        expect(find.text(instruction), findsOneWidget);
      });
    }
  });

  group('layout', () {
    late List<EnergyBehavior> behaviors;
    late List<FoodItem> items;
    late List<TransportMode> modes;

    setUpAll(() {
      behaviors = rawDatasetList(
        'data/app/energy_behaviors.json',
        'behaviors',
      ).map(EnergyBehavior.fromJson).toList();
      items = rawDatasetList(
        'data/app/food_items.json',
        'items',
      ).map(FoodItem.fromJson).toList();
      modes = rawDatasetList(
        'data/app/transport_modes.json',
        'modes',
      ).map(TransportMode.fromJson).toList();
    });

    // With the info buttons, after an answer, and with a sheet open.
    stressWidthLayoutTests(
      (locale, theme) => buildApp(
        behaviors: behaviors,
        items: items,
        modes: modes,
        locale: locale,
        theme: theme,
      ),
      widths: testPhoneWidths,
      scales: const [1.0, 1.3, 2.0],
      act: (tester, locale) async {
        await tapToken(tester, 0);
        final info = find.byType(InfoIconButton).first;
        await tester.ensureVisible(info);
        await tester.pumpAndSettle();
        await tester.tap(info);
        await tester.pumpAndSettle();
        expect(find.byType(QuizItemSheet), findsOneWidget);
      },
    );
  });

  group('after an answer', () {
    testWidgets('says the verdict and the streak', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // The token keeps focus and only its label changes, which a screen
      // reader does not read again.
      await tapToken(tester, dryerIndex(tester));
      expect(tester.takeAnnouncements(), [
        isAccessibilityAnnouncement('Right! Streak: 1'),
      ]);
      await keepGoing(tester);
      await tapToken(tester, 1 - dryerIndex(tester));
      expect(tester.takeAnnouncements(), [
        isAccessibilityAnnouncement('Not this time. Streak: 0'),
      ]);
    });

    testWidgets('a drag on a token scrolls the page', (tester) async {
      sizeViewport(tester, size: const Size(360, 640));
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tapToken(tester, dryerIndex(tester));
      final page = tester.state<ScrollableState>(find.byType(Scrollable).first);
      final before = page.position.pixels;

      await tester.drag(find.byType(Card).first, const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(page.position.pixels, greaterThan(before));
    });
  });

  group('sides', () {
    testWidgets('deal the bigger card on either side at random', (
      tester,
    ) async {
      // Four close cards and one far one: a warm-up pair is a close card
      // and the far one, and the second card drawn is the far one four
      // times in five, so without the shuffle it sits on the right.
      const kwh = {'a': 1.0, 'b': 1.3, 'c': 1.69, 'd': 2.197, 'e': 100.0};
      final cards = [
        for (final MapEntry(:key, :value) in kwh.entries)
          behavior(key, 'g', EnergyCarrier.electricity, value),
      ];
      const seeds = 60;
      var rightBigger = 0;
      for (var seed = 0; seed < seeds; seed++) {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(buildApp(behaviors: cards, seed: seed));
        await tester.pumpAndSettle();
        final left = kwh[tester.widget<Text>(tokenTitle(0)).data]!;
        final right = kwh[tester.widget<Text>(tokenTitle(1)).data]!;
        if (right > left) rightBigger++;
      }
      expect(rightBigger / seeds, inInclusiveRange(0.3, 0.7));
    });
  });

  group('first visit', () {
    double lift(WidgetTester tester) =>
        tester.getTopLeft(find.byType(QuizTokenCard).first).dy -
        spacingXs -
        tester.getRect(arrows.first).bottom;

    testWidgets('the arrows wait for the walkthrough, then bob', (
      tester,
    ) async {
      final settings = StreamController<UserSettingsModel>();
      addTearDown(settings.close);
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            ...walkthroughOverrides(settings: settings.stream),
            energyBehaviorsProvider.overrideWith((_) async => _pair),
            energyCarrierFactorsProvider.overrideWith(
              (_) async => const CarrierFactors(grid: 458, gas: 182),
            ),
            foodItemsProvider.overrideWith((_) async => const []),
            transportModesProvider.overrideWith((_) async => const []),
          ],
          child: HigherOrLowerScreen(random: Random(1)),
        ),
      );
      settings.add(settingsWith([WalkthroughItem.intro]));
      await tester.pump();
      await tester.pump();
      expect(arrows, findsNWidgets(2));

      // Covered by the walkthrough: still, frame by frame.
      for (var frame = 0; frame < 120; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        expect(lift(tester), closeTo(0, 0.01), reason: 'frame $frame');
      }

      // The walkthrough is done: the bob plays now, where it can be seen.
      settings.add(settingsWith([WalkthroughItem.intro, WalkthroughItem.quiz]));
      var highest = 0.0;
      for (var frame = 0; frame < 120; frame++) {
        await tester.pump(const Duration(milliseconds: 16));
        highest = max(highest, lift(tester));
      }
      expect(highest, greaterThan(4));
      await flushOverlayTimers(tester);
    });
  });

  group('small phone', () {
    setUpAll(loadTestFonts);

    for (final language in ['en', 'es', 'ja']) {
      testWidgets('shows how to answer in round 1 in $language', (
        tester,
      ) async {
        sizeViewport(
          tester,
          size: Size(language == 'es' ? 320 * robotoToSfWidthFactor : 320, 568),
        );
        await tester.pumpWidget(
          buildApp(
            locale: Locale(language),
            theme: language == 'ja'
                ? ThemeData(fontFamily: 'FlutterTest')
                : null,
          ),
        );
        await tester.pumpAndSettle();

        final l10n = lookupAppLocalizations(Locale(language));
        final instruction = tester.getRect(find.text(l10n.quizQuestion));
        expect(instruction.top, greaterThanOrEqualTo(0));
        expect(instruction.bottom, lessThanOrEqualTo(568));
        // Above the tokens, so reading it needs no scroll over them.
        expect(
          instruction.bottom,
          lessThan(
            tester.getTopLeft(find.text(l10n.quizHigher.toUpperCase())).dy,
          ),
        );
      });
    }
  });

  group('Japanese copy', () {
    for (final width in [320.0, 360.0, 411.0]) {
      testWidgets('never ends a line on one character at ${width.round()}pt', (
        tester,
      ) async {
        sizeViewport(tester, size: Size(width, 2400));
        await tester.pumpWidget(
          buildApp(
            locale: const Locale('ja'),
            theme: ThemeData(fontFamily: 'FlutterTest'),
          ),
        );
        await tester.pumpAndSettle();
        await tapToken(tester, dryerIndex(tester));

        final l10n = lookupAppLocalizations(const Locale('ja'));
        final bad = <String>[];
        for (final text in [
          l10n.quizSubtitle,
          l10n.quizQuestion,
          l10n.quizCorrect,
          l10n.energyGridBasisNoteRatio(458),
          l10n.quizNoPointsNote,
        ]) {
          final lines = renderedLines(tester, find.text(text));
          if (lines.length > 1 && lines.last.characters.length < 2) {
            bad.add('$lines');
          }
        }
        expect(bad, isEmpty);
      });
    }
  });

  testWidgets('the info buttons line up when one title is longer', (
    tester,
  ) async {
    await tester.pumpWidget(buildApp(behaviors: _unevenPair));
    await tester.pumpAndSettle();

    final buttons = find.byType(InfoIconButton);
    expect(
      tester.getCenter(buttons.at(0)).dy,
      tester.getCenter(buttons.at(1)).dy,
    );
  });
}
