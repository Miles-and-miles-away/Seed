import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mascot_model.freezed.dart';
part 'mascot_model.g.dart';

/// Represents a user's mascot instance.
///
/// This is stored as a nested object in the user's Firestore document.
/// It contains the user's chosen species, custom name, and equipped items.
@freezed
abstract class MascotModel with _$MascotModel {
  const factory MascotModel({
    /// The species ID of the mascot (e.g., "seed").
    required String speciesId,

    /// The user-given name for the mascot.
    @Default('') String name,

    /// List of equipped cosmetic item IDs (for Phase 4).
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
class MascotTimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const MascotTimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}
