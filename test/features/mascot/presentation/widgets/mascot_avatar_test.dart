import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

void main() {
  Future<void> pumpAvatar(
    WidgetTester tester,
    String assetPath, {
    required bool animate,
  }) => tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: MascotAvatar(assetPath: assetPath, size: 60, animate: animate),
      ),
    ),
  );

  testWidgets('a drawn avatar paints one static frame', (tester) async {
    await pumpAvatar(tester, drawnMascotPath('coral', 2), animate: true);

    expect(tester.widget<DrawnMascot>(find.byType(DrawnMascot)).animate, false);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('an SVG avatar floats only when it animates', (tester) async {
    const svg = 'assets/images/mascot/seed_stage1.svg';
    await pumpAvatar(tester, svg, animate: false);
    expect(tester.binding.transientCallbackCount, 0);

    await pumpAvatar(tester, svg, animate: true);
    await tester.pump(const Duration(milliseconds: 1));
    expect(tester.binding.transientCallbackCount, greaterThan(0));
  });
}
