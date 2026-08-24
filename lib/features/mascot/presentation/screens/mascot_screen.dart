import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import '../providers/mascot_providers.dart';
import '../widgets/evolution_timeline.dart';
import '../widgets/mascot_collection_section.dart';
import '../widgets/mascot_display.dart';
import '../widgets/mascot_header.dart';
import '../widgets/mascot_housing.dart';
import '../widgets/mascot_stats_card.dart';
import '../widgets/max_evolution_card.dart';
import '../widgets/next_evolution_card.dart';

/// The main mascot screen with evolution timeline and
/// multi-mascot collection.
class MascotScreen extends ConsumerWidget {
  const MascotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final mascot = ref.watch(activeMascotProvider).value;
    final species = ref.watch(activeSpeciesProvider);
    final currentStage = ref.watch(activeMascotStageProvider);
    final stageName = ref.watch(stageLocalizedNameProvider(locale));
    final nextStageData = ref.watch(activeNextStageDataProvider);
    final allMascots = ref.watch(allMascotsProvider).value ?? [];
    final hasEgg = ref.watch(hasEggProvider);

    if (mascot == null || species == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: spacingLg),
              Text(l10n.navMascot),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(l10n.navMascot),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(spacingXxl),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mascot display, in the shared housing card so the
                  // background matches the home screen
                  MascotHousing(
                    child: Column(
                      children: [
                        const MascotDisplay(size: 220),
                        const SizedBox(height: spacingLg),
                        MascotHeader(
                          name: mascot.name,
                          stageName:
                              stageName ?? l10n.stageFallback(currentStage),
                          mascotLevel: mascot.mascotLevel,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: spacingXxxl),

                  // Our Journey -- per-mascot stats
                  MascotStatsCard(mascot: mascot),

                  const SizedBox(height: spacingXxxl),

                  // My Mascots collection
                  if (allMascots.length > 1 || hasEgg) ...[
                    MascotCollectionSection(
                      mascots: allMascots,
                      activeMascotId: mascot.id,
                      hasEgg: hasEgg,
                    ),
                    const SizedBox(height: spacingXxxl),
                  ],

                  // Evolution Timeline
                  Text(
                    l10n.mascotEvolutionTimeline,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: spacingLg),
                  EvolutionTimeline(
                    stages: species.evolutionStages,
                    currentStage: currentStage,
                  ),

                  const SizedBox(height: spacingXxxl),

                  // Next Evolution / Max Evolution
                  if (nextStageData != null) ...[
                    Text(
                      l10n.mascotNextEvolution,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: spacingLg),
                    NextEvolutionCard(
                      nextStage: nextStageData,
                      mascotLevel: mascot.mascotLevel,
                    ),
                  ] else ...[
                    MaxEvolutionCard(hasEgg: hasEgg),
                  ],

                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
