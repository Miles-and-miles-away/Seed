import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('isTodayChallengeCompletedProvider', () {
    test('returns false for null user', () async {
      final c = await pumpedContainer([userOverride(null)]);

      expect(c.read(isTodayChallengeCompletedProvider), isFalse);
    });

    test('returns true only when completedDate matches today', () async {
      final todayKey = formatDateKey(DateTime.now());
      final c = await pumpedContainer([
        userOverride(
          AppUserModel(uid: 'u', email: 'e', challengeCompletedDate: todayKey),
        ),
      ]);

      expect(c.read(isTodayChallengeCompletedProvider), isTrue);
    });

    test('returns false for a stale completion date', () async {
      final yesterday = formatDateKey(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      final c = await pumpedContainer([
        userOverride(
          AppUserModel(uid: 'u', email: 'e', challengeCompletedDate: yesterday),
        ),
      ]);

      expect(c.read(isTodayChallengeCompletedProvider), isFalse);
    });
  });

  group('challengeStreakProvider', () {
    test('returns 0 for null user', () async {
      final c = await pumpedContainer([userOverride(null)]);

      expect(c.read(challengeStreakProvider), 0);
    });

    test('returns the stored streak while it is still live', () async {
      final c = await pumpedContainer([
        userOverride(
          AppUserModel(
            uid: 'u',
            email: 'e',
            challengeStreak: 7,
            challengeCompletedDate: formatDateKey(DateTime.now()),
          ),
        ),
      ]);

      expect(c.read(challengeStreakProvider), 7);
    });

    test('shows 0 once a missed day has broken the streak', () async {
      // Stored value is only corrected at the next completion; the
      // display must not keep flattering a dead streak.
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final c = await pumpedContainer([
        userOverride(
          AppUserModel(
            uid: 'u',
            email: 'e',
            challengeStreak: 7,
            challengeCompletedDate: formatDateKey(threeDaysAgo),
          ),
        ),
      ]);

      expect(c.read(challengeStreakProvider), 0);
    });
  });

  group('activeMultiDayChallengeProvider', () {
    test('returns null when user has no active challenge', () async {
      final c = await pumpedContainer([
        userOverride(const AppUserModel(uid: 'u', email: 'e')),
      ]);

      expect(c.read(activeMultiDayChallengeProvider), isNull);
    });

    test('parses active multi-day challenge from the user map', () async {
      final c = await pumpedContainer([
        userOverride(
          const AppUserModel(
            uid: 'u',
            email: 'e',
            activeMultiDayChallenge: {
              'templateId': 'md-1',
              'currentDay': 2,
              'targetDays': 5,
              'lastCompletionDate': '2026-04-18',
            },
          ),
        ),
      ]);

      final active = c.read(activeMultiDayChallengeProvider);
      expect(active, isNotNull);
      expect(active!.templateId, 'md-1');
      expect(active.currentDay, 2);
      expect(active.targetDays, 5);
      expect(active.lastCompletionDate, '2026-04-18');
    });

    test('returns null when templateId is missing', () async {
      final c = await pumpedContainer([
        userOverride(
          const AppUserModel(
            uid: 'u',
            email: 'e',
            activeMultiDayChallenge: {'currentDay': 1},
          ),
        ),
      ]);

      expect(c.read(activeMultiDayChallengeProvider), isNull);
    });
  });

  group('ChallengeDialogShown notifier', () {
    test('defaults to false and flips to true on markShown', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      expect(c.read(challengeDialogShownProvider), isFalse);
      c.read(challengeDialogShownProvider.notifier).markShown();
      expect(c.read(challengeDialogShownProvider), isTrue);
    });
  });

  group('shouldShowChallengeDialogProvider', () {
    test('returns false when no user', () async {
      final c = await pumpedContainer([userOverride(null)]);

      expect(c.read(shouldShowChallengeDialogProvider), isFalse);
    });

    test('returns true when not completed and not yet shown', () async {
      final c = await pumpedContainer([
        userOverride(const AppUserModel(uid: 'u', email: 'e')),
      ]);

      expect(c.read(shouldShowChallengeDialogProvider), isTrue);
    });

    test('returns false after dialog has been shown this session', () async {
      final c = await pumpedContainer([
        userOverride(const AppUserModel(uid: 'u', email: 'e')),
      ]);
      c.listen(shouldShowChallengeDialogProvider, (_, _) {});

      c.read(challengeDialogShownProvider.notifier).markShown();

      expect(c.read(shouldShowChallengeDialogProvider), isFalse);
    });

    test('returns false when challenge already completed today', () async {
      final todayKey = formatDateKey(DateTime.now());
      final c = await pumpedContainer([
        userOverride(
          AppUserModel(uid: 'u', email: 'e', challengeCompletedDate: todayKey),
        ),
      ]);

      expect(c.read(shouldShowChallengeDialogProvider), isFalse);
    });
  });

  group('todayChallengeProvider', () {
    DailyChallengeTemplate t(String id) => DailyChallengeTemplate(
      id: id,
      category: 'transport',
      titleEn: id,
      titleEs: '',
      titleJa: '',
    );

    Future<ProviderContainer> containerWith(AppUserModel user) =>
        pumpedContainer([
          userOverride(user),
          challengeTemplateDataProvider.overrideWith(
            (_) async => ChallengeTemplateData(
              daily: [t('a'), t('b'), t('c')],
              multiDay: const [],
            ),
          ),
        ]);

    test('returns the completed template for the rest of the day', () async {
      // Completion prepends the id to recentChallengeIds, which would
      // otherwise feed back into the deterministic selection and make
      // the provider name a different template after completion.
      final user = AppUserModel(
        uid: 'u',
        email: 'e',
        challengeCompletedDate: formatDateKey(DateTime.now()),
        recentChallengeIds: const ['b'],
      );
      final c = await containerWith(user);

      final challenge = await c.read(todayChallengeProvider.future);

      expect(challenge?.id, 'b');
    });

    test('selects normally when today is not yet completed', () async {
      final user = AppUserModel(
        uid: 'u',
        email: 'e',
        recentChallengeIds: const ['b'],
      );
      final c = await containerWith(user);

      final challenge = await c.read(todayChallengeProvider.future);

      // The recent id is excluded while the day is in progress.
      expect(challenge, isNotNull);
      expect(challenge!.id, isNot('b'));
    });
  });

  group('startChallenge', () {
    MultiDayChallengeTemplate md(String id) => MultiDayChallengeTemplate(
      id: id,
      category: 'transport',
      targetDays: 3,
      titleEn: id,
      titleEs: '',
      titleJa: '',
      descriptionEn: '',
      descriptionEs: '',
      descriptionJa: '',
    );

    test('does not stomp a challenge already active elsewhere', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(AppConstants.collectionUsers).doc('u').set({
        AppConstants.fieldActiveMultiDayChallenge: {
          AppConstants.fieldTemplateId: 'other',
          AppConstants.fieldCurrentDay: 2,
          AppConstants.fieldTargetDays: 5,
          AppConstants.fieldLastCompletionDate: '',
        },
      });

      final c = await pumpedContainer([
        firestoreProvider.overrideWithValue(firestore),
        userOverride(const AppUserModel(uid: 'u', email: 'e')),
        challengeTemplateDataProvider.overrideWith(
          (_) async => ChallengeTemplateData(
            daily: const [],
            multiDay: [md('new-challenge')],
          ),
        ),
      ]);

      await c
          .read(multiDayChallengeProvider.notifier)
          .startChallenge('new-challenge');

      expect(c.read(multiDayChallengeProvider).hasError, isTrue);
      final doc = await firestore
          .collection(AppConstants.collectionUsers)
          .doc('u')
          .get();
      final active =
          doc.data()![AppConstants.fieldActiveMultiDayChallenge]
              as Map<String, dynamic>;
      expect(active[AppConstants.fieldTemplateId], 'other');
    });
  });
}
