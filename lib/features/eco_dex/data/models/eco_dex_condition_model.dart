import 'package:freezed_annotation/freezed_annotation.dart';

part 'eco_dex_condition_model.freezed.dart';
part 'eco_dex_condition_model.g.dart';

/// Unlock condition for an Eco-Dex entry.
/// Each variant maps to a different user stat check.
@Freezed(unionKey: 'type')
sealed class EcoDexCondition with _$EcoDexCondition {
  /// Unlock after logging N total actions.
  const factory EcoDexCondition.totalActions({
    required int count,
  }) = TotalActionsCondition;

  /// Unlock after logging N actions in a specific category.
  const factory EcoDexCondition.categoryActions({
    required String category,
    required int count,
  }) = CategoryActionsCondition;

  /// Unlock after saving N grams of CO2.
  const factory EcoDexCondition.co2Saved({
    required int grams,
  }) = Co2SavedCondition;

  /// Unlock after maintaining a streak of N days.
  const factory EcoDexCondition.streakDays({
    required int days,
  }) = StreakDaysCondition;

  /// Unlock after reaching user level N.
  const factory EcoDexCondition.levelReached({
    required int level,
  }) = LevelReachedCondition;

  /// Unlock after logging actions related to N distinct SDGs.
  const factory EcoDexCondition.sdgBreadth({
    required int count,
  }) = SdgBreadthCondition;

  /// Unlock after reaching a challenge streak of N days.
  const factory EcoDexCondition.challengeStreak({
    required int days,
  }) = ChallengeStreakCondition;

  /// Unlock after completing a specific multi-day challenge.
  const factory EcoDexCondition.multiDayChallenge({
    required String templateId,
  }) = MultiDayChallengeCondition;

  /// Unlock after viewing N eco-facts.
  const factory EcoDexCondition.ecoFactsViewed({
    required int count,
  }) = EcoFactsViewedCondition;

  /// Unlock after logging actions in N distinct categories.
  const factory EcoDexCondition.categoriesCovered({
    required int count,
  }) = CategoriesCoveredCondition;

  /// Unlock after logging N unique action types.
  const factory EcoDexCondition.uniqueActionsLogged({
    required int count,
  }) = UniqueActionsLoggedCondition;

  /// Unlock when the user has set a display name and photo.
  const factory EcoDexCondition.profileComplete() = ProfileCompleteCondition;

  /// Unlock after discovering N Eco-Dex entries (meta).
  const factory EcoDexCondition.ecodexCount({
    required int count,
  }) = EcodexCountCondition;

  /// Unlock after completing N total challenges (lifetime).
  const factory EcoDexCondition.challengesCompleted({
    required int count,
  }) = ChallengesCompletedCondition;

  /// Unlock after logging N distinct zero-CO2 ("selfless") actions.
  const factory EcoDexCondition.uniqueZeroCo2Actions({
    required int count,
  }) = UniqueZeroCo2ActionsCondition;

  factory EcoDexCondition.fromJson(Map<String, dynamic> json) =>
      _$EcoDexConditionFromJson(json);
}
