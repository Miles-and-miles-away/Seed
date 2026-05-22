import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';

void main() {
  group('AchievementCriteria.fromJson', () {
    test('decodes actionCount with optional category', () {
      final base = AchievementCriteria.fromJson({
        'type': 'actionCount',
        'count': 10,
      });
      expect(base, isA<ActionCountCriteria>());
      expect((base as ActionCountCriteria).count, 10);
      expect(base.category, isNull);

      final scoped = AchievementCriteria.fromJson({
        'type': 'actionCount',
        'count': 25,
        'category': 'recycling',
      });
      expect((scoped as ActionCountCriteria).category, 'recycling');
    });

    test('decodes streakDays', () {
      final c = AchievementCriteria.fromJson({
        'type': 'streakDays',
        'days': 30,
      });
      expect(c, isA<StreakDaysCriteria>());
      expect((c as StreakDaysCriteria).days, 30);
    });

    test('decodes levelReached', () {
      final c = AchievementCriteria.fromJson({
        'type': 'levelReached',
        'level': 5,
      });
      expect((c as LevelReachedCriteria).level, 5);
    });

    test('decodes sdgCount', () {
      final c = AchievementCriteria.fromJson({
        'type': 'sdgCount',
        'count': 17,
      });
      expect((c as SdgCountCriteria).count, 17);
    });

    test('decodes co2Saved', () {
      final c = AchievementCriteria.fromJson({
        'type': 'co2Saved',
        'grams': 1000000,
      });
      expect((c as Co2SavedCriteria).grams, 1000000);
    });

    test('decodes categoriesCovered', () {
      final c = AchievementCriteria.fromJson({
        'type': 'categoriesCovered',
        'count': 9,
      });
      expect((c as CategoriesCoveredCriteria).count, 9);
    });

    test('decodes special', () {
      final c = AchievementCriteria.fromJson({
        'type': 'special',
        'specialType': 'first_action',
      });
      expect((c as SpecialCriteria).specialType, 'first_action');
    });

    test('round-trips through toJson for every variant', () {
      final cases = <AchievementCriteria>[
        const AchievementCriteria.actionCount(count: 10),
        const AchievementCriteria.actionCount(count: 5, category: 'food'),
        const AchievementCriteria.streakDays(days: 7),
        const AchievementCriteria.levelReached(level: 25),
        const AchievementCriteria.sdgCount(count: 5),
        const AchievementCriteria.co2Saved(grams: 1000),
        const AchievementCriteria.categoriesCovered(count: 9),
        const AchievementCriteria.special(specialType: 'first_action'),
      ];
      for (final c in cases) {
        final round = AchievementCriteria.fromJson(c.toJson());
        expect(round, c, reason: 'round-trip failed for ${c.toJson()}');
      }
    });
  });
}
