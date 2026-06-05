import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/data/models/user_achievement_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';
import 'package:seed_app/features/achievements/presentation/providers/achievement_providers.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_badge.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_detail_sheet.dart';
import 'package:seed_app/features/achievements/presentation/widgets/next_up_section.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

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
      appBar: AppBar(
        title: Text(l10n.achievementsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.achievementsInfoTooltip,
            onPressed: () => InfoSheet.show(
              context,
              title: l10n.achievementsInfoTitle,
              body: l10n.achievementsInfoBody,
            ),
          ),
        ],
      ),
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
              // Full unlock records (not just ids) so the detail
              // sheet can show when each badge was earned.
              final recordsAsync = ref.watch(
                userAchievementsProvider(user.uid),
              );
              return recordsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) =>
                    Center(child: Text(l10n.achievementsLoadError)),
                data: (records) => _AchievementsBody(
                  user: user,
                  definitions: definitions,
                  records: records,
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
    required this.records,
    required this.theme,
    required this.l10n,
  });

  final AppUserModel user;
  final List<AchievementDefinition> definitions;
  final List<UserAchievementModel> records;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final state = achievementStateFromUser(user);
    final unlockedAt = {for (final r in records) r.id: r.unlockedAt};
    final unlockedIds = unlockedAt.keys.toSet();
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
            onItemTap: (definition, progress) => AchievementDetailSheet.show(
              context,
              definition: definition,
              isUnlocked: false,
              progress: progress,
            ),
          ),
          const SizedBox(height: spacingXxl),
        ],
        if (unlocked.isNotEmpty) ...[
          _SectionHeader(label: l10n.achievementsUnlocked),
          const SizedBox(height: spacingMd),
          _BadgeGrid(
            definitions: unlocked,
            isUnlocked: true,
            state: state,
            unlockedAt: unlockedAt,
          ),
          const SizedBox(height: spacingXxl),
        ],
        if (locked.isNotEmpty) ...[
          _SectionHeader(label: l10n.achievementsLocked),
          const SizedBox(height: spacingMd),
          _BadgeGrid(
            definitions: locked,
            isUnlocked: false,
            state: state,
          ),
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
  const _BadgeGrid({
    required this.definitions,
    required this.isUnlocked,
    required this.state,
    this.unlockedAt = const {},
  });

  final List<AchievementDefinition> definitions;
  final bool isUnlocked;
  final AchievementUserState state;
  final Map<String, DateTime> unlockedAt;

  @override
  Widget build(BuildContext context) {
    // Badge height is width-independent, so derive the cell extent
    // from the badge's own layout math (which tracks theme typography
    // and text scaling) instead of a width-based childAspectRatio
    // that overflows on narrow phones.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: spacingMd,
        crossAxisSpacing: spacingMd,
        mainAxisExtent: AchievementBadge.extentFor(context),
      ),
      itemCount: definitions.length,
      itemBuilder: (context, i) {
        final definition = definitions[i];
        return AchievementBadge(
          definition: definition,
          isUnlocked: isUnlocked,
          onTap: () => AchievementDetailSheet.show(
            context,
            definition: definition,
            isUnlocked: isUnlocked,
            progress: isUnlocked
                ? null
                : achievementProgressOf(definition.criteria, state),
            unlockedAt: unlockedAt[definition.id],
          ),
        );
      },
    );
  }
}
