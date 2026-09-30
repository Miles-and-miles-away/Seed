import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every locale defines exactly the keys app_en.arb defines', () {
    Set<String> keys(String file) {
      final json = jsonDecode(File('lib/core/l10n/$file').readAsStringSync());
      return (json as Map<String, dynamic>).keys
          .where((k) => !k.startsWith('@'))
          .toSet();
    }

    final en = keys('app_en.arb');
    for (final file in ['app_ja.arb', 'app_es.arb']) {
      expect(keys(file), en, reason: file);
    }
  });
}
