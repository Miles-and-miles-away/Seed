import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/utils/ja_phrase.dart';

const _ja = Locale('ja');
const _cap = 6;

String _wrap(String text, {int maxPhrase = _cap, bool phrases = true}) =>
    phraseWrap(text, locale: _ja, maxPhrase: maxPhrase, phrases: phrases);

/// Grapheme clusters of [wrapped] with each joiner shown as `|`.
String _marked(String wrapped) => wrapped.replaceAll(wordJoiner, '|');

final _latinOrDigit = RegExp('[A-Za-z0-9]');

void main() {
  group('BudouX parity (v0.9.3 ja model)', () {
    const expected = {
      '毎日いくつのエコアクションを達成したいですか？': ['毎日', 'いくつの', 'エコアクションを', '達成したいですか？'],
      'タップしてあなたの目標を設定しましょう': ['タップしてあなたの', '目標を', '設定しましょう'],
      '完了して今日のエコファクトを解除しよう！': ['完了して', '今日の', 'エコファクトを', '解除しよう！'],
      'お風呂の代わりにシャワー': ['お風呂の', '代わりに', 'シャワー'],
      '今日は近所の人や地域の活動を手伝おう': ['今日は', '近所の', '人や', '地域の', '活動を', '手伝', 'おう'],
      '{name}に切り替えますか？': ['{name}に', '切り', '替えますか？'],
    };
    for (final MapEntry(key: text, value: chunks) in expected.entries) {
      test(text, () => expect(budouxChunks(text), chunks));
    }
  });

  group('post-rule', () {
    test('a one or two kana fragment joins the phrase before it', () {
      expect(jaPhrases('今日は近所の人や地域の活動を手伝おう').last, '手伝おう');
    });

    test('never merges a fragment across a sentence mark', () {
      expect(jaPhrases('エラーが発生しました。もう一度お試しください。'), [
        'エラーが',
        '発生しました。',
        'もう',
        '一度',
        'お試しください。',
      ]);
    });

    test('an opener word stays with the phrase after it', () {
      expect(jaPhrases('CO2を10 kg節約してこのエントリーを'), [
        'CO2を',
        '10 kg節約して',
        'この',
        'エントリーを',
      ]);
      expect(_marked(_wrap('すると、その日に', maxPhrase: 12)), 'す|る|と|、そ|の|日|に');
    });

    test('a longer phrase-level split is kept', () {
      expect(jaPhrases('{name}に切り替えますか？'), ['{name}に', '切り', '替えますか？']);
    });
  });

  group('level 1 kinsoku joins', () {
    const noStart =
        '、。，．,.？！?!ー～〜…‥・：；:;）)］]｝}〕〉》」』】〙〗'
        'ぁぃぅぇぉっゃゅょゎゕゖァィゥェォッャュョヮヵヶ'
        'ㇰㇱㇲㇳㇴㇵㇶㇷㇸㇹㇺㇻㇼㇽㇾㇿ々ゝゞヽヾ%％'
        'ｧｨｩｪｫｬｭｮｯｰ｡､｣';
    const noEnd = '（(［[｛{〔〈《「『【〘〖｢';

    test('every no-line-start mark is joined to the grapheme before it', () {
      for (final mark in noStart.characters) {
        expect(
          _wrap('漢$mark', phrases: false),
          '漢$wordJoiner$mark',
          reason: mark,
        );
      }
    });

    test('every no-line-end mark is joined to the grapheme after it', () {
      for (final mark in noEnd.characters) {
        expect(
          _wrap('$mark漢', phrases: false),
          '$mark$wordJoiner漢',
          reason: mark,
        );
      }
    });

    test('never next to whitespace', () {
      for (final text in ['あ ー', 'あ\nー', '漢\u3000」', '「 漢', 'あ。 い']) {
        final wrapped = _wrap(text);
        expect(wrapped, isNot(contains(' $wordJoiner')), reason: text);
        expect(wrapped, isNot(contains('$wordJoiner ')), reason: text);
        expect(wrapped, isNot(contains('\n$wordJoiner')), reason: text);
        expect(wrapped, isNot(contains('\u3000$wordJoiner')), reason: text);
      }
    });
  });

  group('level 2 phrase joins', () {
    test('joins inside short phrases, not between them', () {
      expect(
        _marked(_wrap('今日は近所の人や地域の活動を手伝おう')),
        '今|日|は近|所|の人|や地|域|の活|動|を手|伝|お|う',
      );
    });

    test('a phrase longer than the cap is left breakable', () {
      final wrapped = _wrap('エコアクションを', maxPhrase: 4);
      expect(_marked(wrapped), 'エコアクシ|ョン|を');
    });

    test('never between two Latin letters or digits', () {
      for (final text in ['CO2を減らす', 'BIPVは建物', '1500kmの移動', 'Seedで記録']) {
        final clusters = _wrap(text).characters.toList();
        for (var i = 1; i + 1 < clusters.length; i++) {
          if (clusters[i] != wordJoiner) continue;
          final a = clusters[i - 1];
          final b = clusters[i + 1];
          expect(
            _latinOrDigit.hasMatch(a) && _latinOrDigit.hasMatch(b),
            isFalse,
            reason: '$text: $a|$b',
          );
        }
      }
    });

    test('the last two clusters of a paragraph stay together', () {
      expect(_marked(_wrap('発見しましょう\n次へ', maxPhrase: 4)), '発見しまし|ょ|う\n次|へ');
    });

    test('level 1 only when phrases is off', () {
      expect(
        _wrap('お風呂の代わりにシャワー', phrases: false),
        isNot(contains('呂$wordJoiner')),
      );
      expect(
        _wrap('お風呂の代わりにシャワー', phrases: false),
        contains(
          '$wordJoiner'
          'ャ',
        ),
      );
    });
  });

  group('run guard', () {
    /// Longest run holding a joiner; ASCII neighbours count as joined.
    int longestJoinedRun(String wrapped) {
      final latin = RegExp(r"^[A-Za-z0-9.,'%+/_-]$");
      var longest = 0;
      var run = 0;
      var hasJoiner = false;
      var joiner = false;
      String? previous;
      for (final c in wrapped.characters) {
        if (c == wordJoiner) {
          joiner = true;
          continue;
        }
        final latinPair =
            previous != null && latin.hasMatch(previous) && latin.hasMatch(c);
        if (joiner || latinPair) {
          run++;
          hasJoiner = hasJoiner || joiner;
        } else {
          run = 1;
          hasJoiner = false;
        }
        if (hasJoiner && run > longest) longest = run;
        joiner = false;
        previous = c;
      }
      return longest;
    }

    test('no joined run outgrows maxPhrase + 1 clusters', () {
      for (final text in [
        '（BIPV）は、建物に組み込む',
        '113g）の生産',
        '状態、-272〜150度Cと',
        'ください...',
        '達成したいですか？',
      ]) {
        for (final maxPhrase in [2, 3, 6]) {
          expect(
            longestJoinedRun(_wrap(text, maxPhrase: maxPhrase)),
            lessThanOrEqualTo(maxPhrase + 1),
            reason:
                '$text at $maxPhrase: ${_marked(_wrap(text, maxPhrase: maxPhrase))}',
          );
        }
      }
    });

    test('a short run keeps its joins', () {
      expect(_marked(_wrap('（BIPV）は')), '（|BIPV|）|は');
    });
  });

  group('locale and memo', () {
    test('other languages and text without kana or kanji are untouched', () {
      const text = 'Plain English. (Really)';
      expect(
        phraseWrap('お風呂の代わり', locale: const Locale('en'), maxPhrase: 6),
        'お風呂の代わり',
      );
      expect(
        phraseWrap('¿Qué?', locale: const Locale('es'), maxPhrase: 6),
        '¿Qué?',
      );
      expect(_wrap(text), text);
    });

    test('the memo keeps level 1 and level 2 results apart', () {
      const text = 'お風呂の代わりにシャワー';
      final level2 = _wrap(text);
      final level1 = _wrap(text, phrases: false);
      expect(level1, isNot(level2));
      expect(_wrap(text), level2);
      expect(_wrap(text, phrases: false), level1);
    });

    test('stripping the joiners gives the input back', () {
      const text = '今日は近所の人や地域の活動を手伝おう';
      expect(stripWordJoiners(_wrap(text)), text);
    });

    test('phraseCap leaves one cluster of headroom', () {
      expect(phraseCap(106, 14), 6);
      expect(phraseCap(192, 14), 12);
    });
  });

  group('dialog layout', () {
    const dialogWidth = 192.0;
    const fontSize = 14.0;

    List<String> lines(String text) {
      final wrapped = _wrap(text, maxPhrase: phraseCap(dialogWidth, fontSize));
      final painter = TextPainter(
        text: TextSpan(
          text: wrapped,
          style: const TextStyle(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: dialogWidth);
      final result = <String>[];
      var start = 0;
      while (start < wrapped.length) {
        final line = painter.getLineBoundary(TextPosition(offset: start));
        result.add(stripWordJoiners(wrapped.substring(line.start, line.end)));
        start = line.end;
      }
      painter.dispose();
      return result;
    }

    testWidgets('the generic error breaks after the first sentence', (
      tester,
    ) async {
      expect(lines('エラーが発生しました。もう一度お試しください。'), ['エラーが発生しました。', 'もう一度お試しください。']);
    });

    testWidgets('no line ends on an opener word', (tester) async {
      const text =
          '有効にすると、その日にサステナブルなアクションを記録していない場合の'
          'みリマインダーが表示されます。';
      for (final line in lines(text)) {
        expect(line.endsWith('その'), isFalse, reason: line);
      }
    });
  });

  group('grapheme clusters', () {
    const texts = [
      'ありがとう\u{1F331}です',
      '葛\u{E0100}飾区',
      '\u304B\u3099き',
      '家族\u{1F468}\u200D\u{1F469}\u200D\u{1F467}と',
    ];

    test('joiners only fall between clusters', () {
      for (final text in texts) {
        for (final phrases in [true, false]) {
          final wrapped = _wrap(text, phrases: phrases);
          final clusters = wrapped.characters
              .where((c) => c != wordJoiner)
              .toList();
          expect(clusters, text.characters.toList(), reason: text);
          expect(stripWordJoiners(wrapped), text);
        }
      }
    });

    testWidgets('each result lays out without throwing', (tester) async {
      for (final text in texts) {
        final painter = TextPainter(
          text: TextSpan(text: _wrap(text)),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: 40);
        expect(painter.width, greaterThan(0));
        painter.dispose();
      }
    });
  });
}
