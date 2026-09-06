import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/widgets/level_progress_bar.dart';

import '../../helpers/test_helpers.dart';

/// Helper to wrap the progress bar in proper layout constraints.
Widget wrapProgressBar(LevelProgressBar progressBar) {
  return createTestWidget(
    scaffold: true,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(width: 300, child: progressBar),
      ),
    ),
  );
}

void main() {
  group('LevelProgressBar', () {
    testWidgets('displays current level label', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 0.5, currentLevel: 5)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Level 5'), findsOneWidget);
    });

    testWidgets('displays next level label', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 0.5, currentLevel: 5)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Level 6'), findsOneWidget);
    });

    testWidgets('hides labels when showLabel is false', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(
          const LevelProgressBar(
            progress: 0.5,
            currentLevel: 5,
            showLabel: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Level 5'), findsNothing);
      expect(find.text('Level 6'), findsNothing);
    });

    double fillOf(WidgetTester tester) => tester
        .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
        .widthFactor!;

    testWidgets('fills the track in proportion to progress', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(
          const LevelProgressBar(progress: 0.25, currentLevel: 1),
        ),
      );
      await tester.pumpAndSettle();

      expect(fillOf(tester), closeTo(0.25, 0.001));
    });

    testWidgets('an empty bar has no fill and a full bar is filled', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 0, currentLevel: 1)),
      );
      await tester.pumpAndSettle();
      expect(fillOf(tester), 0);

      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 1, currentLevel: 1)),
      );
      await tester.pumpAndSettle();
      expect(fillOf(tester), 1);
    });

    testWidgets('clamps progress outside the unit range', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 1.5, currentLevel: 1)),
      );
      await tester.pumpAndSettle();
      expect(fillOf(tester), 1);

      await tester.pumpWidget(
        wrapProgressBar(
          const LevelProgressBar(progress: -0.5, currentLevel: 1),
        ),
      );
      await tester.pumpAndSettle();
      expect(fillOf(tester), 0);
    });

    testWidgets('uses the given height for the track', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(
          const LevelProgressBar(progress: 0.5, currentLevel: 1, height: 20),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.getSize(find.byType(ClipRRect)).height, 20);
      expect(
        tester.widget<ClipRRect>(find.byType(ClipRRect)).borderRadius,
        BorderRadius.circular(10),
      );
    });

    testWidgets('defaults to a 12 pixel track', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 0.5, currentLevel: 1)),
      );
      await tester.pumpAndSettle();

      expect(tester.getSize(find.byType(ClipRRect)).height, 12);
    });
  });
}
