import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/data/challenge_templates_data.dart';
import 'package:seed_app/features/challenge/domain/models/active_multi_day_challenge.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/domain/services/challenge_selection_service.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';

part 'challenge_providers.g.dart';

/// Loads and caches challenge template data from JSON.
@riverpod
Future<ChallengeTemplateData> challengeTemplateData(
  Ref ref,
) =>
    loadChallengeTemplates();

/// Today's challenge based on user ID and recent IDs.
@riverpod
Future<DailyChallengeTemplate?> todayChallenge(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  final data = await ref.watch(
    challengeTemplateDataProvider.future,
  );
  return selectDailyChallenge(
    user.uid,
    DateTime.now(),
    user.recentChallengeIds,
    data.daily,
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
ActiveMultiDayChallenge? activeMultiDayChallenge(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return ActiveMultiDayChallenge.fromMap(
    user?.activeMultiDayChallenge,
  );
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

    final data = await ref.read(
      challengeTemplateDataProvider.future,
    );
    final template = data.multiDay.firstWhere(
      (t) => t.id == templateId,
    );

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final firestore = ref.read(firestoreProvider);
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc(user.uid)
          .update({
        AppConstants.fieldActiveMultiDayChallenge: {
          AppConstants.fieldTemplateId: templateId,
          AppConstants.fieldStartDate: Timestamp.fromDate(DateTime.now()),
          AppConstants.fieldCurrentDay: 0,
          AppConstants.fieldTargetDays: template.targetDays,
          AppConstants.fieldLastCompletionDate: '',
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
        AppConstants.fieldActiveMultiDayChallenge: <String, dynamic>{},
      });
    });
    if (ref.mounted) state = result;
  }
}
