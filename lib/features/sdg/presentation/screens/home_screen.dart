import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../mascot/mascot.dart';
import '../../data/sdg_data.dart';
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
                  const SizedBox(width: 8),
                  Text(l10n.appTitle),
                ],
              ),
              centerTitle: true,
            ),

            // Main content
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mascot section or selection prompt
                  if (hasMascot)
                    _buildMascotSection(context, ref)
                  else
                    _buildMascotSelectionPrompt(context, l10n),
                  const SizedBox(height: 24),

                  // SDG Section header
                  Text(
                    'Explore the Goals',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to learn about the UN Sustainable Development Goals',
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
                  goals: sdgGoals,
                  onGoalTap: (goal) {
                    context.push('/home/sdg/${goal.number}');
                  },
                ),
              ),
            ),

            // Learn more at UN.org
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
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

    final mascot = ref.watch(currentMascotProvider).value;
    final user = ref.watch(currentUserProvider).value;
    final stageName = ref.watch(stageLocalizedNameProvider(locale));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
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

          const SizedBox(height: 12),

          // Mascot name
          Text(
            mascot?.name ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: 4),

          // Evolution stage badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  '$stageName (${l10n.levelLabel(user?.level ?? 1)})',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

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
                'Points',
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
            const SizedBox(width: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMascotSelectionPrompt(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Preview mascot
          MascotPreview(
            assetPath: defaultMascotSpecies.first.evolutionStages.first.assetPath,
          ),

          const SizedBox(height: 16),

          Text(
            l10n.mascotSelectionTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            l10n.mascotSelectionSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

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
          'Learn more at UN.org',
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
