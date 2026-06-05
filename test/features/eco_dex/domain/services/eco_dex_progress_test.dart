import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/domain/constants/zero_co2_action_ids.dart';
import 'package:seed_app/features/eco_dex/domain/services/eco_dex_progress.dart';

void main() {
  /// Minimal user with all defaults (zeroed stats).
  AppUserModel baseUser() => const AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

  group('ecoDexProgressOf', () {
    test('totalActions reports current and target', () {
      final user = baseUser().copyWith(totalActionsCount: 7);
      const condition = EcoDexCondition.totalActions(count: 10);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.hasProgress, isTrue);
      expect(progress.current, 7);
      expect(progress.target, 10);
      expect(progress.fraction, closeTo(0.7, 0.001));
    });

    test('clamps current to target when exceeded', () {
      final user = baseUser().copyWith(totalActionsCount: 25);
      const condition = EcoDexCondition.totalActions(count: 10);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 10);
      expect(progress.fraction, 1.0);
    });

    test('categoryActions reads the category counter', () {
      final user = baseUser().copyWith(categoryActionCounts: {'food': 4});
      const condition = EcoDexCondition.categoryActions(
        category: 'food',
        count: 8,
      );

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 4);
      expect(progress.target, 8);
    });

    test('co2Saved reads total grams', () {
      final user = baseUser().copyWith(totalCo2Grams: 500);
      const condition = EcoDexCondition.co2Saved(grams: 1000);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 500);
      expect(progress.target, 1000);
    });

    test('streakDays reads the longest streak', () {
      final user = baseUser().copyWith(longestStreak: 3);
      const condition = EcoDexCondition.streakDays(days: 30);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 3);
      expect(progress.target, 30);
    });

    test('levelReached reads the level', () {
      final user = baseUser().copyWith(level: 2);
      const condition = EcoDexCondition.levelReached(level: 5);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 2);
      expect(progress.target, 5);
    });

    test('sdgBreadth counts distinct SDGs', () {
      final user = baseUser().copyWith(
        sdgStats: {
          '1': {'count': 2},
          '13': {'count': 1},
        },
      );
      const condition = EcoDexCondition.sdgBreadth(count: 17);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 2);
      expect(progress.target, 17);
    });

    test('challengeStreak reads the challenge streak', () {
      final user = baseUser().copyWith(challengeStreak: 2);
      const condition = EcoDexCondition.challengeStreak(days: 7);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 2);
      expect(progress.target, 7);
    });

    test('ecoFactsViewed counts viewed fact dates', () {
      final user = baseUser().copyWith(
        viewedFactDates: ['2026-01-01', '2026-01-02'],
      );
      const condition = EcoDexCondition.ecoFactsViewed(count: 14);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 2);
      expect(progress.target, 14);
    });

    test('categoriesCovered counts non-zero categories', () {
      final user = baseUser().copyWith(
        categoryActionCounts: {'food': 1, 'energy': 3, 'water': 0},
      );
      const condition = EcoDexCondition.categoriesCovered(count: 9);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 2);
      expect(progress.target, 9);
    });

    test('uniqueActionsLogged counts distinct action ids', () {
      final user = baseUser().copyWith(uniqueActionIds: ['a1', 'a2', 'a3']);
      const condition = EcoDexCondition.uniqueActionsLogged(count: 10);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 3);
      expect(progress.target, 10);
    });

    test('ecodexCount counts discovered entries', () {
      final user = baseUser().copyWith(ecodexDiscovered: ['e1', 'e2']);
      const condition = EcoDexCondition.ecodexCount(count: 25);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 2);
      expect(progress.target, 25);
    });

    test('challengesCompleted reads the lifetime counter', () {
      final user = baseUser().copyWith(challengesCompleted: 5);
      const condition = EcoDexCondition.challengesCompleted(count: 10);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 5);
      expect(progress.target, 10);
    });

    test('uniqueZeroCo2Actions counts only selfless actions', () {
      final user = baseUser().copyWith(
        uniqueActionIds: [zeroCo2ActionIds.first, 'not-selfless'],
      );
      const condition = EcoDexCondition.uniqueZeroCo2Actions(count: 21);

      final progress = ecoDexProgressOf(condition, user);

      expect(progress.current, 1);
      expect(progress.target, 21);
    });

    test('profileComplete is binary', () {
      const condition = EcoDexCondition.profileComplete();

      final progress = ecoDexProgressOf(condition, baseUser());

      expect(progress.hasProgress, isFalse);
      expect(progress.fraction, 0);
    });

    test('multiDayChallenge is binary', () {
      const condition = EcoDexCondition.multiDayChallenge(
        templateId: 'md_vegan_week',
      );

      final progress = ecoDexProgressOf(condition, baseUser());

      expect(progress.hasProgress, isFalse);
      expect(progress.fraction, 0);
    });
  });
}
