import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/utils/firestore_converters.dart';

part 'mascot_model.freezed.dart';
part 'mascot_model.g.dart';

/// Represents a user's mascot instance.
///
/// Stored in the user's `mascots` array in Firestore.
/// Each mascot has its own identity, progression, and evolution state.
@freezed
abstract class MascotModel with _$MascotModel {
  const factory MascotModel({
    /// Unique mascot instance ID.
    required String id,

    /// The species ID of the mascot (e.g., "seed").
    required String speciesId,

    /// The user-given name for the mascot.
    @Default('') String name,

    /// Points earned by this mascot for its evolution.
    @Default(0) int mascotPoints,

    /// Level computed from mascotPoints.
    @Default(1) int mascotLevel,

    /// Total CO2 (grams) collected together with the user while this mascot
    /// was active. Accrues for the mascot's whole life -- including after it
    /// is fully evolved -- so the "collected together" stat keeps growing.
    @Default(0) int co2SavedGrams,

    /// Whether this mascot has reached max evolution (level >= 50).
    @Default(false) bool isFullyEvolved,

    /// List of equipped cosmetic item IDs.
    @Default([]) List<String> equippedItems,

    /// When this mascot was created.
    @TimestampConverter() DateTime? createdAt,

    /// The last seen evolution stage (to detect new evolutions).
    @Default(1) int lastSeenStage,
  }) = _MascotModel;

  factory MascotModel.fromJson(Map<String, dynamic> json) =>
      _$MascotModelFromJson(json);
}

// MascotTimestampConverter replaced by centralized
// TimestampConverter in core/utils/firestore_converters.dart
typedef MascotTimestampConverter = TimestampConverter;
