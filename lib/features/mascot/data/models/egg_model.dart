import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/utils/firestore_converters.dart';

part 'egg_model.freezed.dart';
part 'egg_model.g.dart';

/// Represents a pending egg waiting to hatch.
///
/// Stored on the user document. The egg hatches after 30
/// consecutive days of activity from when it was received.
@freezed
abstract class EggModel with _$EggModel {
  const factory EggModel({
    /// When the egg was received.
    @RequiredTimestampConverter() required DateTime receivedAt,

    /// Consecutive days of activity since egg receipt.
    @Default(0) int hatchingStreakDays,

    /// Date of last activity that counted toward hatching.
    @TimestampConverter() DateTime? lastHatchingActivityDate,
  }) = _EggModel;

  factory EggModel.fromJson(Map<String, dynamic> json) =>
      _$EggModelFromJson(json);
}
