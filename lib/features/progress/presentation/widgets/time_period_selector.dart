import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';

/// Segmented control for choosing the active [TimePeriod] on the
/// Impact dashboard. Four canonical periods: Today, This Week, This
/// Month, All Time.
class TimePeriodSelector extends StatelessWidget {
  const TimePeriodSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final TimePeriod selected;
  final ValueChanged<TimePeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SegmentedButton<TimePeriod>(
      segments: [
        ButtonSegment(
          value: TimePeriod.today,
          label: Text(l10n.periodToday),
        ),
        ButtonSegment(
          value: TimePeriod.thisWeek,
          label: Text(l10n.periodThisWeek),
        ),
        ButtonSegment(
          value: TimePeriod.thisMonth,
          label: Text(l10n.periodThisMonth),
        ),
        ButtonSegment(
          value: TimePeriod.allTime,
          label: Text(l10n.periodAllTime),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.first),
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
