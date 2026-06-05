import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/data/models/user_achievement_model.dart';
import 'package:seed_app/features/achievements/presentation/providers/achievement_providers.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_badge.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_detail_sheet.dart';

/// Compact achievements preview shown inside the Profile screen.
/// Shows up to [_maxBadges] unlocked badges plus a "+N more" chip
/// and a "X of Y unlocked" counter. The whole card is tappable and
/// navigates to the full Achievements screen.
class ProfileAchievementsSection extends ConsumerWidget {
  const ProfileAchievementsSection({required this.userId, super.key});

  final String userId;

  static const _maxBadges = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final defsAsync = ref.watch(achievementDefinitionsProvider);
    // Full unlock records (not just ids) so badge taps can show the
    // unlock date in the detail sheet.
    final recordsAsync = ref.watch(userAchievementsProvider(userId));

    final definitions = defsAsync.value ?? const <AchievementDefinition>[];
    final records = recordsAsync.value ?? const <UserAchievementModel>[];
    final unlockedAt = {for (final r in records) r.id: r.unlockedAt};
    final unlockedDefs = definitions
        .where((d) => unlockedAt.containsKey(d.id))
        .toList(growable: false);

    final isLoading = defsAsync.isLoading || recordsAsync.isLoading;
    final hasError = defsAsync.hasError || recordsAsync.hasError;

    final visible = unlockedDefs.take(_maxBadges).toList(growable: false);
    final remaining = unlockedDefs.length - visible.length;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: borderRadiusLg,
      child: InkWell(
        borderRadius: borderRadiusLg,
        onTap: () => context.push(appRoutes.achievements),
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.achievementsTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: spacingLg),
              if (isLoading)
                const _LoadingRow()
              else if (hasError)
                Text(
                  l10n.achievementsLoadError,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                )
              else if (unlockedDefs.isEmpty)
                Text(
                  l10n.achievementsEmptyHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              else
                _BadgeRow(
                  visible: visible,
                  remaining: remaining,
                  unlockedAt: unlockedAt,
                ),
              const SizedBox(height: spacingMd),
              Text(
                l10n.achievementsProgress(
                  unlockedDefs.length,
                  definitions.length,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({
    required this.visible,
    required this.remaining,
    required this.unlockedAt,
  });

  final List<AchievementDefinition> visible;
  final int remaining;
  final Map<String, DateTime> unlockedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        for (final def in visible)
          Padding(
            padding: const EdgeInsets.only(right: spacingMd),
            child: AchievementBadge(
              definition: def,
              isUnlocked: true,
              size: 52,
              onTap: () => AchievementDetailSheet.show(
                context,
                definition: def,
                isUnlocked: true,
                unlockedAt: unlockedAt[def.id],
              ),
            ),
          ),
        if (remaining > 0)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '+$remaining',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 52,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
