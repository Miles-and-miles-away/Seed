import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'mascot_model.dart';

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
    @MascotTimestampConverter() required DateTime receivedAt,

    /// Consecutive days of activity since egg receipt.
    @Default(0) int hatchingStreakDays,

    /// Date of last activity that counted toward hatching.
    @MascotTimestampConverter() DateTime? lastHatchingActivityDate,
  }) = _EggModel;

  factory EggModel.fromJson(Map<String, dynamic> json) =>
      _$EggModelFromJson(json);
}
