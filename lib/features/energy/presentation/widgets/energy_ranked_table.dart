import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';

/// "Where your energy goes": the ranked, single-carrier, ratio-led
/// teaching table (decision E8; PDR rules 26-28).
///
/// Electricity rows, plus `line_dry` whose zero holds on any grid, are
/// ranked by the kWh of one default-preset use and stated as a
/// multiple of an hour of LED light. The anchor is a dataset row, not
/// an equivalency constant (rule 27), so the multiples hold on every
/// grid; the gram figures do not, and carry the basis note on the
/// screen that hosts this widget. Gas rows are shown beneath WITHOUT a
/// rank (rule 28): a gas row's position moves with the user's grid.
///
/// Standalone on purpose: the E8 in-app comparison may promote this
/// widget from the methodology screen to its own surface.
class EnergyRankedTable extends StatelessWidget {
  const EnergyRankedTable({
    required this.behaviors,
    required this.gridFactor,
    required this.gasFactor,
    super.key,
  });

  final List<EnergyBehavior> behaviors;
  final double gridFactor;
  final double gasFactor;

  /// The rank-1 row every multiple is stated against (rule 27).
  static const _anchorId = 'led_bulb';

  static double _defaultKwh(EnergyBehavior behavior) =>
      behavior.kwhPerUnit * (behavior.defaultPreset?.units ?? 1);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    // A list without the anchor degrades to grams-only rather than
    // throwing: the dataset pins the row, but this widget is exported
    // standalone and a caller may hand it a filtered list.
    final anchors = behaviors.where((b) => b.id == _anchorId);
    final anchorKwh = anchors.isEmpty ? 0.0 : _defaultKwh(anchors.first);
    // Stable secondary sort (rule 22) so tie-cluster rows do not
    // jitter between dataset regenerations.
    int byKwhThenName(EnergyBehavior a, EnergyBehavior b) {
      final byKwh = _defaultKwh(b).compareTo(_defaultKwh(a));
      return byKwh != 0 ? byKwh : a.name(locale).compareTo(b.name(locale));
    }

    final ranked =
        behaviors.where((b) => b.carrier != EnergyCarrier.gas).toList()
          ..sort(byKwhThenName);
    final gas = behaviors.where((b) => b.carrier == EnergyCarrier.gas).toList()
      ..sort(byKwhThenName);
    final noteStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.energyRankedTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: spacingSm),
        Text(l10n.energyRankedIntro, style: noteStyle),
        const SizedBox(height: spacingMd),
        for (final behavior in ranked)
          _row(
            context,
            l10n,
            locale,
            behavior,
            multiple: anchorKwh > 0 && _defaultKwh(behavior) > 0
                ? _defaultKwh(behavior) / anchorKwh
                : null,
            grams: _defaultKwh(behavior) * gridFactor,
          ),
        const SizedBox(height: spacingLg),
        Text(
          l10n.energyRankedGasHeading,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: spacingSm),
        Text(l10n.energyRankedGasNote, style: noteStyle),
        const SizedBox(height: spacingMd),
        for (final behavior in gas)
          _row(
            context,
            l10n,
            locale,
            behavior,
            multiple: null,
            grams: _defaultKwh(behavior) * gasFactor,
          ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    AppLocalizations l10n,
    String locale,
    EnergyBehavior behavior, {
    required double? multiple,
    required double grams,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: spacingSm),
      child: Row(
        children: [
          Icon(
            energyGroupIcon(behavior.comparableGroup),
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(behavior.name(locale), style: theme.textTheme.bodyMedium),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (multiple != null)
                Text(
                  l10n.energyRankedMultiple(
                    formatEnergyMultiple(locale, multiple),
                  ),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                formatCO2Compact(grams.round()),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
