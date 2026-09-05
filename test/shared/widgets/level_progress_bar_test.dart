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

    testWidgets('renders progress bar container', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 0.5, currentLevel: 1)),
      );
      await tester.pumpAndSettle();

      // Should find ClipRRect for rounded corners
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('uses custom height', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(
          const LevelProgressBar(progress: 0.5, currentLevel: 1, height: 20),
        ),
      );
      await tester.pumpAndSettle();

      // Widget should render without errors
      expect(find.byType(LevelProgressBar), findsOneWidget);
    });

    testWidgets('handles zero progress', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 0, currentLevel: 1)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LevelProgressBar), findsOneWidget);
    });

    testWidgets('handles full progress', (tester) async {
      await tester.pumpWidget(
        wrapProgressBar(const LevelProgressBar(progress: 1, currentLevel: 1)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LevelProgressBar), findsOneWidget);
    });
  });
}
