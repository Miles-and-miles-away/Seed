import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

const _riveLoadTimeout = Duration(seconds: 30);
const _rivePollInterval = Duration(milliseconds: 25);

// Decoding the mascot file takes ~40ms on an idle machine but over 100ms
// once a full-suite run saturates the CPU, so poll for the load rather
// than sleeping a fixed span.
Future<Finder> _untilLoaded(WidgetTester tester) async {
  final riveWidget = find.byType(rive.RiveWidget);
  final deadline = DateTime.now().add(_riveLoadTimeout);
  while (!tester.any(riveWidget) && DateTime.now().isBefore(deadline)) {
    await Future<void>.delayed(_rivePollInterval);
    await tester.pump();
  }
  return riveWidget;
}

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

      final riveWidget = await _untilLoaded(tester);

      expect(riveWidget, findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });
  });

  testWidgets('reduce motion freezes a .riv mascot on its first frame', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: MascotImage(
              assetPath: 'assets/animations/coral_mascot.riv',
              artboardName: 'Coral_stage2',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );
      final riveWidget = await _untilLoaded(tester);

      expect(
        tester.widget<rive.RiveWidget>(riveWidget).controller.active,
        isFalse,
      );
    });
  });

  testWidgets('a reduce motion change reaches a loaded .riv mascot', (
    tester,
  ) async {
    Widget app({required bool reduce}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: const MascotImage(
          assetPath: 'assets/animations/coral_mascot.riv',
          artboardName: 'Coral_stage2',
          width: 100,
          height: 100,
        ),
      ),
    );
    await tester.runAsync(() async {
      for (final reduce in [false, true, false]) {
        await tester.pumpWidget(app(reduce: reduce));
        final riveWidget = await _untilLoaded(tester);
        expect(
          tester.widget<rive.RiveWidget>(riveWidget).controller.active,
          !reduce,
        );
      }
    });
  });
}
