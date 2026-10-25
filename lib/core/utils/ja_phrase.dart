// Phrase segmentation modified from BudouX v0.9.3 budoux/parser.py
// (Copyright 2021 Google LLC, Apache License 2.0; see
// assets/licences/budoux.txt): ported to Dart over grapheme clusters,
// with a post-rule for kana fragments and word-joiner insertion added.

import 'package:flutter/widgets.dart';

import 'ja_phrase_model.g.dart';

/// U+2060 WORD JOINER: zero width, and the line breaker never breaks
/// on either side of it while the joined run fits on a line.
const wordJoiner = '\u2060';

/// The narrowest multi-line Japanese text box at a 320pt phone width:
/// an action tile title (`actionTileTitleWidth`).
const defaultPhraseMinLineWidth = 98.0;

const _placeholder = '\uFFFC';
const _memoCapacity = 512;

const _noLineStart = {
  '、', '。', '，', '．', ',', '.', '？', '！', '?', '!', //
  'ー', '～', '〜', '…', '‥', '・', '：', '；', ':', ';',
  '）', ')', '］', ']', '｝', '}', '〕', '〉', '》', '」', '』', '】', '〙', '〗',
  'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'っ', 'ゃ', 'ゅ', 'ょ', 'ゎ', 'ゕ', 'ゖ',
  'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', 'ッ', 'ャ', 'ュ', 'ョ', 'ヮ', 'ヵ', 'ヶ',
  'ㇰ', 'ㇱ', 'ㇲ', 'ㇳ', 'ㇴ', 'ㇵ', 'ㇶ', 'ㇷ', 'ㇸ', 'ㇹ', 'ㇺ', 'ㇻ', 'ㇼ',
  'ㇽ', 'ㇾ', 'ㇿ', '々', 'ゝ', 'ゞ', 'ヽ', 'ヾ', '%', '％',
  'ｧ', 'ｨ', 'ｩ', 'ｪ', 'ｫ', 'ｬ', 'ｭ', 'ｮ', 'ｯ', 'ｰ', '｡', '､', '｣',
};

const _noLineEnd = {
  '（', '(', '［', '[', '｛', '{', '〔', '〈', '《', '「', '『', '【', '〘', '〖', //
  '｢',
};

/// Marks after which a phrase boundary is the natural break.
const _sentenceMarks = {
  '、', '。', '，', '．', ',', '.', '？', '！', '?', '!', '：', '；', '…', //
  '｡', '､',
};

/// Kana words that open a phrase: never merged backwards, glued forwards.
const _phraseOpeners = {
  'その', 'この', 'あの', 'どの', 'もう', 'まだ', 'また', 'まず', 'すぐ', //
  'よく', 'ほぼ', 'ごく',
};

final _kanaFragment = RegExp(r'^[\u3041-\u309Fー]{1,2}$');
final _unbreakableLatin = RegExp(r'^[!-~°\u00A0]$');

/// Grapheme-cluster count of the longest phrase that may be joined
/// into one unbreakable run, for text in boxes at least [minLineWidth]
/// wide whose glyphs advance [glyphAdvance] each. One below the line's
/// capacity, so a joined run never fills a line edge to edge.
int phraseCap(double minLineWidth, double glyphAdvance) =>
    (minLineWidth / glyphAdvance).floor() - 1;

/// [text] with word joiners where a Japanese line must not break.
///
/// Level 1 (always) joins kinsoku pairs: a closing mark, small kana or
/// long vowel never starts a line, an opening bracket never ends one.
/// Level 2 ([phrases]) joins the inside of each BudouX phrase of at
/// most [maxPhrase] grapheme clusters, so a word moves to the next line
/// whole, an opener such as この with the phrase after it, and the last
/// two clusters of each paragraph, so none ends on a lone character.
/// Any unbreakable run longer than `maxPhrase + 1` clusters loses its
/// joins again, because the engine splits an over-long run character
/// by character and ignores the joins. Other languages and text
/// without kana or kanji come back unchanged.
String phraseWrap(
  String text, {
  required Locale locale,
  required int maxPhrase,
  bool phrases = true,
}) {
  if (locale.languageCode != 'ja' || !_hasCjk(text)) return text;
  final key = (text, maxPhrase, phrases);
  final cached = _memo.remove(key);
  if (cached != null) return _memo[key] = cached;
  final result = _wrap(text, maxPhrase, phrases: phrases);
  if (_memo.length >= _memoCapacity) _memo.remove(_memo.keys.first);
  return _memo[key] = result;
}

/// Counters that end one place of a Japanese number, as in 1億6000万.
const _jaNumberScales = {'万', '億', '兆'};

final _digit = RegExp(r'\d');
final _letter = RegExp(r'\p{L}', unicode: true);

/// [figure], a quantity such as 1万5,400リットル, joined so a line breaks
/// only after 万, 億 or 兆 when a digit follows, at a space, or before a
/// trailing unit word of two or more clusters: 1万 / 5,400 / リットル.
/// A lone counter such as 倍 stays with its number. Other languages come
/// back unchanged.
String jaFigureWrap(String figure, {required Locale locale}) {
  if (locale.languageCode != 'ja') return figure;
  final g = figure.characters.toList();
  var unitStart = g.lastIndexWhere(_digit.hasMatch) + 1;
  if (unitStart == 0) unitStart = g.length;
  while (unitStart < g.length && _jaNumberScales.contains(g[unitStart])) {
    unitStart++;
  }
  final unit = g.sublist(unitStart).join().trim().characters;
  final breakBeforeUnit = unit.length > 1 && _letter.hasMatch(unit.first);
  final out = StringBuffer();
  for (var i = 0; i < g.length; i++) {
    final free =
        i == 0 ||
        !_joinable(g[i - 1], g[i]) ||
        (_jaNumberScales.contains(g[i - 1]) && _digit.hasMatch(g[i])) ||
        (i == unitStart && breakBeforeUnit);
    if (!free) out.write(wordJoiner);
    out.write(g[i]);
  }
  return out.toString();
}

/// Removes every [wordJoiner] that [phraseWrap] inserted.
String stripWordJoiners(String text) => text.replaceAll(wordJoiner, '');

/// Raw BudouX chunks of [text], for parity checks against upstream.
@visibleForTesting
List<String> budouxChunks(String text) =>
    _parse(text.characters.toList()).map((c) => c.join()).toList();

/// Graphemes that must not start a line.
@visibleForTesting
Set<String> get jaNoLineStart => _noLineStart;

/// BudouX chunks of [text] after the kana-fragment post-rule.
@visibleForTesting
List<String> jaPhrases(String text) =>
    _phrases(text.characters.toList()).map((p) => p.join()).toList();

final _memo = <(String, int, bool), String>{};

String _wrap(String text, int maxPhrase, {required bool phrases}) {
  final g = text.characters.toList();
  final level1 = <int>{};
  final level2 = <int>{};
  for (var i = 1; i < g.length; i++) {
    if (!_joinable(g[i - 1], g[i])) continue;
    if (_noLineStart.contains(g[i]) || _noLineEnd.contains(g[i - 1])) {
      level1.add(i);
    }
  }
  if (phrases && maxPhrase > 1) {
    var offset = 0;
    for (final phrase in _phraseGroups(_phrases(g), maxPhrase)) {
      if (phrase.length <= maxPhrase) {
        for (var j = 1; j < phrase.length; j++) {
          final a = phrase[j - 1];
          final b = phrase[j];
          if (_joinable(a, b) && (_isCjk(a) || _isCjk(b))) {
            level2.add(offset + j);
          }
        }
      }
      offset += phrase.length;
    }
    for (var i = 2; i <= g.length; i++) {
      final end = i == g.length || g[i] == '\n';
      if (end && _joinable(g[i - 2], g[i - 1]) && _isCjk(g[i - 1])) {
        level2.add(i - 1);
      }
    }
  }
  _dropOverlongRuns(g, level1, level2, maxPhrase + 1);

  final out = StringBuffer();
  for (var i = 0; i < g.length; i++) {
    if (level1.contains(i) || level2.contains(i)) out.write(wordJoiner);
    out.write(g[i]);
  }
  return out.toString();
}

/// Unjoins runs over [maxRun] clusters (Latin glue counts), level 2 first.
void _dropOverlongRuns(
  List<String> g,
  Set<int> level1,
  Set<int> level2,
  int maxRun,
) {
  for (final drop in [
    [level2],
    [level1, level2],
  ]) {
    var start = 0;
    for (var i = 1; i <= g.length; i++) {
      final joined =
          i < g.length &&
          (level1.contains(i) ||
              level2.contains(i) ||
              (_unbreakableLatin.hasMatch(g[i - 1]) &&
                  _unbreakableLatin.hasMatch(g[i])));
      if (joined) continue;
      if (i - start > maxRun) {
        for (var j = start + 1; j < i; j++) {
          for (final set in drop) {
            set.remove(j);
          }
        }
      }
      start = i;
    }
  }
}

List<List<String>> _phrases(List<String> g) {
  final merged = <List<String>>[];
  for (final chunk in _parse(g)) {
    final word = chunk.join();
    final attaches =
        merged.isNotEmpty &&
        _kanaFragment.hasMatch(word) &&
        !_phraseOpeners.contains(word) &&
        !_sentenceMarks.contains(merged.last.last) &&
        merged.last.last.trim().isNotEmpty;
    if (attaches) {
      merged.last.addAll(chunk);
    } else {
      merged.add(chunk);
    }
  }
  return merged;
}

/// [phrases] with each opener joined to the next phrase when both fit.
List<List<String>> _phraseGroups(List<List<String>> phrases, int maxPhrase) {
  final groups = <List<String>>[];
  for (var i = 0; i < phrases.length; i++) {
    final phrase = phrases[i];
    final opener = _phraseOpeners.contains(phrase.join());
    if (opener &&
        i + 1 < phrases.length &&
        phrase.length + phrases[i + 1].length <= maxPhrase) {
      groups.add([...phrase, ...phrases[++i]]);
    } else {
      groups.add(phrase);
    }
  }
  return groups;
}

List<List<String>> _parse(List<String> g) {
  if (g.isEmpty) return [];
  int w(String feature, String key) => jaPhraseModel[feature]?[key] ?? 0;
  String s(int from, int to) => g.sublist(from, to).join();
  final chunks = [
    [g.first],
  ];
  for (var i = 1; i < g.length; i++) {
    var score = _baseScore;
    if (i > 2) score += w('UW1', g[i - 3]);
    if (i > 1) score += w('UW2', g[i - 2]);
    score += w('UW3', g[i - 1]) + w('UW4', g[i]);
    if (i + 1 < g.length) score += w('UW5', g[i + 1]);
    if (i + 2 < g.length) score += w('UW6', g[i + 2]);
    if (i > 1) score += w('BW1', s(i - 2, i));
    score += w('BW2', s(i - 1, i + 1));
    if (i + 1 < g.length) score += w('BW3', s(i, i + 2));
    if (i > 2) score += w('TW1', s(i - 3, i));
    if (i > 1) score += w('TW2', s(i - 2, i + 1));
    if (i + 1 < g.length) score += w('TW3', s(i - 1, i + 2));
    if (i + 2 < g.length) score += w('TW4', s(i, i + 3));
    if (score > 0) {
      chunks.add([g[i]]);
    } else {
      chunks.last.add(g[i]);
    }
  }
  return chunks;
}

final double _baseScore =
    -jaPhraseModel.values
        .expand((table) => table.values)
        .fold<int>(0, (sum, weight) => sum + weight) /
    2;

bool _joinable(String a, String b) =>
    a != _placeholder &&
    b != _placeholder &&
    a.trim().isNotEmpty &&
    b.trim().isNotEmpty;

bool _hasCjk(String text) => text.runes.any(_isCjkRune);

bool _isCjk(String grapheme) => _isCjkRune(grapheme.runes.first);

bool _isCjkRune(int r) =>
    (r >= 0x20000 && r <= 0x3FFFF) ||
    (r >= 0x3000 && r <= 0x30FF) ||
    (r >= 0x31F0 && r <= 0x31FF) ||
    (r >= 0x3400 && r <= 0x9FFF) ||
    (r >= 0xF900 && r <= 0xFAFF) ||
    (r >= 0xFF00 && r <= 0xFFEF);
