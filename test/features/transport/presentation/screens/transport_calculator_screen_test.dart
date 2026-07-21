import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/transport/transport.dart';

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

// Taxi is never suggested (unmapped group), which exercises the
// estimate-flag reset on mode changes without a suggestion.
const _testTaxi = TransportMode(
  id: 'test_taxi',
  group: 'taxi',
  nameEn: 'Test Taxi',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 208,
  perVehicle: true,
  maxOccupants: 4,
);

const _testModes = [_testCar, _testRail, _testTaxi];

const _estimateNote =
    'Estimate derived from city locations. Edit it to match your route.';

// One degree of longitude at the equator is ~111.2 km straight-line,
// within the ground/active suggestion caps.
const _cityA = City(name: 'Alphaville', cc: 'AA', lat: 0, lon: 0, mass: 'T');
const _cityB = City(name: 'Betatown', cc: 'BB', lat: 0, lon: 1, mass: 'T');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        transportModesProvider.overrideWith((_) async => _testModes),
        transportCitiesProvider.overrideWith((_) async => [_cityA, _cityB]),
        transportCityLinksProvider.overrideWith(
          (_) async => const <CityLink>[],
        ),
        transportWaterBlockedPairsProvider.overrideWith(
          (_) async => const <String>{},
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

  Future<void> openEditor(WidgetTester tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add leg'));
    await tester.pumpAndSettle();
  }

  Future<void> addLeg(
    WidgetTester tester, {
    required String modeName,
    required String distance,
  }) async {
    await tester.tap(find.text(modeName).last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), distance);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  Future<void> pickCities(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).first, 'Alpha');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alphaville, AA').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'Beta');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Betatown, BB').last);
    await tester.pumpAndSettle();
  }

  group('TransportCalculatorScreen', () {
    testWidgets('shows the empty journey state', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Add a leg to build your journey and see its '
          'CO2e footprint.',
        ),
        findsOneWidget,
      );
      expect(find.byType(JourneyLegCard), findsNothing);
    });

    testWidgets('adds a per-passenger leg and totals via the calculator', (
      tester,
    ) async {
      await openEditor(tester);

      expect(find.text('Choose a transport mode'), findsOneWidget);
      // Grouped picker shows both fixture groups.
      expect(find.text('Car & motorbike'), findsOneWidget);
      expect(find.text('Rail'), findsOneWidget);

      await addLeg(tester, modeName: 'Test Rail', distance: '100');

      expect(find.byType(JourneyLegCard), findsOneWidget);
      expect(find.text('100 km'), findsOneWidget);

      final expectedGrams = TransportCalculator.journeyCo2eGrams(
        TransportCalculator.byId(_testModes),
        const [JourneyLeg(modeId: 'test_rail', distanceKm: 100)],
      );
      expect(
        find.text('${formatCO2Compact(expectedGrams.round())} CO2e'),
        findsOneWidget,
      );
    });

    testWidgets('per-passenger modes get no occupancy stepper', (tester) async {
      await openEditor(tester);
      await tester.tap(find.text('Test Rail').last);
      await tester.pumpAndSettle();

      expect(find.text('People in the vehicle'), findsNothing);
      expect(find.byType(OccupancyStepper), findsNothing);
    });

    testWidgets('occupancy stepper shows for per-vehicle modes and '
        'divides the total', (tester) async {
      await openEditor(tester);
      await tester.tap(find.text('Test Car').last);
      await tester.pumpAndSettle();

      expect(find.byType(OccupancyStepper), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add_circle_outline));
      await tester.pump();
      expect(find.text('3'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '100');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      const leg = JourneyLeg(modeId: 'test_car', distanceKm: 100, occupants: 3);
      final expectedGrams = TransportCalculator.legCo2eGrams(_testCar, leg);
      expect(find.text('100 km · 3 people'), findsOneWidget);
      expect(
        find.text('${formatCO2Compact(expectedGrams.round())} CO2e'),
        findsOneWidget,
      );
    });

    testWidgets('stepper cannot exceed the mode max occupants', (tester) async {
      await openEditor(tester);
      await tester.tap(find.text('Test Car').last);
      await tester.pumpAndSettle();

      for (var i = 0; i < 6; i++) {
        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();
      }
      expect(find.text('4'), findsOneWidget);
      expect(find.text('5'), findsNothing);
    });

    testWidgets('removing a leg returns to the empty state', (tester) async {
      await openEditor(tester);
      await addLeg(tester, modeName: 'Test Rail', distance: '50');
      expect(find.byType(JourneyLegCard), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.byType(JourneyLegCard), findsNothing);
      expect(
        find.text(
          'Add a leg to build your journey and see its '
          'CO2e footprint.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('sums multiple legs via the calculator', (tester) async {
      await openEditor(tester);
      await addLeg(tester, modeName: 'Test Rail', distance: '100');
      await tester.tap(find.text('Add leg'));
      await tester.pumpAndSettle();
      await addLeg(tester, modeName: 'Test Car', distance: '20');

      expect(find.byType(JourneyLegCard), findsNWidgets(2));
      final expectedGrams = TransportCalculator.journeyCo2eGrams(
        TransportCalculator.byId(_testModes),
        const [
          JourneyLeg(modeId: 'test_rail', distanceKm: 100),
          JourneyLeg(modeId: 'test_car', distanceKm: 20),
        ],
      );
      expect(
        find.text('${formatCO2Compact(expectedGrams.round())} CO2e'),
        findsOneWidget,
      );
    });

    testWidgets('rejects negative and NaN distances', (tester) async {
      await openEditor(tester);
      await tester.tap(find.text('Test Rail').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '-5');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a distance of 0 km or more'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'NaN');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a distance of 0 km or more'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(JourneyLegCard), findsNothing);
    });

    testWidgets('editing a leg updates it in place', (tester) async {
      await openEditor(tester);
      await addLeg(tester, modeName: 'Test Rail', distance: '100');

      await tester.tap(find.text('Test Rail'));
      await tester.pumpAndSettle();
      expect(find.text('Edit leg'), findsOneWidget);
      expect(find.widgetWithText(TextField, '100'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '200');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(JourneyLegCard), findsOneWidget);
      expect(find.text('200 km'), findsOneWidget);
    });

    testWidgets('city pair prefills an editable distance estimate', (
      tester,
    ) async {
      await openEditor(tester);
      await pickCities(tester);

      // Ground estimate = haversine (~111.2 km) x 1.3 circuity.
      expect(find.text('~145 km'), findsNWidgets(2));

      await tester.tap(find.text('Test Car').last);
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, '145'), findsOneWidget);
      expect(find.text(_estimateNote), findsOneWidget);

      // The estimate stays editable (standing decision).
      await tester.enterText(find.byType(TextField), '160');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('160 km · 1 person'), findsOneWidget);
    });

    testWidgets('accepts a locale decimal comma in the distance '
        '(PDR R5-16)', (tester) async {
      await openEditor(tester);
      await addLeg(tester, modeName: 'Test Rail', distance: '12,5');

      expect(find.byType(JourneyLegCard), findsOneWidget);
      expect(find.text('12.5 km'), findsOneWidget);
      expect(find.text('Enter a distance of 0 km or more'), findsNothing);
    });

    testWidgets('seeds the edit field with full precision (PDR R5-19)', (
      tester,
    ) async {
      await openEditor(tester);
      await addLeg(tester, modeName: 'Test Rail', distance: '12.345');
      // The card display rounds; the edit round-trip must not.
      expect(find.text('12.3 km'), findsOneWidget);

      await tester.tap(find.text('Test Rail'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextField, '12.345'), findsOneWidget);
    });

    testWidgets('city fields keep their text across a step round-trip '
        '(PDR R5-17)', (tester) async {
      await openEditor(tester);
      await pickCities(tester);

      await tester.tap(find.text('Test Car').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Alphaville, AA'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Betatown, BB'), findsOneWidget);
      expect(find.text('~145 km'), findsNWidgets(2));

      // The clear-on-edit guard still works after the remount.
      await tester.enterText(find.byType(TextField).first, 'Alphaville');
      await tester.pumpAndSettle();
      expect(find.textContaining('~'), findsNothing);
    });

    testWidgets('estimate flag resets when the new mode has no '
        'suggestion (PDR R5-19)', (tester) async {
      await openEditor(tester);
      await pickCities(tester);

      await tester.tap(find.text('Test Car').last);
      await tester.pumpAndSettle();
      expect(find.text(_estimateNote), findsOneWidget);

      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Taxi').last);
      await tester.pumpAndSettle();

      // The carried-over value is now manual text, not an estimate.
      expect(find.widgetWithText(TextField, '145'), findsOneWidget);
      expect(find.text(_estimateNote), findsNothing);
    });

    testWidgets('a same-city pair shows no suggestions (PDR R5-19)', (
      tester,
    ) async {
      await openEditor(tester);

      await tester.enterText(find.byType(TextField).first, 'Alpha');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alphaville, AA').last);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(1), 'Alpha');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alphaville, AA').last);
      await tester.pumpAndSettle();

      // No "~0 km" label may render for the degenerate pair.
      expect(find.textContaining('~'), findsNothing);
    });

    testWidgets('occupancy stepper exposes semantic labels (PDR R5-18)', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await openEditor(tester);
      await tester.tap(find.text('Test Car').last);
      await tester.pumpAndSettle();

      expect(find.byTooltip('Add a person'), findsOneWidget);
      expect(find.byTooltip('Remove a person'), findsOneWidget);
      expect(find.bySemanticsLabel('People in the vehicle: 1'), findsOneWidget);

      await tester.tap(find.byTooltip('Add a person'));
      await tester.pump();
      expect(find.bySemanticsLabel('People in the vehicle: 2'), findsOneWidget);
      handle.dispose();
    });
  });
}
