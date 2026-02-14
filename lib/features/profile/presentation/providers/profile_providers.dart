import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
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

/// Total CO₂ saved across all actions (in grams).
@riverpod
Stream<int> totalCo2Saved(Ref ref) async* {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    yield 0;
    return;
  }

  final firestore = ref.watch(firestoreProvider);

  yield* firestore
      .collection(AppConstants.collectionUsers)
      .doc(user.uid)
      .collection(AppConstants.collectionActionLog)
      .snapshots()
      .map((snapshot) {
    var total = 0;
    for (final doc in snapshot.docs) {
      final co2 = doc.data()['co2Grams'] as int? ?? 0;
      total += co2;
    }
    return total;
  });
}

/// Total number of actions logged.
@riverpod
Stream<int> totalActionsCount(Ref ref) async* {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    yield 0;
    return;
  }

  final firestore = ref.watch(firestoreProvider);

  yield* firestore
      .collection(AppConstants.collectionUsers)
      .doc(user.uid)
      .collection(AppConstants.collectionActionLog)
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
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
