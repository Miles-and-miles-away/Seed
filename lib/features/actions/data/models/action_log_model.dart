import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/utils/firestore_converters.dart';

part 'action_log_model.freezed.dart';
part 'action_log_model.g.dart';

/// Model representing a logged action by a user.
@freezed
abstract class ActionLogModel with _$ActionLogModel {
  const factory ActionLogModel({
    required String id,
    required String actionId,
    required String actionName,
    required String category,
    required int points,
    @RequiredTimestampConverter() required DateTime loggedAt,
    @Default(0) int co2Grams,
    String? note,
    @Default([]) List<String> relatedSdgs,
  }) = _ActionLogModel;

  factory ActionLogModel.fromJson(Map<String, dynamic> json) =>
      _$ActionLogModelFromJson(json);

  /// Creates an ActionLogModel from a Firestore document.
  factory ActionLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ActionLogModel.fromJson({'id': doc.id, ...data});
  }
}

// RequiredTimestampConverter is now in
// core/utils/firestore_converters.dart
