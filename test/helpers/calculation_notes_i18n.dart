import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dataset_helpers.dart';

/// Units a note's numbers carry, mapped to one form per meaning so
/// `40 C`, `40℃` and `40 °C` compare equal. Denominators (the `/km` of
/// `g/km`) are not compared.
const _units = {
  '%': '%',
  'kWh': 'kWh',
  'Wh': 'Wh',
  'W': 'W',
  'kJ': 'kJ',
  'kg': 'kg',
  'g': 'g',
  'km': 'km',
  'L': 'L',
  'lm': 'lm',
  'K': 'K',
  'C': '°C',
  '°C': '°C',
  '℃': '°C',
  'x': 'x',
  '倍': 'x',
  'veces': 'x',
  'h': 'h',
  'hour': 'h',
  'hours': 'h',
  'hora': 'h',
  'horas': 'h',
  '時間': 'h',
  'min': 'min',
  'minute': 'min',
  'minutes': 'min',
  'minuto': 'min',
  'minutos': 'min',
  '分': 'min',
};

final _unitPattern = (_units.keys.toList()..sort((a, b) => b.length - a.length))
    .map(RegExp.escape)
    .join('|');

final _token = RegExp(
  r'(?:(?<![0-9A-Za-z])([+\-\u2212]))?(\d+(?:[.,]\d+)*)'
  '(?:(\\s?)($_unitPattern)(?![A-Za-z]))?',
);

/// Section, paragraph, table and bill numbers are names, written the same
/// in every locale.
final _referenceBefore = RegExp(r'\b(?:section|sec|para|Table|SB|SAP) $');

/// Model codes and standards (E4, H125, EN50229, CS-227VB): integers only.
final _codeBefore = RegExp(r'(?:[A-Za-z_]|[A-Za-z]-)$');

/// Counts a translation may spell out where English uses a word ("one hour
/// a day" is 1日1時間).
const _maxImplicitCount = 10;

final _implicitCount = RegExp(r'^\d+(?: |$)');

/// The sha256 of an English note, as `calculation_notes_src_sha` stores it.
String noteSha(String english) =>
    sha256.convert(utf8.encode(english)).toString();

/// [english] as es-ES writes it: decimal comma, and a period between
/// thousands from four digits up, except in a year (a unitless 1900-2100).
String spanishNumber(String english, {bool hasUnit = false}) {
  final [whole, ...decimals] = english.split('.');
  final digits = whole.replaceAll(',', '');
  final value = int.parse(digits);
  final year =
      !hasUnit &&
      !whole.contains(',') &&
      digits.length == 4 &&
      value >= 1900 &&
      value <= 2100;
  final grouped = digits.length < 4 || year
      ? digits
      : digits.replaceAllMapped(RegExp(r'\d(?=(\d{3})+$)'), (m) => '${m[0]}.');
  return [grouped, ...decimals].join(',');
}

typedef _Number = ({String sign, String number, String unit});

_Number _parse(RegExpMatch m) => (
  sign: m[1] == '\u2212' ? '-' : m[1] ?? '',
  number: m[2]!,
  // A spaced "x" is multiplication, not a ratio.
  unit: m[4] == 'x' && m[3]!.isNotEmpty ? '' : _units[m[4]] ?? '',
);

String _show(_Number n) =>
    '${n.sign}${n.number}${n.unit.isEmpty ? '' : ' ${n.unit}'}';

/// How [translated] differs from [english] in its signed numbers and
/// units, each English number put in [locale] form: `missing` and `extra`
/// entries. Small counts may be extra; numbers in [ignore] (English form)
/// are skipped on both sides. Order and which clause a number sits in are
/// not checked, so a pass is no proof of meaning.
List<String> numberMismatches(
  String english,
  String translated, {
  required String locale,
  Set<String> ignore = const {},
}) {
  final expected = <String>[];
  for (final m in _token.allMatches(english)) {
    final n = _parse(m);
    if (ignore.contains(n.number)) continue;
    final before = english.substring(0, m.start);
    final code =
        !n.number.contains(RegExp('[.,]')) && _codeBefore.hasMatch(before);
    final asIs = locale != 'es' || code || _referenceBefore.hasMatch(before);
    final number = asIs
        ? n.number
        : spanishNumber(n.number, hasUnit: n.unit.isNotEmpty);
    expected.add(_show((sign: n.sign, number: number, unit: n.unit)));
  }
  final ignored = {
    for (final number in ignore) ...{number, spanishNumber(number)},
  };
  final have = [
    for (final n in _token.allMatches(translated).map(_parse))
      if (!ignored.contains(n.number)) _show(n),
  ];
  final missing = [
    for (final n in expected)
      if (!have.remove(n)) n,
  ];
  return [
    for (final n in missing) 'missing $n',
    for (final n in have)
      if (!_implicitCount.hasMatch(n) ||
          int.parse(n.split(' ').first) > _maxImplicitCount)
        'extra $n',
  ];
}

/// Number-fidelity and staleness checks for the JA and ES calculation
/// notes of the dataset at [path]. [complete] requires every entry to be
/// translated; otherwise at least [minTranslated] must be. [exceptions]
/// maps an entry id to numbers [numberMismatches] skips, each with a
/// reason.
void calculationNotesI18nTests(
  String path,
  String key, {
  required bool complete,
  int? minTranslated,
  Map<String, Map<String, String>> exceptions = const {},
}) {
  final entries = rawDatasetList(path, key);
  String field(Map<String, dynamic> entry, String name) =>
      entry[name] as String? ?? '';
  bool translated(Map<String, dynamic> entry, String locale) =>
      field(entry, 'calculation_notes_$locale').trim().isNotEmpty;

  group('$path calculation notes in JA and ES', () {
    test(
      complete
          ? 'every entry is translated'
          : 'at least $minTranslated entries are translated',
      () {
        final both = [
          for (final e in entries)
            if (translated(e, 'ja') && translated(e, 'es')) e,
        ];
        if (complete) {
          final missing = [
            for (final e in entries)
              if (!both.contains(e)) e['id'],
          ];
          expect(missing, isEmpty, reason: 'untranslated');
        }
        if (minTranslated != null) {
          expect(both.length, greaterThanOrEqualTo(minTranslated));
        }
      },
    );

    test('translations match the current English note', () {
      final stale = [
        for (final e in entries)
          if ((translated(e, 'ja') || translated(e, 'es')) &&
              field(e, 'calculation_notes_src_sha') !=
                  noteSha(field(e, 'calculation_notes')))
            e['id'],
      ];
      expect(stale, isEmpty, reason: 're-translate these notes');
    });

    for (final locale in ['ja', 'es']) {
      test('$locale notes carry every English number', () {
        final wrong = [
          for (final e in entries)
            if (translated(e, locale))
              if (numberMismatches(
                    field(e, 'calculation_notes'),
                    field(e, 'calculation_notes_$locale'),
                    locale: locale,
                    ignore: {...?exceptions[e['id']]?.keys},
                  )
                  case final diff when diff.isNotEmpty)
                '${e['id']}: $diff',
        ];
        expect(wrong, isEmpty);
      });
    }
  });
}
