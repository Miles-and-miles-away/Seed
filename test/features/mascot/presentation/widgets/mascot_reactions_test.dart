import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/presentation/widgets/points_animation_overlay.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';

void main() {
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
