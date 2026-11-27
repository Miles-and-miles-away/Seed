import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/shared/widgets/scaled_segmented_button.dart';

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
    return ScaledSegmentedButton<TimePeriod>(
      segments: [
        (TimePeriod.today, l10n.periodToday),
        (TimePeriod.thisWeek, l10n.periodThisWeek),
        (TimePeriod.thisMonth, l10n.periodThisMonth),
        (TimePeriod.allTime, l10n.periodAllTime),
      ],
      selected: selected,
      onSelected: onChanged,
    );
  }
}
