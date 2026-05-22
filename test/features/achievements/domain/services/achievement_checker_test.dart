import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';

AchievementDefinition _def(
  String id,
  AchievementCriteria criteria, {
  int bonusPoints = 100,
  AchievementCategory category = AchievementCategory.action,
}) {
  return AchievementDefinition(
    id: id,
    category: category,
    iconName: 'emoji_events',
    bonusPoints: bonusPoints,
    criteria: criteria,
    nameEn: id,
    nameJa: '',
    nameEs: '',
    descriptionEn: id,
    descriptionJa: '',
    descriptionEs: '',
  );
}

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
  const checker = AchievementChecker();

  group('actionCount', () {
    final def = _def(
      'a10',
      const AchievementCriteria.actionCount(count: 10),
    );

    test('unlocks at threshold', () {
      final result = checker.findNewlyUnlocked(
        definitions: [def],
        alreadyUnlockedIds: const {},
        state: _state(totalActionsCount: 10),
      );
      expect(result.map((d) => d.id), ['a10']);
    });

    test('does not unlock below threshold', () {
      final result = checker.findNewlyUnlocked(
        definitions: [def],
        alreadyUnlockedIds: const {},
        state: _state(totalActionsCount: 9),
      );
      expect(result, isEmpty);
    });

    test('scoped by category when set', () {
      final scoped = _def(
        'recycle5',
        const AchievementCriteria.actionCount(
          count: 5,
          category: 'recycling',
        ),
      );

      expect(
        checker.findNewlyUnlocked(
          definitions: [scoped],
          alreadyUnlockedIds: const {},
          state: _state(
            totalActionsCount: 100,
            categoryActionCounts: const {'food': 50},
          ),
        ),
        isEmpty,
        reason: 'high totals in other categories should not satisfy a '
            'category-scoped actionCount',
      );

      expect(
        checker.findNewlyUnlocked(
          definitions: [scoped],
          alreadyUnlockedIds: const {},
          state: _state(
            categoryActionCounts: const {'recycling': 5},
          ),
        ),
        hasLength(1),
      );
    });
  });

  group('streakDays', () {
    final def = _def(
      'sp',
      const AchievementCriteria.streakDays(days: 3),
      category: AchievementCategory.streak,
    );

    test('unlocks at threshold', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(currentStreak: 3),
        ),
        hasLength(1),
      );
    });

    test('does not unlock below threshold', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(currentStreak: 2),
        ),
        isEmpty,
      );
    });
  });

  group('levelReached', () {
    final def = _def(
      'l5',
      const AchievementCriteria.levelReached(level: 5),
      category: AchievementCategory.level,
    );

    test('unlocks at exact level', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(level: 5),
        ),
        hasLength(1),
      );
    });

    test('unlocks past level (skipped via large action)', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(level: 8),
        ),
        hasLength(1),
        reason: 'a single action awarding many points may skip levels '
            "-- the achievement still fires when the user's new level "
            'meets or exceeds the threshold',
      );
    });
  });

  group('sdgCount', () {
    final def = _def(
      's5',
      const AchievementCriteria.sdgCount(count: 5),
      category: AchievementCategory.sdg,
    );

    test('counts distinct SDG ids', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(supportedSdgIds: const {'1', '2', '3', '4', '5'}),
        ),
        hasLength(1),
      );
    });

    test('does not unlock with fewer distinct SDGs', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(supportedSdgIds: const {'1', '2', '3', '4'}),
        ),
        isEmpty,
      );
    });
  });

  group('co2Saved', () {
    final def = _def(
      'co2_1kg',
      const AchievementCriteria.co2Saved(grams: 1000),
      category: AchievementCategory.milestone,
    );

    test('unlocks at grams threshold', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(totalCo2Grams: 1000),
        ),
        hasLength(1),
      );
    });

    test('does not unlock below threshold', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(totalCo2Grams: 999),
        ),
        isEmpty,
      );
    });
  });

  group('categoriesCovered', () {
    final def = _def(
      'explorer',
      const AchievementCriteria.categoriesCovered(count: 9),
    );

    test('counts categories with at least one action', () {
      final ninety = <String, int>{
        for (final c in [
          'recycling',
          'transport',
          'food',
          'energy',
          'consumption',
          'water',
          'community',
          'advocacy',
          'learning',
        ])
          c: 1,
      };
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(categoryActionCounts: ninety),
        ),
        hasLength(1),
      );
    });

    test('ignores zero-count category keys', () {
      final eightActive = <String, int>{
        'recycling': 1,
        'transport': 1,
        'food': 1,
        'energy': 1,
        'consumption': 1,
        'water': 1,
        'community': 1,
        'advocacy': 1,
        'learning': 0,
      };
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {},
          state: _state(categoryActionCounts: eightActive),
        ),
        isEmpty,
      );
    });
  });

  group('special', () {
    final firstAction = _def(
      'first_action',
      const AchievementCriteria.special(specialType: 'first_action'),
      category: AchievementCategory.special,
      bonusPoints: 50,
    );

    test('unlocks first_action when totalActionsCount is exactly 1', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [firstAction],
          alreadyUnlockedIds: const {},
          state: _state(totalActionsCount: 1),
        ),
        hasLength(1),
      );
    });

    test('does not re-fire first_action on subsequent actions', () {
      expect(
        checker.findNewlyUnlocked(
          definitions: [firstAction],
          alreadyUnlockedIds: const {},
          state: _state(totalActionsCount: 5),
        ),
        isEmpty,
      );
    });

    test('unknown specialType never unlocks', () {
      final unknown = _def(
        'mystery',
        const AchievementCriteria.special(specialType: 'never_defined'),
      );
      expect(
        checker.findNewlyUnlocked(
          definitions: [unknown],
          alreadyUnlockedIds: const {},
          state: _state(totalActionsCount: 1),
        ),
        isEmpty,
      );
    });
  });

  group('alreadyUnlocked filtering', () {
    test('skips ids already in the unlocked set', () {
      final def = _def(
        'a10',
        const AchievementCriteria.actionCount(count: 10),
      );
      expect(
        checker.findNewlyUnlocked(
          definitions: [def],
          alreadyUnlockedIds: const {'a10'},
          state: _state(totalActionsCount: 100),
        ),
        isEmpty,
      );
    });
  });

  group('multiple unlocks in one call', () {
    test('returns every newly-met criterion in catalog order', () {
      final defs = [
        _def('a10', const AchievementCriteria.actionCount(count: 10)),
        _def(
          'sp3',
          const AchievementCriteria.streakDays(days: 3),
          category: AchievementCategory.streak,
        ),
        _def(
          'co2_1kg',
          const AchievementCriteria.co2Saved(grams: 1000),
          category: AchievementCategory.milestone,
        ),
        _def(
          'a500',
          const AchievementCriteria.actionCount(count: 500),
        ),
      ];
      final result = checker.findNewlyUnlocked(
        definitions: defs,
        alreadyUnlockedIds: const {},
        state: _state(
          totalActionsCount: 10,
          totalCo2Grams: 1500,
          currentStreak: 3,
        ),
      );
      expect(result.map((d) => d.id), ['a10', 'sp3', 'co2_1kg']);
    });
  });
}
