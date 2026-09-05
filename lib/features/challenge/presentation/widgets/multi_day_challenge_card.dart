import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/challenge/domain/models/active_multi_day_challenge.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

/// Compact card showing the active multi-day challenge on the
/// home screen. Hidden when no challenge is active.
class MultiDayChallengeCard extends ConsumerWidget {
  const MultiDayChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChallenge = ref.watch(activeMultiDayChallengeProvider);
    if (activeChallenge == null) {
      return const SizedBox.shrink();
    }

    final templateDataAsync = ref.watch(challengeTemplateDataProvider);
    final templateData = templateDataAsync.value;
    if (templateData == null) return const SizedBox.shrink();

    final template = templateData.multiDay
        .cast<MultiDayChallengeTemplate?>()
        .firstWhere(
          (t) => t?.id == activeChallenge.templateId,
          orElse: () => null,
        );
    if (template == null) return const SizedBox.shrink();

    // A completion date before yesterday means the run is already
    // broken (the next log resets to day 1); show zero progress
    // instead of the stale day count.
    final now = ref.watch(clockProvider)();
    final lastDate = activeChallenge.lastCompletionDate;
    final isBroken =
        lastDate.isNotEmpty &&
        lastDate != formatDateKey(now) &&
        lastDate != formatDateKey(previousCalendarDay(now));
    final currentDay = isBroken ? 0 : activeChallenge.currentDay;
    final targetDays = activeChallenge.targetDays > 0
        ? activeChallenge.targetDays
        : template.targetDays;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final categoryStr = template.category;
    final category = categoryStr != null
        ? ActionCategory.fromString(categoryStr)
        : null;

    final progress = ActiveMultiDayChallenge.progress(currentDay, targetDays);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(appRoutes.challenges),
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Row(
            children: [
              Icon(
                category?.icon ?? Icons.emoji_events,
                color: category?.color ?? colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: spacingMd),
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
                    const SizedBox(height: spacingXs),
                    Text(
                      l10n.challengeMultiDayProgress(currentDay, targetDays),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: spacingSm),
                    ClipRRect(
                      borderRadius: borderRadiusXs,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: spacingSm),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
