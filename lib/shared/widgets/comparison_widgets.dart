import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';

/// Shared presentation widgets for the Phase 8 calculator comparison
/// views (transport 8.3, food 8.9, energy 8.15).
///
/// Feature-agnostic: the screens own labels, totals and the "emits X
/// less" copy; these render the two option columns, the draggable
/// item pool, and the result panel.

/// A CO2e figure whose unit is a link to a plain-language definition
/// of the term.
///
/// "CO2e" is unavoidable jargon -- the factors include methane, N2O
/// and the flight radiative-forcing uplift, so calling them "CO2"
/// would be wrong rather than simpler. Defining it in place is the
/// honest fix. The whole amount is the tap target, not just the four
/// characters, so it clears the minimum touch size.
class Co2eAmount extends StatelessWidget {
  const Co2eAmount({required this.grams, this.style, super.key});

  final double grams;
  final TextStyle? style;

  static Future<void> showDefinition(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.co2eDefinitionTitle),
        content: Text(l10n.co2eDefinitionBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.buttonClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final base = style ?? theme.textTheme.bodyMedium;
    return Semantics(
      button: true,
      label: l10n.co2eDefinitionTitle,
      child: InkWell(
        onTap: () => showDefinition(context),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${formatCO2Compact(grams.round())} '),
              TextSpan(
                text: 'CO2e',
                style: base?.copyWith(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          style: base,
        ),
      ),
    );
  }
}

/// One of the two side-by-side option columns.
///
/// [fraction] scales the magnitude bar against the worse column, so
/// the two bars read as a comparison without needing a separate chart.
///
/// Entries arrive from the feature screen's own "add" button, which
/// knows its column -- both calculators dropped drag-and-drop once
/// their item lists outgrew a reachable chip strip.
class OptionColumn extends StatelessWidget {
  const OptionColumn({
    required this.title,
    required this.totalGrams,
    required this.fraction,
    required this.isBest,
    required this.isEmpty,
    required this.emptyHint,
    required this.children,
    super.key,
  });

  final String title;
  final double totalGrams;
  final double fraction;
  final bool isBest;
  final bool isEmpty;
  final String emptyHint;

  /// The entry cards already built by the feature screen.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusMd,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingXs),
          Co2eAmount(
            grams: totalGrams,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isBest ? theme.colorScheme.primary : null,
            ),
          ),
          const SizedBox(height: spacingXs),
          ClipRRect(
            borderRadius: borderRadiusSm,
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(
                isBest
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondaryContainer,
              ),
            ),
          ),
          const SizedBox(height: spacingSm),
          Expanded(
            child: isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(spacingSm),
                      child: Text(
                        emptyHint,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : ListView(padding: EdgeInsets.zero, children: children),
          ),
        ],
      ),
    );
  }
}

/// A compact entry card inside an [OptionColumn]: name, a detail line,
/// its CO2e, and a remove button. Narrow by design -- two of these sit
/// side by side on a phone.
class OptionEntryCard extends StatelessWidget {
  const OptionEntryCard({
    required this.icon,
    required this.name,
    required this.detail,
    required this.grams,
    required this.removeTooltip,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final IconData icon;
  final String name;
  final String detail;
  final double grams;
  final String removeTooltip;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: spacingXs),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadiusMd,
        child: Padding(
          padding: const EdgeInsets.all(spacingSm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: spacingXs),
                  Expanded(
                    child: Text(
                      name,
                      style: theme.textTheme.labelLarge,
                      // Two lines: the columns are half a phone wide,
                      // so "Medium petrol car" ellipsises on one.
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Dense so the card stays short in a narrow column.
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    tooltip: removeTooltip,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: kMinInteractiveDimension,
                      minHeight: kMinInteractiveDimension,
                    ),
                    onPressed: onRemove,
                  ),
                ],
              ),
              Text(
                detail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${formatCO2Compact(grams.round())} CO2e',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Delta headline card with an optional equivalency line and any
/// data-honesty basis notes. Both strings are built by the caller
/// (feature-specific l10n keys); this only renders them.
class ComparisonDeltaCard extends StatelessWidget {
  const ComparisonDeltaCard({
    required this.headline,
    this.equivalencyText,
    this.basisNotes = const [],
    super.key,
  });

  final String headline;
  final String? equivalencyText;
  final List<String> basisNotes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headline,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            if (equivalencyText != null) ...[
              const SizedBox(height: spacingXs),
              Text(
                equivalencyText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
            for (final note in basisNotes)
              Padding(
                padding: const EdgeInsets.only(top: spacingXs),
                child: Text(
                  note,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
