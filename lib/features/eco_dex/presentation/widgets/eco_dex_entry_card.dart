import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/eco_dex/domain/models/eco_dex_entry_state.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_sheet.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_locked_sheet.dart';

const double _cardImageSize = 48;

/// Card for a single Eco-Dex entry (locked or discovered).
class EcoDexEntryCard extends StatelessWidget {
  const EcoDexEntryCard({
    required this.entryState,
    required this.locale,
    super.key,
  });

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
              EcoDexEntryImage(
                iconName: entry.iconName,
                size: _cardImageSize,
              )
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
              padding: const EdgeInsets.symmetric(
                horizontal: spacingXs,
              ),
              child: Text(
                isDiscovered ? entry.name(locale) : '???',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isDiscovered
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: opacityDisabled,
                        ),
                  fontWeight:
                      isDiscovered ? FontWeight.w600 : FontWeight.normal,
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
