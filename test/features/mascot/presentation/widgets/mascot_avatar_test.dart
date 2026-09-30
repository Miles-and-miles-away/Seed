import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';

const _riveLoadTimeout = Duration(seconds: 30);
const _rivePollInterval = Duration(milliseconds: 25);

void main() {
  Future<rive.RiveWidgetController> pumpAvatar(
    WidgetTester tester, {
    required bool animate,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MascotAvatar(
          assetPath: 'assets/animations/coral_mascot.riv',
          artboardName: 'Coral_stage2',
          size: 60,
          animate: animate,
        ),
      ),
    );
    // Decoding the mascot file runs on the real event loop; poll for it.
    final riveWidget = find.byType(rive.RiveWidget);
    final deadline = DateTime.now().add(_riveLoadTimeout);
    while (!tester.any(riveWidget) && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(_rivePollInterval);
      await tester.pump();
    }
    await tester.pump();
    return tester.widget<rive.RiveWidget>(riveWidget).controller;
  }

  testWidgets('animate: false freezes the Rive controller', (tester) async {
    await tester.runAsync(() async {
      final controller = await pumpAvatar(tester, animate: false);
      expect(controller.active, isFalse);
    });
  });

  testWidgets('animate: true leaves the Rive controller running', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final controller = await pumpAvatar(tester, animate: true);
      expect(controller.active, isTrue);
    });
  });
}
