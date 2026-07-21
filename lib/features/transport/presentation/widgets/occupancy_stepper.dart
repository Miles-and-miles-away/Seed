import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Stepper choosing how many people share a per-vehicle mode.
///
/// Occupancy divides per-vehicle emissions in the calculator, so the
/// value is kept within 1..[max] (the mode's max occupants).
class OccupancyStepper extends StatelessWidget {
  const OccupancyStepper({
    required this.value,
    required this.max,
    required this.onChanged,
    super.key,
  });

  /// Current number of occupants.
  final int value;

  /// The mode's maximum occupancy.
  final int max;

  /// Called with the new occupant count.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.transportOccupantsLabel,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: l10n.transportOccupantsRemove,
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
        ),
        Text(
          '$value',
          style: theme.textTheme.titleMedium,
          // A bare number reads meaninglessly out of context to a
          // screen reader; bind it to its label (PDR R5-18).
          semanticsLabel: l10n.transportOccupantsSemantic(value),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: l10n.transportOccupantsAdd,
          onPressed: value < max ? () => onChanged(value + 1) : null,
        ),
      ],
    );
  }
}
