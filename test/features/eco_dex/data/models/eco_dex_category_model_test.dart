import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';

void main() {
  const sampleJson = {
    'id': 'climate',
    'nameEn': 'Climate',
    'nameJa': '気候',
    'nameEs': 'Clima',
  };

  group('EcoDexCategory.fromJson', () {
    test('parses all fields', () {
      final cat = EcoDexCategory.fromJson(sampleJson);

      expect(cat.id, 'climate');
      expect(cat.nameEn, 'Climate');
      expect(cat.nameJa, '気候');
      expect(cat.nameEs, 'Clima');
    });
  });

  group('name()', () {
    late EcoDexCategory cat;

    setUp(() {
      cat = EcoDexCategory.fromJson(sampleJson);
    });

    test('returns English by default', () {
      expect(cat.name('en'), 'Climate');
    });

    test('returns Japanese for ja', () {
      expect(cat.name('ja'), '気候');
    });

    test('returns Spanish for es', () {
      expect(cat.name('es'), 'Clima');
    });

    test('falls back to English for unknown locale', () {
      expect(cat.name('de'), 'Climate');
    });

    test('falls back to English when es is empty', () {
      final noEs = EcoDexCategory.fromJson(
        Map<String, dynamic>.from(sampleJson)..['nameEs'] = '',
      );
      expect(noEs.name('es'), 'Climate');
    });
  });
}
