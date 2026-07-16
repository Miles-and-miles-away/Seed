import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_card.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_row.dart';

const _fixture = <EquivalencyMetadata>[
  EquivalencyMetadata(
    type: EquivalencyType.trees,
    gramsPerUnit: 21000,
    sourceName: 'EPA',
    sourceUrl: 'https://example.org/epa',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.carKm,
    gramsPerUnit: 200,
    sourceName: 'DEFRA',
    sourceUrl: 'https://example.org/defra',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.phoneCharges,
    gramsPerUnit: 8,
    sourceName: 'EPA',
    sourceUrl: 'https://example.org/epa',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.burgers,
    gramsPerUnit: 3000,
    sourceName: 'OWID',
    sourceUrl: 'https://example.org/owid',
  ),
];

Widget _wrap(Widget child) => ProviderScope(
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
    home: Scaffold(body: child),
  ),
);

void main() {
  group('EquivalencyRow', () {
    testWidgets('renders four cards in fixed order', (tester) async {
      await tester.pumpWidget(_wrap(const EquivalencyRow(totalGrams: 21000)));
      await tester.pumpAndSettle();

      expect(find.byType(EquivalencyCard), findsNWidgets(4));
      expect(find.text('tree-years'), findsOneWidget);
      expect(find.text('beef burgers'), findsOneWidget);
    });

    testWidgets('fits all cards statically without scrolling', (tester) async {
      await tester.pumpWidget(_wrap(const EquivalencyRow(totalGrams: 21000)));
      await tester.pumpAndSettle();

      expect(find.byType(Scrollable), findsNothing);
      expect(find.byType(EquivalencyCard), findsNWidgets(4));
    });

    testWidgets('does not overflow on a narrow screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_wrap(const EquivalencyRow(totalGrams: 21000)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(EquivalencyCard), findsNWidgets(4));
    });

    testWidgets('renders even for very large totals without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const EquivalencyRow(totalGrams: 100000000)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(EquivalencyCard), findsNWidgets(4));
    });
  });
}
