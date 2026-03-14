import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

export 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

/// Converts Firestore Timestamp to/from nullable DateTime.
class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Timestamp? timestamp) => timestamp?.toDate();

  @override
  Timestamp? toJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;
}

/// Converts Firestore Timestamp to/from non-nullable DateTime.
class RequiredTimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const RequiredTimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
