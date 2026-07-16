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

    /// The Rive artboard to render for this stage, for `.riv` assets
    /// containing multiple stage artboards (e.g. coral_mascot.riv).
    /// Null falls back to the file's default artboard. Must match the
    /// editor artboard name exactly (case-sensitive).
    String? artboardName,

    /// The Spanish name of this evolution stage.
    @Default('') String nameEs,
  }) = _EvolutionStageModel;

  factory EvolutionStageModel.fromJson(Map<String, dynamic> json) =>
      _$EvolutionStageModelFromJson(json);
}
