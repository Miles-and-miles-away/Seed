import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/presentation/widgets/rainbow_sun_painter.dart';

/// Test colors for 17 SDGs
const _testColors = <Color>[
  Color(0xFFE5233D),
  Color(0xFFDDA73A),
  Color(0xFF4CA146),
  Color(0xFFC5192D),
  Color(0xFFEF402C),
  Color(0xFF27BFE6),
  Color(0xFFFBC412),
  Color(0xFFA31C44),
  Color(0xFFF26A2D),
  Color(0xFFE01483),
  Color(0xFFF89D2A),
  Color(0xFFBF8D2C),
  Color(0xFF407F46),
  Color(0xFF1F97D4),
  Color(0xFF59BA48),
  Color(0xFF126A9F),
  Color(0xFF13496B),
];

void main() {
  group('RainbowSunPainter', () {
    group('shouldRepaint', () {
      test('returns true when completionRatio changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1,
          sdgColors: _testColors,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.7,
          completedSdgs: const [1, 2, 3],
          animationValue: 1,
          sdgColors: _testColors,
        );

        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('returns true when completedSdgs changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1,
          sdgColors: _testColors,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3, 4],
          animationValue: 1,
          sdgColors: _testColors,
        );

        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('returns true when animationValue changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 0.5,
          sdgColors: _testColors,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1,
          sdgColors: _testColors,
        );

        expect(newPainter.shouldRepaint(oldPainter), isTrue);
      });

      test('returns false when nothing changes', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1,
          sdgColors: _testColors,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1,
          sdgColors: _testColors,
        );

        expect(newPainter.shouldRepaint(oldPainter), isFalse);
      });

      test('returns true when completedSdgs has different order', () {
        final oldPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [1, 2, 3],
          animationValue: 1,
          sdgColors: _testColors,
        );

        final newPainter = RainbowSunPainter(
          completionRatio: 0.5,
          completedSdgs: const [3, 2, 1],
          animationValue: 1,
          sdgColors: _testColors,
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
                  animationValue: 1,
                  sdgColors: _testColors,
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
                  completionRatio: 0,
                  completedSdgs: const [],
                  animationValue: 1,
                  sdgColors: _testColors,
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
                  completionRatio: 1,
                  completedSdgs: const [
                    1,
                    2,
                    3,
                    4,
                    5,
                    6,
                    7,
                    8,
                    9,
                    10,
                    11,
                    12,
                    13,
                    14,
                    15,
                    16,
                    17,
                  ],
                  animationValue: 1,
                  sdgColors: _testColors,
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
                  sdgColors: _testColors,
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
