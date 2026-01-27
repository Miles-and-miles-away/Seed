import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_tile.dart';

void main() {
  Widget createTestWidget({
    required Widget child,
    UserSettingsModel settings = const UserSettingsModel(),
    bool notificationsEnabled = true,
  }) {
    return ProviderScope(
      overrides: [
        userSettingsProvider.overrideWith(
          (ref) => Stream.value(settings),
        ),
        notificationsEnabledProvider.overrideWith((ref) => notificationsEnabled),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: child,
      ),
    );
  }

  group('SettingsScreen', () {
    testWidgets('renders app bar with settings title', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders notifications section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('NOTIFICATIONS'), findsOneWidget);
    });

    testWidgets('renders preferences section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('PREFERENCES'), findsOneWidget);
    });

    testWidgets('renders account section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('ACCOUNT'), findsOneWidget);
    });

    testWidgets('renders about section', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('ABOUT'), findsOneWidget);
    });

    testWidgets('renders notification toggle switch', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SettingsSwitchTile), findsOneWidget);
    });

    testWidgets('shows reminder time setting', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daily Reminder'), findsOneWidget);
    });

    testWidgets('shows language setting', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('shows account setting', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Account tile
      expect(find.text('Account'), findsWidgets);
    });

    testWidgets('shows about setting', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('About'), findsWidgets);
    });

    testWidgets('shows correct language display for English', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('shows correct language display for Japanese', (tester) async {
      const settings = UserSettingsModel(language: 'ja');
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('日本語'), findsOneWidget);
    });

    testWidgets('shows no reminders message when empty', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tap to add reminders'), findsOneWidget);
    });

    testWidgets('shows single reminder time', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('9:00 AM'), findsOneWidget);
    });

    testWidgets('shows multiple reminders count', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          NotificationScheduleModel(id: 'r2', hour: 12, minute: 0),
          NotificationScheduleModel(id: 'r3', hour: 18, minute: 0),
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      // Should show first time + count
      expect(find.text('9:00 AM + 2 more'), findsOneWidget);
    });

    testWidgets('shows all reminders disabled message', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0, isEnabled: false),
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('All reminders disabled'), findsOneWidget);
    });

    testWidgets('shows reminder count subtitle', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
          NotificationScheduleModel(id: 'r2', hour: 12, minute: 0),
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('2 reminders configured'), findsOneWidget);
    });

    testWidgets('shows single reminder configured subtitle', (tester) async {
      const settings = UserSettingsModel(
        reminderSchedules: [
          NotificationScheduleModel(id: 'r1', hour: 9, minute: 0),
        ],
      );
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
          settings: settings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 reminder configured'), findsOneWidget);
    });

    testWidgets('shows no reminders set subtitle when empty', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No reminders set'), findsOneWidget);
    });

    testWidgets('renders multiple SettingsSections', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Should have 4 sections: Notifications, Preferences, Account, About
      expect(find.byType(SettingsSection), findsNWidgets(4));
    });

    testWidgets('renders notification icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('renders schedule icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    });

    testWidgets('renders language icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.language_outlined), findsOneWidget);
    });

    testWidgets('renders person icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('renders info icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('shows version in about tile', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      // Version starts with "Version" prefix
      expect(find.textContaining('Version'), findsOneWidget);
    });

    testWidgets('renders ListView', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const SettingsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('notification switch reflects enabled state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('notification switch reflects disabled state', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SettingsScreen(),
          notificationsEnabled: false,
        ),
      );
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });
  });
}
