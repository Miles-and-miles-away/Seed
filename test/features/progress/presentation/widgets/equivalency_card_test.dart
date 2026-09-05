import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_card.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('EquivalencyCard', () {
    testWidgets('renders trees with one decimal place', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.trees,
              value: 2.4,
            ),
          ),
        ),
      );

      expect(find.text('2.4'), findsOneWidget);
      expect(find.text('tree-years'), findsOneWidget);
    });

    testWidgets('renders sub-unit trees value', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.trees,
              value: 0.2,
            ),
          ),
        ),
      );

      expect(find.text('0.2'), findsOneWidget);
    });

    testWidgets('rounds whole-unit values and groups thousands', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.phoneCharges,
              value: 3125.7,
            ),
          ),
        ),
      );

      expect(find.text('3,126'), findsOneWidget);
      expect(find.text('phone charges'), findsOneWidget);
    });

    testWidgets('shows car-km equivalency with localized label', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.carKm,
              value: 105,
            ),
          ),
        ),
      );

      expect(find.text('105'), findsOneWidget);
      expect(find.text('km not driven'), findsOneWidget);
    });

    testWidgets('shows burgers equivalency with localized label', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.burgers,
              value: 7,
            ),
          ),
        ),
      );

      expect(find.text('7'), findsOneWidget);
      expect(find.text('beef burgers'), findsOneWidget);
    });

    testWidgets('floors sub-rounding tree values to "<0.1"', (tester) async {
      // 0.04 would format as "0.0" -- replace with the sentinel so
      // a real action never reads as zero impact.
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.trees,
              value: 0.04,
            ),
          ),
        ),
      );

      expect(find.text('<0.1'), findsOneWidget);
      expect(find.text('0.0'), findsNothing);
    });

    testWidgets('floors sub-rounding whole-unit values to "<1"', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const EquivalencyCard(
            equivalency: ImpactEquivalency(
              type: EquivalencyType.carKm,
              value: 0.4,
            ),
          ),
        ),
      );

      expect(find.text('<1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });
  });
}
