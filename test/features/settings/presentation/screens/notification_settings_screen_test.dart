import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:seed_app/features/settings/presentation/widgets/reminder_list_tile.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_tile.dart';

void main() {
  Widget createTestWidget({
    required Widget child,
    UserSettingsModel settings = const UserSettingsModel(),
    bool notificationsEnabled = true,
    bool smartRemindersEnabled = true,
    bool canAddReminder = true,
  }) {
    return ProviderScope(
      overrides: [
        userSettingsProvider.overrideWith(
          (ref) => Stream.value(settings),
        ),
        notificationsEnabledProvider
            .overrideWith((ref) => notificationsEnabled),
        smartRemindersEnabledProvider
            .overrideWith((ref) => smartRemindersEnabled),
        canAddReminderProvider.overrideWith((ref) => canAddReminder),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  group('NotificationSettingsScreen', () {
    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Notification Settings'), findsOneWidget);
    });

    testWidgets('renders notifications section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('NOTIFICATIONS'), findsOneWidget);
    });

    testWidgets('renders smart reminders section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('SMART REMINDERS'), findsOneWidget);
    });

    testWidgets('renders reminder times section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('REMINDER TIMES'), findsOneWidget);
    });

    testWidgets('shows enable notifications toggle', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enable Notifications'), findsOneWidget);
    });

    testWidgets('shows smart reminders toggle', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Only remind if no action today'), findsOneWidget);
    });

    testWidgets('shows smart reminders description', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining("haven't logged any sustainable actions"),
        findsOneWidget,
      );
    });

    testWidgets('shows add reminder button', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Reminder Time'), findsOneWidget);
    });

    testWidgets('shows no reminders message when empty', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No reminders set'), findsOneWidget);
      expect(find.text('Add a reminder to get notified'), findsOneWidget);
    });

    testWidgets('shows alarm_off icon when no reminders', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.alarm_off), findsOneWidget);
    });

    testWidgets('renders ReminderListTile for each reminder', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          NotificationScheduleModel(id: 'r2', hour: 18, minute: 0),
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ReminderListTile), findsNWidgets(2));
    });

    testWidgets('shows reminder times', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          NotificationScheduleModel(id: 'r2', hour: 18, minute: 30),
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('9:00 AM'), findsOneWidget);
      expect(find.text('6:30 PM'), findsOneWidget);
    });

    testWidgets('add button disabled when at max reminders', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
          canAddReminder: false,
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Add Reminder Time'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows max reminders message when at limit', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
          canAddReminder: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Maximum 5 reminders allowed'), findsOneWidget);
    });

    testWidgets('add button disabled when notifications off', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
          notificationsEnabled: false,
        ),
      );
      await tester.pumpAndSettle();

      final button = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'Add Reminder Time'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('notification toggle reflects enabled state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Find switches - first one is notifications toggle
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches.first.value, isTrue);
    });

    testWidgets('notification toggle reflects disabled state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
          notificationsEnabled: false,
        ),
      );
      await tester.pumpAndSettle();

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches.first.value, isFalse);
    });

    testWidgets('smart reminders toggle reflects enabled state',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Smart reminders is the second switch
      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches[1].value, isTrue);
    });

    testWidgets('smart reminders toggle reflects disabled state',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const NotificationSettingsScreen(),
          smartRemindersEnabled: false,
        ),
      );
      await tester.pumpAndSettle();

      final switches = tester.widgetList<Switch>(find.byType(Switch)).toList();
      expect(switches[1].value, isFalse);
    });

    testWidgets('renders multiple SettingsSections', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Should have 3 sections: Notifications, Smart Reminders, Reminder Times
      expect(find.byType(SettingsSection), findsNWidgets(3));
    });

    testWidgets('renders SettingsSwitchTile for toggles', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Two switch tiles: Enable Notifications and Smart Reminders
      expect(find.byType(SettingsSwitchTile), findsNWidgets(2));
    });

    testWidgets('shows notification icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('shows auto awesome icon for smart reminders', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);
    });

    testWidgets('shows add icon in button', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders ListView', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('smart reminders subtitle describes feature', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text("Skip reminders on days you've already logged"),
        findsOneWidget,
      );
    });

    testWidgets('notifications subtitle describes feature', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const NotificationSettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Receive daily reminders to log actions'),
        findsOneWidget,
      );
    });
  });
}
