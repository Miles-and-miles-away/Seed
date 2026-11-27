import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';

void main() {
  group('servingHeadline', () {
    test('drops the technical clause after the separator', () {
      expect(
        servingHeadline('1 portion cooked (100 g) - 47 g dry'),
        '1 portion cooked (100 g)',
      );
      expect(servingHeadline('炊飯後1食分（100 g）- 生米47 g'), '炊飯後1食分（100 g）');
    });

    test('leaves a serving without a clause alone', () {
      expect(servingHeadline('1 cup (240 ml)'), '1 cup (240 ml)');
    });

    test('a serving with a clause has it in every language', () {
      final items =
          (jsonDecode(File('data/app/food_items.json').readAsStringSync())
                  as Map<String, dynamic>)['items']
              as List<dynamic>;
      for (final item in items.cast<Map<String, dynamic>>()) {
        final servings = (item['servings'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();
        for (final serving in servings) {
          final split = [
            for (final lang in ['en', 'ja', 'es'])
              servingHeadline(serving['name_$lang'] as String) !=
                  serving['name_$lang'],
          ];
          expect(
            split.toSet(),
            hasLength(1),
            reason: '${item['id']} ${serving['id']}',
          );
        }
      }
    });
  });
}
