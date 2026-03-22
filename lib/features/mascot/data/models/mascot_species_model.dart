import 'package:freezed_annotation/freezed_annotation.dart';

import 'evolution_stage_model.dart';

part 'mascot_species_model.freezed.dart';
part 'mascot_species_model.g.dart';

/// Represents a mascot species definition.
///
/// This is the "template" for mascots. Each species has a name, description,
/// and a set of evolution stages. This data is stored in the `mascotSpecies`
/// Firestore collection and is read-only for users.
@freezed
abstract class MascotSpeciesModel with _$MascotSpeciesModel {
  const factory MascotSpeciesModel({
    /// Unique identifier for the species (e.g., "seed").
    required String id,

    /// English name of the species.
    required String nameEn,

    /// Japanese name of the species.
    required String nameJa,

    /// English description of the species.
    required String descriptionEn,

    /// Japanese description of the species.
    required String descriptionJa,

    /// The evolution stages for this species, ordered by level threshold.
    required List<EvolutionStageModel> evolutionStages,

    /// Spanish name of the species.
    @Default('') String nameEs,

    /// Spanish description of the species.
    @Default('') String descriptionEs,

    /// Availability: 'free', 'premium', or a number (points cost to unlock).
    @Default('free') String availability,
  }) = _MascotSpeciesModel;

  factory MascotSpeciesModel.fromJson(Map<String, dynamic> json) =>
      _$MascotSpeciesModelFromJson(json);
}

/// Extension to provide convenience methods on [MascotSpeciesModel].
extension MascotSpeciesModelX on MascotSpeciesModel {
  /// Gets the localized name based on the given locale.
  String name(String locale) => switch (locale) {
        'ja' => nameJa,
        'es' when nameEs.isNotEmpty => nameEs,
        _ => nameEn,
      };

  /// Gets the localized description based on the given locale.
  String description(String locale) => switch (locale) {
        'ja' => descriptionJa,
        'es' when descriptionEs.isNotEmpty => descriptionEs,
        _ => descriptionEn,
      };

  /// Gets the evolution stage for a given level.
  EvolutionStageModel getStageForLevel(int level) {
    // Find the highest stage the user has reached
    var currentStage = evolutionStages.first;
    for (final stage in evolutionStages) {
      if (level >= stage.level) {
        currentStage = stage;
      } else {
        break;
      }
    }
    return currentStage;
  }

  /// Gets the stage index (1-based) for a given level.
  int getStageIndexForLevel(int level) {
    var index = 1;
    for (var i = 0; i < evolutionStages.length; i++) {
      if (level >= evolutionStages[i].level) {
        index = i + 1;
      } else {
        break;
      }
    }
    return index;
  }

  /// Gets the next evolution stage, or null if at max.
  EvolutionStageModel? getNextStage(int currentLevel) {
    for (final stage in evolutionStages) {
      if (stage.level > currentLevel) {
        return stage;
      }
    }
    return null;
  }
}
