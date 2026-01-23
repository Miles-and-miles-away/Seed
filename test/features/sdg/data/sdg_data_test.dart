import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';

void main() {
  group('SdgGoal', () {
    test('creates goal with all required fields', () {
      const goal = SdgGoal(
        number: 1,
        title: 'No Poverty',
        shortTitle: 'No Poverty',
        description: 'End poverty in all its forms.',
        color: Color(0xFFE5233D),
        iconUrl: 'https://example.com/icon.jpg',
      );

      expect(goal.number, 1);
      expect(goal.title, 'No Poverty');
      expect(goal.shortTitle, 'No Poverty');
      expect(goal.description, 'End poverty in all its forms.');
      expect(goal.color, const Color(0xFFE5233D));
      expect(goal.iconUrl, 'https://example.com/icon.jpg');
    });
  });

  group('sdgGoals', () {
    test('contains all 17 SDGs', () {
      expect(sdgGoals.length, 17);
    });

    test('goals are numbered 1 through 17', () {
      for (var i = 0; i < sdgGoals.length; i++) {
        expect(sdgGoals[i].number, i + 1);
      }
    });

    test('all goals have required properties', () {
      for (final goal in sdgGoals) {
        expect(goal.number, isPositive);
        expect(goal.title, isNotEmpty);
        expect(goal.shortTitle, isNotEmpty);
        expect(goal.description, isNotEmpty);
        expect(goal.iconUrl, isNotEmpty);
        expect(goal.iconUrl, startsWith('https://'));
      }
    });

    test('all goals have valid UN SDG icon URLs', () {
      for (final goal in sdgGoals) {
        expect(goal.iconUrl, contains('sdgs.un.org'));
        expect(goal.iconUrl, endsWith('.jpg'));
      }
    });

    test('goal 1 is No Poverty', () {
      final goal = sdgGoals[0];
      expect(goal.number, 1);
      expect(goal.title, 'No Poverty');
      expect(goal.color, const Color(0xFFE5233D));
    });

    test('goal 13 is Climate Action', () {
      final goal = sdgGoals[12];
      expect(goal.number, 13);
      expect(goal.title, 'Climate Action');
      expect(goal.shortTitle, 'Climate Action');
    });

    test('goal 17 is Partnerships for the Goals', () {
      final goal = sdgGoals[16];
      expect(goal.number, 17);
      expect(goal.title, 'Partnerships for the Goals');
      expect(goal.shortTitle, 'Partnerships');
    });

    test('all goals have unique colors', () {
      final colors = sdgGoals.map((g) => g.color.toARGB32()).toSet();
      expect(colors.length, sdgGoals.length);
    });

    test('all goals have unique numbers', () {
      final numbers = sdgGoals.map((g) => g.number).toSet();
      expect(numbers.length, sdgGoals.length);
    });

    test('descriptions contain meaningful content', () {
      for (final goal in sdgGoals) {
        // Each description should be substantial (more than 100 chars)
        expect(goal.description.length, greaterThan(100));
      }
    });

    test('short titles are actually short', () {
      for (final goal in sdgGoals) {
        // Short titles should be concise (less than 25 chars)
        expect(goal.shortTitle.length, lessThan(25));
      }
    });
  });
}
