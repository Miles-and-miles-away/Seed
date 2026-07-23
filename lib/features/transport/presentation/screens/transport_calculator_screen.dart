import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/transport_calculator.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/features/transport/presentation/screens/journey_comparison_screen.dart';
import 'package:seed_app/features/transport/presentation/screens/transport_methodology_screen.dart';
import 'package:seed_app/features/transport/presentation/widgets/journey_leg_card.dart';
import 'package:seed_app/features/transport/presentation/widgets/leg_editor_sheet.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Journey builder screen: build a multi-leg journey and see its
/// CO2e footprint. Educational tool only -- it never awards points
/// or credits CO2 savings (No Fake Points, Phase 8 plan).
///
/// Build a journey, stage it as a comparison option, then compare
/// 2-3 side by side (8.3). A methodology link (8.4) opens the
/// sources page.
class TransportCalculatorScreen extends ConsumerStatefulWidget {
  const TransportCalculatorScreen({super.key});

  @override
  ConsumerState<TransportCalculatorScreen> createState() =>
      _TransportCalculatorScreenState();
}

class _TransportCalculatorScreenState
    extends ConsumerState<TransportCalculatorScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logTransportCalculatorOpened();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modesAsync = ref.watch(transportModesByIdProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transportCalculatorTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.science_outlined),
            tooltip: l10n.transportMethodologyTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const TransportMethodologyScreen(),
              ),
            ),
          ),
        ],
      ),
      body: modesAsync.when(
        data: (modesById) => _JourneyBuilderView(modesById: modesById),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: ErrorDisplay()),
      ),
    );
  }
}

class _JourneyBuilderView extends ConsumerWidget {
  const _JourneyBuilderView({required this.modesById});

  final Map<String, TransportMode> modesById;

  Future<void> _addLeg(BuildContext context, WidgetRef ref) async {
    final leg = await LegEditorSheet.show(context);
    if (leg == null || !context.mounted) return;
    ref.read(journeyBuilderProvider.notifier).addLeg(leg);
  }

  Future<void> _editLeg(
    BuildContext context,
    WidgetRef ref,
    int index,
    JourneyLeg leg,
  ) async {
    final updated = await LegEditorSheet.show(
      context,
      initialLeg: leg,
      initialMode: modesById[leg.modeId],
    );
    if (updated == null || !context.mounted) return;
    ref.read(journeyBuilderProvider.notifier).updateLeg(index, updated);
  }

  /// Snapshots the current journey as a comparison option and clears
  /// the builder so the next option starts fresh.
  void _stageForComparison(BuildContext context, WidgetRef ref) {
    final legs = ref.read(journeyBuilderProvider);
    ref.read(journeyComparisonProvider.notifier).add(legs);
    ref.read(journeyBuilderProvider.notifier).clear();
    final count = ref.read(journeyComparisonProvider).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).transportOptionStaged(count),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openComparison(BuildContext context, WidgetRef ref) {
    final options = ref.read(journeyComparisonProvider);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            JourneyComparisonScreen(options: options, modesById: modesById),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final legs = ref.watch(journeyBuilderProvider);
    final comparisonCount = ref.watch(journeyComparisonProvider).length;
    if (legs.isEmpty) {
      return _EmptyJourney(
        onAddLeg: () => _addLeg(context, ref),
        comparisonCount: comparisonCount,
        onCompare: comparisonCount >= 2
            ? () => _openComparison(context, ref)
            : null,
      );
    }
    final total = TransportCalculator.journeyCo2eGrams(modesById, legs);
    final atCap = comparisonCount >= comparisonMaxOptions;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(spacingLg),
            children: [
              for (var i = 0; i < legs.length; i++)
                JourneyLegCard(
                  leg: legs[i],
                  mode: modesById[legs[i].modeId]!,
                  onTap: () => _editLeg(context, ref, i, legs[i]),
                  onRemove: () =>
                      ref.read(journeyBuilderProvider.notifier).removeLeg(i),
                ),
              const SizedBox(height: spacingSm),
              OutlinedButton.icon(
                onPressed: () => _addLeg(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.transportAddLeg),
              ),
              const SizedBox(height: spacingSm),
              FilledButton.tonalIcon(
                onPressed: atCap
                    ? null
                    : () => _stageForComparison(context, ref),
                icon: const Icon(Icons.playlist_add),
                label: Text(
                  atCap
                      ? l10n.transportComparisonFull(comparisonMaxOptions)
                      : l10n.transportAddToComparison,
                ),
              ),
              if (comparisonCount >= 2) ...[
                const SizedBox(height: spacingSm),
                FilledButton.icon(
                  onPressed: () => _openComparison(context, ref),
                  icon: const Icon(Icons.bar_chart),
                  label: Text(l10n.transportCompareOptions(comparisonCount)),
                ),
              ],
            ],
          ),
        ),
        _TotalBar(totalGrams: total),
      ],
    );
  }
}

/// Persistent journey total. Emissions of the built journey, not a
/// saving -- comparison deltas (8.3) use "emits X less" copy.
class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.totalGrams});

  final double totalGrams;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          // Both texts flex so large text scales wrap instead of
          // overflowing the bar.
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.transportTotalLabel,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: spacingSm),
              Flexible(
                child: Text(
                  '${formatCO2Compact(totalGrams.round())} CO2e',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyJourney extends StatelessWidget {
  const _EmptyJourney({
    required this.onAddLeg,
    required this.comparisonCount,
    this.onCompare,
  });

  final VoidCallback onAddLeg;
  final int comparisonCount;
  final VoidCallback? onCompare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Scrollable so the empty state stays reachable at the largest
    // accessibility text scales.
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.route,
              size: spacingHuge,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: spacingMd),
            Text(
              l10n.transportJourneyEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: spacingLg),
            FilledButton.icon(
              onPressed: onAddLeg,
              icon: const Icon(Icons.add),
              label: Text(l10n.transportAddLeg),
            ),
            // Staged options survive an emptied builder, so keep the
            // compare action reachable from the empty state too.
            if (onCompare != null) ...[
              const SizedBox(height: spacingSm),
              FilledButton.tonalIcon(
                onPressed: onCompare,
                icon: const Icon(Icons.bar_chart),
                label: Text(l10n.transportCompareOptions(comparisonCount)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
