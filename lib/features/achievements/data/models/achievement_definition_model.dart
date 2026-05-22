import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';

/// Immutable definition for a single achievement, loaded from the
/// bundled `data/app/achievements.json` asset.
///
/// Hand-written rather than Freezed-generated to match the
/// `EcoDexEntry` pattern: small, value-typed, infrequently
/// constructed (one-shot load at app start), and serialized in a
/// single direction (JSON -> Dart only).
class AchievementDefinition {
  const AchievementDefinition({
    required this.id,
    required this.category,
    required this.iconName,
    required this.bonusPoints,
    required this.criteria,
    required this.nameEn,
    required this.nameJa,
    required this.nameEs,
    required this.descriptionEn,
    required this.descriptionJa,
    required this.descriptionEs,
  });

  factory AchievementDefinition.fromJson(Map<String, dynamic> json) {
    final categoryName = json['category'] as String;
    final category = AchievementCategory.fromString(categoryName);
    if (category == null) {
      throw FormatException(
        'Unknown achievement category: $categoryName '
        '(achievement id: ${json['id']})',
      );
    }
    return AchievementDefinition(
      id: json['id'] as String,
      category: category,
      iconName: json['iconName'] as String,
      bonusPoints: json['bonusPoints'] as int,
      criteria: AchievementCriteria.fromJson(
        json['criteria'] as Map<String, dynamic>,
      ),
      nameEn: json['nameEn'] as String,
      nameJa: json['nameJa'] as String? ?? '',
      nameEs: json['nameEs'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String,
      descriptionJa: json['descriptionJa'] as String? ?? '',
      descriptionEs: json['descriptionEs'] as String? ?? '',
    );
  }

  final String id;
  final AchievementCategory category;
  final String iconName;
  final int bonusPoints;
  final AchievementCriteria criteria;
  final String nameEn;
  final String nameJa;
  final String nameEs;
  final String descriptionEn;
  final String descriptionJa;
  final String descriptionEs;

  /// Localized name. Falls back to English when the requested
  /// locale string is missing.
  String name(String locale) => switch (locale) {
        'ja' when nameJa.isNotEmpty => nameJa,
        'es' when nameEs.isNotEmpty => nameEs,
        _ => nameEn,
      };

  /// Localized description. Falls back to English when the
  /// requested locale string is missing.
  String description(String locale) => switch (locale) {
        'ja' when descriptionJa.isNotEmpty => descriptionJa,
        'es' when descriptionEs.isNotEmpty => descriptionEs,
        _ => descriptionEn,
      };
}
