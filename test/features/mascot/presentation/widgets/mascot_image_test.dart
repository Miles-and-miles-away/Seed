import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

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
            artboardName: 'Coral_Stage2',
            width: 100,
            height: 100,
          ),
        ),
      );

      // Let the async file load complete, then rebuild.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await tester.pump();

      expect(find.byType(rive.RiveWidget), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });
  });
}
