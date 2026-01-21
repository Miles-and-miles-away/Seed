import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/presentation/widgets/rainbow_sun_painter.dart';

void main() {
  group('RainbowSunPainter', () {
    group('shouldRepaint', () {
      test('returns true when completionRatio changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1.0,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.7,
          completedSdgs: const [1, 2, 3],
          animationValue: 1.0,
        );

        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('returns true when completedSdgs changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1.0,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3, 4],
          animationValue: 1.0,
        );

        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('returns true when animationValue changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 0.5,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1.0,
        );

        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('returns false when nothing changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1.0,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1.0,
        );

        expect(newPainter.shouldRepaint(oldPainter), isFalse);
      });

      test('returns true when completedSdgs has different order', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1.0,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [3, 2, 1],
          animationValue: 1.0,
        );

        // Different order means different list, should repaint
        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });
    });

    group('paint', () {
      testWidgets('renders CustomPaint with RainbowSunPainter', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                size: const Size(300, 300),
                painter: RainbowSunPainter(
                  completionRatio: 0.5,
                  completedSdgs: const [1, 2, 3],
                  animationValue: 1.0,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CustomPaint), findsAtLeast(1));
      });

      testWidgets('renders with zero completion', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                size: const Size(300, 300),
                painter: RainbowSunPainter(
                  completionRatio: 0.0,
                  completedSdgs: const [],
                  animationValue: 1.0,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CustomPaint), findsAtLeast(1));
      });

      testWidgets('renders with full completion', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                size: const Size(300, 300),
                painter: RainbowSunPainter(
                  completionRatio: 1.0,
                  completedSdgs: const [
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17
                  ],
                  animationValue: 1.0,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CustomPaint), findsAtLeast(1));
      });

      testWidgets('renders with partial animation', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CustomPaint(
                size: const Size(300, 300),
                painter: RainbowSunPainter(
                  completionRatio: 0.5,
                  completedSdgs: const [1, 5, 10],
                  animationValue: 0.5,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(CustomPaint), findsAtLeast(1));
      });
    });
  });
}
