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
        'iconUrl': 'https://example.com/icon.jpg',
      });

      expect(goal.number, 1);
      expect(goal.titleEn, 'No Poverty');
      expect(goal.shortTitleEn, 'No Poverty');
      expect(goal.descriptionEn, 'End poverty in all its forms.');
      expect(goal.color.toARGB32(), const Color(0xFFE5233D).toARGB32());
      expect(goal.iconUrl, 'https://example.com/icon.jpg');
    });

    test('fromJson parses hex color correctly', () {
      final goal = SdgGoal.fromJson({
        'number': 1,
        'title': 'No Poverty',
        'shortTitle': 'No Poverty',
        'description': 'End poverty.',
        'color': 'E5233D',
        'iconUrl': 'https://example.com/icon.jpg',
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
        'iconUrl': 'https://example.com/icon.jpg',
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
        'iconUrl': 'https://example.com/icon.jpg',
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

      final jsonString = await rootBundle.loadString(
        'data/app/sdg_goals.json',
      );
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
        expect(goal.iconUrl, isNotEmpty);
        expect(goal.iconUrl, startsWith('https://'));
      }
    });

    test('all goals have valid UN SDG icon URLs', () {
      for (final goal in data.goals) {
        expect(goal.iconUrl, contains('sdgs.un.org'));
        expect(goal.iconUrl, endsWith('.jpg'));
      }
    });

    test('goal 1 is No Poverty', () {
      final goal = data.goals[0];
      expect(goal.number, 1);
      expect(goal.titleEn, 'No Poverty');
      expect(goal.color.toARGB32(), const Color(0xFFE5233D).toARGB32());
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
      expect(
        data.goalMap[17]?.titleEn,
        'Partnerships for the Goals',
      );
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
