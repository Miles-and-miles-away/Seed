import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// "1.5" or "3.25": es-ES writes the decimal with a comma. A period
/// followed by exactly three digits is a thousands group and is allowed.
final _periodDecimal = RegExp(r'\d\.(\d{1,2}|\d{4,})(?!\d)');

/// "1,500": es-ES groups thousands with a period. "0,500" is a decimal.
final _commaThousands = RegExp(r'(?<![\d.,])[1-9]\d{0,2}(,\d{3})+(?![\d,])');

List<String> _englishMarks(String text) => [
  for (final pattern in [_periodDecimal, _commaThousands])
    ...pattern.allMatches(text).map((m) => m.group(0)!),
];

List<Map<String, dynamic>> _records(String path, {String? key}) {
  final json = jsonDecode(File(path).readAsStringSync());
  final list = key == null ? json : (json as Map<String, dynamic>)[key];
  return (list as List).cast<Map<String, dynamic>>();
}

void main() {
  test('the patterns tell English marks from Spanish ones', () {
    expect(_englishMarks('1.5 kg, 3.25 t, 1,500 km, 12,300,000'), [
      '1.5',
      '3.25',
      '1,500',
      '12,300,000',
    ]);
    expect(_englishMarks('1,5 kg, 1.500 km, 0,500 l, 2019, 99,9%'), isEmpty);
  });

  final sources = {
    'data/app/eco_facts.json': _records('data/app/eco_facts.json'),
    'data/app/eco_dex_entries.json': _records(
      'data/app/eco_dex_entries.json',
      key: 'entries',
    ),
  };
  for (final MapEntry(key: path, value: records) in sources.entries) {
    test('$path factEs numbers use es-ES marks', () {
      final wrong = [
        for (final record in records)
          for (final mark in _englishMarks(record['factEs'] as String? ?? ''))
            '${record['id'] ?? record['dayOfYear']}: $mark',
      ];
      expect(wrong, isEmpty);
    });
  }
}
