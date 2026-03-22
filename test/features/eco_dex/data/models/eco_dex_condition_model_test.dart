import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';

void main() {
  group('EcoDexCondition.fromJson', () {
    test('totalActions', () {
      final c = EcoDexCondition.fromJson({
        'type': 'totalActions',
        'count': 25,
      });
      expect(c, isA<TotalActionsCondition>());
      expect((c as TotalActionsCondition).count, 25);
    });

    test('categoryActions', () {
      final c = EcoDexCondition.fromJson({
        'type': 'categoryActions',
        'category': 'food',
        'count': 10,
      });
      expect(c, isA<CategoryActionsCondition>());
      final ca = c as CategoryActionsCondition;
      expect(ca.category, 'food');
      expect(ca.count, 10);
    });

    test('co2Saved', () {
      final c = EcoDexCondition.fromJson({
        'type': 'co2Saved',
        'grams': 5000,
      });
      expect(c, isA<Co2SavedCondition>());
      expect((c as Co2SavedCondition).grams, 5000);
    });

    test('streakDays', () {
      final c = EcoDexCondition.fromJson({
        'type': 'streakDays',
        'days': 7,
      });
      expect(c, isA<StreakDaysCondition>());
      expect((c as StreakDaysCondition).days, 7);
    });

    test('levelReached', () {
      final c = EcoDexCondition.fromJson({
        'type': 'levelReached',
        'level': 15,
      });
      expect(c, isA<LevelReachedCondition>());
      expect((c as LevelReachedCondition).level, 15);
    });

    test('sdgBreadth', () {
      final c = EcoDexCondition.fromJson({
        'type': 'sdgBreadth',
        'count': 5,
      });
      expect(c, isA<SdgBreadthCondition>());
      expect((c as SdgBreadthCondition).count, 5);
    });

    test('challengeStreak', () {
      final c = EcoDexCondition.fromJson({
        'type': 'challengeStreak',
        'days': 14,
      });
      expect(c, isA<ChallengeStreakCondition>());
      expect((c as ChallengeStreakCondition).days, 14);
    });

    test('multiDayChallenge', () {
      final c = EcoDexCondition.fromJson({
        'type': 'multiDayChallenge',
        'templateId': 'vegan_week',
      });
      expect(c, isA<MultiDayChallengeCondition>());
      expect(
        (c as MultiDayChallengeCondition).templateId,
        'vegan_week',
      );
    });

    test('ecoFactsViewed', () {
      final c = EcoDexCondition.fromJson({
        'type': 'ecoFactsViewed',
        'count': 30,
      });
      expect(c, isA<EcoFactsViewedCondition>());
      expect((c as EcoFactsViewedCondition).count, 30);
    });

    test('categoriesCovered', () {
      final c = EcoDexCondition.fromJson({
        'type': 'categoriesCovered',
        'count': 4,
      });
      expect(c, isA<CategoriesCoveredCondition>());
      expect((c as CategoriesCoveredCondition).count, 4);
    });

    test('uniqueActionsLogged', () {
      final c = EcoDexCondition.fromJson({
        'type': 'uniqueActionsLogged',
        'count': 20,
      });
      expect(c, isA<UniqueActionsLoggedCondition>());
      expect((c as UniqueActionsLoggedCondition).count, 20);
    });

    test('profileComplete', () {
      final c = EcoDexCondition.fromJson({
        'type': 'profileComplete',
      });
      expect(c, isA<ProfileCompleteCondition>());
    });

    test('ecodexCount', () {
      final c = EcoDexCondition.fromJson({
        'type': 'ecodexCount',
        'count': 10,
      });
      expect(c, isA<EcodexCountCondition>());
      expect((c as EcodexCountCondition).count, 10);
    });

    test('challengesCompleted', () {
      final c = EcoDexCondition.fromJson({
        'type': 'challengesCompleted',
        'count': 50,
      });
      expect(c, isA<ChallengesCompletedCondition>());
      expect((c as ChallengesCompletedCondition).count, 50);
    });
  });

  group('EcoDexCondition.toJson roundtrip', () {
    test('totalActions survives roundtrip', () {
      const original = EcoDexCondition.totalActions(count: 25);
      final restored = EcoDexCondition.fromJson(original.toJson());
      expect(restored, original);
    });

    test('categoryActions survives roundtrip', () {
      const original = EcoDexCondition.categoryActions(
        category: 'food',
        count: 10,
      );
      final restored = EcoDexCondition.fromJson(original.toJson());
      expect(restored, original);
    });

    test('profileComplete survives roundtrip', () {
      const original = EcoDexCondition.profileComplete();
      final restored = EcoDexCondition.fromJson(original.toJson());
      expect(restored, original);
    });
  });
}
