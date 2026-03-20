import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/data/challenge_selection_service.dart';
import 'package:seed_app/features/challenge/data/challenge_templates.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';

part 'challenge_providers.g.dart';

/// Today's challenge based on user ID and recent IDs.
@riverpod
DailyChallengeTemplate? todayChallenge(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  return selectDailyChallenge(
    user.uid,
    DateTime.now(),
    user.recentChallengeIds,
  );
}

/// Whether today's daily challenge is completed.
@riverpod
bool isTodayChallengeCompleted(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;
  final todayKey = formatDateKey(DateTime.now());
  return user.challengeCompletedDate == todayKey;
}

/// Current challenge streak.
@riverpod
int challengeStreak(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.challengeStreak ?? 0;
}

/// Active multi-day challenge data.
@riverpod
Map<String, dynamic> activeMultiDayChallenge(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.activeMultiDayChallenge ?? {};
}

/// Session-scoped flag: has the challenge dialog been
/// shown this session?
@riverpod
class ChallengeDialogShown extends _$ChallengeDialogShown {
  @override
  bool build() => false;

  void markShown() {
    state = true;
  }
}

/// Whether the daily challenge dialog should be shown.
@riverpod
bool shouldShowChallengeDialog(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;
  final completed = ref.watch(isTodayChallengeCompletedProvider);
  final dialogShown = ref.watch(challengeDialogShownProvider);
  return !completed && !dialogShown;
}

/// Notifier for multi-day challenge actions.
@riverpod
class MultiDayChallengeNotifier extends _$MultiDayChallengeNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Starts a multi-day challenge.
  Future<void> startChallenge(String templateId) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final template = multiDayChallengeTemplates.firstWhere(
      (t) => t.id == templateId,
    );

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final firestore = ref.read(firestoreProvider);
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc(user.uid)
          .update({
        'activeMultiDayChallenge': {
          'templateId': templateId,
          'startDate': Timestamp.fromDate(DateTime.now()),
          'currentDay': 0,
          'targetDays': template.targetDays,
          'lastCompletionDate': '',
        },
      });
    });
    if (ref.mounted) state = result;
  }

  /// Abandons the active multi-day challenge.
  Future<void> abandonChallenge() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final firestore = ref.read(firestoreProvider);
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc(user.uid)
          .update({
        'activeMultiDayChallenge': <String, dynamic>{},
      });
    });
    if (ref.mounted) state = result;
  }
}
