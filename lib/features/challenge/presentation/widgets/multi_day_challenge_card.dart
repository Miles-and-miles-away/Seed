import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';

/// Compact card showing the active multi-day challenge on the
/// home screen. Hidden when no challenge is active.
class MultiDayChallengeCard extends ConsumerWidget {
  const MultiDayChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChallenge = ref.watch(
      activeMultiDayChallengeProvider,
    );
    if (activeChallenge == null) {
      return const SizedBox.shrink();
    }

    final templateDataAsync = ref.watch(
      challengeTemplateDataProvider,
    );
    final templateData = templateDataAsync.value;
    if (templateData == null) return const SizedBox.shrink();

    final template =
        templateData.multiDay.cast<MultiDayChallengeTemplate?>().firstWhere(
              (t) => t?.id == activeChallenge.templateId,
              orElse: () => null,
            );
    if (template == null) return const SizedBox.shrink();

    final currentDay = activeChallenge.currentDay;
    final targetDays = activeChallenge.targetDays > 0
        ? activeChallenge.targetDays
        : template.targetDays;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(
      context,
    ).languageCode;

    final categoryStr = template.category;
    final category =
        categoryStr != null ? ActionCategory.fromString(categoryStr) : null;

    final progress =
        targetDays > 0 ? (currentDay / targetDays).clamp(0.0, 1.0) : 0.0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          '${AppRoutes.home}/${AppRoutes.challenges}',
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Row(
            children: [
              Icon(
                category?.icon ?? Icons.emoji_events,
                color: category?.color ?? colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.title(locale),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      l10n.challengeMultiDayProgress(
                        currentDay,
                        targetDays,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    ClipRRect(
                      borderRadius: Radii.borderXs,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
