import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/explore/presentation/explore_entries.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _discRadius = 24.0;
const _chevronSize = 24.0;
const _ringWidth = 2.0;

/// Title and subtitle width at 320pt: list and tile padding, the disc, the
/// chevron and the gap beside each.
const _textMinLineWidth =
    phraseNarrowestScreenWidth - 6 * spacingLg - 2 * _discRadius - _chevronSize;

/// One Explore destination: a titled, described row that pushes its route.
class ExploreTile extends StatelessWidget {
  const ExploreTile({
    required this.entry,
    this.dimmed = false,
    this.ringed = false,
    this.subtitle,
    this.trailingIcon,
    super.key,
  });

  final ExploreEntry entry;

  /// Replaces the entry's own subtitle, for a state such as locked.
  final String? subtitle;

  /// Replaces the chevron.
  final IconData? trailingIcon;

  /// Faded while the walkthrough explains another tile.
  final bool dimmed;

  /// Gold-ringed while the walkthrough explains this tile.
  final bool ringed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final color = entry.color ?? theme.colorScheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadiusLg,
        side: ringed
            ? const BorderSide(color: AppColors.gold, width: _ringWidth)
            : BorderSide.none,
      ),
      child: AnimatedOpacity(
        opacity: dimmed ? opacityMuted : 1,
        duration: durationNormal,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: spacingLg),
          minVerticalPadding: spacingMd,
          leading: CircleAvatar(
            radius: _discRadius,
            backgroundColor: color.withValues(alpha: opacityLight),
            child: Icon(
              entry.icon,
              color: readableTextColor(color, theme.brightness),
            ),
          ),
          title: PhraseText(
            entry.title(l10n),
            minLineWidth: _textMinLineWidth,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: PhraseText(
            subtitle ?? entry.subtitle(l10n),
            minLineWidth: _textMinLineWidth,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Icon(
            trailingIcon ?? Icons.chevron_right,
            size: _chevronSize,
          ),
          onTap: () => context.push(entry.route),
        ),
      ),
    );
  }
}
