import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';

void main() {
  group('FoodItem.notes', () {
    FoodItem item({String ja = '', String es = ''}) => FoodItem(
      id: 'beef',
      group: 'meat',
      nameEn: 'Beef',
      nameJa: '牛肉',
      nameEs: 'Ternera',
      kgCo2ePerKg: 99.48,
      calculationNotes: 'Poore & Nemecek mean.',
      calculationNotesJa: ja,
      calculationNotesEs: es,
    );

    test('falls back to English while the item is untranslated', () {
      for (final locale in ['en', 'ja', 'es', 'fr']) {
        expect(item().notes(locale), 'Poore & Nemecek mean.');
      }
    });

    test('resolves a translation per locale', () {
      final translated = item(ja: '平均値です。', es: 'Media de Poore & Nemecek.');
      expect(translated.notes('ja'), '平均値です。');
      expect(translated.notes('es'), 'Media de Poore & Nemecek.');
      expect(item(ja: '平均値です。').notes('es'), 'Poore & Nemecek mean.');
    });
  });
}
