import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

void main() {
  test('only a drawn path names a code-drawn stage', () {
    expect(drawnMascotStage(drawnMascotPath('coral', 3)), (
      speciesId: 'coral',
      stage: 3,
    ));
    expect(drawnMascotStage('drawn/seed/9')?.stage, 4);
    expect(drawnMascotStage('assets/images/mascot/seed_stage1.svg'), isNull);
    expect(drawnMascotStage('drawn/seed/two'), isNull);
  });

  testWidgets('a drawn path renders a static code-drawn mascot', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Center(
            child: SizedBox(
              width: 80,
              height: 60,
              child: MascotImage(assetPath: drawnMascotPath('fungi', 2)),
            ),
          ),
        ),
      ),
    );

    final drawn = tester.widget<DrawnMascot>(find.byType(DrawnMascot));
    expect((drawn.speciesId, drawn.stage, drawn.size), ('fungi', 2, 60));
    expect(drawn.animate, isFalse);
    expect(tester.binding.transientCallbackCount, 0);
    expect(find.byType(SvgPicture), findsNothing);
  });

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
  });

  testWidgets('a routine animates a drawn mascot that is not the hero', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: MascotImage(
            assetPath: drawnMascotPath('seed', 3),
            width: 100,
            height: 100,
            routine: dance,
          ),
        ),
      ),
    );

    final drawn = tester.widget<DrawnMascot>(find.byType(DrawnMascot));
    expect(drawn.animate, isTrue);
    expect(drawn.routine, same(dance));
    expect(tester.binding.transientCallbackCount, greaterThan(0));
  });
}
