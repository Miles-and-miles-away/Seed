import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Monthly calendar showing which days the user viewed
/// their eco-fact. Tapping a past viewed day re-reads
/// that day's fact (navigates to detail -- for now just
/// shows the fact inline via callback).
class FactCalendar extends ConsumerWidget {
  const FactCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(factCalendarSelectedMonthProvider);
    final calendarAsync = ref.watch(factCalendarDataProvider);
    final canGoNext =
        ref.watch(factCalendarSelectedMonthProvider.notifier).canGoToNextMonth;

    return Column(
      children: [
        _buildHeader(
          context,
          ref,
          selectedMonth,
          canGoNext,
        ),
        const SizedBox(height: Spacing.sm),
        _buildWeekdayLabels(context),
        const SizedBox(height: Spacing.sm),
        calendarAsync.when(
          data: (days) => _buildGrid(context, selectedMonth, days),
          loading: () => const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => const SizedBox(
            height: 200,
            child: Center(
              child: ErrorDisplay(compact: true),
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
    final l10n = AppLocalizations.of(context);
    final monthFormat = DateFormat.yMMMM();

    return Column(
      children: [
        Text(
          l10n.ecoFactCalendar,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                ref
                    .read(
                      factCalendarSelectedMonthProvider.notifier,
                    )
                    .goToPreviousMonth();
              },
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              monthFormat.format(selectedMonth),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: canGoNext
                  ? () {
                      ref
                          .read(
                            factCalendarSelectedMonthProvider.notifier,
                          )
                          .goToNextMonth();
                    }
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final weekdays = List.generate(7, (i) {
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

  Widget _buildGrid(
    BuildContext context,
    DateTime selectedMonth,
    List<FactCalendarDay> calendarData,
  ) {
    final firstDayOfMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month,
    );
    final startingWeekday = firstDayOfMonth.weekday % 7;

    final rows = <Widget>[];
    var currentDay = 0;
    final totalCells = startingWeekday + calendarData.length;
    final numRows = (totalCells / 7).ceil();

    for (var row = 0; row < numRows; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;
        if (cellIndex < startingWeekday || currentDay >= calendarData.length) {
          cells.add(
            const Expanded(child: SizedBox(height: 44)),
          );
        } else {
          final day = calendarData[currentDay];
          cells.add(
            Expanded(
              child: _FactCalendarDayCell(
                day: day,
                onTap: day.isViewed && !day.isFuture
                    ? () => context.push(
                          '/home/daily-fact',
                        )
                    : null,
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

class _FactCalendarDayCell extends StatelessWidget {
  const _FactCalendarDayCell({
    required this.day,
    this.onTap,
  });

  final FactCalendarDay day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color? bgColor;
    var textColor = colorScheme.onSurface;
    var fontWeight = FontWeight.normal;

    if (day.isFuture) {
      textColor = colorScheme.onSurface.withValues(
        alpha: Opacities.muted,
      );
    } else if (day.isToday) {
      bgColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      fontWeight = FontWeight.bold;
    } else if (day.isViewed) {
      bgColor = colorScheme.primary.withValues(
        alpha: Opacities.subtle,
      );
      textColor = colorScheme.primary;
      fontWeight = FontWeight.w600;
    } else {
      textColor = colorScheme.onSurface.withValues(
        alpha: Opacities.strong,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: bgColor != null
                ? BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  )
                : null,
            alignment: Alignment.center,
            child: Text(
              '${day.date.day}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
