import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/presentation/providers/achievement_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

void main() {
  AchievementDefinition stub(String id) => AchievementDefinition(
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

  ProviderContainer makeContainer({required List<AchievementDefinition> defs}) {
    return ProviderContainer(
      overrides: [
        firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
        achievementDefinitionsProvider.overrideWith((ref) async => defs),
      ],
    );
  }

  test('achievementDefinitionsProvider is keepAlive across listener churn',
      () async {
    final c = makeContainer(defs: [stub('a'), stub('b')]);
    addTearDown(c.dispose);

    final first = await c.read(achievementDefinitionsProvider.future);
    c.listen(achievementDefinitionsProvider, (_, __) {}).close();
    final second = await c.read(achievementDefinitionsProvider.future);

    expect(identical(first, second), isTrue);
    expect(first.map((d) => d.id), ['a', 'b']);
  });

  test('userUnlockedAchievementIdsProvider starts empty for a fresh user',
      () async {
    final c = makeContainer(defs: [stub('first_action')]);
    addTearDown(c.dispose);

    final provider = userUnlockedAchievementIdsProvider('u1');
    c.listen(provider, (_, __) {});
    final ids = await c.read(provider.future);
    expect(ids, isEmpty);
  });
}
