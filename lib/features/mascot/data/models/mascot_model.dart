import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

    /// Whether this mascot has reached max evolution (level >= 50).
    @Default(false) bool isFullyEvolved,

    /// List of equipped cosmetic item IDs.
    @Default([]) List<String> equippedItems,

    /// When this mascot was created.
    @MascotTimestampConverter() DateTime? createdAt,

    /// The last seen evolution stage (to detect new evolutions).
    @Default(1) int lastSeenStage,
  }) = _MascotModel;

  factory MascotModel.fromJson(Map<String, dynamic> json) =>
      _$MascotModelFromJson(json);
}

/// Converts Firestore Timestamp to/from DateTime for mascot model.
class MascotTimestampConverter
    implements JsonConverter<DateTime?, Timestamp?> {
  const MascotTimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) =>
      timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}
