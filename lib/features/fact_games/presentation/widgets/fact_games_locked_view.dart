import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _lockSize = 48.0;

/// Shown by every fact game until [count] reaches [factGamesMinFacts]:
/// why it is locked, how far along the user is, and the way to today's
/// challenge, which unlocks the next fact.
class FactGamesLockedView extends StatelessWidget {
  const FactGamesLockedView({required this.count, super.key});

  /// Distinct figures in the user's pool.
  final int count;

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
              l10n.factGamesLockedBody(factGamesMinFacts),
              minLineWidth: phraseNarrowestScreenWidth - 2 * spacingXxl,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: spacingLg),
            Text(
              l10n.factGamesLockedProgress(count, factGamesMinFacts),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: spacingLg),
            FilledButton.tonal(
              onPressed: () => context.go(appRoutes.home),
              child: Text(l10n.factGamesGoToChallenge),
            ),
          ],
        ),
      ),
    );
  }
}
