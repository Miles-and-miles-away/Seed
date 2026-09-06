import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/presentation/widgets/reminder_list_tile.dart';

void _noop() {}

void _ignore(bool _) {}

void main() {
  Widget createTestWidget({
    required NotificationScheduleModel schedule,
    ValueChanged<bool> onToggle = _ignore,
    VoidCallback onDelete = _noop,
    VoidCallback onTap = _noop,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ReminderListTile(
          schedule: schedule,
          onToggle: onToggle,
          onDelete: onDelete,
          onTap: onTap,
        ),
      ),
    );
  }

  const enabledSchedule = NotificationScheduleModel(
    id: 'test-1',
    hour: 9,
    minute: 0,
    label: 'Morning',
  );

  const disabledSchedule = NotificationScheduleModel(
    id: 'test-2',
    hour: 18,
    minute: 30,
    isEnabled: false,
    label: 'Evening',
  );

  const noLabelSchedule = NotificationScheduleModel(
    id: 'test-3',
    hour: 12,
    minute: 0,
  );

  group('ReminderListTile', () {
    testWidgets('renders time display', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: enabledSchedule));

      // Should show the formatted time (9:00 AM)
      expect(find.text('9:00 AM'), findsOneWidget);
    });

    testWidgets('renders label when provided', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: enabledSchedule));

      expect(find.text('Morning'), findsOneWidget);
    });

    testWidgets('does not render label when empty', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: noLabelSchedule));

      // Should only find the time, no subtitle
      expect(find.text('12:00 PM'), findsOneWidget);
      expect(find.text(''), findsNothing);
    });

    testWidgets('shows alarm icon', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: enabledSchedule));

      expect(find.byIcon(Icons.alarm), findsOneWidget);
    });

    testWidgets('shows delete icon button', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: enabledSchedule));

      expect(find.byIcon(Icons.delete_outline), findsWidgets);
    });

    testWidgets('switch reflects enabled state', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: enabledSchedule));

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('switch reflects disabled state', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: disabledSchedule));

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('calls onToggle when switch tapped', (tester) async {
      bool? receivedValue;

      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (value) => receivedValue = value,
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Switch was on (true), tapping should send false
      expect(receivedValue, isFalse);
    });

    testWidgets('calls onDelete when delete button tapped', (tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onDelete: () => deleteCalled = true,
        ),
      );

      // Find the delete icon button (not the dismissible background)
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });

    testWidgets('calls onTap when tile tapped', (tester) async {
      var tapCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onTap: () => tapCalled = true,
        ),
      );

      // Tap on the time text to trigger tile onTap
      await tester.tap(find.text('9:00 AM'));
      await tester.pumpAndSettle();

      expect(tapCalled, isTrue);
    });

    testWidgets('dismissible key uses schedule id', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: enabledSchedule));

      final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
      expect(dismissible.key, equals(const Key('test-1')));
    });

    testWidgets('calls onDelete when dismissed', (tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onDelete: () => deleteCalled = true,
        ),
      );

      // Swipe to dismiss (end to start)
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });

    testWidgets('displays time with PM correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(schedule: disabledSchedule));

      // 18:30 should display as 6:30 PM
      expect(find.text('6:30 PM'), findsOneWidget);
    });
  });
}
