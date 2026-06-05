import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';
import 'package:seed_app/features/achievements/presentation/providers/achievement_providers.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_badge.dart';
import 'package:seed_app/features/achievements/presentation/widgets/next_up_section.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

/// Full Achievements screen at `/profile/achievements`. Shows the
/// overall unlock progress header, a "Next Up" preview of the three
/// closest-to-complete achievements, and grids of unlocked + locked
/// badges.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentUserProvider);
    final defsAsync = ref.watch(achievementDefinitionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievementsTitle)),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.achievementsLoadError)),
        data: (user) {
          if (user == null) {
            return Center(child: Text(l10n.achievementsLoadError));
          }
          return defsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(child: Text(l10n.achievementsLoadError)),
            data: (definitions) {
              final unlockedAsync = ref.watch(
                userUnlockedAchievementIdsProvider(user.uid),
              );
              return unlockedAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    Center(child: Text(l10n.achievementsLoadError)),
                data: (unlockedIds) => _AchievementsBody(
                  user: user,
                  definitions: definitions,
                  unlockedIds: unlockedIds,
                  theme: theme,
                  l10n: l10n,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AchievementsBody extends StatelessWidget {
  const _AchievementsBody({
    required this.user,
    required this.definitions,
    required this.unlockedIds,
    required this.theme,
    required this.l10n,
  });

  final AppUserModel user;
  final List<AchievementDefinition> definitions;
  final Set<String> unlockedIds;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final state = achievementStateFromUser(user);
    final unlocked = definitions
        .where((d) => unlockedIds.contains(d.id))
        .toList(growable: false);
    final locked = definitions
        .where((d) => !unlockedIds.contains(d.id))
        .toList(growable: false);
    final fraction =
        definitions.isEmpty ? 0.0 : unlocked.length / definitions.length;

    return ListView(
      padding: const EdgeInsets.all(spacingLg),
      children: [
        _ProgressHeader(
          unlockedCount: unlocked.length,
          totalCount: definitions.length,
          fraction: fraction,
        ),
        const SizedBox(height: spacingXxl),
        if (locked.isNotEmpty) ...[
          _SectionHeader(label: l10n.achievementsNextUp),
          const SizedBox(height: spacingMd),
          NextUpSection(
            definitions: definitions,
            unlockedIds: unlockedIds,
            state: state,
          ),
          const SizedBox(height: spacingXxl),
        ],
        if (unlocked.isNotEmpty) ...[
          _SectionHeader(label: l10n.achievementsUnlocked),
          const SizedBox(height: spacingMd),
          _BadgeGrid(definitions: unlocked, isUnlocked: true),
          const SizedBox(height: spacingXxl),
        ],
        if (locked.isNotEmpty) ...[
          _SectionHeader(label: l10n.achievementsLocked),
          const SizedBox(height: spacingMd),
          _BadgeGrid(definitions: locked, isUnlocked: false),
        ],
      ],
    );
  }
}

/// Builds the checker's view of the user from the persisted user
/// model. Public so widget/unit tests can exercise the mapping in
/// isolation without instantiating the screen.
AchievementUserState achievementStateFromUser(AppUserModel user) {
  return AchievementUserState(
    totalActionsCount: user.totalActionsCount,
    totalCo2Grams: user.totalCo2Grams,
    currentStreak: user.currentStreak,
    level: user.level,
    categoryActionCounts: Map.of(user.categoryActionCounts),
    supportedSdgIds: {
      for (final entry in user.sdgStats.entries)
        if ((entry.value[AppConstants.fieldCount] ?? 0) > 0) entry.key,
    },
  );
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.unlockedCount,
    required this.totalCount,
    required this.fraction,
  });

  final int unlockedCount;
  final int totalCount;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.achievementsProgress(unlockedCount, totalCount),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: spacingMd),
        ClipRRect(
          borderRadius: borderRadiusXs,
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _BadgeGrid extends StatelessWidget {
  const _BadgeGrid({required this.definitions, required this.isUnlocked});

  final List<AchievementDefinition> definitions;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: spacingMd,
        crossAxisSpacing: spacingMd,
        childAspectRatio: 0.78,
      ),
      itemCount: definitions.length,
      itemBuilder: (context, i) => AchievementBadge(
        definition: definitions[i],
        isUnlocked: isUnlocked,
      ),
    );
  }
}
