import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user_model.freezed.dart';
part 'app_user_model.g.dart';

/// User model for Firestore serialization/deserialization.
@freezed
abstract class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(0) int points,
    @Default(1) int level,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default('en') String language,
    @Default('09:00') String notificationTime,
    @TimestampConverter() DateTime? createdAt,
    @Default(false) bool emailVerified,
  }) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);
}

/// Converts Firestore Timestamp to/from DateTime.
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}
