import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_info_sheet.dart';

const _fixture = <EquivalencyMetadata>[
  EquivalencyMetadata(
    type: EquivalencyType.trees,
    gramsPerUnit: 21000,
    sourceName: 'US EPA — Greenhouse Gas Equivalencies Calculator',
    sourceUrl: 'https://www.epa.gov/example',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.carKm,
    gramsPerUnit: 200,
    sourceName: 'UK DEFRA — 2023 GHG Conversion Factors',
    sourceUrl: 'https://www.gov.uk/example',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.phoneCharges,
    gramsPerUnit: 8,
    sourceName: 'US EPA — Greenhouse Gas Equivalencies Calculator',
    sourceUrl: 'https://www.epa.gov/example',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.burgers,
    gramsPerUnit: 3000,
    sourceName: 'Our World in Data (after Poore & Nemecek 2018)',
    sourceUrl: 'https://ourworldindata.org/example',
  ),
];

Widget _wrap(Widget home) => ProviderScope(
  overrides: [
    impactEquivalenciesDataProvider.overrideWith((_) async => _fixture),
  ],
  child: MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  ),
);

void main() {
  group('EquivalencyInfoSheet', () {
    testWidgets('shows title, intro, all four explainers, and sources', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => EquivalencyInfoSheet.show(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('How we calculate this'), findsOneWidget);

      // All four equivalency labels render.
      expect(find.text('tree-years'), findsOneWidget);
      expect(find.text('km not driven'), findsOneWidget);
      expect(find.text('phone charges'), findsOneWidget);
      expect(find.text('beef burgers'), findsOneWidget);

      // Formula template renders factor from JSON, locale-formatted.
      expect(find.textContaining('g of CO2 / 21,000'), findsOneWidget);
      expect(find.textContaining('g of CO2 / 200'), findsOneWidget);
      expect(find.textContaining('g of CO2 / 8'), findsOneWidget);
      expect(find.textContaining('g of CO2 / 3,000'), findsOneWidget);

      // Source citations from JSON are present and labeled.
      expect(find.textContaining('US EPA'), findsWidgets);
      expect(find.textContaining('DEFRA'), findsOneWidget);
      expect(find.textContaining('Our World in Data'), findsOneWidget);
      expect(find.textContaining('Poore & Nemecek'), findsOneWidget);

      // Source tile uses the book icon to read unambiguously as a link.
      expect(find.byIcon(Icons.menu_book_outlined), findsNWidgets(4));
    });
  });
}
