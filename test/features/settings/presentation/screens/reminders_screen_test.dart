import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/screens/reminders_screen.dart';
import 'package:seed_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';

import '../../../../helpers/test_helpers.dart';

const _reminder = ActionReminder(hour: 18, minute: 0, weekdays: [1, 3]);

const _library = [
  ActionModel(
    id: 'bus',
    nameEn: 'Take the bus',
    nameJa: 'バスに乗る',
    category: 'transport',
    points: 8,
  ),
  ActionModel(
    id: 'bag',
    nameEn: 'Bring a bag',
    nameJa: 'バッグを持参',
    category: 'waste',
    points: 5,
  ),
];

void main() {
  Future<void> pump(
    WidgetTester tester, {
    UserSettingsModel settings = const UserSettingsModel(),
    Widget child = const RemindersScreen(),
    List<Override> overrides = const [],
  }) async {
    sizeViewport(tester);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => child),
        GoRoute(
          path: appRoutes.settingsReminders,
          builder: (_, _) => const RemindersScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          languageStoreOverride(),
          userIdProvider.overrideWithValue('u'),
          userSettingsProvider.overrideWith((_) => Stream.value(settings)),
          actionLibraryProvider.overrideWith((_) async => _library),
          todayActionsProvider.overrideWith((_) => Stream.value([])),
          ...overrides,
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  bool switchOn(WidgetTester tester, String title) => tester
      .widget<Switch>(
        find.descendant(
          of: find.widgetWithText(ListTile, title),
          matching: find.byType(Switch),
        ),
      )
      .value;

  testWidgets('Settings opens it from one tile', (tester) async {
    await pump(tester, child: const SettingsScreen());

    await tester.tap(find.text('Manage reminders'));
    await tester.pumpAndSettle();

    expect(find.byType(RemindersScreen), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
  });

  testWidgets('the daily reminder is off with its time disabled', (
    tester,
  ) async {
    await pump(tester);

    expect(switchOn(tester, 'Daily challenge reminder'), isFalse);
    final timeTile = find.ancestor(
      of: find.text('6:00 PM'),
      matching: find.byType(ListTile),
    );
    expect(tester.widget<ListTile>(timeTile).onTap, isNull);
  });

  testWidgets('an enabled daily reminder opens the time picker', (
    tester,
  ) async {
    await pump(
      tester,
      settings: const UserSettingsModel(
        notificationsEnabled: true,
        reminderHour: 7,
        reminderMinute: 30,
      ),
    );

    expect(switchOn(tester, 'Daily challenge reminder'), isTrue);
    await tester.tap(find.text('7:30 AM'));
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
  });

  testWidgets('lists action reminders by name with their schedule', (
    tester,
  ) async {
    await pump(
      tester,
      settings: const UserSettingsModel(
        actionRemindersEnabled: true,
        actionReminders: {'bus': _reminder, 'bag': _reminder},
      ),
    );

    expect(switchOn(tester, 'Action reminders'), isTrue);
    expect(
      tester.getTopLeft(find.text('Bring a bag')).dy,
      lessThan(tester.getTopLeft(find.text('Take the bus')).dy),
    );
    expect(find.text('Mon, Wed at 6:00 PM'), findsNWidgets(2));
    expect(find.text('No action reminders yet.'), findsNothing);

    await tester.tap(find.text('Bring a bag'));
    await tester.pumpAndSettle();
    expect(find.text('Remind me'), findsOneWidget);
  });

  testWidgets('reminders stay editable while switched off', (tester) async {
    await pump(
      tester,
      settings: const UserSettingsModel(actionReminders: {'bag': _reminder}),
    );

    expect(switchOn(tester, 'Action reminders'), isFalse);
    await tester.tap(find.text('Bring a bag'));
    await tester.pumpAndSettle();
    expect(find.text('Remind me'), findsOneWidget);
  });

  testWidgets('says when there are no action reminders', (tester) async {
    await pump(tester);

    expect(find.text('No action reminders yet.'), findsOneWidget);
  });

  final blocked = notificationPermissionStatusProvider.overrideWith(
    (_) async => false,
  );

  testWidgets('does not flag blocked notifications while all off', (
    tester,
  ) async {
    await pump(tester, overrides: [blocked]);

    expect(find.text('Notifications are blocked'), findsNothing);
  });

  testWidgets('flags blocked notifications once a switch is on', (
    tester,
  ) async {
    await pump(
      tester,
      settings: const UserSettingsModel(actionRemindersEnabled: true),
      overrides: [blocked],
    );

    expect(find.text('Notifications are blocked'), findsOneWidget);
  });
}
