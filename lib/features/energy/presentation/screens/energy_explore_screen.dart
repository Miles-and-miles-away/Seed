import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_explore_sheet.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_ranked_table.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Baselines a row may be measured against, with the icon that fills
/// the what-if sheet's wall.
///
/// Every one is a dataset row with a one-unit default preset, never an
/// equivalency constant (rule 27), so switching baseline re-expresses
/// the ratios without changing what is being claimed.
const _baselines = <(String, IconData)>[
  (EnergyRankedTable.defaultAnchorId, Icons.lightbulb_outline),
  ('phone_charge', Icons.smartphone),
  ('kettle', Icons.water_drop),
  ('fan', Icons.air),
];

/// "Where your energy goes" as its own surface (decision E8).
///
/// The ranked table promoted out of the methodology screen, plus the
/// two things a teaching table could not do two taps deep: switch the
/// measuring baseline, and answer "what if I did it for longer" per row
/// without leaving the list.
class EnergyExploreScreen extends ConsumerStatefulWidget {
  const EnergyExploreScreen({super.key});

  @override
  ConsumerState<EnergyExploreScreen> createState() =>
      _EnergyExploreScreenState();
}

class _EnergyExploreScreenState extends ConsumerState<EnergyExploreScreen> {
  String _anchorId = EnergyRankedTable.defaultAnchorId;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logEnergyExploreOpened();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final behaviorsAsync = ref.watch(energyBehaviorsProvider);
    final factorsAsync = ref.watch(energyCarrierFactorsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.energyRankedTitle)),
      body: switch ((behaviorsAsync, factorsAsync)) {
        (AsyncData(value: final behaviors), AsyncData(value: final factors)) =>
          _buildBody(context, l10n, behaviors, factors),
        (AsyncError(), _) ||
        (_, AsyncError()) => const Center(child: ErrorDisplay()),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  /// One baseline choice: equal width, equal height, and the energy
  /// category's own yellow when it is the active baseline.
  Widget _baselineButton(
    BuildContext context,
    AppLocalizations l10n,
    (String, IconData) baseline, {
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final accent = ActionCategory.energy.color;
    final (id, icon) = baseline;
    return Material(
      color: isSelected
          ? accent.withValues(alpha: opacityLight)
          : theme.colorScheme.surface,
      borderRadius: borderRadiusMd,
      child: InkWell(
        onTap: () => setState(() => _anchorId = id),
        borderRadius: borderRadiusMd,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: spacingMd,
            horizontal: spacingSm,
          ),
          decoration: BoxDecoration(
            borderRadius: borderRadiusMd,
            // One width for every state: a thicker selected border made
            // that button 2pt taller than its neighbours.
            border: Border.all(
              color: isSelected ? accent : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? accent : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: spacingSm),
              Flexible(
                child: Text(
                  energyAnchorChipLabel(l10n, id),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    List<EnergyBehavior> behaviors,
    CarrierFactors factors,
  ) {
    final theme = Theme.of(context);
    // Only offer baselines the loaded list actually has, and never
    // measure against one it does not: the table degrades to
    // grams-only, so a missing anchor must not throw either.
    final present = _baselines
        .where((b) => behaviors.any((behavior) => behavior.id == b.$1))
        .toList();
    final selected = present.any((b) => b.$1 == _anchorId)
        ? _anchorId
        : (present.firstOrNull?.$1 ?? _anchorId);
    final anchorIcon =
        present.where((b) => b.$1 == selected).firstOrNull?.$2 ?? Icons.bolt;
    final anchor = behaviors.where((b) => b.id == selected).firstOrNull;
    final anchorUnitPhrase = energyAnchorUnitPhrase(l10n, selected);

    return ListView(
      padding: const EdgeInsets.all(spacingXxl),
      children: [
        if (present.isNotEmpty) ...[
          // Two per row, each half the width: a Wrap sized every button
          // to its own label, which read as a ragged pile rather than a
          // set of equal choices.
          for (var i = 0; i < present.length; i += 2) ...[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _baselineButton(
                      context,
                      l10n,
                      present[i],
                      isSelected: present[i].$1 == selected,
                    ),
                  ),
                  const SizedBox(width: spacingSm),
                  if (i + 1 < present.length)
                    Expanded(
                      child: _baselineButton(
                        context,
                        l10n,
                        present[i + 1],
                        isSelected: present[i + 1].$1 == selected,
                      ),
                    )
                  else
                    // A lone odd button keeps its half of the row, so
                    // the grid stays a grid.
                    const Spacer(),
                ],
              ),
            ),
            const SizedBox(height: spacingSm),
          ],
          const SizedBox(height: spacingMd),
        ],
        Text(
          l10n.energyExploreIntro(anchorUnitPhrase),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: spacingLg),
        EnergyRankedTable(
          behaviors: behaviors,
          anchorId: selected,
          showHeading: false,
          showBars: true,
          onRowTap: (behavior) => EnergyExploreSheet.show(
            context,
            behavior: behavior,
            anchorBehavior: anchor,
            anchorIcon: anchorIcon,
            anchorUnitPhrase: anchorUnitPhrase,
            factors: factors,
          ),
        ),
        const SizedBox(height: spacingLg),
        // The sqrt scale is a deliberate distortion: without saying so,
        // the bars would overstate every small row.
        Text(
          l10n.energyExploreBarNote,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
