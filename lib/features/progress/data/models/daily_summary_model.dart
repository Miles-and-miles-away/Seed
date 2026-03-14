import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/utils/firestore_converters.dart';

part 'daily_summary_model.freezed.dart';
part 'daily_summary_model.g.dart';

/// Daily summary model for Firestore serialization/deserialization.
/// Stored at: users/{userId}/dailySummaries/{YYYY-MM-DD}
@freezed
abstract class DailySummaryModel with _$DailySummaryModel {
  const factory DailySummaryModel({
    /// Date string in YYYY-MM-DD format (document ID)
    required String date,

    /// Number of goals completed today
    @Default(0) int goalCount,

    /// List of completed SDG numbers (1-17, deduplicated)
    @Default([]) List<int> completedSdgs,

    /// Total points earned today
    @Default(0) int totalPoints,

    /// Total CO2 saved in grams today
    @Default(0) int totalCo2Grams,

    /// When this summary was created
    @TimestampConverter() DateTime? createdAt,

    /// When this summary was last updated
    @TimestampConverter() DateTime? updatedAt,
  }) = _DailySummaryModel;

  factory DailySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryModelFromJson(json);
}

// _TimestampConverter replaced by centralized
// TimestampConverter in core/utils/firestore_converters.dart
