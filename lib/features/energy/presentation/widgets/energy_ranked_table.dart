import 'dart:math';

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';

/// "Where your energy goes": the ranked, energy-led teaching table
/// (decision E8; PDR rules 26-27).
///
/// Every behavior is ranked by the kWh of one default-preset use and
/// stated as a multiple of [anchorId]'s own default use. The anchor is
/// a dataset row, not an equivalency constant (rule 27), so the
/// multiples hold on every grid.
///
/// Gas rows sit in the same ranking (rule 28). What this ranks is
/// ENERGY USED: the part a habit decides,
/// and the part that barely moves over a decade. How clean a kWh is
/// belongs to the grid, differs by country and improves every year.
/// That leaves one thing a reader can misread -- a gas water heater
/// uses more energy than an electric one for the same bath, yet emits
/// less on today's world-average grid -- so [AppLocalizations
/// .energyRankedGasNote] is rendered under every copy of this table,
/// and each gas row repeats it when tapped.
///
/// Shared by the methodology screen (defaults: headed, no bars, no row
/// taps) and the explore screen, which switches the anchor, draws bars
/// and opens a what-if sheet per row.
class EnergyRankedTable extends StatelessWidget {
  const EnergyRankedTable({
    required this.behaviors,
    this.anchorId = defaultAnchorId,
    this.showHeading = true,
    this.showBars = false,
    this.onRowTap,
    super.key,
  });

  final List<EnergyBehavior> behaviors;

  /// The row every multiple is stated against (rule 27).
  final String anchorId;

  /// Renders the title and the LED-anchored intro. Off for callers that
  /// write their own intro, which any non-default [anchorId] must.
  final bool showHeading;

  /// Draws a square-root-scaled bar under each ranked row. A caller
  /// that turns these on owes the user the distortion footnote.
  final bool showBars;

  /// Makes ranked and gas rows tappable, e.g. to open a what-if sheet.
  final ValueChanged<EnergyBehavior>? onRowTap;

  /// The rank-1 row of the shipped dataset: an hour of LED light.
  static const defaultAnchorId = 'led_bulb';

  /// Bar height: a rank cue beside the numbers, never the headline.
  static const _barHeight = 6.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    // A list without the anchor shows names without multiples rather
    // than throwing: the dataset pins the row, but this widget is
    // exported standalone and a caller may hand it a filtered list.
    final anchors = behaviors.where((b) => b.id == anchorId);
    final anchorKwh = anchors.isEmpty
        ? 0.0
        : EnergyCalculator.defaultPresetKwh(anchors.first);
    // One list, gas included: this ranks energy used (rule 28). Stable
    // secondary sort (rule 22) so tie-cluster rows do not jitter
    // between dataset regenerations.
    final ranked =
        [
          for (final b in behaviors)
            (behavior: b, kwh: EnergyCalculator.defaultPresetKwh(b)),
        ]..sort((a, b) {
          final byKwh = b.kwh.compareTo(a.kwh);
          return byKwh != 0
              ? byKwh
              : a.behavior.name(locale).compareTo(b.behavior.name(locale));
        });
    final maxRankedKwh = ranked.isEmpty ? 0.0 : ranked.first.kwh;
    final noteStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeading) ...[
          Text(
            l10n.energyRankedTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingSm),
          Text(l10n.energyRankedIntro, style: noteStyle),
          const SizedBox(height: spacingMd),
        ],
        for (final row in ranked)
          _row(
            context,
            l10n,
            locale,
            row.behavior,
            multiple: anchorKwh > 0 && row.kwh > 0 ? row.kwh / anchorKwh : null,
            barFraction: showBars && maxRankedKwh > 0
                ? sqrt(row.kwh / maxRankedKwh)
                : null,
          ),
        const SizedBox(height: spacingLg),
        Text(l10n.energyRankedGasNote, style: noteStyle),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    AppLocalizations l10n,
    String locale,
    EnergyBehavior behavior, {
    required double? multiple,
    required double? barFraction,
  }) {
    final theme = Theme.of(context);
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                energyGroupIcon(behavior.comparableGroup),
                size: 20,
                color: ActionCategory.energy.color,
              ),
              const SizedBox(width: spacingLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      behavior.name(locale),
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (behavior.defaultPreset != null)
                      Text(
                        behavior.defaultPreset!.name(locale),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: spacingLg),
              if (multiple != null)
                Text(
                  l10n.energyRankedMultiple(
                    formatEnergyMultiple(locale, multiple),
                  ),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          if (barFraction != null) ...[
            const SizedBox(height: spacingSm),
            ClipRRect(
              borderRadius: borderRadiusXs,
              child: Container(
                height: _barHeight,
                color: theme.colorScheme.surfaceContainerHighest,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: barFraction,
                  child: ColoredBox(color: ActionCategory.energy.color),
                ),
              ),
            ),
          ],
        ],
      ),
    );
    if (onRowTap == null) return content;
    return InkWell(onTap: () => onRowTap!(behavior), child: content);
  }
}
