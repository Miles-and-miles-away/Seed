import 'dart:math';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import '../mascot_species_loader.dart';
import '../models/egg_model.dart';
import '../models/mascot_model.dart';
import '../models/mascot_species_model.dart';

/// Result of an egg streak calculation.
class EggStreakResult {
  const EggStreakResult({
    required this.newStreakDays,
    required this.shouldHatch,
    this.streakBroken = false,
  });

  final int newStreakDays;
  final bool shouldHatch;
  final bool streakBroken;
}

/// Pure Dart service for egg hatching logic.
class EggHatchingService {
  const EggHatchingService();

  /// Calculates the updated egg streak based on activity.
  ///
  /// - Same day: no change
  /// - Next day: increment streak
  /// - Gap > 1 day: reset to 1
  EggStreakResult calculateEggStreakUpdate(EggModel egg, DateTime now) {
    final lastActivity = egg.lastHatchingActivityDate;

    if (lastActivity == null) {
      // First activity with the egg
      return EggStreakResult(
        newStreakDays: 1,
        shouldHatch: 1 >= AppConstants.eggHatchingStreakRequired,
      );
    }

    final diff = calendarDaysBetween(lastActivity, now);

    if (diff <= 0) {
      // Same day -- no change. Negative differences happen after
      // travelling west across timezones; not a broken streak.
      return EggStreakResult(
        newStreakDays: egg.hatchingStreakDays,
        shouldHatch:
            egg.hatchingStreakDays >= AppConstants.eggHatchingStreakRequired,
      );
    } else if (diff == 1) {
      // Consecutive day
      final newStreak = egg.hatchingStreakDays + 1;
      return EggStreakResult(
        newStreakDays: newStreak,
        shouldHatch: newStreak >= AppConstants.eggHatchingStreakRequired,
      );
    } else {
      // Gap -- reset to 1
      return EggStreakResult(
        newStreakDays: 1,
        shouldHatch: false,
        streakBroken: egg.hatchingStreakDays > 1,
      );
    }
  }

  /// Whether the user has earned an egg for a species they don't own yet.
  ///
  /// A mascot reaching [AppConstants.speciesUnlockStage] unlocks the next
  /// species; once every offered species is owned there is nothing left
  /// to hatch.
  bool hasUnlockedNextSpecies(
    List<MascotModel> ownedMascots,
    List<MascotSpeciesModel> allSpecies,
  ) {
    final ownedIds = ownedMascots.map((m) => m.speciesId).toSet();
    if (selectableSpecies(allSpecies).every((s) => ownedIds.contains(s.id))) {
      return false;
    }
    return ownedMascots.any((m) {
      final species = getSpeciesById(m.speciesId, allSpecies);
      return species != null &&
          species.getStageIndexForLevel(m.mascotLevel) >=
              AppConstants.speciesUnlockStage;
    });
  }

  /// Selects a random species for the hatching egg.
  ///
  /// Only currently-offered species (see [selectableSpecies]) can hatch.
  /// Prefers species the user owns none of, then those not yet fully
  /// evolved, then any.
  MascotSpeciesModel selectHatchingSpecies(
    List<MascotModel> ownedMascots,
    List<MascotSpeciesModel> allSpecies,
  ) {
    final rng = Random();

    // Restrict to species currently offered; fall back to the full list
    // if data ever leaves us with none (never hatch nothing).
    final offered = selectableSpecies(allSpecies);
    final pool = offered.isNotEmpty ? offered : allSpecies;

    // A species the user has none of is the one the egg is for.
    final ownedSpeciesIds = ownedMascots.map((m) => m.speciesId).toSet();
    final unowned = pool.where((s) => !ownedSpeciesIds.contains(s.id)).toList();
    if (unowned.isNotEmpty) {
      return unowned[rng.nextInt(unowned.length)];
    }

    // Species IDs that have been fully evolved
    final fullyEvolvedSpeciesIds = ownedMascots
        .where((m) => m.isFullyEvolved)
        .map((m) => m.speciesId)
        .toSet();

    // Prefer species not yet fully evolved
    final candidates = pool
        .where((s) => !fullyEvolvedSpeciesIds.contains(s.id))
        .toList();

    if (candidates.isNotEmpty) {
      return candidates[rng.nextInt(candidates.length)];
    }

    // All species fully evolved -- pick any
    return pool[rng.nextInt(pool.length)];
  }
}
