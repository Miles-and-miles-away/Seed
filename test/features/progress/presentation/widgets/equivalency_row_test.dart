import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_card.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_row.dart';

import '../../../../helpers/test_helpers.dart';

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

Widget _wrap(Widget child, {Locale? locale}) => createTestWidget(
  scaffold: true,
  locale: locale,
  overrides: [
    impactEquivalenciesDataProvider.overrideWith((_) async => _fixture),
  ],
  child: child,
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

    double rowsOfCards(WidgetTester tester) => find
        .byType(EquivalencyCard)
        .evaluate()
        .map((e) => tester.getTopLeft(find.byWidget(e.widget)).dy)
        .toSet()
        .length
        .toDouble();

    testWidgets('lays out two by two on a phone', (tester) async {
      await tester.binding.setSurfaceSize(const Size(393, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_wrap(const EquivalencyRow(totalGrams: 21000)));
      await tester.pumpAndSettle();

      expect(rowsOfCards(tester), 2);
    });

    testWidgets('keeps four across on a wide layout', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_wrap(const EquivalencyRow(totalGrams: 21000)));
      await tester.pumpAndSettle();

      expect(rowsOfCards(tester), 1);
    });

    group('in Spanish with real Latin metrics', () {
      setUpAll(loadTestFonts);

      for (final width in testPhoneWidths) {
        testWidgets('no label is cut at ${width}pt', (tester) async {
          final emulated = width * robotoToSfWidthFactor;
          await tester.binding.setSurfaceSize(Size(emulated, 600));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            _wrap(
              const EquivalencyRow(totalGrams: 21000),
              locale: const Locale('es'),
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          final label = tester.renderObject<RenderParagraph>(
            find.text('hamburguesas de carne'),
          );
          expect(label.didExceedMaxLines, isFalse);
        });
      }
    });
  });
}
