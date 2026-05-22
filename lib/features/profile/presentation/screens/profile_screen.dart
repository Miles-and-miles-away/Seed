import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/achievements/presentation/widgets/profile_achievements_section.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';
import '../providers/profile_providers.dart';

/// User profile screen displaying stats, level progress, and achievements.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;

    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User header
                _buildUserHeader(context, theme, colorScheme, user, l10n),

                const SizedBox(height: Spacing.xxl),

                // Level progress
                _buildLevelSection(
                  context,
                  ref,
                  theme,
                  colorScheme,
                  user,
                  l10n,
                ),

                const SizedBox(height: Spacing.xxl),

                // Statistics section
                _buildStatsSection(context, ref, theme, l10n),

                const SizedBox(height: Spacing.xxl),

                ProfileAchievementsSection(userId: user.uid),

                const SizedBox(height: Spacing.xxl),

                // Sign out button
                OutlinedButton.icon(
                  onPressed: () => ref.read(authProvider.notifier).signOut(),
                  icon: const Icon(Icons.logout),
                  label: Text(l10n.authLogout),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(
          child: ErrorDisplay(),
        ),
      ),
    );
  }

  Widget _buildUserHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppUserModel user,
    AppLocalizations l10n,
  ) {
    final displayName = user.displayName ?? user.email.split('@').first;

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: Radii.borderXl,
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: colorScheme.primary,
            backgroundImage: user.photoUrl != null
                ? CachedNetworkImageProvider(user.photoUrl!)
                : null,
            child: user.photoUrl == null
                ? Text(
                    displayName[0].toUpperCase(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: Spacing.lg),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  user.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer
                        .withValues(alpha: Opacities.strong),
                  ),
                ),
                if (user.createdAt != null) ...[
                  const SizedBox(height: Spacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: colorScheme.onPrimaryContainer
                            .withValues(alpha: Opacities.strong),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Text(
                        '${l10n.profileMemberSince} ${DateFormat.yMMMd().format(user.createdAt!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: Opacities.strong),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ColorScheme colorScheme,
    AppUserModel user,
    AppLocalizations l10n,
  ) {
    final levelProgress = ref.watch(levelProgressProvider);
    final pointsToNext = ref.watch(pointsToNextLevelProvider);
    final evolutionStage = ref.watch(evolutionStageProvider);

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: Radii.borderXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Level and points header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.levelLabel(user.level),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    l10n.pointsLabel(user.points),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              // Evolution stage badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: Radii.borderXl,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: colorScheme.tertiary,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      l10n.profileEvolutionStage(evolutionStage),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: Spacing.xl),

          // Level progress bar
          LevelProgressBar(
            progress: levelProgress,
            currentLevel: user.level,
          ),

          const SizedBox(height: Spacing.sm),

          // Points to next level
          Text(
            l10n.profileNextLevel(pointsToNext),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final colorScheme = theme.colorScheme;
    final userAsync = ref.watch(currentUserProvider);
    final totalCo2 = ref.watch(totalCo2SavedProvider);
    final totalActions = ref.watch(totalActionsCountProvider);
    final daysSinceJoined = ref.watch(daysSinceJoinedProvider);

    final user = userAsync.value;
    if (user == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profileStats,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.md),

        // First row: Current streak & Longest streak
        StatCardRow(
          left: StatCard(
            icon: Icons.local_fire_department,
            value: '${user.currentStreak}',
            label: l10n.profileCurrentStreak,
            iconColor: Colors.orange,
          ),
          right: StatCard(
            icon: Icons.emoji_events,
            value: '${user.longestStreak}',
            label: l10n.profileLongestStreak,
            iconColor: Colors.amber,
          ),
        ),

        const SizedBox(height: Spacing.md),

        // Second row: Total CO2 & Total actions
        StatCardRow(
          left: StatCard(
            icon: Icons.eco,
            value: formatCO2Compact(totalCo2),
            label: l10n.profileTotalCO2,
            iconColor: colorScheme.primary,
          ),
          right: StatCard(
            icon: Icons.check_circle,
            value: '$totalActions',
            label: l10n.profileTotalActions,
            iconColor: colorScheme.secondary,
          ),
        ),

        const SizedBox(height: Spacing.md),

        // Days active (single card)
        StatCard(
          icon: Icons.calendar_month,
          value: l10n.profileDaysActive(daysSinceJoined),
          label: l10n.profileMemberSince,
          iconColor: colorScheme.tertiary,
        ),
      ],
    );
  }
}
