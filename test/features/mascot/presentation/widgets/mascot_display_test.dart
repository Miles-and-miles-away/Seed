import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';

Widget _wrap(Widget child, {String? assetPath}) => ProviderScope(
      overrides: [
        mascotAssetPathProvider.overrideWith((_) => assetPath),
      ],
      child: MaterialApp(home: Scaffold(body: Center(child: child))),
    );

void main() {
  group('MascotAnimationController', () {
    test('triggerBounce flips state briefly, then resets', () async {
      final controller = MascotAnimationController();
      addTearDown(controller.dispose);

      expect(controller.shouldBounce, isFalse);
      controller.triggerBounce();
      expect(controller.shouldBounce, isTrue);

      // After the reset delay, the flag should drop.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      expect(controller.shouldBounce, isFalse);
    });

    test('listeners fire on both set and reset', () async {
      final controller = MascotAnimationController();
      addTearDown(controller.dispose);
      var notifications = 0;
      controller
        ..addListener(() => notifications++)
        ..triggerBounce();
      await Future<void>.delayed(const Duration(milliseconds: 600));

      expect(notifications, 2);
    });
  });

  group('MascotDisplay', () {
    testWidgets('shows a loading spinner while asset path is null', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const MascotDisplay(size: 100)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
