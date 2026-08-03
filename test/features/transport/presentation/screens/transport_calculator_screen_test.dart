import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/transport/transport.dart';
import 'package:seed_app/shared/widgets/comparison_widgets.dart';

const _testCar = TransportMode(
  id: 'test_car',
  group: 'car',
  nameEn: 'Test Car',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 160,
  perVehicle: true,
  maxOccupants: 4,
);

const _testRail = TransportMode(
  id: 'test_rail',
  group: 'rail',
  nameEn: 'Test Rail',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 35,
);

const _testModes = [_testCar, _testRail];

const _estimateNote =
    'Estimate derived from city locations. Edit it to match your route.';

// One degree of longitude at the equator is ~111.2 km straight-line.
const _cityA = City(name: 'Alphaville', cc: 'AA', lat: 0, lon: 0, mass: 'T');
const _cityB = City(name: 'Betatown', cc: 'BB', lat: 0, lon: 1, mass: 'T');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Cities default to empty so the sheet holds exactly one TextField
  // (the distance); the prefill tests opt into a city list.
  Widget buildApp({
    List<City> cities = const [],
    Set<String> waterBlocked = const {},
  }) {
    return ProviderScope(
      overrides: [
        transportModesProvider.overrideWith((_) async => _testModes),
        transportCitiesProvider.overrideWith((_) async => cities),
        transportCityLinksProvider.overrideWith(
          (_) async => const <CityLink>[],
        ),
        transportWaterBlockedPairsProvider.overrideWith(
          (_) async => waterBlocked,
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TransportCalculatorScreen(),
      ),
    );
  }

  /// Opens the leg editor through the shipped path: the per-column
  /// "Add leg" button opens the mode picker, which opens the editor.
  Future<void> openSheet(
    WidgetTester tester,
    String modeName, {
    int column = 0,
  }) async {
    await tester.tap(find.text('Add leg').at(column));
    await tester.pumpAndSettle();
    await tester.tap(find.text(modeName).last);
    await tester.pumpAndSettle();
  }

  Future<void> addLeg(
    WidgetTester tester, {
    required String modeName,
    required String distance,
    int column = 0,
  }) async {
    await openSheet(tester, modeName, column: column);
    await tester.enterText(find.byType(TextField).last, distance);
    await tester.pumpAndSettle();
    // The column is known from the button, so the editor confirms
    // with a single Save.
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  group('TransportCalculatorScreen', () {
    testWidgets('starts with two empty columns and no verdict', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Option A'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
      expect(find.text('Tap Add leg to start this journey'), findsNWidgets(2));
      expect(find.text('Build both options to compare them'), findsOneWidget);
      expect(find.byType(OptionEntryCard), findsNothing);
    });

    testWidgets('the Add leg button adds a leg to its own column', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addLeg(tester, modeName: 'Test Rail', distance: '100');

      expect(find.byType(OptionEntryCard), findsOneWidget);
      expect(find.text('100 km'), findsOneWidget);
      // Column A holds it, so B is still showing its hint.
      expect(find.text('Tap Add leg to start this journey'), findsOneWidget);

      final expected = TransportCalculator.journeyCo2eGrams(
        TransportCalculator.byId(_testModes),
        const [JourneyLeg(modeId: 'test_rail', distanceKm: 100)],
      );
      expect(
        find.textContaining(formatCO2Compact(expected.round())),
        findsWidgets,
      );
    });

    testWidgets('per-vehicle modes get an occupancy stepper that divides', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await openSheet(tester, 'Test Car');
      await tester.enterText(find.byType(TextField).last, '100');
      await tester.pumpAndSettle();

      // 160 g/vehicle-km x 100 km = 16kg alone, halved by a second
      // passenger. The per-vehicle factor line never moves, so this
      // preview is the only place occupancy is visible.
      expect(find.text('This adds 16.0kg CO2e'), findsOneWidget);
      await tester.tap(find.byTooltip('Add a person'));
      await tester.pumpAndSettle();
      expect(find.text('This adds 8.0kg CO2e'), findsOneWidget);
    });

    testWidgets('per-passenger modes get no occupancy stepper', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await openSheet(tester, 'Test Rail');

      expect(find.byTooltip('Add a person'), findsNothing);
    });

    testWidgets('rejects negative and NaN distances', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await openSheet(tester, 'Test Rail');

      await tester.enterText(find.byType(TextField).last, 'NaN');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Enter a distance of 0 km or more'), findsOneWidget);
      expect(find.byType(OptionEntryCard), findsNothing);
    });

    testWidgets('editing a leg updates it in place', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addLeg(tester, modeName: 'Test Rail', distance: '100');

      await tester.tap(find.byType(OptionEntryCard));
      await tester.pumpAndSettle();
      // Seeded with the stored value, then edited.
      expect(
        tester.widget<TextField>(find.byType(TextField).last).controller!.text,
        '100',
      );
      await tester.enterText(find.byType(TextField).last, '250');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(OptionEntryCard), findsOneWidget);
      expect(find.text('250 km'), findsOneWidget);
    });

    testWidgets('removing a leg empties the column again', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addLeg(tester, modeName: 'Test Rail', distance: '100');

      await tester.tap(find.byTooltip('Remove'));
      await tester.pumpAndSettle();

      expect(find.byType(OptionEntryCard), findsNothing);
      expect(find.text('Tap Add leg to start this journey'), findsNWidgets(2));
    });

    testWidgets('a journey can stack multiple legs in one column', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addLeg(tester, modeName: 'Test Rail', distance: '400');
      await addLeg(tester, modeName: 'Test Rail', distance: '30');

      // Tokyo -> Osaka -> Kobe shape: two legs, one column.
      expect(find.byType(OptionEntryCard), findsNWidgets(2));
      final expected = TransportCalculator.journeyCo2eGrams(
        TransportCalculator.byId(_testModes),
        const [
          JourneyLeg(modeId: 'test_rail', distanceKm: 400),
          JourneyLeg(modeId: 'test_rail', distanceKm: 30),
        ],
      );
      expect(
        find.textContaining(formatCO2Compact(expected.round())),
        findsWidgets,
      );
    });

    testWidgets('both columns built shows the delta and the bank action', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await addLeg(tester, modeName: 'Test Rail', distance: '100');
      await addLeg(tester, modeName: 'Test Car', distance: '100', column: 1);

      // Rail 3.5kg vs car 16kg -> rail emits 12.5kg less (78% lower).
      // The summary names the columns, not one leg from inside them.
      expect(find.text('Build both options to compare them'), findsNothing);
      expect(find.textContaining('emits'), findsOneWidget);
      expect(find.textContaining('less than Option B'), findsOneWidget);
      expect(find.text('I chose Option A'), findsOneWidget);
      expect(find.textContaining('less than Test Car'), findsNothing);
    });

    testWidgets('a CO2e total links to a definition of the unit', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Co2eAmount).first);
      await tester.pumpAndSettle();

      expect(find.text('What is CO2e?'), findsOneWidget);
      expect(
        find.textContaining('counts methane and other greenhouse gases'),
        findsOneWidget,
      );
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('What is CO2e?'), findsNothing);
    });

    testWidgets('a per-leg city pair prefills an editable estimate', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(cities: const [_cityA, _cityB]));
      await tester.pumpAndSettle();
      await openSheet(tester, 'Test Rail');

      // The sheet carries the only From/To now -- the screen-level
      // pair is gone -- so each leg is estimated from its own
      // endpoints. Fields in the sheet: From, To, then distance.
      await tester.enterText(find.byType(TextField).at(0), 'Alpha');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alphaville, AA').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(1), 'Beta');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Betatown, BB').last);
      await tester.pumpAndSettle();

      expect(find.text(_estimateNote), findsOneWidget);
      final text = tester
          .widget<TextField>(find.byType(TextField).last)
          .controller!
          .text;
      expect(double.parse(text), closeTo(111.2 * 1.3, 3));
    });

    testWidgets('a pair with no estimate reads Unknown until tapped', (
      tester,
    ) async {
      // Water-blocked, so the ground kind is withheld (the
      // Helsinki-Tallinn case): the field must say so rather than sit
      // blank and indistinguishable from no pair at all.
      await tester.pumpWidget(
        buildApp(
          cities: const [_cityA, _cityB],
          waterBlocked: {cityPairKey(_cityA, _cityB)},
        ),
      );
      await tester.pumpAndSettle();
      await openSheet(tester, 'Test Rail');

      await tester.enterText(find.byType(TextField).at(0), 'Alpha');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alphaville, AA').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(1), 'Beta');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Betatown, BB').last);
      await tester.pumpAndSettle();

      expect(find.text('Unknown'), findsOneWidget);
      expect(find.text(_estimateNote), findsNothing);
      expect(
        tester.widget<TextField>(find.byType(TextField).last).controller!.text,
        isEmpty,
      );

      await tester.tap(find.byType(TextField).last);
      await tester.pumpAndSettle();
      expect(find.text('Unknown'), findsNothing);
    });
  });
}
