import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/theme/text_styles.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/widgets/no_word_break.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _iconSize = 32.0;
const _chevronSize = 24.0;
const _flameSize = 18.0;
const _streakCountMaxWidth = 24.0;

/// Card content width at 320pt.
const _innerMinWidth =
    phraseNarrowestScreenWidth - 2 * (spacingXxl + cardMargin + spacingLg);

/// Overline width at 320pt beside a two-digit streak badge.
const _overlineMinLineWidth =
    _innerMinWidth - spacingSm - _flameSize - spacingXxs - _streakCountMaxWidth;

/// Text column width at 320pt, between the icon and the chevron.
const _textMinLineWidth =
    _innerMinWidth - _iconSize - spacingMd - spacingXs - _chevronSize;

/// The incomplete card's shade: a step off the plain cards around it.
Color _cardColor(ColorScheme scheme) => Color.alphaBlend(
  scheme.tertiaryContainer.withValues(alpha: opacityHalf),
  scheme.surfaceContainerLow,
);

/// The completed card's shade, opaque like the incomplete one.
Color _completedColor(ColorScheme scheme) => Color.alphaBlend(
  scheme.primaryContainer.withValues(alpha: opacityHalf),
  scheme.surfaceContainerLow,
);

/// Card showing today's daily challenge status on the home screen.
class DailyChallengeCard extends ConsumerWidget {
  const DailyChallengeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayChallengeActionProvider).value;
    if (today == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (ref.watch(isTodayChallengeCompletedProvider)) {
      return _CompletedCard(
        theme: theme,
        l10n: l10n,
        onTap: () => _openFact(context, ref),
      );
    }

    final (:challenge, :action) = today;
    return _IncompleteCard(
      theme: theme,
      l10n: l10n,
      challenge: challenge,
      action: action,
      streak: ref.watch(challengeStreakProvider),
      onTap: (route) => _explainThenOpen(context, ref, route),
    );
  }
}

class _IncompleteCard extends StatelessWidget {
  const _IncompleteCard({
    required this.theme,
    required this.l10n,
    required this.challenge,
    required this.action,
    required this.streak,
    required this.onTap,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final DailyChallengeTemplate challenge;
  final ActionModel? action;
  final int streak;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final category = ActionCategory.fromString(challenge.category);
    final action = this.action;

    final title = action == null
        ? l10n.challengeLogAnyAction(challenge.category)
        : l10n.challengeLogAction(action.name(locale));
    final route = action != null
        ? appRoutes.actionLogForAction(challenge.category, action.id)
        : category != null
        ? appRoutes.actionLogForCategory(category.name)
        : appRoutes.actionLog;

    return Card(
      color: _cardColor(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => onTap(route),
          child: Padding(
            padding: const EdgeInsets.all(spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _Overline(theme: theme, l10n: l10n),
                    ),
                    if (streak > 0) ...[
                      const SizedBox(width: spacingSm),
                      _StreakBadge(streak: streak),
                    ],
                  ],
                ),
                const SizedBox(height: spacingSm),
                Row(
                  children: [
                    Icon(
                      category?.icon ?? Icons.eco,
                      color:
                          category?.textColorOn(theme.brightness) ??
                          colorScheme.primary,
                      size: _iconSize,
                    ),
                    const SizedBox(width: spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CardText(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          if (action != null) ...[
                            const SizedBox(height: spacingXs),
                            _CardText(
                              l10n.challengeAnyActionCounts(challenge.category),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: spacingXs),
                    Icon(
                      Icons.chevron_right,
                      size: _chevronSize,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompletedCard extends StatelessWidget {
  const _CompletedCard({
    required this.theme,
    required this.l10n,
    required this.onTap,
  });

  final ThemeData theme;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    return Card(
      color: _completedColor(colorScheme),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Overline(theme: theme, l10n: l10n),
                const SizedBox(height: spacingSm),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: _iconSize,
                    ),
                    const SizedBox(width: spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CardText(
                            l10n.challengeCompleted,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: spacingXs),
                          _CardText(
                            l10n.challengeSeeFact,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: spacingXs),
                    Icon(
                      Icons.chevron_right,
                      size: _chevronSize,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Overline extends StatelessWidget {
  const _Overline({required this.theme, required this.l10n});

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => _CardText(
    l10n.challengeOverline.toUpperCase(),
    minLineWidth: _overlineMinLineWidth,
    style: theme.overline,
  );
}

/// Card text that never breaks inside a word: a Latin word wider than
/// the line shrinks the text instead.
class _CardText extends StatelessWidget {
  const _CardText(
    this.text, {
    required this.style,
    this.minLineWidth = _textMinLineWidth,
  });

  final String text;
  final TextStyle? style;
  final double minLineWidth;

  @override
  Widget build(BuildContext context) => NoWordBreak(
    alignment: AlignmentDirectional.topStart,
    child: PhraseText(text, minLineWidth: minLineWidth, style: style),
  );
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: AppLocalizations.of(context).challengeStreakDays(streak),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: _flameSize,
              color: readableTextColor(
                AppColors.streak,
                theme.brightness,
                large: true,
              ),
            ),
            const SizedBox(width: spacingXxs),
            Text(
              '$streak',
              style: theme.textTheme.labelLarge?.copyWith(
                color: readableTextColor(AppColors.streak, theme.brightness),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
