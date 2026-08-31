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

    testWidgets('ranks electricity rows as LED-hour multiples, in order', (
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
      // line_dry ranks (carrier none) but gets no multiple: 0g only.
      expect(find.text('0g'), findsOneWidget);
    });

    testWidgets('a list without the anchor drops the multiples, not the page', (
      tester,
    ) async {
      // The widget is exported standalone, so a caller may hand it a
      // filtered list; firstWhere on the anchor took the whole page
      // down with a StateError.
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: EnergyRankedTable(
                behaviors: _behaviors.where((b) => b.id != 'led_bulb').toList(),
                gridFactor: 458,
                gasFactor: 182,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // Rows and grams survive; only the multiples go.
      expect(find.text('dryer'), findsOneWidget);
      expect(find.text('2.1kg'), findsOneWidget);
      expect(find.text('529x'), findsNothing);
    });

    testWidgets('gas rows appear under the unranked heading, no multiple', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Gas appliances, unranked'),
        300,
      );
      expect(find.text('Gas appliances, unranked'), findsOneWidget);
      // bath_gas sits below the gas heading, priced at the gas factor:
      // 7.526854 kWh x 182 = 1.4kg -- and carries no "x" multiple.
      expect(
        tester.getTopLeft(find.text('bath_gas')).dy,
        greaterThan(
          tester.getTopLeft(find.text('Gas appliances, unranked')).dy,
        ),
      );
      expect(find.text('1.4kg'), findsOneWidget);
    });
  });
}
