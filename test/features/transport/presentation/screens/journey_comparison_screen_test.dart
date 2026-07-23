import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/transport/transport.dart';

const _flight = TransportMode(
  id: 'flight_longhaul',
  group: 'air',
  nameEn: 'Long-haul flight',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 117,
);
const _rail = TransportMode(
  id: 'rail_national',
  group: 'rail',
  nameEn: 'Train',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 35,
);
const _bev = TransportMode(
  id: 'car_bev',
  group: 'car',
  nameEn: 'Electric car',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 73,
  perVehicle: true,
  maxOccupants: 5,
);

final _modesById = TransportCalculator.byId(const [_flight, _rail, _bev]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp(List<List<JourneyLeg>> options) {
    return ProviderScope(
      overrides: [
        impactEquivalenciesDataProvider.overrideWith(
          (_) async => const [
            EquivalencyMetadata(
              type: EquivalencyType.trees,
              gramsPerUnit: 21770,
              sourceName: 'EPA',
              sourceUrl: 'https://example.org',
            ),
          ],
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: JourneyComparisonScreen(options: options, modesById: _modesById),
      ),
    );
  }

  testWidgets('draws a bar per option and the "emits less" delta', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(const [
        [JourneyLeg(modeId: 'flight_longhaul', distanceKm: 1000)],
        [JourneyLeg(modeId: 'rail_national', distanceKm: 1000)],
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    // 117kg vs 35kg -> "Rail emits 82.0kg CO2e less than Air (70%
    // lower)". Copy rule: "emits ... less", never "saves". The worst
    // option is named so the comparison is explicit.
    expect(find.textContaining('emits'), findsOneWidget);
    expect(find.textContaining('less than Air'), findsOneWidget);
    expect(find.textContaining('82.0kg'), findsWidgets);
    expect(find.textContaining('saves'), findsNothing);
  });

  testWidgets('shows the electric-car grid caveat on a BEV option', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(const [
        [JourneyLeg(modeId: 'flight_longhaul', distanceKm: 500)],
        [JourneyLeg(modeId: 'car_bev', distanceKm: 500)],
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Global-average grid'), findsOneWidget);
  });

  // Three-option comparisons: rail 35kg, BEV 73kg, flight 117kg over
  // 1000km. Best=rail, worst=flight, so the default bank is 82kg.
  const threeOptions = [
    [JourneyLeg(modeId: 'flight_longhaul', distanceKm: 1000)],
    [JourneyLeg(modeId: 'rail_national', distanceKm: 1000)],
    [JourneyLeg(modeId: 'car_bev', distanceKm: 1000)],
  ];

  testWidgets('banks the chosen-vs-baseline delta, not always best-vs-worst', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildApp(threeOptions));
    await tester.pumpAndSettle();

    // Default: took rail, instead of flight -> 82kg.
    expect(find.textContaining('bank the 82.0kg'), findsOneWidget);

    // Change the avoided alternative to the electric car (73kg): the
    // banked saving drops to 73 - 35 = 38kg.
    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<int>).at(1),
        matching: find.text('Car & motorbike'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('bank the 38.0kg'), findsOneWidget);
    expect(find.textContaining('bank the 82.0kg'), findsNothing);
  });

  testWidgets('disables banking when the two picks are the same option', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildApp(threeOptions));
    await tester.pumpAndSettle();

    // Set the avoided alternative to rail -- the same as what was taken.
    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<int>).at(1),
        matching: find.text('Rail'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Pick two different options'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });
}
