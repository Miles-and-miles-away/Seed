import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/utils/ja_phrase.dart';

const _ja = Locale('ja');
const _fontSize = 14.0;
const _widths = [98.0, 126.0, 151.0, 200.0, 280.0];
const _scales = [1.0, 1.3, 2.0];
const _actionTitleMaxLines = 2;

/// One string may gain at most this fraction of its lines (or 2 lines).
const _perStringGrowth = 0.5;

/// Plain, or level 1 + 2 capped by the real width or by the default.
enum _Mode { plain, fit, defaultCap }

class _Stats {
  int lines = 0;
  int starts = 0;

  /// Starts after an ASCII run wider than the line, which plain splits too.
  int startsInLatinRuns = 0;
  int oneChar = 0;
  int midWord = 0;
  final perString = <int>[];

  @override
  String toString() => '$lines/$starts/$oneChar/$midWord';
}

Object? _json(String path) => jsonDecode(File(path).readAsStringSync());

List<Map<String, Object?>> _records(Object? list) => [
  for (final item in list! as List<Object?>) item! as Map<String, Object?>,
];

List<String> _fields(
  Iterable<Map<String, Object?>> records,
  List<String> keys,
) => [
  for (final record in records)
    for (final key in keys)
      if (record[key] case final String value when value.isNotEmpty) value,
];

final _ascii = RegExp(r'^[!-~]$');

final _arb = _arbCorpus();
final _facts = _fields(_records(_json('data/app/eco_facts.json')), ['factJa']);
final _actions = _fields(
  _records(
    (_json('data/seed/co2_actions_database.json')!
        as Map<String, Object?>)['actions'],
  ),
  ['name_ja'],
);
final _challenges = () {
  final data =
      _json('data/app/challenge_templates.json')! as Map<String, Object?>;
  return _fields(
    [..._records(data['daily']), ..._records(data['multiDay'])],
    ['titleJa', 'descriptionJa'],
  );
}();
final _ecoDex = _fields(
  _records(
    (_json('data/app/eco_dex_entries.json')!
        as Map<String, Object?>)['entries'],
  ),
  ['nameJa', 'factJa', 'hintJa'],
);
final _sdg = [
  ..._fields(_records(_json('data/app/sdg_goals.json')), [
    'titleJa',
    'descriptionJa',
  ]),
  for (final targets
      in (_json('data/app/sdg_targets.json')! as Map<String, Object?>).values)
    ..._fields(_records(targets), ['descriptionJa']),
];

/// Every `app_ja.arb` value, `other` branches only, placeholders filled.
List<String> _arbCorpus() {
  final arb = _json('lib/core/l10n/app_ja.arb')! as Map<String, Object?>;
  return [
    for (final MapEntry(:key, :value) in arb.entries)
      if (!key.startsWith('@') && value is String) _fillPlaceholders(value),
  ];
}

final _icuMessage = RegExp(r'\{(\w+), (?:plural|select),');
final _simplePlaceholder = RegExp(r'\{(\w+)\}');
final _numericName = RegExp(
  'count|days|level|number|points|percent|km|kg|value|amount|total|goal',
  caseSensitive: false,
);

String _fillPlaceholders(String message) {
  var text = message;
  for (
    var match = _icuMessage.firstMatch(text);
    match != null;
    match = _icuMessage.firstMatch(text)
  ) {
    final end = _closingBrace(text, match.start);
    final other = text.indexOf('other{', match.end);
    final body = other < 0 || other > end
        ? ''
        : text.substring(other + 6, _closingBrace(text, other + 5));
    text = text.replaceRange(match.start, end + 1, body);
  }
  return text.replaceAllMapped(
    _simplePlaceholder,
    (m) => _numericName.hasMatch(m[1]!) ? '12' : 'サンプル',
  );
}

int _closingBrace(String text, int open) {
  var depth = 0;
  for (var i = open; i < text.length; i++) {
    if (text[i] == '{') depth++;
    if (text[i] == '}' && --depth == 0) return i;
  }
  return text.length - 1;
}

int _maxPhrase(double minLineWidth, double scale) =>
    phraseCap(minLineWidth, TextScaler.linear(scale).scale(_fontSize));

String _render(String text, _Mode mode, double width, double scale) =>
    switch (mode) {
      _Mode.plain => text,
      _Mode.fit => phraseWrap(
        text,
        locale: _ja,
        maxPhrase: _maxPhrase(width, scale),
      ),
      _Mode.defaultCap => phraseWrap(
        text,
        locale: _ja,
        maxPhrase: _maxPhrase(defaultPhraseMinLineWidth, scale),
      ),
    };

TextPainter _layout(
  String text,
  double width,
  double scale, {
  int? maxLines,
  double fontSize = _fontSize,
}) => TextPainter(
  text: TextSpan(
    text: text,
    style: TextStyle(fontSize: fontSize),
  ),
  textDirection: TextDirection.ltr,
  textScaler: TextScaler.linear(scale),
  maxLines: maxLines,
)..layout(maxWidth: width);

/// Clean text of each laid-out line, and clean offsets of soft breaks.
(List<String>, List<int>) _lines(
  String rendered,
  double width,
  double scale, {
  double fontSize = _fontSize,
}) {
  final painter = _layout(rendered, width, scale, fontSize: fontSize);
  final lines = <String>[];
  final breaks = <int>[];
  var start = 0;
  int clean(int offset) =>
      stripWordJoiners(rendered.substring(0, offset)).length;
  while (start < rendered.length) {
    final line = painter.getLineBoundary(TextPosition(offset: start));
    if (line.end <= start) {
      start++;
      continue;
    }
    if (start > 0 && rendered[start - 1] != '\n') breaks.add(clean(start));
    lines.add(stripWordJoiners(rendered.substring(line.start, line.end)));
    start = line.end;
  }
  painter.dispose();
  return (lines, breaks);
}

/// Upstream BudouX boundaries: the mid-word oracle, before any post-rule.
Set<int> _budouxBoundaries(String text) {
  final boundaries = <int>{};
  var offset = 0;
  for (final chunk in budouxChunks(text)) {
    boundaries.add(offset);
    offset += chunk.length;
  }
  return boundaries;
}

_Stats _measure(List<String> corpus, _Mode mode, double width, double scale) {
  final stats = _Stats();
  for (final text in corpus) {
    final rendered = _render(text, mode, width, scale);
    final painter = _layout(rendered, width, scale);
    final lineCount = painter.computeLineMetrics().length;
    painter.dispose();
    stats
      ..lines += lineCount
      ..perString.add(lineCount);
    final (lines, breaks) = _lines(rendered, width, scale);
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      if (i > 0 && jaNoLineStart.contains(line.characters.first)) {
        stats.starts++;
        final before = lines[i - 1].trimRight();
        if (before.isNotEmpty && _ascii.hasMatch(before.characters.last)) {
          stats.startsInLatinRuns++;
        }
      }
      if (lines.length > 1 && line.characters.length == 1) stats.oneChar++;
    }
    final boundaries = _budouxBoundaries(text);
    for (final b in breaks) {
      final besideSpace =
          text[b - 1].trim().isEmpty ||
          (b < text.length && text[b].trim().isEmpty);
      if (!besideSpace && !boundaries.contains(b)) stats.midWord++;
    }
  }
  return stats;
}

bool _exceeds(String text, double width, double scale) {
  final painter = _layout(text, width, scale, maxLines: _actionTitleMaxLines);
  final exceeded = painter.didExceedMaxLines;
  painter.dispose();
  return exceeded;
}

/// Ellipsised titles: plain, level 1 alone, and `PhraseText` (with fallback).
(int, int, int) _ellipsised(double width, double scale) {
  var plain = 0;
  var level1 = 0;
  var phraseText = 0;
  for (final title in _actions) {
    final joined = phraseWrap(
      title,
      locale: _ja,
      maxPhrase: _maxPhrase(width, scale),
      phrases: false,
    );
    final plainExceeds = _exceeds(title, width, scale);
    final joinedExceeds = _exceeds(joined, width, scale);
    if (plainExceeds) plain++;
    if (joinedExceeds) level1++;
    if (joinedExceeds && plainExceeds) phraseText++;
  }
  return (plain, level1, phraseText);
}

/// Prints the measurements when `PHRASE_REPORT` is set.
void _report(StringBuffer report) {
  // ignore: avoid_print
  if (Platform.environment.containsKey('PHRASE_REPORT')) print(report);
}

void main() {
  final corpora = {
    'arb': _arb,
    'facts': _facts,
    'actions': _actions,
    'challenges': _challenges,
    'ecodex': _ecoDex,
    'sdg': _sdg,
  };
  // Measured peaks plus 0.01, over every width, scale and cap.
  final lineRatioLimit = {
    'arb': 1.114,
    'facts': 1.179,
    'actions': 1.058,
    'challenges': 1.157,
    'ecodex': 1.161,
    'sdg': 1.166,
  };

  test('control: plain Text breaks inside the reported phrase', () {
    final painter = TextPainter(
      text: const TextSpan(
        text: '今日は近所の人や地域の活動を手伝おう',
        style: TextStyle(fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 175);
    final firstLine = painter.getLineBoundary(const TextPosition(offset: 0));
    expect(firstLine.end, '今日は近所の人や地域の活動を手伝お'.length);
    painter.dispose();

    final (lines, _) = _lines(
      phraseWrap(
        '今日は近所の人や地域の活動を手伝おう',
        locale: _ja,
        maxPhrase: phraseCap(175, 10),
      ),
      175,
      1,
      fontSize: 10,
    );
    expect(lines, ['今日は近所の人や地域の活動を', '手伝おう']);
  });

  test('reported walk strings break between phrases', () {
    List<String> fit(String text, double width) => _lines(
      phraseWrap(text, locale: _ja, maxPhrase: phraseCap(width, _fontSize)),
      width,
      1,
    ).$1;

    expect(fit('毎日いくつのエコアクションを達成したいですか？', 140), [
      '毎日いくつの',
      'エコアクションを',
      '達成したいですか？',
    ]);
    expect(fit('使い捨てカトラリーを断る', 106), ['使い捨て', 'カトラリーを', '断る']);
    expect(fit('お風呂の代わりにシャワー', 106), ['お風呂の', '代わりに', 'シャワー']);
  });

  test('corpora are complete', () {
    expect(_arb.length, greaterThan(600));
    expect(_facts, hasLength(366));
    expect(_actions, hasLength(91));
    expect(_challenges, contains('今日は近所の人や地域の活動を手伝おう'));
    expect(_ecoDex.length, greaterThan(300));
    expect(_sdg.length, greaterThan(169));
  });

  for (final MapEntry(key: name, value: corpus) in corpora.entries) {
    for (final scale in _scales) {
      test('$name at text scale $scale', () {
        final report = StringBuffer(
          '$name x$scale  width: plain | fit | default-cap '
          '(lines/starts/1-char/mid-word) max ratio\n',
        );
        for (final width in _widths) {
          final plain = _measure(corpus, _Mode.plain, width, scale);
          final fit = _measure(corpus, _Mode.fit, width, scale);
          final defaultCap = _measure(corpus, _Mode.defaultCap, width, scale);
          final ratio = max(fit.lines, defaultCap.lines) / plain.lines;
          report.writeln(
            '  $width: $plain | $fit | $defaultCap '
            '${ratio.toStringAsFixed(3)}',
          );
          for (final (label, phrase) in [
            ('fit', fit),
            ('default-cap', defaultCap),
          ]) {
            final at = '$name $label at ${width}pt x$scale';
            expect(phrase.starts, lessThanOrEqualTo(plain.starts), reason: at);
            final startsMustBeZero =
                (scale == 1.0 && width >= 126) ||
                (scale == 1.3 && width >= 151);
            if (startsMustBeZero) {
              expect(phrase.starts - phrase.startsInLatinRuns, 0, reason: at);
            }
            expect(
              phrase.oneChar,
              lessThanOrEqualTo(plain.oneChar + _oneCharSlack(scale)),
              reason: at,
            );
            expect(
              phrase.lines,
              lessThanOrEqualTo(plain.lines * lineRatioLimit[name]!),
              reason: at,
            );
            for (var i = 0; i < corpus.length; i++) {
              final before = plain.perString[i];
              expect(
                phrase.perString[i],
                lessThanOrEqualTo(before + max(2, before * _perStringGrowth)),
                reason: '$at: ${corpus[i]}',
              );
            }
          }
        }
        _report(report);
      });
    }
  }

  test('maxLines titles never ellipsise more than plain', () {
    final report = StringBuffer(
      'action titles ellipsised: plain / level 1 alone / PhraseText\n',
    );
    for (final scale in _scales) {
      for (final width in [..._widths.take(3), 134.5]) {
        final (plain, level1, phraseText) = _ellipsised(width, scale);
        report.writeln('  ${width}pt x$scale: $plain / $level1 / $phraseText');
        expect(phraseText, lessThanOrEqualTo(plain), reason: '$width x$scale');
      }
    }
    _report(report);
  });
}

/// Extra one-character lines allowed over plain, by text scale.
int _oneCharSlack(double scale) => switch (scale) {
  1.0 => 0,
  1.3 => 1,
  _ => 10,
};
