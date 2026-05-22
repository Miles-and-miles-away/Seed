import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';

AchievementUserState _state({
  int totalActionsCount = 0,
  int totalCo2Grams = 0,
  int currentStreak = 0,
  int level = 1,
  Map<String, int>? categoryActionCounts,
  Set<String>? supportedSdgIds,
}) {
  return AchievementUserState(
    totalActionsCount: totalActionsCount,
    totalCo2Grams: totalCo2Grams,
    currentStreak: currentStreak,
    level: level,
    categoryActionCounts: categoryActionCounts ?? const {},
    supportedSdgIds: supportedSdgIds ?? const {},
  );
}

void main() {
  group('numeric criteria', () {
    test('actionCount reports current and target', () {
      final p = achievementProgressOf(
        const AchievementCriteria.actionCount(count: 100),
        _state(totalActionsCount: 42),
      );
      expect(p.hasProgress, isTrue);
      expect(p.current, 42);
      expect(p.target, 100);
      expect(p.fraction, closeTo(0.42, 1e-9));
      expect(p.isComplete, isFalse);
    });

    test('actionCount with category scopes the current value', () {
      final p = achievementProgressOf(
        const AchievementCriteria.actionCount(
          count: 5,
          category: 'recycling',
        ),
        _state(
          totalActionsCount: 200,
          categoryActionCounts: const {'recycling': 3, 'food': 50},
        ),
      );
      expect(p.current, 3);
      expect(p.target, 5);
    });

    test('current is clamped to [0, target]', () {
      final p = achievementProgressOf(
        const AchievementCriteria.actionCount(count: 10),
        _state(totalActionsCount: 100),
      );
      expect(p.current, 10);
      expect(p.fraction, 1.0);
      expect(p.isComplete, isTrue);
    });

    test('streakDays', () {
      final p = achievementProgressOf(
        const AchievementCriteria.streakDays(days: 7),
        _state(currentStreak: 3),
      );
      expect(p.current, 3);
      expect(p.target, 7);
    });

    test('levelReached', () {
      final p = achievementProgressOf(
        const AchievementCriteria.levelReached(level: 25),
        _state(level: 12),
      );
      expect(p.current, 12);
      expect(p.target, 25);
    });

    test('sdgCount counts distinct ids', () {
      final p = achievementProgressOf(
        const AchievementCriteria.sdgCount(count: 17),
        _state(supportedSdgIds: const {'1', '7', '13'}),
      );
      expect(p.current, 3);
      expect(p.target, 17);
    });

    test('co2Saved in grams', () {
      final p = achievementProgressOf(
        const AchievementCriteria.co2Saved(grams: 1000),
        _state(totalCo2Grams: 250),
      );
      expect(p.current, 250);
      expect(p.target, 1000);
    });

    test('categoriesCovered ignores zero-count categories', () {
      final p = achievementProgressOf(
        const AchievementCriteria.categoriesCovered(count: 9),
        _state(
          categoryActionCounts: const {
            'recycling': 2,
            'food': 1,
            'energy': 0,
          },
        ),
      );
      expect(p.current, 2);
      expect(p.target, 9);
    });
  });

  group('special criteria', () {
    test('returns a non-numeric progress with hasProgress=false', () {
      final p = achievementProgressOf(
        const AchievementCriteria.special(specialType: 'first_action'),
        _state(totalActionsCount: 1),
      );
      expect(p.hasProgress, isFalse);
      expect(p.fraction, 0);
      expect(p.isComplete, isFalse);
    });
  });

  group('numeric criteria edge cases', () {
    test('categoriesCovered with an empty map reports zero progress', () {
      final p = achievementProgressOf(
        const AchievementCriteria.categoriesCovered(count: 9),
        _state(),
      );
      expect(p.current, 0);
      expect(p.target, 9);
      expect(p.fraction, 0);
      expect(p.isComplete, isFalse);
    });
  });
}
