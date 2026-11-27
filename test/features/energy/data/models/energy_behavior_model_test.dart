import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';

void main() {
  group('EnergyBehavior.notes', () {
    EnergyBehavior behavior({String ja = '', String es = ''}) => EnergyBehavior(
      id: 'kettle',
      comparableGroup: 'boil',
      carrier: EnergyCarrier.electricity,
      unit: EnergyUnit.use,
      kwhPerUnit: 0.116278,
      nameEn: 'Electric kettle, 1 L',
      nameJa: '電気ケトル（1L）',
      nameEs: 'Hervidor eléctrico, 1 L',
      calculationNotes: 'Physics floor over 0.85.',
      calculationNotesJa: ja,
      calculationNotesEs: es,
    );

    test('resolves a translation per locale', () {
      final translated = behavior(
        ja: '下限を0.85で割ります。',
        es: 'Mínimo entre 0,85.',
      );
      expect(translated.notes('ja'), '下限を0.85で割ります。');
      expect(translated.notes('es'), 'Mínimo entre 0,85.');
      expect(translated.notes('en'), 'Physics floor over 0.85.');
    });

    test('falls back to English when a translation is empty', () {
      final partial = behavior(es: 'Mínimo entre 0,85.');
      expect(partial.notes('ja'), 'Physics floor over 0.85.');
      expect(partial.notes('fr'), 'Physics floor over 0.85.');
    });
  });
}
