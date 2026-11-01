import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/progress/presentation/screens/progress_screen.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _lockSize = 48.0;

/// Shown by a fact game until the user has discovered [needed] Eco-Dex
/// entries: why it is locked, how far along the user is, and the way to
/// the Eco-Dex.
class FactGamesLockedView extends StatelessWidget {
  const FactGamesLockedView({
    required this.count,
    required this.needed,
    super.key,
  });

  /// Eco-Dex entries the user has discovered.
  final int count;
  final int needed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: _lockSize,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: spacingLg),
            PhraseText(
              l10n.factGamesLockedTitle,
              minLineWidth: phraseNarrowestScreenWidth - 2 * spacingXxl,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: spacingSm),
            PhraseText(
              l10n.factGamesLockedBody(needed),
              minLineWidth: phraseNarrowestScreenWidth - 2 * spacingXxl,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: spacingLg),
            Text(
              l10n.factGamesLockedProgress(count, needed),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: spacingLg),
            FilledButton.tonal(
              onPressed: () =>
                  context.go('${appRoutes.progress}?tab=$progressTabEcoDex'),
              child: Text(l10n.factGamesGoToEcoDex),
            ),
          ],
        ),
      ),
    );
  }
}
