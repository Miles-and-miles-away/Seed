import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/achievements/data/datasources/achievements_remote_datasource.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/data/repositories/achievements_repository.dart';

void main() {
  AchievementDefinition def(String id) => AchievementDefinition(
        id: id,
        category: AchievementCategory.special,
        iconName: 'rocket_launch',
        bonusPoints: 50,
        criteria: const AchievementCriteria.special(
          specialType: 'first_action',
        ),
        nameEn: id,
        nameJa: '',
        nameEs: '',
        descriptionEn: id,
        descriptionJa: '',
        descriptionEs: '',
      );

  late AchievementsRepository repository;
  late int loaderCallCount;

  setUp(() {
    final fake = FakeFirebaseFirestore();
    loaderCallCount = 0;
    repository = AchievementsRepository(
      remoteDataSource: AchievementsRemoteDataSourceImpl(firestore: fake),
      definitionsLoader: () async {
        loaderCallCount++;
        return [def('first_action'), def('joined_seed')];
      },
    );
  });

  group('getDefinitions', () {
    test('returns injected catalog', () async {
      final result = await repository.getDefinitions();
      expect(result.map((d) => d.id), ['first_action', 'joined_seed']);
    });

    test('caches after the first load', () async {
      await repository.getDefinitions();
      await repository.getDefinitions();
      expect(loaderCallCount, 1);
    });
  });

  group('unlock + read flow', () {
    const userId = 'u1';

    test('getUnlockedIds returns empty for a fresh user', () async {
      expect(await repository.getUnlockedIds(userId), isEmpty);
    });

    test('unlockAchievement adds to getUnlockedIds', () async {
      await repository.unlockAchievement(userId, 'first_action');
      await repository.unlockAchievement(userId, 'streak_7');

      expect(
        await repository.getUnlockedIds(userId),
        {'first_action', 'streak_7'},
      );
    });

    test('unlockAchievement is idempotent', () async {
      await repository.unlockAchievement(userId, 'first_action');
      await repository.unlockAchievement(userId, 'first_action');

      final records = await repository.watchUserAchievements(userId).first;
      expect(records, hasLength(1));
    });

    test('watchUnlockedIds emits the current id set', () async {
      await repository.unlockAchievement(userId, 'first_action');
      final ids = await repository.watchUnlockedIds(userId).first;
      expect(ids, {'first_action'});
    });

    test('markPointsClaimed flips the flag on the record', () async {
      await repository.unlockAchievement(userId, 'first_action');
      await repository.markPointsClaimed(userId, 'first_action');

      final records = await repository.watchUserAchievements(userId).first;
      expect(records.single.pointsClaimed, isTrue);
    });
  });
}
