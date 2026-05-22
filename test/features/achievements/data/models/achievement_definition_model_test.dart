import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';

void main() {
  Map<String, dynamic> sampleJson({
    String id = 'streak_7',
    String category = 'streak',
    Map<String, dynamic>? criteria,
    String? nameJa,
    String? nameEs,
    String? descriptionJa,
    String? descriptionEs,
  }) {
    return {
      'id': id,
      'category': category,
      'iconName': 'local_fire_department',
      'bonusPoints': 150,
      'criteria': criteria ?? {'type': 'streakDays', 'days': 7},
      'nameEn': 'One Week Strong',
      if (nameJa != null) 'nameJa': nameJa,
      if (nameEs != null) 'nameEs': nameEs,
      'descriptionEn': 'Maintain a 7-day streak',
      if (descriptionJa != null) 'descriptionJa': descriptionJa,
      if (descriptionEs != null) 'descriptionEs': descriptionEs,
    };
  }

  group('AchievementDefinition.fromJson', () {
    test('parses required fields and criteria', () {
      final def = AchievementDefinition.fromJson(
        sampleJson(
          nameJa: '一週間連続',
          nameEs: 'Una Semana Firme',
          descriptionJa: '7日間連続の記録を達成する',
          descriptionEs: 'Mantén una racha de 7 días',
        ),
      );

      expect(def.id, 'streak_7');
      expect(def.category, AchievementCategory.streak);
      expect(def.iconName, 'local_fire_department');
      expect(def.bonusPoints, 150);
      expect(def.criteria, isA<StreakDaysCriteria>());
      expect((def.criteria as StreakDaysCriteria).days, 7);
      expect(def.nameJa, '一週間連続');
      expect(def.nameEs, 'Una Semana Firme');
    });

    test('throws FormatException for unknown category', () {
      expect(
        () => AchievementDefinition.fromJson(
          sampleJson(category: 'mythical'),
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws when criteria.type is unknown', () {
      expect(
        () => AchievementDefinition.fromJson(
          sampleJson(criteria: {'type': 'no_such_criterion'}),
        ),
        throwsA(anything),
      );
    });

    test('defaults missing locale strings to empty', () {
      final def = AchievementDefinition.fromJson(sampleJson());
      expect(def.nameJa, '');
      expect(def.nameEs, '');
      expect(def.descriptionJa, '');
      expect(def.descriptionEs, '');
    });
  });

  group('AchievementDefinition.name/description localization', () {
    final def = AchievementDefinition.fromJson(
      sampleJson(
        nameJa: '一週間連続',
        nameEs: 'Una Semana Firme',
        descriptionJa: '7日間連続の記録',
        descriptionEs: 'Una racha de 7 días',
      ),
    );

    test('returns the requested locale string when present', () {
      expect(def.name('en'), 'One Week Strong');
      expect(def.name('ja'), '一週間連続');
      expect(def.name('es'), 'Una Semana Firme');
      expect(def.description('en'), 'Maintain a 7-day streak');
      expect(def.description('ja'), '7日間連続の記録');
      expect(def.description('es'), 'Una racha de 7 días');
    });

    test('falls back to English for unknown locales', () {
      expect(def.name('fr'), 'One Week Strong');
      expect(def.description('de'), 'Maintain a 7-day streak');
    });

    test('falls back to English when the locale string is empty', () {
      final partial = AchievementDefinition.fromJson(sampleJson());
      expect(partial.name('ja'), 'One Week Strong');
      expect(partial.name('es'), 'One Week Strong');
      expect(partial.description('ja'), 'Maintain a 7-day streak');
    });
  });
}
