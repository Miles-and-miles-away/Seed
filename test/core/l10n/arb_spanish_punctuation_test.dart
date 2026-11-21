import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Spanish questions and exclamations open with ¿ and ¡', () {
    final arb =
        jsonDecode(File('lib/core/l10n/app_es.arb').readAsStringSync())
            as Map<String, dynamic>;
    final sentenceEnd = RegExp(r'(?<=[.!?])\s+');
    final missing = <String>[];
    for (final MapEntry(:key, :value) in arb.entries) {
      if (key.startsWith('@') || value is! String) continue;
      for (final sentence in value.split(sentenceEnd)) {
        if (sentence.contains('!') && !sentence.contains('¡')) {
          missing.add('$key: $sentence');
        }
        if (sentence.contains('?') && !sentence.contains('¿')) {
          missing.add('$key: $sentence');
        }
      }
    }
    expect(missing, isEmpty);
  });
}
