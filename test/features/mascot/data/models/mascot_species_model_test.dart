import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';

void main() {
  const testStages = [
    EvolutionStageModel(
      level: 1,
      assetPath: 'assets/mascot/stage1.svg',
      nameEn: 'Seed',
      nameJa: 'たね',
    ),
    EvolutionStageModel(
      level: 10,
      assetPath: 'assets/mascot/stage2.svg',
      nameEn: 'Sprout',
      nameJa: 'めばえ',
    ),
    EvolutionStageModel(
      level: 25,
      assetPath: 'assets/mascot/stage3.svg',
      nameEn: 'Sapling',
      nameJa: 'なえぎ',
    ),
    EvolutionStageModel(
      level: 50,
      assetPath: 'assets/mascot/stage4.svg',
      nameEn: 'Tree',
      nameJa: 'たいぼく',
    ),
  ];

  const testSpecies = MascotSpeciesModel(
    id: 'seed',
    nameEn: 'Seed',
    nameJa: 'シード',
    descriptionEn: 'A tiny seed with big dreams!',
    descriptionJa: '大きな夢を持つ小さな種！',
    evolutionStages: testStages,
  );

  group('MascotSpeciesModel', () {
    group('construction', () {
      test('creates model with required fields', () {
        expect(testSpecies.id, 'seed');
        expect(testSpecies.nameEn, 'Seed');
        expect(testSpecies.nameJa, 'シード');
        expect(testSpecies.descriptionEn, 'A tiny seed with big dreams!');
        expect(testSpecies.descriptionJa, '大きな夢を持つ小さな種！');
        expect(testSpecies.evolutionStages, hasLength(4));
      });

      test('has correct default availability', () {
        expect(testSpecies.availability, 'free');
      });

      test('creates model with custom availability', () {
        const premiumSpecies = MascotSpeciesModel(
          id: 'dragon',
          nameEn: 'Dragon',
          nameJa: 'ドラゴン',
          descriptionEn: 'A majestic dragon!',
          descriptionJa: '壮大なドラゴン！',
          evolutionStages: testStages,
          availability: 'premium',
        );

        expect(premiumSpecies.availability, 'premium');
      });
    });

    group('fromJson', () {
      test('creates model from JSON', () {
        final json = {
          'id': 'seed',
          'nameEn': 'Seed',
          'nameJa': 'シード',
          'descriptionEn': 'A tiny seed!',
          'descriptionJa': '小さな種！',
          'evolutionStages': [
            {
              'level': 1,
              'assetPath': 'assets/stage1.svg',
              'nameEn': 'Seed',
              'nameJa': 'たね',
            },
          ],
          'availability': 'premium',
        };

        final model = MascotSpeciesModel.fromJson(json);

        expect(model.id, 'seed');
        expect(model.nameEn, 'Seed');
        expect(model.evolutionStages, hasLength(1));
        expect(model.availability, 'premium');
      });
    });

    group('toJson', () {
      test('converts model to JSON', () {
        final json = testSpecies.toJson();

        expect(json['id'], 'seed');
        expect(json['nameEn'], 'Seed');
        expect(json['nameJa'], 'シード');
        expect(json['evolutionStages'], hasLength(4));
        expect(json['availability'], 'free');
      });
    });
  });

  group('MascotSpeciesModelX extension', () {
    group('getName', () {
      test('returns English name for en locale', () {
        expect(testSpecies.getName('en'), 'Seed');
      });

      test('returns Japanese name for ja locale', () {
        expect(testSpecies.getName('ja'), 'シード');
      });

      test('returns English name for unknown locale', () {
        expect(testSpecies.getName('fr'), 'Seed');
      });
    });

    group('getDescription', () {
      test('returns English description for en locale', () {
        expect(
          testSpecies.getDescription('en'),
          'A tiny seed with big dreams!',
        );
      });

      test('returns Japanese description for ja locale', () {
        expect(testSpecies.getDescription('ja'), '大きな夢を持つ小さな種！');
      });
    });

    group('getStageForLevel', () {
      test('returns first stage for level 1', () {
        final stage = testSpecies.getStageForLevel(1);

        expect(stage.level, 1);
        expect(stage.nameEn, 'Seed');
      });

      test('returns first stage for level 9', () {
        final stage = testSpecies.getStageForLevel(9);

        expect(stage.level, 1);
        expect(stage.nameEn, 'Seed');
      });

      test('returns second stage for level 10', () {
        final stage = testSpecies.getStageForLevel(10);

        expect(stage.level, 10);
        expect(stage.nameEn, 'Sprout');
      });

      test('returns second stage for level 24', () {
        final stage = testSpecies.getStageForLevel(24);

        expect(stage.level, 10);
        expect(stage.nameEn, 'Sprout');
      });

      test('returns third stage for level 25', () {
        final stage = testSpecies.getStageForLevel(25);

        expect(stage.level, 25);
        expect(stage.nameEn, 'Sapling');
      });

      test('returns fourth stage for level 50', () {
        final stage = testSpecies.getStageForLevel(50);

        expect(stage.level, 50);
        expect(stage.nameEn, 'Tree');
      });

      test('returns fourth stage for level 100', () {
        final stage = testSpecies.getStageForLevel(100);

        expect(stage.level, 50);
        expect(stage.nameEn, 'Tree');
      });
    });

    group('getStageIndexForLevel', () {
      test('returns 1 for level 1-9', () {
        expect(testSpecies.getStageIndexForLevel(1), 1);
        expect(testSpecies.getStageIndexForLevel(5), 1);
        expect(testSpecies.getStageIndexForLevel(9), 1);
      });

      test('returns 2 for level 10-24', () {
        expect(testSpecies.getStageIndexForLevel(10), 2);
        expect(testSpecies.getStageIndexForLevel(15), 2);
        expect(testSpecies.getStageIndexForLevel(24), 2);
      });

      test('returns 3 for level 25-49', () {
        expect(testSpecies.getStageIndexForLevel(25), 3);
        expect(testSpecies.getStageIndexForLevel(35), 3);
        expect(testSpecies.getStageIndexForLevel(49), 3);
      });

      test('returns 4 for level 50+', () {
        expect(testSpecies.getStageIndexForLevel(50), 4);
        expect(testSpecies.getStageIndexForLevel(100), 4);
      });
    });

    group('getNextStage', () {
      test('returns second stage when at level 1', () {
        final nextStage = testSpecies.getNextStage(1);

        expect(nextStage, isNotNull);
        expect(nextStage!.level, 10);
        expect(nextStage.nameEn, 'Sprout');
      });

      test('returns second stage when at level 9', () {
        final nextStage = testSpecies.getNextStage(9);

        expect(nextStage, isNotNull);
        expect(nextStage!.level, 10);
      });

      test('returns third stage when at level 10', () {
        final nextStage = testSpecies.getNextStage(10);

        expect(nextStage, isNotNull);
        expect(nextStage!.level, 25);
        expect(nextStage.nameEn, 'Sapling');
      });

      test('returns fourth stage when at level 25', () {
        final nextStage = testSpecies.getNextStage(25);

        expect(nextStage, isNotNull);
        expect(nextStage!.level, 50);
        expect(nextStage.nameEn, 'Tree');
      });

      test('returns null when at max level', () {
        final nextStage = testSpecies.getNextStage(50);

        expect(nextStage, isNull);
      });

      test('returns null when past max level', () {
        final nextStage = testSpecies.getNextStage(100);

        expect(nextStage, isNull);
      });
    });
  });

  group('EvolutionStageModel', () {
    group('construction', () {
      test('creates model with all fields', () {
        const stage = EvolutionStageModel(
          level: 10,
          assetPath: 'assets/mascot/stage2.svg',
          nameEn: 'Sprout',
          nameJa: 'めばえ',
        );

        expect(stage.level, 10);
        expect(stage.assetPath, 'assets/mascot/stage2.svg');
        expect(stage.nameEn, 'Sprout');
        expect(stage.nameJa, 'めばえ');
      });
    });

    group('fromJson', () {
      test('creates model from JSON', () {
        final json = {
          'level': 25,
          'assetPath': 'assets/mascot/stage3.svg',
          'nameEn': 'Sapling',
          'nameJa': 'なえぎ',
        };

        final stage = EvolutionStageModel.fromJson(json);

        expect(stage.level, 25);
        expect(stage.assetPath, 'assets/mascot/stage3.svg');
        expect(stage.nameEn, 'Sapling');
        expect(stage.nameJa, 'なえぎ');
      });
    });

    group('toJson', () {
      test('converts model to JSON', () {
        const stage = EvolutionStageModel(
          level: 50,
          assetPath: 'assets/mascot/stage4.svg',
          nameEn: 'Tree',
          nameJa: 'たいぼく',
        );

        final json = stage.toJson();

        expect(json['level'], 50);
        expect(json['assetPath'], 'assets/mascot/stage4.svg');
        expect(json['nameEn'], 'Tree');
        expect(json['nameJa'], 'たいぼく');
      });
    });

    group('equality', () {
      test('two stages with same values are equal', () {
        const stage1 = EvolutionStageModel(
          level: 10,
          assetPath: 'assets/stage2.svg',
          nameEn: 'Sprout',
          nameJa: 'めばえ',
        );

        const stage2 = EvolutionStageModel(
          level: 10,
          assetPath: 'assets/stage2.svg',
          nameEn: 'Sprout',
          nameJa: 'めばえ',
        );

        expect(stage1, equals(stage2));
      });
    });
  });
}
