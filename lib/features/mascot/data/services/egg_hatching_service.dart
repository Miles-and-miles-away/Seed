import 'dart:math';

import 'package:seed_app/core/constants/app_constants.dart';
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
  EggStreakResult calculateEggStreakUpdate(
    EggModel egg,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final lastActivity = egg.lastHatchingActivityDate;

    if (lastActivity == null) {
      // First activity with the egg
      return EggStreakResult(
        newStreakDays: 1,
        shouldHatch: 1 >= AppConstants.eggHatchingStreakRequired,
      );
    }

    final lastDate = DateTime(
      lastActivity.year,
      lastActivity.month,
      lastActivity.day,
    );
    final diff = today.difference(lastDate).inDays;

    if (diff == 0) {
      // Same day -- no change
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

  /// Selects a random species for the hatching egg.
  ///
  /// Prefers species the user hasn't fully evolved yet.
  /// If all are fully evolved, picks any random species.
  MascotSpeciesModel selectHatchingSpecies(
    List<MascotModel> ownedMascots,
    List<MascotSpeciesModel> allSpecies,
  ) {
    final rng = Random();

    // Species IDs that have been fully evolved
    final fullyEvolvedSpeciesIds = ownedMascots
        .where((m) => m.isFullyEvolved)
        .map((m) => m.speciesId)
        .toSet();

    // Prefer species not yet fully evolved
    final candidates = allSpecies
        .where(
          (s) => !fullyEvolvedSpeciesIds.contains(s.id),
        )
        .toList();

    if (candidates.isNotEmpty) {
      return candidates[rng.nextInt(candidates.length)];
    }

    // All species fully evolved -- pick any
    return allSpecies[rng.nextInt(allSpecies.length)];
  }
}
