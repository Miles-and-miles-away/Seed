import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/domain/models/active_multi_day_challenge.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

enum _ChallengeState { completed, active, available, blocked }

/// Screen listing all 6 multi-day challenge templates with their
/// current state (completed, active, available, or blocked).
class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activeChallenge = ref.watch(activeMultiDayChallengeProvider);
    final user = ref.watch(currentUserProvider).value;
    final completedIds = user?.completedMultiDayChallenges ?? [];
    final activeTemplateId = activeChallenge?.templateId;
    final templateDataAsync = ref.watch(challengeTemplateDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.challengesScreenTitle)),
      body: templateDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: ErrorDisplay(
            onRetry: () => ref.invalidate(challengeTemplateDataProvider),
          ),
        ),
        data: (templateData) => ListView.builder(
          padding: const EdgeInsets.all(spacingLg),
          itemCount: templateData.multiDay.length,
          itemBuilder: (context, index) {
            final template = templateData.multiDay[index];

            final state = _resolveState(
              template: template,
              activeTemplateId: activeTemplateId,
              completedIds: completedIds,
            );

            return _ChallengeTemplateCard(
              template: template,
              state: state,
              activeChallenge: activeChallenge,
            );
          },
        ),
      ),
    );
  }

  _ChallengeState _resolveState({
    required MultiDayChallengeTemplate template,
    required String? activeTemplateId,
    required List<String> completedIds,
  }) {
    if (completedIds.contains(template.id)) {
      return _ChallengeState.completed;
    }
    if (activeTemplateId == template.id) {
      return _ChallengeState.active;
    }
    if (activeTemplateId != null && activeTemplateId.isNotEmpty) {
      return _ChallengeState.blocked;
    }
    return _ChallengeState.available;
  }
}

class _ChallengeTemplateCard extends ConsumerWidget {
  const _ChallengeTemplateCard({
    required this.template,
    required this.state,
    required this.activeChallenge,
  });

  final MultiDayChallengeTemplate template;
  final _ChallengeState state;
  final ActiveMultiDayChallenge? activeChallenge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final categoryStr = template.category;
    final category = categoryStr != null
        ? ActionCategory.fromString(categoryStr)
        : null;

    final isBlocked = state == _ChallengeState.blocked;

    final cardColor = isBlocked
        ? colorScheme.surfaceContainerHighest.withValues(alpha: opacityHalf)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: spacingMd),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  category?.icon ?? Icons.emoji_events,
                  color: isBlocked
                      ? colorScheme.onSurfaceVariant.withValues(
                          alpha: opacityDisabled,
                        )
                      : category?.color ?? colorScheme.primary,
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
                          color: isBlocked
                              ? colorScheme.onSurfaceVariant.withValues(
                                  alpha: opacityDisabled,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: spacingXxs),
                      Text(
                        l10n.challengeDays(template.targetDays),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: isBlocked ? opacityDisabled : 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStateBadge(theme, colorScheme, l10n),
              ],
            ),
            const SizedBox(height: spacingSm),
            Text(
              template.description(locale),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(
                  alpha: isBlocked ? opacityDisabled : 1.0,
                ),
              ),
            ),
            if (state == _ChallengeState.active) ...[
              const SizedBox(height: spacingMd),
              _buildActiveSection(context, ref, theme, colorScheme, l10n),
            ],
            if (state == _ChallengeState.available) ...[
              const SizedBox(height: spacingMd),
              _buildStartButton(context, ref, l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStateBadge(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final (label, color) = switch (state) {
      _ChallengeState.completed => (
        l10n.challengeCompletedBadge,
        colorScheme.primary,
      ),
      _ChallengeState.active => (l10n.challengeActive, AppColors.streak),
      _ChallengeState.available => (
        l10n.challengeAvailable,
        colorScheme.onSurfaceVariant,
      ),
      _ChallengeState.blocked => (
        l10n.challengeLocked,
        colorScheme.onSurfaceVariant,
      ),
    };

    final icon = state == _ChallengeState.completed
        ? Icons.check_circle
        : state == _ChallengeState.blocked
        ? Icons.lock_outline
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacingSm,
        vertical: spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacityFaint),
        borderRadius: borderRadiusMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: spacingXs),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSection(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    final currentDay = activeChallenge?.currentDay ?? 0;
    final targetDays = activeChallenge?.targetDays ?? template.targetDays;
    final progress = ActiveMultiDayChallenge.progress(currentDay, targetDays);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: borderRadiusXs,
                child: LinearProgressIndicator(value: progress, minHeight: 6),
              ),
            ),
            const SizedBox(width: spacingMd),
            Text(
              l10n.challengeMultiDayProgress(currentDay, targetDays),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: spacingSm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _confirmAbandon(context, ref, l10n),
            child: Text(l10n.challengeAbandon),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton(
        onPressed: () => _confirmStart(context, ref, l10n),
        child: Text(l10n.challengeStart),
      ),
    );
  }

  Future<void> _confirmStart(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      message: l10n.challengeStartConfirm,
      confirmLabel: l10n.challengeStart,
    );
    if (confirmed && context.mounted) {
      await ref
          .read(multiDayChallengeProvider.notifier)
          .startChallenge(template.id);
    }
  }

  Future<void> _confirmAbandon(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await _showConfirmDialog(
      context,
      message: l10n.challengeAbandonConfirm,
      confirmLabel: l10n.challengeAbandon,
    );
    if (confirmed && context.mounted) {
      await ref.read(multiDayChallengeProvider.notifier).abandonChallenge();
    }
  }
}

Future<bool> _showConfirmDialog(
  BuildContext context, {
  required String message,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
