import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';

void main() {
  group('SdgGoal', () {
    test('creates goal with all required fields', () {
      final goal = SdgGoal.fromJson({
        'number': 1,
        'title': 'No Poverty',
        'shortTitle': 'No Poverty',
        'description': 'End poverty in all its forms.',
        'color': 'E5233D',
      });

      expect(goal.number, 1);
      expect(goal.titleEn, 'No Poverty');
      expect(goal.shortTitleEn, 'No Poverty');
      expect(goal.descriptionEn, 'End poverty in all its forms.');
      expect(goal.color.toARGB32(), const Color(0xFFE5233D).toARGB32());
    });

    test('fromJson parses hex color correctly', () {
      final goal = SdgGoal.fromJson({
        'number': 1,
        'title': 'No Poverty',
        'shortTitle': 'No Poverty',
        'description': 'End poverty.',
        'color': 'E5233D',
      });

      expect(goal.color, const Color(0xFFE5233D));
      expect(goal.isLearnOnly, false);
    });

    test('fromJson handles isLearnOnly', () {
      final goal = SdgGoal.fromJson({
        'number': 4,
        'title': 'Quality Education',
        'shortTitle': 'Education',
        'description': 'Education for all.',
        'color': 'C5192D',
        'isLearnOnly': true,
      });

      expect(goal.isLearnOnly, true);
    });

    test('fromJson handles missing optional fields', () {
      final goal = SdgGoal.fromJson({
        'number': 1,
        'title': 'No Poverty',
        'shortTitle': 'No Poverty',
        'description': 'End poverty.',
        'color': 'E5233D',
      });

      expect(goal.titleJa, '');
      expect(goal.titleEs, '');
      expect(goal.isLearnOnly, false);
    });
  });

  group('sdg_goals.json', () {
    late SdgGoalsData data;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      final jsonString = await rootBundle.loadString('data/app/sdg_goals.json');
      expect(jsonString, isNotEmpty);

      data = await loadSdgGoals();
    });

    test('contains all 17 SDGs', () {
      expect(data.goals.length, 17);
    });

    test('goals are numbered 1 through 17', () {
      for (var i = 0; i < data.goals.length; i++) {
        expect(data.goals[i].number, i + 1);
      }
    });

    test('all goals have required properties', () {
      for (final goal in data.goals) {
        expect(goal.number, isPositive);
        expect(goal.titleEn, isNotEmpty);
        expect(goal.shortTitleEn, isNotEmpty);
        expect(goal.descriptionEn, isNotEmpty);
      }
    });

    test('every goal has a bundled icon in each app language', () {
      for (final goal in data.goals) {
        for (final locale in ['en', 'ja', 'es']) {
          final path = goal.iconAsset(locale);
          expect(path, contains('/$locale/'));
          expect(rootBundle.load(path), completes, reason: path);
        }
      }
    });

    test('an unsupported locale falls back to the English icon', () {
      expect(
        data.goals.first.iconAsset('fr'),
        data.goals.first.iconAsset('en'),
      );
    });

    test('goal 1 is No Poverty', () {
      final goal = data.goals[0];
      expect(goal.number, 1);
      expect(goal.titleEn, 'No Poverty');
      expect(goal.color.toARGB32(), const Color(0xFFE5243B).toARGB32());
    });

    test('goal colours are the UN guideline palette', () {
      const palette = [
        0xFFE5243B,
        0xFFDDA63A,
        0xFF4C9F38,
        0xFFC5192D,
        0xFFFF3A21,
        0xFF26BDE2,
        0xFFFCC30B,
        0xFFA21942,
        0xFFFD6925,
        0xFFDD1367,
        0xFFFD9D24,
        0xFFBF8B2E,
        0xFF3F7E44,
        0xFF0A97D9,
        0xFF56C02B,
        0xFF00689D,
        0xFF19486A,
      ];
      expect(data.goals.map((g) => g.color.toARGB32()), palette);
    });

    test('goal 13 is Climate Action', () {
      final goal = data.goals[12];
      expect(goal.number, 13);
      expect(goal.titleEn, 'Climate Action');
      expect(goal.shortTitleEn, 'Climate Action');
    });

    test('goal 17 is Partnerships for the Goals', () {
      final goal = data.goals[16];
      expect(goal.number, 17);
      expect(goal.titleEn, 'Partnerships for the Goals');
      expect(goal.shortTitleEn, 'Partnerships');
    });

    test('all goals have unique colors', () {
      final colors = data.goals.map((g) => g.color.toARGB32()).toSet();
      expect(colors.length, data.goals.length);
    });

    test('all goals have unique numbers', () {
      final numbers = data.goals.map((g) => g.number).toSet();
      expect(numbers.length, data.goals.length);
    });

    test('descriptions contain meaningful content', () {
      for (final goal in data.goals) {
        expect(goal.descriptionEn.length, greaterThan(100));
      }
    });

    test('short titles are actually short', () {
      for (final goal in data.goals) {
        expect(goal.shortTitleEn.length, lessThan(25));
      }
    });

    test('goalMap provides O(1) lookup', () {
      expect(data.goalMap[1]?.titleEn, 'No Poverty');
      expect(data.goalMap[13]?.titleEn, 'Climate Action');
      expect(data.goalMap[17]?.titleEn, 'Partnerships for the Goals');
    });

    test('all goals have Japanese translations', () {
      for (final goal in data.goals) {
        expect(goal.titleJa, isNotEmpty);
        expect(goal.descriptionJa, isNotEmpty);
      }
    });

    test('all goals have Spanish translations', () {
      for (final goal in data.goals) {
        expect(goal.titleEs, isNotEmpty);
        expect(goal.descriptionEs, isNotEmpty);
      }
    });

    test('Spanish text contains proper diacritics', () {
      final goal1 = data.goalMap[1]!;
      expect(goal1.descriptionEs, contains('Más'));
      expect(goal1.descriptionEs, contains('educación'));
      expect(goal1.descriptionEs, contains('protección'));
      expect(goal1.descriptionEs, contains('económicos'));
      expect(goal1.descriptionEs, contains('climáticos'));
    });
  });
}
