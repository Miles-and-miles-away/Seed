import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';

void main() {
  group('EvolutionStageModel', () {
    test('fromJson parses required fields and defaults nameEs', () {
      final stage = EvolutionStageModel.fromJson({
        'level': 10,
        'assetPath': 'assets/mascots/seed/stage_2.png',
        'nameEn': 'Sprout',
        'nameJa': '芽',
      });

      expect(stage.level, 10);
      expect(stage.assetPath, 'assets/mascots/seed/stage_2.png');
      expect(stage.nameEn, 'Sprout');
      expect(stage.nameJa, '芽');
      expect(stage.nameEs, '');
    });

    test('fromJson preserves nameEs when provided', () {
      final stage = EvolutionStageModel.fromJson({
        'level': 1,
        'assetPath': 'x.png',
        'nameEn': 'Seed',
        'nameJa': 'シード',
        'nameEs': 'Semilla',
      });

      expect(stage.nameEs, 'Semilla');
    });

    test('toJson round-trips', () {
      const stage = EvolutionStageModel(
        level: 25,
        assetPath: 'a.png',
        nameEn: 'Tree',
        nameJa: '木',
        nameEs: 'Árbol',
      );

      expect(EvolutionStageModel.fromJson(stage.toJson()), stage);
    });
  });
}
