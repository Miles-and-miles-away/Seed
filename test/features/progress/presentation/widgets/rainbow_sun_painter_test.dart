import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      RainbowSunPainter painter({
        double completion = 0,
        List<int> completed = const [],
        double animation = 1,
      }) => RainbowSunPainter(
        completionRatio: completion,
        completedSdgs: completed,
        animationValue: animation,
        sdgColors: _testColors,
      );

      /// A 300x300 canvas: max ball radius 75, minimum 15, centre (150, 150).
      Future<RenderCustomPaint> pump(
        WidgetTester tester,
        RainbowSunPainter p,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(painter: p),
              ),
            ),
          ),
        );
        return tester.renderObject<RenderCustomPaint>(
          find.byWidgetPredicate(
            (w) => w is CustomPaint && w.painter is RainbowSunPainter,
          ),
        );
      }

      int drawPathCalls(RenderCustomPaint canvas) {
        var paths = 0;
        expect(
          canvas,
          paints..everything((method, _) {
            if (method == #drawPath) paths++;
            return true;
          }),
        );
        return paths;
      }

      testWidgets('the ball rests at its minimum radius with no completion', (
        tester,
      ) async {
        final canvas = await pump(tester, painter());

        // Glow first (1.5x), then the ball itself.
        expect(
          canvas,
          paints
            ..circle(x: 150, y: 150, radius: 22.5)
            ..circle(x: 150, y: 150, radius: 15),
        );
      });

      testWidgets('the ball reaches its maximum radius when complete', (
        tester,
      ) async {
        final canvas = await pump(tester, painter(completion: 1));

        expect(
          canvas,
          paints
            ..circle(x: 150, y: 150, radius: 112.5)
            ..circle(x: 150, y: 150, radius: 75),
        );
      });

      testWidgets('growth follows the animation value', (tester) async {
        final canvas = await pump(
          tester,
          painter(completion: 1, animation: 0.5),
        );

        expect(
          canvas,
          paints
            ..circle(x: 150, y: 150, radius: 67.5)
            ..circle(x: 150, y: 150, radius: 45),
        );
      });

      testWidgets('draws 17 segments plus one ray per completed SDG', (
        tester,
      ) async {
        expect(drawPathCalls(await pump(tester, painter())), 17);
        expect(
          drawPathCalls(await pump(tester, painter(completed: [1, 5, 10]))),
          20,
        );
        expect(
          drawPathCalls(
            await pump(
              tester,
              painter(completed: List.generate(17, (i) => i + 1)),
            ),
          ),
          34,
        );
      });
    });
  });
}
