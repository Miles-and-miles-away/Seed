import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/shared/widgets/no_word_break.dart';

import '../../helpers/test_helpers.dart';

const _style = TextStyle(fontSize: 20, letterSpacing: 0.15);

Future<void> _pump(WidgetTester tester, double width, String text) =>
    tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: NoWordBreak(
                child: Text(text, textAlign: TextAlign.center, style: _style),
              ),
            ),
          ),
        ),
      ),
    );

/// The widest word of [text] as the app styles it, unrounded.
Future<double> _wordWidth(WidgetTester tester, String text) async {
  await _pump(tester, 1000, text);
  return tester
      .renderObject<RenderParagraph>(find.byType(RichText))
      .getMinIntrinsicWidth(double.infinity);
}

double _scale(WidgetTester tester) {
  final box = tester.renderObject<RenderFittedBox>(find.byType(FittedBox));
  return box.size.width / box.child!.size.width;
}

void main() {
  setUpAll(loadTestFonts);

  testWidgets('a word wider than the box shrinks the text, unbroken', (
    tester,
  ) async {
    const text = 'Air conditioner, heating';
    final word = await _wordWidth(tester, text);
    final box = (word * 0.7).roundToDouble();
    await _pump(tester, box, text);

    final lines = renderedLines(tester, find.text(text));
    expect(breaksInsideWords(lines, 'en'), isEmpty, reason: '$lines');
    // As far as the word needs and no further: rounded up, it is laid
    // out a pixel wide at most.
    expect(_scale(tester), closeTo(box / word.ceilToDouble(), 0.001));
    expect(_scale(tester), lessThan(1));
  });

  testWidgets('a word laid out at exactly its own width cannot break', (
    tester,
  ) async {
    // Each width just under the word: at the unrounded width the last
    // letter could wrap.
    const text = 'conditioner';
    final word = await _wordWidth(tester, text);
    for (final box in [word - 0.6, word - 0.2, word - 0.01]) {
      await _pump(tester, box, text);
      expect(renderedLines(tester, find.text(text)), [text], reason: '$box');
    }
  });

  testWidgets('text whose words fit keeps the box width and its size', (
    tester,
  ) async {
    const text = 'conditioner';
    final word = await _wordWidth(tester, text);
    // A fractional box just wider than the word: rounding the word up
    // here would lay it out wider than the box and shrink it a little.
    final box = word.floorToDouble() + 0.9;
    expect(box, greaterThan(word));
    await _pump(tester, box, text);

    expect(_scale(tester), 1);
    final paragraph = tester.renderObject<RenderParagraph>(
      find.byType(RichText),
    );
    expect(paragraph.size.width, box);
  });

  testWidgets('wraps between words when they fit the line', (tester) async {
    const text = 'Air conditioner, heating';
    final word = await _wordWidth(tester, text);
    await _pump(tester, word + 10, text);

    final lines = renderedLines(tester, find.text(text));
    expect(lines.length, greaterThan(1));
    expect(breaksInsideWords(lines, 'en'), isEmpty);
    expect(_scale(tester), 1);
  });
}
