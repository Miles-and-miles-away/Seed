import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/energy/energy.dart';
import 'package:seed_app/shared/models/emission_source_model.dart';

const _oneUse = UsagePreset(
  id: 'one',
  nameEn: '1 use',
  nameJa: '',
  nameEs: '',
  units: 1,
);

EnergyBehavior _behavior(
  String id,
  String group,
  EnergyCarrier carrier,
  double kwh, {
  List<EmissionSource> sources = const [],
}) => EnergyBehavior(
  id: id,
  comparableGroup: group,
  carrier: carrier,
  unit: EnergyUnit.use,
  kwhPerUnit: kwh,
  nameEn: id,
  nameJa: '',
  nameEs: '',
  presets: const [_oneUse],
  defaultPresetId: 'one',
  sources: sources,
);

final _behaviors = [
  // The ranked-table anchor: an LED hour is 1x (RESEARCH sec 7).
  _behavior('led_bulb', 'lighting', EnergyCarrier.electricity, 0.0085),
  _behavior('dryer', 'laundry_dry', EnergyCarrier.electricity, 4.5),
  _behavior('line_dry', 'laundry_dry', EnergyCarrier.none, 0),
  _behavior(
    'heater',
    'space_heat',
    EnergyCarrier.electricity,
    1.2,
    sources: const [
      EmissionSource(
        name: 'OCWR',
        url: 'https://example.gov/heaters',
        quote: '400-1,500 watts',
        accessed: '2026-08-02',
      ),
    ],
  ),
  _behavior('bath_gas', 'hot_water', EnergyCarrier.gas, 7.526854),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        energyBehaviorsProvider.overrideWith((_) async => _behaviors),
        energyCarrierFactorsProvider.overrideWith(
          (_) async => const CarrierFactors(grid: 458, gas: 182),
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
        home: EnergyMethodologyScreen(),
      ),
    );
  }

  /// The table on its own, for the option params the methodology
  /// screen leaves at their defaults.
  Widget buildTable(EnergyRankedTable table) => MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: table)),
  );

  group('EnergyMethodologyScreen', () {
    testWidgets('renders the prose, the ranked table and the sources', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Why one number for the whole world?'),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(find.text('Where your energy goes'), 300);
      expect(find.text('Where your energy goes'), findsOneWidget);
      // The data-derived source list carries the fixture's citation.
      await tester.scrollUntilVisible(find.textContaining('OCWR'), 300);
      expect(find.textContaining('OCWR'), findsOneWidget);
    });

    testWidgets('ranks every row as LED-hour multiples, in order', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // 4.5 / 0.0085 = 529x; 1.2 / 0.0085 = 141x; the anchor reads 1.0x.
      await tester.scrollUntilVisible(find.text('529x'), 300);
      expect(find.text('529x'), findsOneWidget);
      expect(find.text('141x'), findsOneWidget);
      expect(find.text('1.0x'), findsOneWidget);
      // Sorted by default-preset kWh, largest first.
      expect(
        tester.getTopLeft(find.text('dryer')).dy,
        lessThan(tester.getTopLeft(find.text('heater')).dy),
      );
      // line_dry ranks (carrier none) but gets no multiple: zero
      // energy has no ratio to state.
      expect(find.text('0x'), findsNothing);
    });

    testWidgets('a list without the anchor drops the multiples, not the page', (
      tester,
    ) async {
      // The widget is exported standalone, so a caller may hand it a
      // filtered list; firstWhere on the anchor took the whole page
      // down with a StateError.
      await tester.pumpWidget(
        buildTable(
          EnergyRankedTable(
            behaviors: _behaviors.where((b) => b.id != 'led_bulb').toList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Rows survive; only the multiples go.
      expect(find.text('dryer'), findsOneWidget);
      expect(find.text('529x'), findsNothing);
    });

    testWidgets('gas rows rank in the same list, on the same basis', (
      tester,
    ) async {
      // They used to sit in an unranked strip below everything (rule
      // 28). The list ranks ENERGY now, which is carrier-blind, and the
      // note carries what that leaves out (owner call 2026-09-02).
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // bath_gas is 7.526854 kWh, the largest row in the fixture, so it
      // ranks first -- above the 4.5 kWh dryer.
      await tester.scrollUntilVisible(find.text('bath_gas'), 300);
      expect(
        tester.getTopLeft(find.text('bath_gas')).dy,
        lessThan(tester.getTopLeft(find.text('dryer')).dy),
      );
      // 7.526854 / 0.0085 = 886x, stated like any other row.
      expect(find.text('886x'), findsOneWidget);
      // And the phenomenon is spelled out under the list.
      expect(
        find.textContaining('uses more energy than an electric one'),
        findsOneWidget,
      );
    });

    testWidgets('no gram figures in the rows at all', (tester) async {
      // One axis per list: grams are grid-dependent and would invert
      // the order they sit in. They live in the row's sheet instead.
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      for (final grams in ['2.1kg', '1.4kg', '0g', '550g']) {
        expect(find.text(grams), findsNothing, reason: '$grams in a row');
      }
    });
  });

  // The explore screen (E8) drives the same widget with bars, its own
  // anchor and no heading; the defaults above must keep the
  // methodology screen exactly as it shipped.
  group('EnergyRankedTable options', () {
    testWidgets('showBars draws a sqrt-scaled bar on ranked rows only', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTable(EnergyRankedTable(behaviors: _behaviors, showBars: true)),
      );
      await tester.pumpAndSettle();

      // Four ranked rows get a bar; the gas row never does (rule 28).
      final bars = tester
          .widgetList<FractionallySizedBox>(
            find.descendant(
              of: find.byType(EnergyRankedTable),
              matching: find.byType(FractionallySizedBox),
            ),
          )
          .toList();
      // Five rows, gas included: everything in one ranking.
      expect(bars, hasLength(5));
      // Ranked desc: bath_gas 7.53, dryer 4.5, heater 1.2, led_bulb
      // 0.0085, line_dry 0. Square root, not linear: the dryer is 0.77
      // of the track where a linear scale would give 0.60.
      expect(bars[0].widthFactor, 1);
      expect(bars[1].widthFactor, closeTo(0.773, 0.001));
      expect(bars[2].widthFactor, closeTo(0.399, 0.001));
      expect(bars[4].widthFactor, 0);
    });

    testWidgets('anchorId re-states every multiple against that row', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTable(
          EnergyRankedTable(behaviors: _behaviors, anchorId: 'heater'),
        ),
      );
      await tester.pumpAndSettle();

      // 4.5 / 1.2 = 3.8x against the heater, not 529x against the LED.
      expect(find.text('3.8x'), findsOneWidget);
      expect(find.text('529x'), findsNothing);
    });

    testWidgets('showHeading false drops the title and the LED intro', (
      tester,
    ) async {
      // The intro names the LED anchor, so it would be false on any
      // other baseline -- it must go with the title.
      await tester.pumpWidget(
        buildTable(
          EnergyRankedTable(
            behaviors: _behaviors,
            anchorId: 'heater',
            showHeading: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Where your energy goes'), findsNothing);
      expect(find.textContaining('an hour of LED light'), findsNothing);
      // The gas strip stays: it is not part of the heading.
    });

    testWidgets('onRowTap makes rows tappable and reports the behavior', (
      tester,
    ) async {
      final tapped = <String>[];
      await tester.pumpWidget(
        buildTable(
          EnergyRankedTable(
            behaviors: _behaviors,
            onRowTap: (behavior) => tapped.add(behavior.id),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('dryer'));
      await tester.pumpAndSettle();
      expect(tapped, ['dryer']);
    });
  });
}
