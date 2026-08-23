import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/challenge.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/mail_icon_button.dart';
import 'package:seed_app/features/home/presentation/providers/home_providers.dart';
import 'package:seed_app/features/home/presentation/widgets/my_goal_card.dart';
import 'package:seed_app/features/mascot/mascot.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_carousel.dart';
import 'package:seed_app/shared/services/streak_service.dart';

/// The main home screen of the Seed app
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hasMascot = ref.watch(hasMascotProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.eco, color: theme.colorScheme.primary),
                  const SizedBox(width: spacingSm),
                  Text(l10n.appTitle),
                ],
              ),
              centerTitle: true,
              actions: const [MailIconButton()],
            ),

            // Main content
            SliverPadding(
              padding: const EdgeInsets.all(spacingXxl),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mascot section or selection prompt
                  if (hasMascot)
                    _buildMascotSection(context, ref)
                  else
                    _buildMascotSelectionPrompt(context, ref, l10n),
                  const SizedBox(height: spacingMd),

                  const DailyChallengeCard(),
                  const SizedBox(height: spacingMd),
                  const MultiDayChallengeCard(),
                  const SizedBox(height: spacingMd),

                  // Personal goal
                  const MyGoalCard(),
                  const SizedBox(height: spacingXxl),

                  // SDG Section header
                  Text(
                    l10n.homeExploreGoals,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: spacingSm),
                  Text(
                    l10n.homeExploreGoalsSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ]),
              ),
            ),

            // SDG Carousel (infinite scroll)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: SdgCarousel(
                  goals: ref.watch(sdgGoalsDataProvider).value?.goals ?? [],
                  locale: Localizations.localeOf(context).languageCode,
                  resetSignal: ref.watch(homeVisitSignalProvider),
                  onGoalTap: (goal) {
                    context.push(appRoutes.sdgDetail(goal.number));
                  },
                ),
              ),
            ),

            // Learn more at UN.org
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: spacingXxl,
                vertical: spacingLg,
              ),
              sliver: SliverToBoxAdapter(child: _buildLearnMoreLink(context)),
            ),

            // Bottom padding
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildMascotSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final mascot = ref.watch(activeMascotProvider).value;
    final user = ref.watch(currentUserProvider).value;
    final stageName = ref.watch(stageLocalizedNameProvider(locale));

    return MascotHousing(
      child: Column(
        children: [
          // Mascot display
          GestureDetector(
            onTap: () => context.push(appRoutes.mascot),
            child: const MascotDisplay(size: 160),
          ),

          const SizedBox(height: spacingMd),

          // Mascot name
          Text(
            mascot?.name ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: spacingXs),

          // Evolution stage badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: spacingMd,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: opacitySubtle),
              borderRadius: borderRadiusXl,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 16, color: colorScheme.primary),
                const SizedBox(width: spacingSm),
                Text(
                  '$stageName (${l10n.levelLabel(mascot?.mascotLevel ?? 1)})',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: spacingLg),

          // Quick stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickStat(
                context,
                Icons.local_fire_department,
                // displayedStreak shows 0 once a missed day has
                // already broken the streak (the stored value is
                // only corrected at the next log).
                '${displayedStreak(storedStreak: user?.currentStreak ?? 0, lastActionDate: user?.lastActionDate, now: DateTime.now())}',
                l10n.profileCurrentStreak,
                Colors.orange,
              ),
              _buildQuickStat(
                context,
                Icons.star_outline,
                '${user?.points ?? 0}',
                l10n.homePoints,
                colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: spacingSm),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: spacingXxs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(
              alpha: opacityStrong,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMascotSelectionPrompt(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(spacingXxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: borderRadiusXxl,
      ),
      child: Column(
        children: [
          // Preview mascot
          MascotAvatar(
            assetPath:
                ref
                    .watch(mascotSpeciesDataProvider)
                    .value
                    ?.first
                    .evolutionStages
                    .first
                    .assetPath ??
                'assets/images/mascot/seed_stage1.svg',
            artboardName: ref
                .watch(mascotSpeciesDataProvider)
                .value
                ?.first
                .evolutionStages
                .first
                .artboardName,
          ),

          const SizedBox(height: spacingLg),

          Text(
            l10n.mascotSelectionTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: spacingSm),

          Text(
            l10n.mascotSelectionSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(
                alpha: opacityHeavy,
              ),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: spacingLg),

          FilledButton.icon(
            onPressed: () => context.push(appRoutes.mascotSelection),
            icon: const Icon(Icons.pets),
            label: Text(l10n.mascotSelectionConfirm),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnMoreLink(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: TextButton(
        onPressed: () => openExternalUrl(context, AppConstants.sdgGoalsUrl),
        child: Text(
          '${AppLocalizations.of(context).homeLearnMore} $externalLinkChar',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
