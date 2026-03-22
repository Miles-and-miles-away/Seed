import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';

/// Bottom sheet showing a hint for a locked Eco-Dex entry.
class EcoDexLockedSheet extends StatelessWidget {
  const EcoDexLockedSheet({
    required this.entry,
    required this.locale,
    super.key,
  });

  final EcoDexEntry entry;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.xxl,
        Spacing.lg,
        Spacing.xxl,
        Spacing.xxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant
                  .withValues(alpha: Opacities.medium),
              borderRadius: BorderRadius.circular(Spacing.xxs),
            ),
          ),
          const SizedBox(height: Spacing.xxl),

          // Lock icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.lg),

          // Locked title
          Text(
            l10n.ecoDexLocked,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Spacing.sm),

          // Hint
          Text(
            entry.hint(locale),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.sm),
        ],
      ),
    );
  }
}
