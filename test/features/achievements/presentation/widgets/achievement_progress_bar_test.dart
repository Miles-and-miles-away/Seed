import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_progress_bar.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );

void main() {
  group('AchievementProgressBar', () {
    testWidgets('renders bar + current/target label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementProgressBar(
            progress: AchievementProgress(
              current: 3,
              target: 7,
              hasProgress: true,
            ),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('3 / 7'), findsOneWidget);
    });

    testWidgets('renders nothing for binary criteria', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementProgressBar(
            progress: AchievementProgress.binary(),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsNothing);
      expect(find.textContaining('/'), findsNothing);
    });
  });
}
