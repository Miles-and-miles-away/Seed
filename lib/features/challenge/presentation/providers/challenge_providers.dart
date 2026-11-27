import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/data/challenge_templates_data.dart';
import 'package:seed_app/features/challenge/domain/models/active_multi_day_challenge.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/domain/services/challenge_selection_service.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

part 'challenge_providers.g.dart';

/// Loads and caches challenge template data from JSON.
@riverpod
Future<ChallengeTemplateData> challengeTemplateData(Ref ref) =>
    loadChallengeTemplates();

/// Today's challenge based on user ID and recent IDs.
@riverpod
Future<DailyChallengeTemplate?> todayChallenge(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  final now = ref.watch(clockProvider)();
  final data = await ref.watch(challengeTemplateDataProvider.future);

  // Completing a challenge prepends its id to recentChallengeIds,
  // which feeds the deterministic selection below -- without this
  // branch the provider would name a different template for the rest
  // of the day. The completed id is the head of recentChallengeIds.
  final todayKey = formatDateKey(now);
  if (user.challengeCompletedDate == todayKey &&
      user.recentChallengeIds.isNotEmpty) {
    final completedId = user.recentChallengeIds.first;
    for (final template in data.daily) {
      if (template.id == completedId) return template;
    }
  }

  return selectDailyChallenge(
    user.uid,
    now,
    user.recentChallengeIds,
    data.daily,
  );
}

/// Today's challenge with the library action it names.
typedef ChallengeAction = ({
  DailyChallengeTemplate challenge,
  ActionModel? action,
});

/// Null action when the library failed to load or lacks the id in the
/// challenge's category, so the card falls back to naming the category.
@riverpod
AsyncValue<ChallengeAction?> todayChallengeAction(Ref ref) {
  final challenge = ref.watch(todayChallengeProvider).value;
  if (challenge == null) return const AsyncData(null);
  final library = ref.watch(actionLibraryProvider);
  // A refresh keeps the old list, so the card does not blink out.
  if (!library.hasValue && !library.hasError) return const AsyncLoading();
  final action = library.value?.firstWhereOrNull(
    (a) => a.id == challenge.actionId && a.category == challenge.category,
  );
  return AsyncData((challenge: challenge, action: action));
}

/// Whether today's daily challenge is completed.
@riverpod
bool isTodayChallengeCompleted(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;
  final todayKey = formatDateKey(ref.watch(clockProvider)());
  return user.challengeCompletedDate == todayKey;
}

/// Current challenge streak as the user should see it.
///
/// The stored value is only corrected by the next completion, so
/// after a missed day it still holds the old streak; a completion
/// date before yesterday means the streak is already broken.
@riverpod
int challengeStreak(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return 0;
  final completed = user.challengeCompletedDate;
  if (completed.isEmpty) return 0;
  final now = ref.watch(clockProvider)();
  if (completed != formatDateKey(now) &&
      completed != formatDateKey(previousCalendarDay(now))) {
    return 0;
  }
  return user.challengeStreak;
}

/// Active multi-day challenge data.
@riverpod
ActiveMultiDayChallenge? activeMultiDayChallenge(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return ActiveMultiDayChallenge.fromMap(user?.activeMultiDayChallenge);
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
///
/// Kept alive: callers only `read` it, so as autoDispose it was disposed
/// while awaiting the template load and the following `state` write threw.
@Riverpod(keepAlive: true)
class MultiDayChallengeNotifier extends _$MultiDayChallengeNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Starts a multi-day challenge.
  Future<void> startChallenge(String templateId) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    final data = await ref.read(challengeTemplateDataProvider.future);
    final template = data.multiDay.firstWhere((t) => t.id == templateId);

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final firestore = ref.read(firestoreProvider);
      final userRef = firestore
          .collection(AppConstants.collectionUsers)
          .doc(user.uid);
      // Transaction: a blind update could stomp a challenge started
      // concurrently on another device.
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(userRef);
        final active =
            doc.data()?[AppConstants.fieldActiveMultiDayChallenge]
                as Map<String, dynamic>?;
        if (active != null && active.isNotEmpty) {
          throw StateError('A multi-day challenge is already active');
        }
        transaction.update(userRef, {
          AppConstants.fieldActiveMultiDayChallenge: {
            AppConstants.fieldTemplateId: templateId,
            AppConstants.fieldStartDate: Timestamp.fromDate(
              ref.read(clockProvider)(),
            ),
            AppConstants.fieldCurrentDay: 0,
            AppConstants.fieldTargetDays: template.targetDays,
            AppConstants.fieldLastCompletionDate: '',
          },
        });
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
