import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

/// Card showing today's daily challenge status on the home screen.
class DailyChallengeCard extends ConsumerWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeAsync = ref.watch(todayChallengeProvider);
    final challenge = challengeAsync.value;
    if (challenge == null) return const SizedBox.shrink();

    final completed = ref.watch(isTodayChallengeCompletedProvider);
    final streak = ref.watch(challengeStreakProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final category = ActionCategory.fromString(challenge.category);

    if (completed) {
      return _buildCompletedCard(context, ref, theme, colorScheme, l10n);
    }

    return _buildIncompleteCard(
      context,
      ref,
      theme,
      colorScheme,
      l10n,
      challenge.title(locale),
      category,
      streak,
    );
  }

  Widget _buildCompletedCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Card(
      color: colorScheme.primaryContainer.withValues(alpha: opacityHalf),
      child: Padding(
        padding: const EdgeInsets.all(spacingLg),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: colorScheme.primary, size: 32),
            const SizedBox(width: spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.challengeCompleted,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: spacingXs),
                  GestureDetector(
                    onTap: () => _openFact(context, ref),
                    child: Text(
                      l10n.challengeSeeFact,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncompleteCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    String title,
    ActionCategory? category,
    int streak,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Jump straight to the actions that complete this challenge, with
        // its category filter already applied. Deep-links by category rather
        // than a specific action -- fine while challenges target a category;
        // revisit if a challenge ever targets a single action.
        onTap: () => _explainThenOpen(
          context,
          ref,
          category != null
              ? appRoutes.actionLogForCategory(category.name)
              : appRoutes.actionLog,
        ),
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Row(
            children: [
              Icon(
                category?.icon ?? Icons.eco,
                color: category?.color ?? colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: spacingXs),
                    Text(
                      l10n.challengeDialogUnlock,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (streak > 0) _StreakBadge(streak: streak, l10n: l10n),
              const SizedBox(width: spacingXs),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak, required this.l10n});

  final int streak;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.local_fire_department,
          size: 18,
          color: AppColors.streak,
        ),
        const SizedBox(width: spacingXxs),
        Text(
          '$streak',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.streak,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

const _item = WalkthroughItem.dailyChallenge;

/// Explains the card the first time it is tapped, then navigates.
Future<void> _explainThenOpen(
  BuildContext context,
  WidgetRef ref,
  String route,
) async {
  if (ref.read(walkthroughPendingProvider(_item))) {
    await showWalkthroughItem(context, _item);
    if (!context.mounted) return;
  }
  await context.push(route);
}

/// One explanation per tap: the inbox explains itself on arrival, so the
/// card is ticked silently here.
Future<void> _openFact(BuildContext context, WidgetRef ref) {
  if (ref.read(walkthroughPendingProvider(_item))) {
    // Not awaited: offline, the write only completes on server ack.
    unawaited(
      ref.read(settingsProvider.notifier).markWalkthroughFound(_item.name),
    );
  }
  return context.push(appRoutes.dailyFact);
}
