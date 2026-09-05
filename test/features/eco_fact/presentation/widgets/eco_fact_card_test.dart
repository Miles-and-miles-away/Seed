import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/eco_fact_card.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

import '../../../../helpers/test_helpers.dart';

const _testFact = EcoFact(
  dayOfYear: 1,
  category: 'mythBuster',
  factEn: 'Test fact content',
  sourceEn: 'Test source',
  sourceUrl: 'https://example.com',
  relatedSdgs: [7, 13],
  unWorldDay: 'Earth Day',
);

const _minimalFact = EcoFact(
  dayOfYear: 2,
  category: 'positiveNews',
  factEn: 'Minimal fact',
  sourceEn: 'Minimal source',
);

void main() {
  late SdgGoalsData sdgData;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    sdgData = await loadSdgGoals();
  });

  Widget wrap(Widget child) => createTestWidget(
    overrides: [sdgGoalsDataProvider.overrideWith((ref) async => sdgData)],
    child: child,
  );

  group('EcoFactCard', () {
    testWidgets('shows fact text', (tester) async {
      await tester.pumpWidget(wrap(const EcoFactCard(fact: _testFact)));
      await tester.pumpAndSettle();

      expect(find.text('Test fact content'), findsOneWidget);
    });

    testWidgets('shows source', (tester) async {
      await tester.pumpWidget(wrap(const EcoFactCard(fact: _testFact)));
      await tester.pumpAndSettle();

      expect(find.textContaining('Test source'), findsOneWidget);
    });

    testWidgets('shows category chip', (tester) async {
      await tester.pumpWidget(wrap(const EcoFactCard(fact: _testFact)));
      await tester.pumpAndSettle();

      expect(find.text('Myth Buster'), findsOneWidget);
    });

    testWidgets('shows related SDG badges', (tester) async {
      await tester.pumpWidget(wrap(const EcoFactCard(fact: _testFact)));
      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
      expect(find.text('13'), findsOneWidget);
    });

    testWidgets('shows UN World Day badge', (tester) async {
      await tester.pumpWidget(wrap(const EcoFactCard(fact: _testFact)));
      await tester.pumpAndSettle();

      expect(find.text('Earth Day'), findsOneWidget);
    });

    testWidgets('hides UN World Day when null', (tester) async {
      await tester.pumpWidget(wrap(const EcoFactCard(fact: _minimalFact)));
      await tester.pumpAndSettle();

      expect(find.text('Earth Day'), findsNothing);
    });

    testWidgets('shows lock icon when locked', (tester) async {
      await tester.pumpWidget(
        wrap(const EcoFactCard(fact: _testFact, isLocked: true)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text('Test fact content'), findsNothing);
    });

    testWidgets('does not show lock icon when unlocked', (tester) async {
      await tester.pumpWidget(wrap(const EcoFactCard(fact: _testFact)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsNothing);
    });
  });
}
