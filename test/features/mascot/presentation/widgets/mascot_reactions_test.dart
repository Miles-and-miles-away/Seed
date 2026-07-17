import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/presentation/widgets/points_animation_overlay.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

void main() {
  group('MascotSmileTrigger', () {
    test('triggerSmile sets state true, then resets to false', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(mascotSmileTriggerProvider, (_, _) {});

      expect(container.read(mascotSmileTriggerProvider), isFalse);

      container.read(mascotSmileTriggerProvider.notifier).triggerSmile();
      expect(container.read(mascotSmileTriggerProvider), isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(container.read(mascotSmileTriggerProvider), isFalse);
    });
  });

  group('mascotGazeTarget', () {
    const screen = Size(400, 800);
    const center = Offset(200, 400);

    test('pointer at mascot centre gives no deflection', () {
      expect(mascotGazeTarget(center, center, screen), Offset.zero);
    });

    test('screen corners give full deflection', () {
      expect(
        mascotGazeTarget(Offset.zero, center, screen),
        const Offset(-mascotLookRange, -mascotLookRange),
      );
      expect(
        mascotGazeTarget(const Offset(400, 800), center, screen),
        const Offset(mascotLookRange, mascotLookRange),
      );
    });

    test('deflection scales linearly between centre and edge', () {
      expect(
        mascotGazeTarget(const Offset(300, 400), center, screen),
        const Offset(mascotLookRange / 2, 0),
      );
    });

    test('clamps when the mascot is off-centre and pointer is far', () {
      const offCentre = Offset(50, 50);
      final gaze = mascotGazeTarget(const Offset(400, 800), offCentre, screen);
      expect(gaze, const Offset(mascotLookRange, mascotLookRange));
    });

    test('zero screen size is a safe no-op', () {
      expect(mascotGazeTarget(center, center, Size.zero), Offset.zero);
    });
  });

  group('MascotAnimationTrigger', () {
    test('triggerBounce sets state true, then resets to false', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Keep the provider alive across the reset delay (a bare read would let
      // it auto-dispose before the delayed reset callback runs).
      container.listen(mascotAnimationTriggerProvider, (_, _) {});

      expect(container.read(mascotAnimationTriggerProvider), isFalse);

      container.read(mascotAnimationTriggerProvider.notifier).triggerBounce();
      expect(container.read(mascotAnimationTriggerProvider), isTrue);

      // The notifier resets after durationInstant (100ms).
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(container.read(mascotAnimationTriggerProvider), isFalse);
    });
  });

  group('PointsAnimationOverlay', () {
    testWidgets('renders the points value and fires onDismiss', (tester) async {
      var dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            // Positioned.fill inside the overlay needs a Stack ancestor.
            body: Stack(
              children: [
                PointsAnimationOverlay(
                  points: 25,
                  onDismiss: () => dismissed = true,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // The overlay renders the value as "<points> points".
      expect(find.text('25 points'), findsOneWidget);
      expect(dismissed, isFalse);

      // The animation runs for durationShowcase (1500ms); after it completes
      // onDismiss fires.
      await tester.pump(const Duration(milliseconds: 1600));
      expect(dismissed, isTrue);
    });
  });
}
