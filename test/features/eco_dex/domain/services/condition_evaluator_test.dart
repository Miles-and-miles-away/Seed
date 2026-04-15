import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/domain/constants/zero_co2_action_ids.dart';
import 'package:seed_app/features/eco_dex/domain/services/condition_evaluator.dart';

void main() {
  /// Minimal user with all defaults (zeroed stats).
  AppUserModel baseUser() => const AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

  group('isConditionMet', () {
    // ---------------------------------------------------------------
    // TotalActionsCondition
    // ---------------------------------------------------------------
    group('totalActions', () {
      const condition = EcoDexCondition.totalActions(count: 10);

      test('false when below threshold', () {
        final user = baseUser().copyWith(totalActionsCount: 9);
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when exactly at threshold', () {
        final user = baseUser().copyWith(totalActionsCount: 10);
        expect(isConditionMet(condition, user), isTrue);
      });

      test('true when above threshold', () {
        final user = baseUser().copyWith(totalActionsCount: 25);
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // CategoryActionsCondition
    // ---------------------------------------------------------------
    group('categoryActions', () {
      const condition = EcoDexCondition.categoryActions(
        category: 'food',
        count: 5,
      );

      test('false when category missing', () {
        expect(isConditionMet(condition, baseUser()), isFalse);
      });

      test('false when below threshold', () {
        final user = baseUser().copyWith(
          categoryActionCounts: {'food': 4},
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(
          categoryActionCounts: {'food': 5},
        );
        expect(isConditionMet(condition, user), isTrue);
      });

      test('ignores other categories', () {
        final user = baseUser().copyWith(
          categoryActionCounts: {'energy': 100},
        );
        expect(isConditionMet(condition, user), isFalse);
      });
    });

    // ---------------------------------------------------------------
    // Co2SavedCondition
    // ---------------------------------------------------------------
    group('co2Saved', () {
      const condition = EcoDexCondition.co2Saved(grams: 5000);

      test('false when below', () {
        final user = baseUser().copyWith(totalCo2Grams: 4999);
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(totalCo2Grams: 5000);
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // StreakDaysCondition
    // ---------------------------------------------------------------
    group('streakDays', () {
      const condition = EcoDexCondition.streakDays(days: 7);

      test('false when below', () {
        final user = baseUser().copyWith(longestStreak: 6);
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(longestStreak: 7);
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // LevelReachedCondition
    // ---------------------------------------------------------------
    group('levelReached', () {
      const condition = EcoDexCondition.levelReached(level: 10);

      test('false when below', () {
        final user = baseUser().copyWith(level: 9);
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(level: 10);
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // SdgBreadthCondition
    // ---------------------------------------------------------------
    group('sdgBreadth', () {
      const condition = EcoDexCondition.sdgBreadth(count: 3);

      test('false when below', () {
        final user = baseUser().copyWith(
          sdgStats: {
            '1': {'count': 1, 'co2': 100},
            '2': {'count': 2, 'co2': 200},
          },
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(
          sdgStats: {
            '1': {'count': 1, 'co2': 100},
            '2': {'count': 2, 'co2': 200},
            '7': {'count': 1, 'co2': 50},
          },
        );
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // ChallengeStreakCondition
    // ---------------------------------------------------------------
    group('challengeStreak', () {
      const condition = EcoDexCondition.challengeStreak(days: 5);

      test('false when below', () {
        final user = baseUser().copyWith(challengeStreak: 4);
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(challengeStreak: 5);
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // MultiDayChallengeCondition
    // ---------------------------------------------------------------
    group('multiDayChallenge', () {
      const condition = EcoDexCondition.multiDayChallenge(
        templateId: 'vegan_week',
      );

      test('false when not completed', () {
        expect(isConditionMet(condition, baseUser()), isFalse);
      });

      test('false when different challenge completed', () {
        final user = baseUser().copyWith(
          completedMultiDayChallenges: ['zero_waste_week'],
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when specific challenge completed', () {
        final user = baseUser().copyWith(
          completedMultiDayChallenges: ['vegan_week'],
        );
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // EcoFactsViewedCondition
    // ---------------------------------------------------------------
    group('ecoFactsViewed', () {
      const condition = EcoDexCondition.ecoFactsViewed(count: 3);

      test('false when below', () {
        final user = baseUser().copyWith(
          viewedFactDates: ['2026-01-01', '2026-01-02'],
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(
          viewedFactDates: [
            '2026-01-01',
            '2026-01-02',
            '2026-01-03',
          ],
        );
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // CategoriesCoveredCondition
    // ---------------------------------------------------------------
    group('categoriesCovered', () {
      const condition = EcoDexCondition.categoriesCovered(count: 3);

      test('false when below', () {
        final user = baseUser().copyWith(
          categoryActionCounts: {'food': 5, 'energy': 2},
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('ignores categories with zero count', () {
        final user = baseUser().copyWith(
          categoryActionCounts: {'food': 5, 'energy': 0, 'water': 3},
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(
          categoryActionCounts: {
            'food': 5,
            'energy': 2,
            'water': 1,
          },
        );
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // UniqueActionsLoggedCondition
    // ---------------------------------------------------------------
    group('uniqueActionsLogged', () {
      const condition = EcoDexCondition.uniqueActionsLogged(count: 5);

      test('false when below', () {
        final user = baseUser().copyWith(
          uniqueActionIds: ['a1', 'a2', 'a3', 'a4'],
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(
          uniqueActionIds: ['a1', 'a2', 'a3', 'a4', 'a5'],
        );
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // ProfileCompleteCondition
    // ---------------------------------------------------------------
    group('profileComplete', () {
      const condition = EcoDexCondition.profileComplete();

      test('false when both null', () {
        expect(isConditionMet(condition, baseUser()), isFalse);
      });

      test('false when only displayName set', () {
        final user = baseUser().copyWith(displayName: 'Test');
        expect(isConditionMet(condition, user), isFalse);
      });

      test('false when only photoUrl set', () {
        final user = baseUser().copyWith(photoUrl: 'https://x.com/a.png');
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when both set', () {
        final user = baseUser().copyWith(
          displayName: 'Test',
          photoUrl: 'https://x.com/a.png',
        );
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // EcodexCountCondition
    // ---------------------------------------------------------------
    group('ecodexCount', () {
      const condition = EcoDexCondition.ecodexCount(count: 10);

      test('false when below', () {
        final user = baseUser().copyWith(
          ecodexDiscovered: List.generate(9, (i) => 'entry_$i'),
        );
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(
          ecodexDiscovered: List.generate(10, (i) => 'entry_$i'),
        );
        expect(isConditionMet(condition, user), isTrue);
      });
    });

    // ---------------------------------------------------------------
    // ChallengesCompletedCondition
    // ---------------------------------------------------------------
    group('challengesCompleted', () {
      const condition = EcoDexCondition.challengesCompleted(count: 10);

      test('false when below', () {
        final user = baseUser().copyWith(challengesCompleted: 9);
        expect(isConditionMet(condition, user), isFalse);
      });

      test('true when at threshold', () {
        final user = baseUser().copyWith(challengesCompleted: 10);
        expect(isConditionMet(condition, user), isTrue);
      });
    });
  });

  // -----------------------------------------------------------------
  // Helper functions
  // -----------------------------------------------------------------
  group('categoryActionCount', () {
    test('returns 0 for missing category', () {
      expect(categoryActionCount(baseUser(), 'food'), 0);
    });

    test('returns count for present category', () {
      final user = baseUser().copyWith(
        categoryActionCounts: {'food': 12},
      );
      expect(categoryActionCount(user, 'food'), 12);
    });
  });

  group('sdgBreadthCount', () {
    test('returns 0 for empty sdgStats', () {
      expect(sdgBreadthCount(baseUser()), 0);
    });

    test('returns distinct SDG count', () {
      final user = baseUser().copyWith(
        sdgStats: {
          '1': {'count': 1, 'co2': 100},
          '3': {'count': 2, 'co2': 200},
          '13': {'count': 5, 'co2': 500},
        },
      );
      expect(sdgBreadthCount(user), 3);
    });
  });

  group('categoriesCoveredCount', () {
    test('returns 0 for empty counts', () {
      expect(categoriesCoveredCount(baseUser()), 0);
    });

    test('excludes zero-count categories', () {
      final user = baseUser().copyWith(
        categoryActionCounts: {'food': 5, 'energy': 0, 'water': 3},
      );
      expect(categoriesCoveredCount(user), 2);
    });
  });

  group('uniqueZeroCo2Actions', () {
    const tier1 = EcoDexCondition.uniqueZeroCo2Actions(count: 1);
    const tier2 = EcoDexCondition.uniqueZeroCo2Actions(count: 21);

    test('false when user has logged no actions', () {
      expect(isConditionMet(tier1, baseUser()), isFalse);
      expect(isConditionMet(tier2, baseUser()), isFalse);
    });

    test('false when only non-zero-CO2 actions logged', () {
      final user = baseUser().copyWith(
        uniqueActionIds: const [
          'recycle_aluminum_can',
          'skip_high_impact_food',
        ],
      );
      expect(isConditionMet(tier1, user), isFalse);
      expect(isConditionMet(tier2, user), isFalse);
    });

    test('tier 1 unlocks on first zero-CO2 action', () {
      final user = baseUser().copyWith(
        uniqueActionIds: const ['beach_cleanup'],
      );
      expect(isConditionMet(tier1, user), isTrue);
      expect(isConditionMet(tier2, user), isFalse);
    });

    test('tier 1 true, tier 2 false with mixed logs', () {
      final user = baseUser().copyWith(
        uniqueActionIds: const [
          'beach_cleanup',
          'sign_petition',
          'recycle_aluminum_can',
        ],
      );
      expect(isConditionMet(tier1, user), isTrue);
      expect(isConditionMet(tier2, user), isFalse);
    });

    test('tier 2 unlocks when all zero-CO2 actions logged', () {
      final user = baseUser().copyWith(
        uniqueActionIds: zeroCo2ActionIds.toList(),
      );
      expect(isConditionMet(tier1, user), isTrue);
      expect(isConditionMet(tier2, user), isTrue);
    });

    test('zeroCo2ActionIds set has 21 entries', () {
      // Guards against silent drift from seed_action_library.js.
      expect(zeroCo2ActionIds, hasLength(21));
    });
  });
}
