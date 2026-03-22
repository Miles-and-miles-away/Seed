import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/presentation/widgets/daily_challenge_card.dart';
import 'package:seed_app/features/challenge/presentation/widgets/multi_day_challenge_card.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/mail_icon_button.dart';
import 'package:seed_app/features/mascot/mascot.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/sdg_carousel.dart';

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
                  Icon(
                    Icons.eco,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Text(l10n.appTitle),
                ],
              ),
              centerTitle: true,
              actions: const [MailIconButton()],
            ),

            // Main content
            SliverPadding(
              padding: const EdgeInsets.all(Spacing.xxl),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mascot section or selection prompt
                  if (hasMascot)
                    _buildMascotSection(context, ref)
                  else
                    _buildMascotSelectionPrompt(context, ref, l10n),
                  const SizedBox(height: Spacing.md),

                  const DailyChallengeCard(),
                  const SizedBox(height: Spacing.md),
                  const MultiDayChallengeCard(),
                  const SizedBox(height: Spacing.xxl),

                  // SDG Section header
                  Text(
                    l10n.homeExploreGoals,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
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
                  locale: Localizations.localeOf(
                    context,
                  ).languageCode,
                  onGoalTap: (goal) {
                    context.push(
                      '/home/sdg/${goal.number}',
                    );
                  },
                ),
              ),
            ),

            // Learn more at UN.org
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.xxl,
                vertical: Spacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildLearnMoreLink(context),
              ),
            ),

            // Bottom padding
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 100),
            ),
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

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: Radii.borderXxl,
      ),
      child: Column(
        children: [
          // Mascot display
          GestureDetector(
            onTap: () => context.push('/mascot'),
            child: const MascotDisplay(
              size: 160,
            ),
          ),

          const SizedBox(height: Spacing.md),

          // Mascot name
          Text(
            mascot?.name ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: Spacing.xs),

          // Evolution stage badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(
                alpha: Opacities.subtle,
              ),
              borderRadius: Radii.borderXl,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: Spacing.sm),
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

          const SizedBox(height: Spacing.lg),

          // Quick stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickStat(
                context,
                Icons.local_fire_department,
                '${user?.currentStreak ?? 0}',
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
            const SizedBox(width: Spacing.sm),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xxs),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(
              alpha: Opacities.strong,
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
      padding: const EdgeInsets.all(Spacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: Radii.borderXxl,
      ),
      child: Column(
        children: [
          // Preview mascot
          MascotPreview(
            assetPath: ref
                    .watch(mascotSpeciesDataProvider)
                    .value
                    ?.first
                    .evolutionStages
                    .first
                    .assetPath ??
                'assets/images/mascot/seed_stage1.svg',
          ),

          const SizedBox(height: Spacing.lg),

          Text(
            l10n.mascotSelectionTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: Spacing.sm),

          Text(
            l10n.mascotSelectionSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(
                alpha: Opacities.heavy,
              ),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: Spacing.lg),

          FilledButton.icon(
            onPressed: () => context.push('/mascot-selection'),
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
      child: TextButton.icon(
        onPressed: _launchUnSdgPage,
        icon: Icon(
          Icons.open_in_new,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        label: Text(
          AppLocalizations.of(context).homeLearnMore,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _launchUnSdgPage() async {
    final url = Uri.parse(AppConstants.sdgGoalsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
