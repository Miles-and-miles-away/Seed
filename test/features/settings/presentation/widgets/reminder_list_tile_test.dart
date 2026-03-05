import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/presentation/widgets/reminder_list_tile.dart';

void main() {
  Widget createTestWidget({
    required NotificationScheduleModel schedule,
    required ValueChanged<bool> onToggle,
    required VoidCallback onDelete,
    required VoidCallback onTap,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      // Should show the formatted time (9:00 AM)
      expect(find.text('9:00 AM'), findsOneWidget);
    });

    testWidgets('renders label when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      expect(find.text('Morning'), findsOneWidget);
    });

    testWidgets('does not render label when empty', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: noLabelSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      // Should only find the time, no subtitle
      expect(find.text('12:00 PM'), findsOneWidget);
      expect(find.text(''), findsNothing);
    });

    testWidgets('shows alarm icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.alarm), findsOneWidget);
    });

    testWidgets('shows delete icon button', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsWidgets);
    });

    testWidgets('shows switch toggle', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('switch reflects enabled state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('switch reflects disabled state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: disabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('calls onToggle when switch tapped', (tester) async {
      bool? receivedValue;

      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (value) => receivedValue = value,
          onDelete: () {},
          onTap: () {},
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
          onToggle: (_) {},
          onDelete: () => deleteCalled = true,
          onTap: () {},
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
          onToggle: (_) {},
          onDelete: () {},
          onTap: () => tapCalled = true,
        ),
      );

      // Tap on the time text to trigger tile onTap
      await tester.tap(find.text('9:00 AM'));
      await tester.pumpAndSettle();

      expect(tapCalled, isTrue);
    });

    testWidgets('is wrapped in Dismissible', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      expect(find.byType(Dismissible), findsOneWidget);
    });

    testWidgets('dismissible key uses schedule id', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      final dismissible = tester.widget<Dismissible>(find.byType(Dismissible));
      expect(dismissible.key, equals(const Key('test-1')));
    });

    testWidgets('calls onDelete when dismissed', (tester) async {
      var deleteCalled = false;

      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () => deleteCalled = true,
          onTap: () {},
        ),
      );

      // Swipe to dismiss (end to start)
      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(deleteCalled, isTrue);
    });

    testWidgets('displays time with PM correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: disabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      // 18:30 should display as 6:30 PM
      expect(find.text('6:30 PM'), findsOneWidget);
    });

    testWidgets('shows ListTile inside Dismissible', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          schedule: enabledSchedule,
          onToggle: (_) {},
          onDelete: () {},
          onTap: () {},
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
    });
  });
}
