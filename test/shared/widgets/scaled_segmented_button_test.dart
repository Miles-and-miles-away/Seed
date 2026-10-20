import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/shared/widgets/scaled_segmented_button.dart';

import '../../helpers/test_helpers.dart';

void main() {
  Widget wrap(Widget child, {Locale locale = const Locale('en')}) =>
      createTestWidget(
        theme: appTheme(Brightness.light),
        locale: locale,
        scaffold: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      );

  ScaledSegmentedButton<int> control(List<String> labels) =>
      ScaledSegmentedButton<int>(
        segments: [for (var i = 0; i < labels.length; i++) (i, labels[i])],
        selected: 0,
        onSelected: (_) {},
      );

  /// The label laid out at its full width: nothing clipped or wrapped.
  void expectWhole(WidgetTester tester, String label) {
    final paragraph = tester.renderObject<RenderParagraph>(find.text(label));
    expect(paragraph.didExceedMaxLines, isFalse, reason: label);
    expect(
      paragraph.size.width,
      greaterThanOrEqualTo(paragraph.getMaxIntrinsicWidth(double.infinity)),
      reason: label,
    );
  }

  double labelScale(WidgetTester tester, String label) =>
      tester.widget<Text>(find.text(label)).textScaler!.scale(14) / 14;

  const japanese = ['カレンダー', 'インパクト', 'エコ図鑑'];

  for (final width in testPhoneWidths) {
    testWidgets('Japanese Progress labels fit unscaled at ${width}pt', (
      tester,
    ) async {
      sizeViewport(tester, size: Size(width, 800));
      await tester.pumpWidget(
        wrap(control(japanese), locale: const Locale('ja')),
      );

      expect(tester.takeException(), isNull);
      for (final label in japanese) {
        expectWhole(tester, label);
        expect(labelScale(tester, label), 1.0);
      }
    });
  }

  for (final width in testPhoneWidths) {
    testWidgets('Japanese labels share one scale at text scale 1.3 at '
        '${width}pt', (tester) async {
      sizeViewport(tester, size: Size(width, 800));
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        wrap(control(japanese), locale: const Locale('ja')),
      );

      expect(tester.takeException(), isNull);
      final scales = japanese.map((l) => labelScale(tester, l)).toSet();
      expect(scales, hasLength(1));
      final heights = japanese
          .map((l) => tester.getRect(find.text(l)).height)
          .toSet();
      expect(heights, hasLength(1));
      for (final label in japanese) {
        expectWhole(tester, label);
      }
    });
  }

  testWidgets('one long label shrinks every label by the same factor', (
    tester,
  ) async {
    sizeViewport(tester, size: const Size(320, 800));
    const labels = ['Hoy', 'A considerably longer label', 'Mes'];
    await tester.pumpWidget(wrap(control(labels)));

    final scales = labels.map((l) => labelScale(tester, l)).toSet();
    expect(scales, hasLength(1));
    expect(scales.single, lessThan(1));
    final heights = labels
        .map((l) => tester.getSize(find.text(l)).height)
        .toSet();
    expect(heights, hasLength(1));
    for (final label in labels) {
      expectWhole(tester, label);
    }
  });

  testWidgets('lays out under intrinsic sizing without asserting', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        theme: appTheme(Brightness.light),
        child: Builder(
          builder: (context) => Center(
            child: IntrinsicWidth(child: control(const ['One', 'Two'])),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    const labels = ['One', 'Two', 'Three'];
    await tester.pumpWidget(
      createTestWidget(
        theme: appTheme(Brightness.light),
        child: AlertDialog(content: control(labels)),
      ),
    );
    expect(tester.takeException(), isNull);
    for (final label in labels) {
      expectWhole(tester, label);
    }
  });

  group('with real Latin metrics', () {
    setUpAll(loadTestFonts);

    const spanish = ['Calendario', 'Impacto', 'Eco-Dex'];
    const periods = ['Hoy', 'Semana', 'Mes', 'Total'];

    for (final width in testPhoneWidths) {
      final emulated = width * robotoToSfWidthFactor;
      testWidgets('Spanish labels stay whole at ${width}pt', (tester) async {
        sizeViewport(tester, size: Size(emulated, 800));
        await tester.pumpWidget(
          wrap(control(spanish), locale: const Locale('es')),
        );
        expect(tester.takeException(), isNull);
        for (final label in spanish) {
          expectWhole(tester, label);
        }

        await tester.pumpWidget(
          wrap(control(periods), locale: const Locale('es')),
        );
        final scales = periods.map((l) => labelScale(tester, l)).toSet();
        expect(scales, hasLength(1));
        // Only the 320pt stress width may shrink the four, and only a little.
        expect(scales.single, width > 320 ? 1.0 : greaterThan(0.85));
        for (final label in periods) {
          expectWhole(tester, label);
        }
      });
    }
  });
}
