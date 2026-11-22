import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/presentation/widgets/points_animation_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';

import '../../helpers/test_helpers.dart';

Widget _reduced(Widget child) => createTestWidget(
  scaffold: true,
  child: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: child,
    ),
  ),
);

void main() {
  testWidgets('confetti is skipped under reduce motion', (tester) async {
    await tester.pumpWidget(_reduced(const TimedConfettiLayer()));
    expect(
      find.descendant(
        of: find.byType(TimedConfettiLayer),
        matching: find.byType(CustomPaint),
      ),
      findsNothing,
    );
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('a confetti loop schedules no frames under reduce motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _reduced(
        ConfettiLayer(
          painter: (progress) => ConfettiPainter(
            particles: const [],
            colors: celebrationConfettiColors,
            progress: progress,
          ),
        ),
      ),
    );
    // A running loop keeps scheduling frames, so settling would time out.
    await tester.pumpAndSettle();
  });

  testWidgets('the points pill keeps its full time under reduce motion', (
    tester,
  ) async {
    var dismissed = false;
    await tester.pumpWidget(
      _reduced(
        Stack(
          children: [
            PointsAnimationOverlay(
              points: 12,
              onDismiss: () => dismissed = true,
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));
    expect(dismissed, isFalse);
    await tester.pumpAndSettle();
    expect(dismissed, isTrue);
  });
}
