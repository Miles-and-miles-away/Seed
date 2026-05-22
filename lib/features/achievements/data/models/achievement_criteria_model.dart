import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_criteria_model.freezed.dart';
part 'achievement_criteria_model.g.dart';

/// Unlock criterion for an achievement. Each variant maps to a
/// distinct user-stat check evaluated by the §6.7 checker service.
///
/// The JSON form uses a `type` discriminator that matches each
/// variant's constructor name (e.g. `actionCount`, `streakDays`).
@Freezed(unionKey: 'type')
sealed class AchievementCriteria with _$AchievementCriteria {
  /// Unlock after logging N total actions. When `category` is set,
  /// only actions in that category count.
  const factory AchievementCriteria.actionCount({
    required int count,
    String? category,
  }) = ActionCountCriteria;

  /// Unlock after reaching a daily streak of N days.
  const factory AchievementCriteria.streakDays({
    required int days,
  }) = StreakDaysCriteria;

  /// Unlock after reaching user level N.
  const factory AchievementCriteria.levelReached({
    required int level,
  }) = LevelReachedCriteria;

  /// Unlock after supporting N distinct SDGs.
  const factory AchievementCriteria.sdgCount({
    required int count,
  }) = SdgCountCriteria;

  /// Unlock after saving N grams of CO2.
  const factory AchievementCriteria.co2Saved({
    required int grams,
  }) = Co2SavedCriteria;

  /// Unlock after logging at least one action in N distinct
  /// categories. Used for the Explorer achievement.
  const factory AchievementCriteria.categoriesCovered({
    required int count,
  }) = CategoriesCoveredCriteria;

  /// Unlock on a one-shot event identified by `specialType`
  /// (e.g. `first_action`, `account_created`).
  const factory AchievementCriteria.special({
    required String specialType,
  }) = SpecialCriteria;

  factory AchievementCriteria.fromJson(Map<String, dynamic> json) =>
      _$AchievementCriteriaFromJson(json);
}
