import 'package:freezed_annotation/freezed_annotation.dart';

part 'evolution_stage_model.freezed.dart';
part 'evolution_stage_model.g.dart';

/// Represents an evolution stage of a mascot species.
///
/// Each species has multiple evolution stages that are unlocked at
/// certain level thresholds.
@freezed
abstract class EvolutionStageModel with _$EvolutionStageModel {
  const factory EvolutionStageModel({
    /// The level threshold required to reach this stage.
    required int level,

    /// The local asset path to the mascot image for this stage.
    required String assetPath,

    /// The English name of this evolution stage.
    required String nameEn,

    /// The Japanese name of this evolution stage.
    required String nameJa,
  }) = _EvolutionStageModel;

  factory EvolutionStageModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionStageModelFromJson(json);
}
