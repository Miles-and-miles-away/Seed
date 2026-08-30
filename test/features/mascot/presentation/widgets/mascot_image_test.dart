import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

const _riveLoadTimeout = Duration(seconds: 30);
const _rivePollInterval = Duration(milliseconds: 25);

void main() {
  testWidgets('renders SVG assets with SvgPicture', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MascotImage(
          assetPath: 'assets/images/mascot/seed_stage1.svg',
          width: 100,
          height: 100,
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(rive.RiveWidget), findsNothing);
  });

  testWidgets('loads and renders .riv assets with RiveWidget', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MascotImage(
            assetPath: 'assets/animations/coral_mascot.riv',
            artboardName: 'Coral_stage2',
            width: 100,
            height: 100,
          ),
        ),
      );

      // Decoding the 6 MB mascot file takes ~40ms on an idle machine but
      // over 100ms once a full-suite run saturates the CPU, so poll for the
      // load rather than sleeping a fixed span.
      final riveWidget = find.byType(rive.RiveWidget);
      final deadline = DateTime.now().add(_riveLoadTimeout);
      while (!tester.any(riveWidget) && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(_rivePollInterval);
        await tester.pump();
      }

      expect(riveWidget, findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });
  });
}
