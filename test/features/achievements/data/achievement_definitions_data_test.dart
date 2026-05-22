import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/achievements/data/achievement_definitions_data.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<AchievementDefinition> defs;

  setUpAll(() async {
    defs = await loadAchievementDefinitions();
  });

  group('loadAchievementDefinitions', () {
    test('loads 19 achievements', () {
      expect(defs.length, 19);
    });

    test('all ids are unique', () {
      final ids = defs.map((d) => d.id).toSet();
      expect(ids.length, defs.length);
    });

    test('category distribution matches PLAN_PHASE_6 §6.6', () {
      int countWhere(AchievementCategory c) =>
          defs.where((d) => d.category == c).length;
      expect(countWhere(AchievementCategory.special), 2);
      expect(countWhere(AchievementCategory.action), 5);
      expect(countWhere(AchievementCategory.streak), 4);
      expect(countWhere(AchievementCategory.level), 3);
      expect(countWhere(AchievementCategory.sdg), 2);
      expect(countWhere(AchievementCategory.milestone), 3);
    });

    test('every entry has non-empty EN copy', () {
      for (final d in defs) {
        expect(d.nameEn, isNotEmpty, reason: 'nameEn empty for ${d.id}');
        expect(
          d.descriptionEn,
          isNotEmpty,
          reason: 'descriptionEn empty for ${d.id}',
        );
      }
    });

    test('every entry has non-empty JA copy', () {
      for (final d in defs) {
        expect(d.nameJa, isNotEmpty, reason: 'nameJa empty for ${d.id}');
        expect(
          d.descriptionJa,
          isNotEmpty,
          reason: 'descriptionJa empty for ${d.id}',
        );
      }
    });

    test('every entry has non-empty ES copy', () {
      for (final d in defs) {
        expect(d.nameEs, isNotEmpty, reason: 'nameEs empty for ${d.id}');
        expect(
          d.descriptionEs,
          isNotEmpty,
          reason: 'descriptionEs empty for ${d.id}',
        );
      }
    });

    test('every entry has an iconName and positive bonusPoints', () {
      for (final d in defs) {
        expect(d.iconName, isNotEmpty, reason: 'iconName empty for ${d.id}');
        expect(
          d.bonusPoints,
          greaterThan(0),
          reason: 'bonusPoints not positive for ${d.id}',
        );
      }
    });

    test('streak achievements increase monotonically', () {
      final streakDays = defs
          .where((d) => d.id.startsWith('streak_'))
          .map((d) => int.parse(d.id.substring('streak_'.length)))
          .toList()
        ..sort();
      expect(streakDays, [7, 30, 100, 365]);
    });

    test('co2 milestone grams increase monotonically', () {
      final grams = defs
          .where((d) => d.criteria is Co2SavedCriteria)
          .map((d) => (d.criteria as Co2SavedCriteria).grams)
          .toList()
        ..sort();
      expect(grams, [1000, 100000, 1000000]);
    });

    test('try_all_categories.count matches the ActionCategory enum size', () {
      final explorer = defs.firstWhere((d) => d.id == 'try_all_categories');
      expect(
        (explorer.criteria as CategoriesCoveredCriteria).count,
        ActionCategory.values.length,
        reason:
            'try_all_categories.count must equal ActionCategory.values.length',
      );
    });

    test('actionCount.category, when set, is a real ActionCategory', () {
      final validNames = ActionCategory.values.map((c) => c.name).toSet();
      for (final d in defs) {
        final c = d.criteria;
        if (c is ActionCountCriteria && c.category != null) {
          expect(
            validNames,
            contains(c.category),
            reason: '${d.id}: unknown category "${c.category}"',
          );
        }
      }
    });
  });
}
