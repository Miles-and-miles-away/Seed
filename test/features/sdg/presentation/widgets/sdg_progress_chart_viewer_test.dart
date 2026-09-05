import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_progress_chart_viewer.dart';

import '../../../../helpers/test_helpers.dart';

SdgGoal _goal(int number) => SdgGoal(
  number: number,
  titleEn: 'Goal $number',
  shortTitleEn: 'Short $number',
  descriptionEn: 'Description $number',
  color: const Color(0xFFE5233D),
  iconUrl: 'https://example.com/icon$number.jpg',
);

void main() {
  group('progressChartAsset', () {
    test('zero-pads the goal number for all 17 goals', () {
      for (var n = 1; n <= 17; n++) {
        expect(
          _goal(n).progressChartAsset,
          'assets/images/sdg_progress/sdg_progress_'
          '${n.toString().padLeft(2, '0')}.png',
        );
      }
    });

    test('every goal resolves to a file that exists on disk', () {
      for (var n = 1; n <= 17; n++) {
        expect(
          File(_goal(n).progressChartAsset).existsSync(),
          isTrue,
          reason: 'missing asset for goal $n',
        );
      }
    });

    test('all 17 cards share one canvas size', () {
      // The widget reserves space from a single aspect ratio, so a
      // re-export at a different size would silently letterbox.
      final sizes = <String>{};
      for (var n = 1; n <= 17; n++) {
        final bytes = File(_goal(n).progressChartAsset).readAsBytesSync();
        // PNG IHDR: width and height are big-endian uint32 at offset 16.
        final w = bytes.buffer.asByteData().getUint32(16);
        final h = bytes.buffer.asByteData().getUint32(20);
        sizes.add('${w}x$h');
      }
      expect(sizes, {'984x1296'});
    });
  });

  testWidgets('renders the chart unclipped at its natural aspect ratio', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        scaffold: true,
        child: SingleChildScrollView(
          child: SdgProgressChartViewer(goal: _goal(1)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final image = tester.widget<Image>(find.byType(Image));
    // BoxFit.cover would crop the card header and source line, which carry
    // the indicator code and custodian agency.
    expect(image.fit, BoxFit.contain);
    expect((image.image as AssetImage).assetName, contains('sdg_progress_01'));

    // Space is reserved before the image decodes, so the page does not
    // reflow underneath the reader.
    final box = tester.getSize(find.byType(AspectRatio));
    expect(box.width / box.height, closeTo(984 / 1296, 0.001));
  });
}
