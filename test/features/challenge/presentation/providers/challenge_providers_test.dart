import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';

ProviderContainer _container(AppUserModel? user) {
  return ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
    ],
  );
}

Future<void> _pump(ProviderContainer c) async {
  c.listen(currentUserProvider, (_, __) {});
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('isTodayChallengeCompletedProvider', () {
    test('returns false for null user', () async {
      final c = _container(null);
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(isTodayChallengeCompletedProvider), isFalse);
    });

    test('returns true only when completedDate matches today', () async {
      final todayKey = formatDateKey(DateTime.now());
      final c = _container(
        AppUserModel(
          uid: 'u',
          email: 'e',
          challengeCompletedDate: todayKey,
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(isTodayChallengeCompletedProvider), isTrue);
    });

    test('returns false for a stale completion date', () async {
      final yesterday =
          formatDateKey(DateTime.now().subtract(const Duration(days: 1)));
      final c = _container(
        AppUserModel(
          uid: 'u',
          email: 'e',
          challengeCompletedDate: yesterday,
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(isTodayChallengeCompletedProvider), isFalse);
    });
  });

  group('challengeStreakProvider', () {
    test('returns 0 for null user', () async {
      final c = _container(null);
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(challengeStreakProvider), 0);
    });

    test('returns user.challengeStreak', () async {
      final c = _container(
        const AppUserModel(uid: 'u', email: 'e', challengeStreak: 7),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(challengeStreakProvider), 7);
    });
  });

  group('activeMultiDayChallengeProvider', () {
    test('returns null when user has no active challenge', () async {
      final c = _container(const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(activeMultiDayChallengeProvider), isNull);
    });

    test('parses active multi-day challenge from the user map', () async {
      final c = _container(
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
      );
      addTearDown(c.dispose);
      await _pump(c);

      final active = c.read(activeMultiDayChallengeProvider);
      expect(active, isNotNull);
      expect(active!.templateId, 'md-1');
      expect(active.currentDay, 2);
      expect(active.targetDays, 5);
      expect(active.lastCompletionDate, '2026-04-18');
    });

    test('returns null when templateId is missing', () async {
      final c = _container(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          activeMultiDayChallenge: {'currentDay': 1},
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

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
      final c = _container(null);
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(shouldShowChallengeDialogProvider), isFalse);
    });

    test('returns true when not completed and not yet shown', () async {
      final c = _container(const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(shouldShowChallengeDialogProvider), isTrue);
    });

    test('returns false after dialog has been shown this session', () async {
      final c = _container(const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(c.dispose);
      c.listen(shouldShowChallengeDialogProvider, (_, __) {});
      await _pump(c);

      c.read(challengeDialogShownProvider.notifier).markShown();

      expect(c.read(shouldShowChallengeDialogProvider), isFalse);
    });

    test('returns false when challenge already completed today', () async {
      final todayKey = formatDateKey(DateTime.now());
      final c = _container(
        AppUserModel(
          uid: 'u',
          email: 'e',
          challengeCompletedDate: todayKey,
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(shouldShowChallengeDialogProvider), isFalse);
    });
  });
}
