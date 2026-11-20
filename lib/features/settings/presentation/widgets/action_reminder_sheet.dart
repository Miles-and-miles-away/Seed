import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/settings/data/models/action_reminder_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';

/// The sheet's answer: a reminder to save, or null to delete it.
typedef _SheetResult = ({ActionReminder? reminder});

/// Opens the reminder sheet for [action] and saves what the user picks.
/// [doneToday] says the action is logged today, so today's never fires.
Future<void> showActionReminderSheet(
  BuildContext context,
  WidgetRef ref, {
  required ActionModel action,
  required String languageCode,
  required bool doneToday,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final reminders = ref.read(actionRemindersProvider);
  final existing = reminders[action.id];
  if (existing == null && reminders.length >= AppConstants.maxActionReminders) {
    final router = GoRouter.maybeOf(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.reminderLimit(AppConstants.maxActionReminders)),
        behavior: SnackBarBehavior.floating,
        persist: false,
        action: SnackBarAction(
          label: l10n.reminderManage,
          onPressed: () => router?.push(appRoutes.settingsReminders),
        ),
      ),
    );
    return;
  }

  final result = await showModalBottomSheet<_SheetResult>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: sheetShape,
    builder: (_) => _ActionReminderSheet(
      actionName: action.name(languageCode),
      existing: existing,
      defaultTime: ref.read(reminderTimeProvider),
      doneToday: doneToday,
    ),
  );
  if (result == null || !context.mounted) return;

  final notifier = ref.read(settingsProvider.notifier);
  final reminder = result.reminder;
  if (reminder == null) {
    unawaited(notifier.deleteActionReminder(action.id));
    return;
  }
  // Only a first reminder turns them on; never undo the user's switch-off.
  final permitted = await notifier.saveActionReminder(
    action.id,
    reminder,
    enable: reminders.isEmpty,
  );
  if (!context.mounted) return;
  if (permitted) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.reminderSaved),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    showNotificationsBlockedSnackBar(context, ref);
  }
}

/// Tells the user the OS blocks notifications, with a way to its settings.
void showNotificationsBlockedSnackBar(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  final service = ref.read(notificationServiceProvider);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.notifBlocked),
      behavior: SnackBarBehavior.floating,
      persist: false,
      action: SnackBarAction(
        label: l10n.notifOpenSettings,
        onPressed: () => unawaited(service.openSettings()),
      ),
    ),
  );
}

/// "Mon, Wed at 6:00 PM", plus the last day if it ends, for [reminder].
String actionReminderSummary(BuildContext context, ActionReminder reminder) {
  final l10n = AppLocalizations.of(context);
  final materialL10n = MaterialLocalizations.of(context);
  final format = DateFormat.E(Localizations.localeOf(context).toString());
  final days = reminder.weekdays.length == DateTime.daysPerWeek
      ? l10n.reminderEveryDay
      : [
          for (final day in _week)
            if (reminder.weekdays.contains(day)) format.format(_dateOn(day)),
        ].join(l10n.reminderDaySeparator);
  final time = TimeOfDay(
    hour: reminder.hour,
    minute: reminder.minute,
  ).format(context);
  final lastDay = reminder.lastDay;
  return lastDay == null
      ? l10n.reminderSummary(days, time, reminder.hour)
      : l10n.reminderSummaryUntil(
          days,
          time,
          reminder.hour,
          materialL10n.formatMediumDate(DateTime.parse(lastDay)),
        );
}

/// [DateTime.weekday] values; the week starts on Monday in every locale.
const _week = [1, 2, 3, 4, 5, 6, 7];

/// A date falling on [weekday]: 1 January 2024 was a Monday.
DateTime _dateOn(int weekday) => DateTime(2024, 1, weekday);

class _ActionReminderSheet extends ConsumerStatefulWidget {
  const _ActionReminderSheet({
    required this.actionName,
    required this.existing,
    required this.defaultTime,
    required this.doneToday,
  });

  final String actionName;
  final ActionReminder? existing;
  final TimeOfDay defaultTime;
  final bool doneToday;

  @override
  ConsumerState<_ActionReminderSheet> createState() =>
      _ActionReminderSheetState();
}

class _ActionReminderSheetState extends ConsumerState<_ActionReminderSheet> {
  // Read afresh so a sheet left open past midnight counts from today.
  DateTime get _now => ref.read(clockProvider)();
  late TimeOfDay _time;
  late final Set<int> _weekdays;
  late bool _forever;
  late int _count;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _time = existing == null
        ? widget.defaultTime
        : TimeOfDay(hour: existing.hour, minute: existing.minute);
    _weekdays = {...existing?.weekdays ?? _week};
    _forever = existing?.lastDay == null;
    _count = existing == null || _forever
        ? AppConstants.defaultReminderRepeats
        : _days(existing.weekdays).takeWhile(existing.coversDay).length;
    _count = _count.clamp(1, AppConstants.maxReminderRepeats);
  }

  Iterable<DateTime> _days(List<int> weekdays) {
    final now = _now;
    return reminderDays(
      now: now,
      hour: _time.hour,
      minute: _time.minute,
      weekdays: weekdays,
    ).where((t) => !widget.doneToday || !isSameCalendarDay(t, now));
  }

  /// The day of the last reminder when it repeats [_count] times.
  DateTime? get _lastDay =>
      _weekdays.isEmpty ? null : _days(_sortedWeekdays).elementAt(_count - 1);

  List<int> get _sortedWeekdays => _weekdays.toList()..sort();

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: _time);
    if (time != null && mounted) setState(() => _time = time);
  }

  void _save() {
    final lastDay = _lastDay;
    Navigator.pop<_SheetResult>(context, (
      reminder: ActionReminder(
        hour: _time.hour,
        minute: _time.minute,
        weekdays: _sortedWeekdays,
        lastDay: _forever || lastDay == null ? null : formatDateKey(lastDay),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final materialL10n = MaterialLocalizations.of(context);
    final fullDay = DateFormat.EEEE(Localizations.localeOf(context).toString());
    final lastDay = _lastDay;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          spacingXxl,
          0,
          spacingXxl,
          spacingXxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.reminderSheetTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingXs),
            Text(
              widget.actionName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingLg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule_outlined),
              title: Text(l10n.notifReminderTime),
              trailing: Text(
                _time.format(context),
                style: theme.textTheme.titleMedium,
              ),
              onTap: _pickTime,
            ),
            const SizedBox(height: spacingSm),
            Text(l10n.reminderDays, style: theme.textTheme.titleSmall),
            const SizedBox(height: spacingSm),
            Row(
              children: [
                for (final day in _week)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: _DayToggle(
                        label: materialL10n.narrowWeekdays[day % 7],
                        semanticsLabel: fullDay.format(_dateOn(day)),
                        selected: _weekdays.contains(day),
                        onTap: () => setState(() {
                          if (!_weekdays.remove(day)) _weekdays.add(day);
                        }),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: spacingLg),
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: true, label: Text(l10n.reminderForever)),
                ButtonSegment(value: false, label: Text(l10n.reminderRepeat)),
              ],
              selected: {_forever},
              onSelectionChanged: (selection) =>
                  setState(() => _forever = selection.first),
            ),
            if (!_forever) ...[
              const SizedBox(height: spacingSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    tooltip: l10n.reminderFewer,
                    onPressed: _count > 1
                        ? () => setState(() => _count--)
                        : null,
                  ),
                  Text(
                    l10n.reminderRepeatCount(_count),
                    style: theme.textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: l10n.reminderMore,
                    onPressed: _count < AppConstants.maxReminderRepeats
                        ? () => setState(() => _count++)
                        : null,
                  ),
                ],
              ),
              if (lastDay != null)
                Text(
                  l10n.reminderLastDay(materialL10n.formatMediumDate(lastDay)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
            const SizedBox(height: spacingXl),
            Row(
              children: [
                if (widget.existing != null)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    onPressed: () =>
                        Navigator.pop<_SheetResult>(context, (reminder: null)),
                    child: Text(l10n.buttonDelete),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _weekdays.isEmpty ? null : _save,
                  child: Text(l10n.buttonSave),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A round on/off button for one weekday.
class _DayToggle extends StatelessWidget {
  const _DayToggle({
    required this.label,
    required this.semanticsLabel,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String semanticsLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      toggled: selected,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Material(
        shape: const CircleBorder(),
        color: selected
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
