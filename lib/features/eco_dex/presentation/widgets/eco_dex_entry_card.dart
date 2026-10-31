import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/eco_dex/domain/models/eco_dex_entry_state.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_sheet.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_locked_sheet.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const double _cardImageSize = 48;

/// Image, gap and breathing room: the part of a card that does not move
/// with the text scale.
const double _cardChromeHeight = _cardImageSize + spacingXs + 2 * spacingSm;

/// The name's `labelSmall` metrics: up to two lines of 11pt type on a 16pt
/// line.
const double _nameFontSize = 11;
const double _nameLineHeight = 16;
const int _nameMaxLines = 2;

/// Cells per row in the Eco-Dex grid.
const ecoDexGridColumns = 4;

/// Name width at 320pt: one cell of the 16pt-padded grid, less chrome.
const _nameMinLineWidth =
    (phraseNarrowestScreenWidth -
            2 * spacingLg -
            (ecoDexGridColumns - 1) * spacingMd) /
        ecoDexGridColumns -
    2 * (cardMargin + spacingXs);

/// Card for a single Eco-Dex entry (locked or discovered).
class EcoDexEntryCard extends StatelessWidget {
  const EcoDexEntryCard({
    required this.entryState,
    required this.locale,
    super.key,
  });

  /// Grid cell height for a card at [scaler], sized from the content so a
  /// two-line name never overflows a narrow cell.
  /// Scales the font size, not the block, because a nonlinear system
  /// scaler grows small type more than large.
  static double heightFor(TextScaler scaler) =>
      _cardChromeHeight +
      _nameMaxLines *
          scaler.scale(_nameFontSize) *
          _nameLineHeight /
          _nameFontSize;

  final EcoDexEntryState entryState;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDiscovered = entryState.isDiscovered;
    final entry = entryState.entry;

    return GestureDetector(
      onTap: () {
        if (isDiscovered) {
          EcoDexEntrySheet.show(context, entry: entry, locale: locale);
        } else {
          EcoDexLockedSheet.show(context, entry: entry, locale: locale);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDiscovered
              ? theme.colorScheme.primaryContainer.withValues(
                  alpha: opacityMedium,
                )
              : theme.colorScheme.surfaceContainerHigh.withValues(
                  alpha: opacityHalf,
                ),
          borderRadius: borderRadiusMd,
          border: isDiscovered
              ? Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: opacityMuted,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDiscovered)
              EcoDexEntryImage(iconName: entry.iconName, size: _cardImageSize)
            else
              Icon(
                Icons.lock_outline,
                size: 24,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: opacityDisabled,
                ),
              ),
            const SizedBox(height: spacingXs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacingXs),
              child: PhraseText(
                isDiscovered ? entry.name(locale) : '???',
                locale: Locale(locale),
                minLineWidth: _nameMinLineWidth,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDiscovered
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: opacityDisabled,
                        ),
                  fontWeight: isDiscovered
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
