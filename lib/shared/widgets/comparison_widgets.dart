import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/shared/widgets/explainer_dialog.dart';

/// Shared presentation widgets for the Phase 8 calculator comparison
/// views (transport 8.3, food 8.9, energy 8.15).
///
/// Feature-agnostic: the screens own labels, totals and the "emits X
/// less" copy; these render the two option columns, the draggable
/// item pool, and the result panel.

/// The column name for [option]: "Option A" or "Option B".
String optionLabel(AppLocalizations l10n, int option) =>
    option == optionA ? l10n.calculatorOptionA : l10n.calculatorOptionB;

/// The AppBar action opening a calculator's methodology screen.
IconButton methodologyAction(
  BuildContext context, {
  required String tooltip,
  required WidgetBuilder builder,
}) => IconButton(
  icon: const Icon(Icons.science_outlined),
  tooltip: tooltip,
  onPressed: () =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: builder)),
);

/// Centered, muted guidance in a calculator's result panel.
class CalculatorHint extends StatelessWidget {
  const CalculatorHint(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// A CO2e figure whose unit is a link to a plain-language definition
/// of the term.
///
/// "CO2e" is unavoidable jargon -- the factors include methane, N2O
/// and the flight radiative-forcing uplift, so calling them "CO2"
/// would be wrong rather than simpler. Defining it in place is the
/// honest fix. The whole amount is the tap target, not just the four
/// characters, so it clears the minimum touch size.
class Co2eAmount extends StatelessWidget {
  const Co2eAmount({
    required this.grams,
    this.style,
    this.accentColor,
    super.key,
  });

  /// The domain's colour. Null keeps the scheme's primary.
  final Color? accentColor;

  final double grams;
  final TextStyle? style;

  static Future<void> showDefinition(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showExplainerDialog(
      context,
      title: l10n.co2eDefinitionTitle,
      body: l10n.co2eDefinitionBody,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The raw category colour, matching the bars and the tokens.
    final ink = accentColor ?? theme.colorScheme.primary;
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
                  color: ink,
                  decoration: TextDecoration.underline,
                  decorationColor: ink,
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

/// The comparison body all three calculators share: the option
/// columns totalled live, an add button under each, and the result
/// block underneath.
///
/// The feature screen keeps what is genuinely its own -- which cards
/// an option holds, what "add" opens, and what the result says.
class ComparisonScaffold extends StatelessWidget {
  const ComparisonScaffold({
    required this.totals,
    required this.entries,
    required this.emptyHint,
    required this.addLabel,
    required this.onAdd,
    required this.bestIndex,
    required this.result,
    this.accentColor,
    super.key,
  });

  /// Grams CO2e per option, in column order.
  final List<double> totals;

  /// Entry cards per option, already built by the feature screen.
  final List<List<Widget>> entries;

  /// Placeholder for a column with no entries yet.
  final String emptyHint;

  /// Label for each column's add button.
  final String addLabel;

  final void Function(int option) onAdd;

  /// Column to crown, or null where the comparison declines to name
  /// one. Transport passes the lowest column unconditionally; food and
  /// energy gate it on their verdict, because crowning a column is a
  /// verdict in its own right.
  final int? bestIndex;

  /// The delta card, gating explanation or hint shown underneath.
  final Widget result;

  /// The domain's colour for the totals and bars. Null keeps the
  /// scheme's primary, which is what a caller with no domain wants.
  final Color? accentColor;

  /// Share of the body the result may claim before it scrolls. Fits
  /// the tallest card (energy, Spanish) at the default text scale and
  /// still leaves the option columns the larger half.
  static const _resultMaxHeightFraction = 0.55;

  /// The floor a column starts at, as a share of the region above the
  /// result. Full-height empty columns read as a form to fill, so a
  /// column starts compact -- the add buttons directly beneath -- and
  /// grows with its entries, capping at the region and scrolling
  /// internally. An empty column is pinned to the floor so its hint
  /// stays centered.
  ///
  /// The buttons share one row: per-column, a filled column beside an
  /// empty one put them 206px apart.
  static const _minColumnFraction = 0.3;

  @override
  Widget build(BuildContext context) {
    assert(
      totals.length == optionCount && entries.length == optionCount,
      'ComparisonScaffold needs one total and one entry list per option',
    );
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    final onAccent = inkOnFill(accent);
    final worst = totals.reduce((a, b) => a > b ? a : b);
    // Bottom only: the result panel is pinned to the bottom of the
    // body and slid under the home indicator without it. The top is
    // the AppBar's problem.
    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            const SizedBox(height: spacingSm),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacingMd),
                child: LayoutBuilder(
                  builder: (context, region) {
                    final floor = region.maxHeight * _minColumnFraction;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (
                                var option = 0;
                                option < optionCount;
                                option++
                              ) ...[
                                if (option > 0)
                                  const SizedBox(width: spacingSm),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: floor,
                                      maxHeight: entries[option].isEmpty
                                          ? floor
                                          : double.infinity,
                                    ),
                                    child: OptionColumn(
                                      accentColor: accentColor,
                                      title: optionLabel(l10n, option),
                                      totalGrams: totals[option],
                                      fraction: worst <= 0
                                          ? 0
                                          : totals[option] / worst,
                                      isBest: option == bestIndex,
                                      isEmpty: entries[option].isEmpty,
                                      emptyHint: emptyHint,
                                      children: entries[option],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: spacingSm),
                        Row(
                          children: [
                            for (
                              var option = 0;
                              option < optionCount;
                              option++
                            ) ...[
                              if (option > 0) const SizedBox(width: spacingSm),
                              Expanded(
                                child: FilledButton.tonalIcon(
                                  style: FilledButton.styleFrom(
                                    // Solid category colour, with dark
                                    // ink on it: white on amber is
                                    // 1.9:1, near-black is 11:1.
                                    backgroundColor: accent,
                                    foregroundColor: onAccent,
                                  ),
                                  onPressed: () => onAdd(option),
                                  icon: const Icon(Icons.add),
                                  label: Text(addLabel),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Fixed-height child: the energy card overflowed it by
            // 452px at textScale 2, so cap it and let it scroll.
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * _resultMaxHeightFraction,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(spacingMd),
                  child: result,
                ),
              ),
            ),
          ],
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
    this.accentColor,
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

  /// The domain's colour for this column's total and bar.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    final ink = readableTextColor(accent, theme.brightness);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusMd,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(spacingSm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          assert(
            constraints.maxHeight.isFinite,
            'OptionColumn needs a bounded height; ComparisonScaffold '
            'gives it one.',
          );
          return Column(
            // min, so the card wraps its entries: the scaffold's floor
            // and cap constraints decide the rest.
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fixed-height header: it overflowed a squeezed column at
              // a large text scale, so cap it and let it scroll.
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: (constraints.maxHeight - spacingSm).clamp(
                    0.0,
                    double.infinity,
                  ),
                ),
                child: SingleChildScrollView(
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
                        accentColor: accent,
                        grams: totalGrams,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isBest ? ink : null,
                        ),
                      ),
                      const SizedBox(height: spacingXs),
                      ClipRRect(
                        borderRadius: borderRadiusSm,
                        child: LinearProgressIndicator(
                          value: fraction.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(
                            isBest
                                ? accent
                                : accent.withValues(alpha: opacityMuted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: spacingSm),
              // Empty columns arrive height-pinned (tight constraints), so
              // Expanded centers the hint in exactly the floor height. With
              // entries the list shrink-wraps, growing the card until the
              // cap clamps it and the list scrolls.
              if (isEmpty)
                Expanded(
                  child: Center(
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
                  ),
                )
              else
                Flexible(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: children,
                  ),
                ),
            ],
          );
        },
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
    this.accentColor,
    super.key,
  });

  /// The domain's colour. Null keeps the scheme's primary.
  final Color? accentColor;

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
    final accent = accentColor ?? theme.colorScheme.primary;
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
                  Icon(icon, size: 16, color: accent),
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
    this.accentColor,
    super.key,
  });

  final String headline;
  final String? equivalencyText;
  final List<String> basisNotes;

  /// The domain's colour. Null keeps the scheme's primary.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    final ink = readableTextColor(accent, theme.brightness);
    // The headline is 16pt bold, which clears at 3:1, so it keeps more
    // of the domain's colour than the lines under it.
    final headlineInk = readableTextColor(
      accent,
      theme.brightness,
      large: true,
    );
    return Card(
      color: accent.withValues(alpha: opacitySubtle),
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
                color: headlineInk,
              ),
            ),
            if (equivalencyText != null) ...[
              const SizedBox(height: spacingXs),
              Text(
                equivalencyText!,
                style: theme.textTheme.bodySmall?.copyWith(color: ink),
              ),
            ],
            for (final note in basisNotes)
              Padding(
                padding: const EdgeInsets.only(top: spacingXs),
                child: Text(
                  note,
                  style: theme.textTheme.bodySmall?.copyWith(color: ink),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
