import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/utils/helpers.dart';

/// Shared presentation widgets for the Phase 8 calculator comparison
/// views (transport 8.3, food 8.9, energy 8.15). Feature-agnostic: the
/// screens own labels, totals, and the "emits X less" copy; these render
/// the bars, the "I took / instead of" pickers, and the delta card.

/// One horizontal option bar scaled to the worst option. The best option
/// is highlighted; [basisNotes] renders any data-honesty sublabels.
class ComparisonOptionBar extends StatelessWidget {
  const ComparisonOptionBar({
    required this.label,
    required this.grams,
    required this.fraction,
    required this.isBest,
    this.basisNotes = const [],
    super.key,
  });

  final String label;
  final double grams;
  final double fraction;
  final bool isBest;
  final List<String> basisNotes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = isBest
        ? theme.colorScheme.primary
        : theme.colorScheme.secondaryContainer;
    return Padding(
      padding: const EdgeInsets.only(bottom: spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: spacingSm),
              Text(
                '${formatCO2Compact(grams.round())} CO2e',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: spacingXs),
          ClipRRect(
            borderRadius: borderRadiusSm,
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          for (final note in basisNotes)
            Padding(
              padding: const EdgeInsets.only(top: spacingXs),
              child: Text(
                note,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal, scrollable single-select over the option labels for the
/// "I took" / "instead of" bank pickers (Option C).
class ChoiceSelector extends StatelessWidget {
  const ChoiceSelector({
    required this.title,
    required this.labels,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String title;
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelLarge),
        const SizedBox(height: spacingXs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              for (var i = 0; i < labels.length; i++)
                ButtonSegment(value: i, label: Text(labels[i])),
            ],
            selected: {selected},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ),
      ],
    );
  }
}

/// Delta headline card with an optional equivalency line. Both strings
/// are built by the caller (feature-specific l10n keys); this only
/// renders them in the primaryContainer card.
class ComparisonDeltaCard extends StatelessWidget {
  const ComparisonDeltaCard({
    required this.headline,
    this.equivalencyText,
    super.key,
  });

  final String headline;
  final String? equivalencyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headline,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            if (equivalencyText != null) ...[
              const SizedBox(height: spacingXs),
              Text(
                equivalencyText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
