import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_model.freezed.dart';
part 'action_model.g.dart';

/// Model representing an eco-friendly action from the action library.
@freezed
abstract class ActionModel with _$ActionModel {
  const factory ActionModel({
    required String id,
    required String nameEn,
    required String nameJa,
    required String category,
    required int points,
    @Default('') String descriptionEn,
    @Default('') String descriptionJa,
    @Default(0) int co2Grams,
    @Default('eco') String iconName,
    @Default([]) List<String> relatedSdgs,
    @Default(false) bool isLearnOnly,
    @Default(true) bool isActive,
    @Default(0) int sortOrder,
  }) = _ActionModel;

  factory ActionModel.fromJson(Map<String, dynamic> json) =>
      _$ActionModelFromJson(json);

  /// Creates an ActionModel from a Firestore document.
  factory ActionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ActionModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }
}

/// Extension to get localized name based on language.
extension ActionModelLocalization on ActionModel {
  /// Returns the action name in the specified language.
  String name(String languageCode) {
    return languageCode == 'ja' ? nameJa : nameEn;
  }

  /// Returns the action description in the specified language.
  String description(String languageCode) {
    return languageCode == 'ja' ? descriptionJa : descriptionEn;
  }
}
