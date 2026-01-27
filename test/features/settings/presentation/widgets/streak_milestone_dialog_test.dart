import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';

void main() {
  group('StreakMilestoneDialog widget properties', () {
    test('weekNumber is stored correctly', () {
      const dialog = StreakMilestoneDialog(
        weekNumber: 5,
        totalDays: 35,
        onDismiss: _emptyCallback,
      );

      expect(dialog.weekNumber, 5);
    });

    test('totalDays is stored correctly', () {
      const dialog = StreakMilestoneDialog(
        weekNumber: 5,
        totalDays: 35,
        onDismiss: _emptyCallback,
      );

      expect(dialog.totalDays, 35);
    });

    test('onDismiss callback is stored', () {
      var called = false;
      final dialog = StreakMilestoneDialog(
        weekNumber: 1,
        totalDays: 7,
        onDismiss: () => called = true,
      );

      dialog.onDismiss();
      expect(called, isTrue);
    });

    test('creates ConsumerStatefulWidget', () {
      const dialog = StreakMilestoneDialog(
        weekNumber: 1,
        totalDays: 7,
        onDismiss: _emptyCallback,
      );

      expect(dialog, isA<StatefulWidget>());
    });

    test('accepts different week numbers', () {
      for (final week in [1, 2, 3, 4, 8, 12, 26, 52]) {
        final dialog = StreakMilestoneDialog(
          weekNumber: week,
          totalDays: week * 7,
          onDismiss: _emptyCallback,
        );

        expect(dialog.weekNumber, week);
        expect(dialog.totalDays, week * 7);
      }
    });

    test('handles large week numbers', () {
      const dialog = StreakMilestoneDialog(
        weekNumber: 100,
        totalDays: 700,
        onDismiss: _emptyCallback,
      );

      expect(dialog.weekNumber, 100);
      expect(dialog.totalDays, 700);
    });
  });

  group('showStreakMilestoneCelebration function', () {
    test('is callable', () {
      expect(showStreakMilestoneCelebration, isA<Function>());
    });
  });
}

void _emptyCallback() {}
