import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

import '../../helpers/test_helpers.dart';

const _text = 'お風呂の代わりにシャワー';
const _fontSize = 14.0;
const _style = TextStyle(fontSize: _fontSize);

Future<String> _rendered(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('ja'),
}) async {
  await tester.pumpWidget(
    createTestWidget(locale: locale, scaffold: true, child: child),
  );
  final rich = tester.widget<RichText>(find.byType(RichText).first);
  return rich.text.toPlainText(includeSemanticsLabels: false);
}

String _expected({required int maxPhrase, bool phrases = true}) => phraseWrap(
  _text,
  locale: const Locale('ja'),
  maxPhrase: maxPhrase,
  phrases: phrases,
);

void main() {
  testWidgets('wraps with the cap of the default line width', (tester) async {
    expect(
      await _rendered(tester, const PhraseText(_text, style: _style)),
      _expected(maxPhrase: phraseCap(defaultPhraseMinLineWidth, _fontSize)),
    );
  });

  testWidgets('leaves other languages as a plain Text', (tester) async {
    await _rendered(
      tester,
      const PhraseText(_text, style: _style),
      locale: const Locale('en'),
    );
    expect(tester.widget<Text>(find.byType(Text)).data, _text);
  });

  testWidgets('an explicit locale overrides the app locale', (tester) async {
    expect(
      await _rendered(
        tester,
        const PhraseText(_text, style: _style, locale: Locale('ja')),
        locale: const Locale('en'),
      ),
      contains(wordJoiner),
    );
  });

  testWidgets('maxLines gets the kinsoku joins only', (tester) async {
    final level1 = _expected(maxPhrase: 6, phrases: false);
    expect(level1, contains(wordJoiner));
    expect(
      await _rendered(
        tester,
        const PhraseText(_text, style: _style, maxLines: 2),
      ),
      level1,
    );
  });

  testWidgets('maxLines from DefaultTextStyle counts too', (tester) async {
    expect(
      await _rendered(
        tester,
        const DefaultTextStyle(
          style: _style,
          maxLines: 2,
          child: PhraseText(_text),
        ),
      ),
      _expected(maxPhrase: 6, phrases: false),
    );
  });

  testWidgets('the cap shrinks with the text scale', (tester) async {
    const scaler = TextScaler.linear(2);
    expect(
      await _rendered(
        tester,
        const PhraseText(_text, style: _style, textScaler: scaler),
      ),
      _expected(
        maxPhrase: phraseCap(
          defaultPhraseMinLineWidth,
          scaler.scale(_fontSize),
        ),
      ),
    );
  });

  testWidgets('the cap allows for letter spacing', (tester) async {
    const spacing = 10.0;
    expect(
      await _rendered(
        tester,
        const PhraseText(
          _text,
          style: TextStyle(fontSize: _fontSize, letterSpacing: spacing),
        ),
      ),
      _expected(
        maxPhrase: phraseCap(defaultPhraseMinLineWidth, _fontSize + spacing),
      ),
    );
  });

  testWidgets('markdown paragraphs render through PhraseText', (tester) async {
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('ja'),
        scaffold: true,
        child: MarkdownBlock(
          data: '$_text\n\n- [$_text](https://example.com)',
          generator: phraseMarkdownGenerator(bodyWidth: 272),
        ),
      ),
    );
    expect(find.byType(PhraseText), findsWidgets);
    final texts = tester
        .widgetList<RichText>(find.byType(RichText))
        .map((r) => r.text.toPlainText(includeSemanticsLabels: false));
    expect(texts.where((t) => t.contains(wordJoiner)), isNotEmpty);
    expect(find.text(_text, findRichText: true), findsWidgets);
  });

  test('the default line width is the action tile title width', () {
    expect(actionTileTitleWidth, defaultPhraseMinLineWidth);
  });

  group('maxLines titles keep their ending', () {
    const titleStyle = TextStyle(fontSize: _fontSize, letterSpacing: 0.1);
    const scaler = TextScaler.linear(1.3);

    for (final (title, width) in [
      ('マイクロローンに出資', actionTileTitleWidth),
      ('サステナビリティの知識を共有', 134.5),
    ]) {
      testWidgets(title, (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            locale: const Locale('ja'),
            scaffold: true,
            child: Center(
              child: SizedBox(
                width: width,
                child: PhraseText(
                  title,
                  style: titleStyle,
                  textScaler: scaler,
                  maxLines: 2,
                ),
              ),
            ),
          ),
        );
        final paragraph = tester.renderObject<RenderParagraph>(
          find.byType(RichText),
        );
        expect(paragraph.didExceedMaxLines, isFalse);
      });
    }
  });

  test('joiners already in a span are kept and the rest is wrapped', () {
    final figure = jaFigureWrap('1億3,200万', locale: const Locale('ja'));
    const bold = TextStyle(fontWeight: FontWeight.bold);
    final root = TextSpan(
      children: [
        const TextSpan(text: 'お風呂の代わりに'),
        TextSpan(text: figure, style: bold),
        const TextSpan(text: '人がシャワー'),
      ],
    );
    final mapped =
        wrapPhraseSpan(
              root,
              (text) =>
                  phraseWrap(text, locale: const Locale('ja'), maxPhrase: 6),
            )
            as TextSpan;

    expect((mapped.children![0] as TextSpan).text, contains(wordJoiner));
    expect((mapped.children![1] as TextSpan).text, figure);
    expect(
      mapped.toPlainText(),
      stripWordJoiners(root.toPlainText(includeSemanticsLabels: false)),
    );
  });

  test('joiners skip placeholders and keep span offsets', () {
    const bold = TextStyle(fontWeight: FontWeight.bold);
    final root = TextSpan(
      children: [
        const TextSpan(text: 'お風呂の'),
        const WidgetSpan(child: SizedBox.shrink()),
        const TextSpan(text: '代わりに', style: bold),
        const TextSpan(text: 'シャワー'),
      ],
    );
    final plain = root.toPlainText(includeSemanticsLabels: false);
    final expected = phraseWrap(
      plain,
      locale: const Locale('ja'),
      maxPhrase: 6,
    );
    final mapped =
        wrapPhraseSpan(
              root,
              (text) =>
                  phraseWrap(text, locale: const Locale('ja'), maxPhrase: 6),
            )
            as TextSpan;

    expect(mapped.toPlainText(includeSemanticsLabels: false), expected);
    expect(mapped.toPlainText(), plain);
    expect(mapped.children![1], isA<WidgetSpan>());
    expect((mapped.children![2] as TextSpan).style, bold);
    expect((mapped.children![2] as TextSpan).text, contains(wordJoiner));
  });
}
