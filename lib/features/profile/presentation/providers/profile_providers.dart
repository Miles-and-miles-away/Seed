import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

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
  // Mirror the mascot screens: derive the stage from the ACTIVE mascot's
  // level, not the global account level -- they diverge once a second
  // mascot hatches. Falls back to stage 1 when there is no mascot yet.
  return ref.watch(activeMascotStageProvider);
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
  return calendarDaysBetween(user.createdAt!, ref.watch(clockProvider)());
}
