import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:seed_app/features/settings/presentation/widgets/reminder_list_tile.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_tile.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    UserSettingsModel settings = const UserSettingsModel(),
    bool notificationsEnabled = true,
    bool smartRemindersEnabled = true,
    bool canAddReminder = true,
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        child: const NotificationSettingsScreen(),
        overrides: [
          userSettingsProvider.overrideWith((ref) => Stream.value(settings)),
          notificationsEnabledProvider.overrideWith(
            (ref) => notificationsEnabled,
          ),
          smartRemindersEnabledProvider.overrideWith(
            (ref) => smartRemindersEnabled,
          ),
          canAddReminderProvider.overrideWith((ref) => canAddReminder),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  group('NotificationSettingsScreen', () {
    testWidgets('renders app bar with title', (tester) async {
      await pumpScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Notification Settings'), findsOneWidget);
    });

    testWidgets('renders notifications section', (tester) async {
      await pumpScreen(tester);

      expect(find.text('NOTIFICATIONS'), findsOneWidget);
    });

    testWidgets('renders smart reminders section', (tester) async {
      await pumpScreen(tester);

      expect(find.text('SMART REMINDERS'), findsOneWidget);
    });

    testWidgets('renders reminder times section', (tester) async {
      await pumpScreen(tester);

      expect(find.text('REMINDER TIMES'), findsOneWidget);
    });

    testWidgets('shows enable notifications toggle', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Enable Notifications'), findsOneWidget);
    });

    testWidgets('shows smart reminders toggle', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Only remind if no action today'), findsOneWidget);
    });

    testWidgets('shows smart reminders description', (tester) async {
      await pumpScreen(tester);

      expect(
        find.textContaining("haven't logged any sustainable actions"),
        findsOneWidget,
      );
    });

    testWidgets('shows add reminder button', (tester) async {
      await pumpScreen(tester);

      expect(find.text('Add Reminder Time'), findsOneWidget);
    });

    testWidgets('shows no reminders message when empty', (tester) async {
      await pumpScreen(tester);

      expect(find.text('No reminders set'), findsOneWidget);
      expect(find.text('Add a reminder to get notified'), findsOneWidget);
    });

    testWidgets('shows alarm_off icon when no reminders', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.alarm_off), findsOneWidget);
    });

    testWidgets('renders ReminderListTile for each reminder', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          NotificationScheduleModel(id: 'r2', hour: 18, minute: 0),
        ],
      );
      await pumpScreen(tester, settings: settings);

      expect(find.byType(ReminderListTile), findsNWidgets(2));
    });

    testWidgets('shows reminder times', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          NotificationScheduleModel(id: 'r2', hour: 18, minute: 30),
        ],
      );
      await pumpScreen(tester, settings: settings);

      expect(find.text('9:00 AM'), findsOneWidget);
      expect(find.text('6:30 PM'), findsOneWidget);
    });

    testWidgets('add button disabled when at max reminders', (tester) async {
      await pumpScreen(tester, canAddReminder: false);

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Add Reminder Time'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows max reminders message when at limit', (tester) async {
      await pumpScreen(tester, canAddReminder: false);

      expect(find.text('Maximum 5 reminders allowed'), findsOneWidget);
    });

    testWidgets('add button disabled when notifications off', (tester) async {
      await pumpScreen(tester, notificationsEnabled: false);

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Add Reminder Time'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('notification toggle reflects enabled state', (tester) async {
      await pumpScreen(tester);

      // Find switches - first one is notifications toggle
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches.first.value, isTrue);
    });

    testWidgets('notification toggle reflects disabled state', (tester) async {
      await pumpScreen(tester, notificationsEnabled: false);

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches.first.value, isFalse);
    });

    testWidgets('smart reminders toggle reflects enabled state', (
      tester,
    ) async {
      await pumpScreen(tester);

      // Smart reminders is the second switch
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches[1].value, isTrue);
    });

    testWidgets('smart reminders toggle reflects disabled state', (
      tester,
    ) async {
      await pumpScreen(tester, smartRemindersEnabled: false);

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches[1].value, isFalse);
    });

    testWidgets('renders multiple SettingsSections', (tester) async {
      await pumpScreen(tester);

      // Should have 3 sections: Notifications, Smart Reminders, Reminder Times
      expect(find.byType(SettingsSection), findsNWidgets(3));
    });

    testWidgets('renders SettingsSwitchTile for toggles', (tester) async {
      await pumpScreen(tester);

      // Two switch tiles: Enable Notifications and Smart Reminders
      expect(find.byType(SettingsSwitchTile), findsNWidgets(2));
    });

    testWidgets('shows notification icon', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('shows auto awesome icon for smart reminders', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);
    });

    testWidgets('shows add icon in button', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders ListView', (tester) async {
      await pumpScreen(tester);

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('smart reminders subtitle describes feature', (tester) async {
      await pumpScreen(tester);

      expect(
        find.text("Skip reminders on days you've already logged"),
        findsOneWidget,
      );
    });

    testWidgets('notifications subtitle describes feature', (tester) async {
      await pumpScreen(tester);

      expect(
        find.text('Receive daily reminders to log actions'),
        findsOneWidget,
      );
    });
  });
}
