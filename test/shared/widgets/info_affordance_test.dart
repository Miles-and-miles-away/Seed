import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/shared/widgets/info_affordance.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

import '../../helpers/test_helpers.dart';

const _tooltip = 'How we calculate this';
const _term = 'Equivalent to';
const _longTerms = {
  'ja': '牛肉や羊肉の代わりに植物性の食事を選んで、今日の食事から温室効果ガスの排出を減らそう',
  'es':
      'Elige hoy una comida vegetal en lugar de ternera o cordero y reduce '
      'las emisiones de tu plato',
};

final _glyph = find.byIcon(Icons.info_outline);

Color? _glyphColor(WidgetTester tester) => tester
    .widget<RichText>(
      find.descendant(of: _glyph, matching: find.byType(RichText)),
    )
    .text
    .style
    ?.color;

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Brightness brightness = Brightness.light,
}) => tester.pumpWidget(
  createTestWidget(
    theme: appTheme(brightness),
    scaffold: true,
    child: Center(child: child),
  ),
);

void main() {
  group('InfoIconButton', () {
    for (final (brightness, colour) in [
      (Brightness.light, AppColors.infoLight),
      (Brightness.dark, AppColors.infoDark),
    ]) {
      testWidgets('draws the reserved glyph on ${brightness.name}', (
        tester,
      ) async {
        await _pump(
          tester,
          InfoIconButton(tooltip: _tooltip, onPressed: () {}),
          brightness: brightness,
        );

        expect(_glyph, findsOneWidget);
        expect(tester.getSize(_glyph), const Size.square(infoIconSize));
        expect(_glyphColor(tester), colour);
      });
    }

    testWidgets('is a named 48dp button', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, InfoIconButton(tooltip: _tooltip, onPressed: () {}));

      expect(
        tester.getSize(find.byType(InfoIconButton)),
        const Size.square(kMinInteractiveDimension),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      final node = tester.getSemantics(find.byType(InfoIconButton));
      expect(node.tooltip, _tooltip);
      expect(node.flagsCollection.isButton, isTrue);
      semantics.dispose();
    });

    testWidgets('one tap calls onPressed once', (tester) async {
      var taps = 0;
      await _pump(
        tester,
        InfoIconButton(tooltip: _tooltip, onPressed: () => taps++),
      );

      await tester.tap(find.byType(InfoIconButton));
      await tester.pump();

      expect(taps, 1);
    });
  });

  group('TermWithInfo', () {
    Widget termWithInfo(VoidCallback onPressed) => TermWithInfo(
      term: const Text(_term),
      tooltip: _tooltip,
      onPressed: onPressed,
    );

    testWidgets('the term and the glyph both open the explanation', (
      tester,
    ) async {
      var taps = 0;
      await _pump(tester, termWithInfo(() => taps++));

      await tester.tap(find.text(_term));
      await tester.pump();
      await tester.tap(_glyph);
      await tester.pump();

      expect(taps, 2);
    });

    testWidgets('a long-press shows the tooltip and does not open it', (
      tester,
    ) async {
      var taps = 0;
      await _pump(tester, termWithInfo(() => taps++));
      expect(find.text(_tooltip), findsNothing);

      await tester.longPress(find.text(_term));
      await tester.pump();

      expect(find.text(_tooltip), findsOneWidget);
      expect(taps, 0);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('keeps to the term and glyph in a stretched column', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      sizeViewport(tester, size: const Size(800, 600));
      var taps = 0;
      await tester.pumpWidget(
        createTestWidget(
          theme: appTheme(Brightness.light),
          scaffold: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [termWithInfo(() => taps++)],
          ),
        ),
      );

      final width =
          tester.getSize(find.text(_term)).width + spacingXs + infoIconSize;
      final target = tester.getRect(find.byType(InkWell));
      expect(target.width, moreOrLessEquals(width));
      expect(
        tester.getSemantics(find.text(_term)).rect.width,
        moreOrLessEquals(width),
      );

      await tester.tapAt(Offset(600, target.center.dy));
      await tester.pump();
      expect(taps, 0);
      semantics.dispose();
    });

    testWidgets('draws the glyph in the reserved colour', (tester) async {
      await _pump(tester, termWithInfo(() {}), brightness: Brightness.dark);

      expect(tester.getSize(_glyph), const Size.square(infoIconSize));
      expect(_glyphColor(tester), AppColors.infoDark);
    });

    testWidgets('is at least 48dp tall', (tester) async {
      await _pump(tester, termWithInfo(() {}));

      expect(
        tester.getSize(find.byType(TermWithInfo)).height,
        greaterThanOrEqualTo(kMinInteractiveDimension),
      );
    });

    testWidgets('is at least 48dp wide for a short term', (tester) async {
      await _pump(
        tester,
        TermWithInfo(
          term: const Text('a'),
          tooltip: _tooltip,
          onPressed: () {},
        ),
      );

      expect(
        tester.getSize(find.byType(InkWell)).width,
        kMinInteractiveDimension,
      );
    });

    testWidgets('announces the tooltip once, as the hint', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, termWithInfo(() {}));

      final node = tester.getSemantics(find.text(_term));
      expect(node.label, _term);
      expect(node.hint, _tooltip);
      expect(node.tooltip, isEmpty);
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      semantics.dispose();
    });

    group('long term at text scale 2', () {
      setUpAll(loadTestFonts);

      for (final language in _longTerms.keys) {
        for (final width in testPhoneWidths) {
          testWidgets('fits in $language at ${width}pt', (tester) async {
            final emulated = language == 'es'
                ? width * robotoToSfWidthFactor
                : width;
            sizeViewport(tester, size: Size(emulated, 900));
            tester.platformDispatcher.textScaleFactorTestValue = 2;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );

            await tester.pumpWidget(
              createTestWidget(
                locale: Locale(language),
                // Roboto has no kana, so Japanese keeps the test font.
                theme: language == 'ja'
                    ? ThemeData(fontFamily: 'FlutterTest')
                    : null,
                scaffold: true,
                child: Padding(
                  padding: const EdgeInsets.all(spacingLg),
                  child: Center(
                    child: TermWithInfo(
                      term: PhraseText(
                        _longTerms[language]!,
                        locale: Locale(language),
                        textAlign: TextAlign.center,
                      ),
                      tooltip: _tooltip,
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            );

            expect(tester.takeException(), isNull);
            expect(
              tester.getRect(_glyph).right,
              lessThanOrEqualTo(emulated - spacingLg),
            );
          });
        }
      }
    });
  });
}
