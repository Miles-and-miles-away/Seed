import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/action_reminder_sheet.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

import '../../../../helpers/test_helpers.dart';

const _action = ActionModel(
  id: 'bag',
  nameEn: 'Bring a bag',
  nameJa: 'バッグを持参',
  category: 'waste',
  points: 5,
);

const _reminder = ActionReminder(hour: 18, minute: 0, weekdays: [1, 3]);

class _RecordingSettings extends SettingsNotifier {
  _RecordingSettings({required this.permitted});

  final bool permitted;
  final saved = <(String, ActionReminder)>[];
  final enables = <bool>[];
  final deleted = <String>[];

  @override
  Future<bool> saveActionReminder(
    String actionId,
    ActionReminder reminder, {
    required bool enable,
  }) async {
    saved.add((actionId, reminder));
    enables.add(enable);
    return permitted;
  }

  @override
  Future<void> deleteActionReminder(String actionId) async =>
      deleted.add(actionId);
}

void main() {
  late SdgGoalsData sdgData;

  setUpAll(() async => sdgData = await loadSdgGoals());

  Future<_RecordingSettings> pumpCard(
    WidgetTester tester, {
    ActionModel action = _action,
    Map<String, ActionReminder> reminders = const {},
    bool permitted = true,
    bool remindersOn = true,
    bool loggedToday = false,
    Locale? locale,
  }) async {
    final settings = _RecordingSettings(permitted: permitted);
    sizeViewport(tester, size: const Size(400, 900));
    await tester.pumpWidget(
      createTestWidget(
        scaffold: true,
        locale: locale,
        overrides: [
          sdgGoalsDataProvider.overrideWith((_) async => sdgData),
          actionRemindersProvider.overrideWithValue(reminders),
          actionRemindersEnabledProvider.overrideWithValue(remindersOn),
          reminderTimeProvider.overrideWithValue(
            const TimeOfDay(hour: 18, minute: 0),
          ),
          // A Saturday.
          clockProvider.overrideWithValue(() => DateTime(2026, 11, 7, 9)),
          settingsProvider.overrideWith(() => settings),
          todayActionsProvider.overrideWith(
            (_) => Stream.value([
              if (loggedToday)
                ActionLogModel(
                  id: 'log',
                  actionId: action.id,
                  actionName: 'Bring a bag',
                  category: 'waste',
                  points: 5,
                  loggedAt: DateTime(2026, 11, 7, 8),
                ),
            ]),
          ),
        ],
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 180,
            height: 200,
            child: ActionCard(action: action, languageCode: 'en', onTap: () {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return settings;
  }

  group('reminder bell', () {
    testWidgets('is outlined until a reminder is set', (tester) async {
      await pumpCard(tester);
      expect(find.byIcon(Icons.notifications_none), findsOneWidget);
      expect(find.byTooltip('Set a reminder'), findsOneWidget);

      await pumpCard(tester, reminders: {'bag': _reminder});
      expect(find.byIcon(Icons.notifications_active), findsOneWidget);
      expect(find.byTooltip('Edit reminder'), findsOneWidget);
    });

    testWidgets('is coloured only while action reminders are on', (
      tester,
    ) async {
      Color? bellColour() =>
          tester.widget<Icon>(find.byIcon(Icons.notifications_active)).color;
      final outline = ThemeData().colorScheme.outline;

      await pumpCard(tester, reminders: {'bag': _reminder});
      expect(bellColour(), isNot(outline));

      await pumpCard(tester, reminders: {'bag': _reminder}, remindersOn: false);
      expect(bellColour(), outline);
      expect(
        find.byTooltip('Edit reminder (action reminders are off)'),
        findsOneWidget,
      );
    });

    testWidgets('is hidden on learn-only actions', (tester) async {
      await pumpCard(tester, action: _action.copyWith(isLearnOnly: true));

      expect(find.byIcon(Icons.notifications_none), findsNothing);
    });

    testWidgets('at the limit points to Settings instead', (tester) async {
      await pumpCard(
        tester,
        reminders: {
          for (var i = 0; i < AppConstants.maxActionReminders; i++)
            'other$i': _reminder,
        },
      );

      await tester.tap(find.byTooltip('Set a reminder'));
      await tester.pumpAndSettle();

      expect(find.text('Remind me'), findsNothing);
      expect(find.textContaining('up to 10 action reminders'), findsOneWidget);
    });
  });

  group('actionReminderSummary', () {
    Future<String> summary(
      WidgetTester tester,
      ActionReminder reminder,
      Locale locale,
    ) async {
      late String text;
      await tester.pumpWidget(
        createTestWidget(
          locale: locale,
          child: Builder(
            builder: (context) {
              text = actionReminderSummary(context, reminder);
              return const SizedBox();
            },
          ),
        ),
      );
      return text;
    }

    testWidgets('reads naturally in each language', (tester) async {
      const one = ActionReminder(hour: 1, minute: 0, weekdays: [1, 3]);

      expect(
        await summary(tester, one, const Locale('es')),
        contains('a la 1:00'),
      );
      expect(
        await summary(tester, one.copyWith(hour: 13), const Locale('es')),
        contains('a las 13:00'),
      );
      expect(await summary(tester, one, const Locale('ja')), startsWith('月、水'));
      expect(
        await summary(tester, one, const Locale('en')),
        startsWith('Mon, Wed'),
      );
    });
  });

  group('reminder sheet', () {
    testWidgets('saves the picked days and repeat count', (tester) async {
      final semantics = tester.ensureSemantics();
      final settings = await pumpCard(tester);

      await tester.tap(find.byTooltip('Set a reminder'));
      await tester.pumpAndSettle();
      expect(find.text('Remind me'), findsOneWidget);
      expect(find.text('6:00 PM'), findsOneWidget);

      for (final day in [
        'Tuesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ]) {
        await tester.tap(find.bySemanticsLabel(day));
      }
      await tester.tap(find.text('Number of times'));
      await tester.pumpAndSettle();
      // Mon and Wed from Saturday 7 Nov: 9, 11, 16, 18, 23.
      expect(find.text('5 times'), findsOneWidget);
      expect(find.textContaining('Nov 23'), findsOneWidget);

      await tester.tap(find.byTooltip('Fewer times'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Nov 18'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(settings.saved, [
        ('bag', _reminder.copyWith(lastDay: '2026-11-18')),
      ]);
      expect(find.text('Reminder saved'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('counts from tomorrow once the action is logged today', (
      tester,
    ) async {
      await pumpCard(tester, loggedToday: true);

      await tester.tap(find.byTooltip('Set a reminder'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Number of times'));
      await tester.pumpAndSettle();

      // Today's 6:00 PM is skipped, so five times runs Sun 8 to Thu 12.
      expect(find.textContaining('Nov 12'), findsOneWidget);
    });

    testWidgets('a first reminder switches action reminders on', (
      tester,
    ) async {
      final settings = await pumpCard(tester, remindersOn: false);
      await tester.tap(find.byTooltip('Set a reminder'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(settings.enables, [isTrue]);
    });

    testWidgets('saving another leaves action reminders switched off', (
      tester,
    ) async {
      final settings = await pumpCard(
        tester,
        reminders: {'bag': _reminder},
        remindersOn: false,
      );
      await tester.tap(
        find.byTooltip('Edit reminder (action reminders are off)'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(settings.saved, hasLength(1));
      expect(settings.enables, [isFalse]);
    });

    testWidgets('a refused permission explains where to allow it', (
      tester,
    ) async {
      await pumpCard(tester, permitted: false);

      await tester.tap(find.byTooltip('Set a reminder'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Notifications are off'), findsOneWidget);
      expect(find.text('Open settings'), findsOneWidget);

      // A snackbar with an action would otherwise stay until swiped.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.textContaining('Notifications are off'), findsNothing);
    });

    testWidgets('saves every day forever by default', (tester) async {
      final settings = await pumpCard(tester);

      await tester.tap(find.byTooltip('Set a reminder'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(settings.saved, [
        (
          'bag',
          const ActionReminder(
            hour: 18,
            minute: 0,
            weekdays: [1, 2, 3, 4, 5, 6, 7],
          ),
        ),
      ]);
    });

    testWidgets('cannot save without a day', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpCard(tester);
      await tester.tap(find.byTooltip('Set a reminder'));
      await tester.pumpAndSettle();

      for (final day in [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ]) {
        await tester.tap(find.bySemanticsLabel(day));
      }
      await tester.pump();

      final save = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save'),
      );
      expect(save.onPressed, isNull);
      // Every week starts on Monday, whatever the locale.
      final xs = [
        for (final day in [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ])
          tester.getCenter(find.bySemanticsLabel(day)).dx,
      ];
      expect(xs, [...xs]..sort());
      semantics.dispose();
    });

    testWidgets('names the days in the locale', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpCard(tester, locale: const Locale('es'));
      await tester.tap(find.byIcon(Icons.notifications_none));
      await tester.pumpAndSettle();

      const week = {
        'lunes': 'L',
        'martes': 'M',
        'miércoles': 'X',
        'jueves': 'J',
        'viernes': 'V',
        'sábado': 'S',
        'domingo': 'D',
      };
      final xs = <double>[];
      for (final MapEntry(key: day, value: letter) in week.entries) {
        final toggle = find.bySemanticsLabel(day);
        expect(
          find.descendant(of: toggle, matching: find.text(letter)),
          findsOneWidget,
          reason: day,
        );
        xs.add(tester.getCenter(toggle).dx);
      }
      expect(xs, [...xs]..sort());
      semantics.dispose();
    });

    testWidgets('edits an existing reminder and can delete it', (tester) async {
      final settings = await pumpCard(
        tester,
        reminders: {'bag': _reminder.copyWith(lastDay: '2026-11-16')},
      );

      await tester.tap(find.byTooltip('Edit reminder'));
      await tester.pumpAndSettle();
      // 9, 11 and 16 Nov are left.
      expect(find.text('3 times'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(settings.deleted, ['bag']);
      expect(settings.saved, isEmpty);
    });
  });
}
