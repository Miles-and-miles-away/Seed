import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/data/services/egg_hatching_service.dart';

void main() {
  const service = EggHatchingService();

  // Reusable dates
  final now = DateTime(2024, 6, 15, 12);
  final yesterday = DateTime(2024, 6, 14, 8);
  final twoDaysAgo = DateTime(2024, 6, 13, 20);

  MascotSpeciesModel species(String id) {
    return MascotSpeciesModel(
      id: id,
      nameEn: id,
      nameJa: id,
      descriptionEn: '',
      descriptionJa: '',
      evolutionStages: const [
        EvolutionStageModel(
          level: 1,
          assetPath: '',
          nameEn: 'Stage 1',
          nameJa: '',
        ),
      ],
    );
  }

  group('EggHatchingService', () {
    group('calculateEggStreakUpdate', () {
      test('first activity ever sets streak to 1', () {
        final egg = EggModel(receivedAt: twoDaysAgo);

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.newStreakDays, 1);
        expect(result.streakBroken, isFalse);
      });

      test('first activity hatches if streak req is 1', () {
        // Edge case: if eggHatchingStreakRequired were 1
        final egg = EggModel(receivedAt: now);

        final result = service.calculateEggStreakUpdate(egg, now);

        // 1 >= 30 is false, so shouldn't hatch
        expect(result.shouldHatch, isFalse);
        expect(result.newStreakDays, 1);
      });

      test('same day returns no change', () {
        final egg = EggModel(
          receivedAt: twoDaysAgo,
          hatchingStreakDays: 5,
          lastHatchingActivityDate: now,
        );

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.newStreakDays, 5);
        expect(result.shouldHatch, isFalse);
        expect(result.streakBroken, isFalse);
      });

      test('same day with different times returns no change', () {
        final morning = DateTime(2024, 6, 15, 8);
        final evening = DateTime(2024, 6, 15, 20);
        final egg = EggModel(
          receivedAt: twoDaysAgo,
          hatchingStreakDays: 10,
          lastHatchingActivityDate: morning,
        );

        final result = service.calculateEggStreakUpdate(egg, evening);

        expect(result.newStreakDays, 10);
      });

      test('travelling west (now on an earlier day) does not reset', () {
        // A negative day difference after a westward timezone
        // change must be treated as same-day, not a broken streak.
        final egg = EggModel(
          receivedAt: twoDaysAgo,
          hatchingStreakDays: 10,
          lastHatchingActivityDate: DateTime(2024, 6, 15, 0, 30),
        );

        final result = service.calculateEggStreakUpdate(
          egg,
          DateTime(2024, 6, 14, 23),
        );

        expect(result.newStreakDays, 10);
        expect(result.streakBroken, isFalse);
      });

      test('next day increments streak by 1', () {
        final egg = EggModel(
          receivedAt: twoDaysAgo,
          hatchingStreakDays: 5,
          lastHatchingActivityDate: yesterday,
        );

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.newStreakDays, 6);
        expect(result.shouldHatch, isFalse);
        expect(result.streakBroken, isFalse);
      });

      test('reaching streak threshold triggers hatch', () {
        final egg = EggModel(
          receivedAt: DateTime(2024, 5),
          hatchingStreakDays: AppConstants.eggHatchingStreakRequired - 1,
          lastHatchingActivityDate: yesterday,
        );

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.newStreakDays, AppConstants.eggHatchingStreakRequired);
        expect(result.shouldHatch, isTrue);
      });

      test('exceeding streak threshold still hatches', () {
        final egg = EggModel(
          receivedAt: DateTime(2024, 5),
          hatchingStreakDays: AppConstants.eggHatchingStreakRequired,
          lastHatchingActivityDate: now,
        );

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.shouldHatch, isTrue);
      });

      test('gap of 2+ days resets streak to 1', () {
        final egg = EggModel(
          receivedAt: DateTime(2024, 5),
          hatchingStreakDays: 15,
          lastHatchingActivityDate: twoDaysAgo,
        );

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.newStreakDays, 1);
        expect(result.shouldHatch, isFalse);
        expect(result.streakBroken, isTrue);
      });

      test('gap does not mark broken if streak was 1', () {
        final egg = EggModel(
          receivedAt: DateTime(2024, 5),
          hatchingStreakDays: 1,
          lastHatchingActivityDate: twoDaysAgo,
        );

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.newStreakDays, 1);
        expect(result.streakBroken, isFalse);
      });

      test('large gap resets streak', () {
        final longAgo = DateTime(2024);
        final egg = EggModel(
          receivedAt: longAgo,
          hatchingStreakDays: 25,
          lastHatchingActivityDate: longAgo,
        );

        final result = service.calculateEggStreakUpdate(egg, now);

        expect(result.newStreakDays, 1);
        expect(result.shouldHatch, isFalse);
        expect(result.streakBroken, isTrue);
      });
    });

    group('selectHatchingSpecies', () {
      final speciesA = species('a');
      final speciesB = species('b');
      final speciesC = species('c');

      test('prefers unevolved species', () {
        final owned = [
          const MascotModel(id: 'm1', speciesId: 'a', isFullyEvolved: true),
        ];
        final allSpecies = [speciesA, speciesB, speciesC];

        // Run many times to verify never picks 'a'
        final results = <String>{};
        for (var i = 0; i < 50; i++) {
          final picked = service.selectHatchingSpecies(owned, allSpecies);
          results.add(picked.id);
        }

        expect(results, isNot(contains('a')));
        expect(results.length, greaterThanOrEqualTo(1));
      });

      test('returns from all species when all evolved', () {
        final owned = [
          const MascotModel(id: 'm1', speciesId: 'a', isFullyEvolved: true),
          const MascotModel(id: 'm2', speciesId: 'b', isFullyEvolved: true),
          const MascotModel(id: 'm3', speciesId: 'c', isFullyEvolved: true),
        ];
        final allSpecies = [speciesA, speciesB, speciesC];

        final picked = service.selectHatchingSpecies(owned, allSpecies);

        expect(allSpecies.map((s) => s.id), contains(picked.id));
      });

      test('handles single species', () {
        final picked = service.selectHatchingSpecies([], [speciesA]);

        expect(picked.id, 'a');
      });

      test('handles no owned mascots', () {
        final allSpecies = [speciesA, speciesB];

        final picked = service.selectHatchingSpecies([], allSpecies);

        expect(allSpecies.map((s) => s.id), contains(picked.id));
      });

      test('only unevolved mascots do not filter', () {
        final owned = [const MascotModel(id: 'm1', speciesId: 'a')];
        final allSpecies = [speciesA, speciesB];

        // All species are candidates since none fully evolved
        final results = <String>{};
        for (var i = 0; i < 50; i++) {
          final picked = service.selectHatchingSpecies(owned, allSpecies);
          results.add(picked.id);
        }

        // Both species should be possible
        expect(results.length, greaterThanOrEqualTo(1));
      });
    });
  });
}
