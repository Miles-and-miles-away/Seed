import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadSdgGoals', () {
    test('loads all 17 goals', () async {
      final data = await loadSdgGoals();

      expect(data.goals, hasLength(AppConstants.sdgMaxGoal));
    });

    test('goalMap is keyed by goal number and matches the list', () async {
      final data = await loadSdgGoals();

      for (final g in data.goals) {
        expect(data.goalMap[g.number], same(g));
      }
    });

    test('goal numbers range 1..17 with no gaps', () async {
      final data = await loadSdgGoals();

      final numbers = data.goals.map((g) => g.number).toSet();
      for (var n = AppConstants.sdgMinGoal; n <= AppConstants.sdgMaxGoal; n++) {
        expect(numbers, contains(n));
      }
    });

    test('every goal has a non-empty title and description', () async {
      final data = await loadSdgGoals();

      for (final g in data.goals) {
        expect(g.titleEn, isNotEmpty, reason: 'goal ${g.number}');
        expect(g.descriptionEn, isNotEmpty, reason: 'goal ${g.number}');
      }
    });
  });
}
