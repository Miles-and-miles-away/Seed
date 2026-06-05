import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
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
        _segment(TimePeriod.today, l10n.periodToday),
        _segment(TimePeriod.thisWeek, l10n.periodThisWeek),
        _segment(TimePeriod.thisMonth, l10n.periodThisMonth),
        _segment(TimePeriod.allTime, l10n.periodAllTime),
      ],
      selected: {selected},
      onSelectionChanged: (set) => onChanged(set.first),
      // The default checkmark steals width from the selected segment,
      // pushing labels onto a second line on narrow phones.
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: spacingSm),
      ),
    );
  }

  /// Labels must never wrap; scale down instead so longer
  /// translations (e.g. "Esta semana") stay on one line.
  ButtonSegment<TimePeriod> _segment(TimePeriod value, String label) {
    return ButtonSegment(
      value: value,
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(label, maxLines: 1, softWrap: false),
      ),
    );
  }
}
