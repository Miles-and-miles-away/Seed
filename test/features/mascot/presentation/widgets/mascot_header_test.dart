import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_header.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  for (final width in testPhoneWidths) {
    testWidgets('a 20-character Japanese name fits at ${width}pt', (
      tester,
    ) async {
      sizeViewport(tester, size: Size(width, 800));
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          locale: const Locale('ja'),
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: MascotHeader(
              name: 'ちいさなさんごのこどもたちのなかまたちです',
              stageName: 'サンゴしょう',
              mascotLevel: 12,
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });
  }

  testWidgets('every icon button is labelled', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      createTestWidget(
        scaffold: true,
        child: const MascotHeader(
          name: 'Reefy',
          stageName: 'Polyp',
          mascotLevel: 1,
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });
}
