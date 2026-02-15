import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/helpers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

part 'profile_providers.g.dart';

/// Computed level progress (0.0 to 1.0) from user points.
@riverpod
double levelProgress(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return 0;
  return calculateLevelProgress(user.points);
}

/// Points needed to reach the next level.
@riverpod
int pointsToNextLevel(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return 0;
  return calculatePointsToNextLevel(user.points);
}

/// Current mascot evolution stage (1-4).
@riverpod
int evolutionStage(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return 1;
  return getEvolutionStage(user.level);
}

/// Total CO2 saved across all actions (grams).
/// Reads denormalized field from user doc instead of
/// streaming entire actionLog subcollection.
@riverpod
int totalCo2Saved(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.totalCo2Grams ?? 0;
}

/// Total number of actions logged.
/// Reads denormalized field from user doc.
@riverpod
int totalActionsCount(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.totalActionsCount ?? 0;
}

/// Number of days since the user joined.
@riverpod
int daysSinceJoined(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null || user.createdAt == null) return 0;
  return DateTime.now().difference(user.createdAt!).inDays;
}

/// Current streak bonus multiplier.
@riverpod
double streakBonus(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return 1;
  return calculateStreakBonus(user.currentStreak);
}
