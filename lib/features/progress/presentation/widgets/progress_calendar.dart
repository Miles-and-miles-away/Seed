import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';
import '../providers/progress_providers.dart';
import 'calendar_day_cell.dart';

/// Monthly calendar view showing daily progress.
///
/// Displays a grid of days with balls sized by goal completion,
/// with navigation to previous months.
class ProgressCalendar extends ConsumerWidget {
  const ProgressCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final calendarDataAsync = ref.watch(monthCalendarDataProvider);
    final canGoNext =
        ref.watch(selectedMonthProvider.notifier).canGoToNextMonth;

    return Column(
      children: [
        _buildHeader(context, ref, selectedMonth, canGoNext),
        const SizedBox(height: Spacing.sm),
        _buildWeekdayLabels(context),
        const SizedBox(height: Spacing.sm),
        calendarDataAsync.when(
          data: (data) => _buildCalendarGrid(context, selectedMonth, data),
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => SizedBox(
            height: 200,
            child: Center(
              child: Text('Error loading calendar: $error'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    DateTime selectedMonth,
    bool canGoNext,
  ) {
    final theme = Theme.of(context);
    final monthFormat = DateFormat.yMMMM();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            ref.read(selectedMonthProvider.notifier).goToPreviousMonth();
          },
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          monthFormat.format(selectedMonth),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: canGoNext
              ? () {
                  ref.read(selectedMonthProvider.notifier).goToNextMonth();
                }
              : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    // Generate Sun..Sat labels using intl
    final weekdays = List.generate(7, (i) {
      // Jan 5, 2025 is a Sunday
      final date = DateTime(2025, 1, 5 + i);
      return DateFormat.E(locale).format(date).substring(0, 1).toUpperCase();
    });

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    DateTime selectedMonth,
    List<CalendarDayData> calendarData,
  ) {
    // Get the first day of the month
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month);
    // Get the weekday of the first day (0 = Sunday in our grid)
    final startingWeekday = firstDayOfMonth.weekday % 7;

    // Build rows
    final rows = <Widget>[];
    var currentDay = 0;

    // Calculate number of rows needed
    final totalCells = startingWeekday + calendarData.length;
    final numRows = (totalCells / 7).ceil();

    for (var row = 0; row < numRows; row++) {
      final cells = <Widget>[];

      for (var col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;

        if (cellIndex < startingWeekday || currentDay >= calendarData.length) {
          // Empty cell
          cells.add(const Expanded(child: SizedBox(height: 50)));
        } else {
          cells.add(
            Expanded(
              child: SizedBox(
                height: 50,
                child: CalendarDayCell(data: calendarData[currentDay]),
              ),
            ),
          );
          currentDay++;
        }
      }

      rows.add(Row(children: cells));
    }

    return Column(children: rows);
  }
}
