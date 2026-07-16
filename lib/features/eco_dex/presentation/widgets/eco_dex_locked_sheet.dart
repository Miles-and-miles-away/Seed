import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/domain/services/eco_dex_progress.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_progress_bar.dart';

/// Bottom sheet showing a hint and unlock progress for a locked
/// Eco-Dex entry.
class EcoDexLockedSheet extends ConsumerWidget {
  const EcoDexLockedSheet({
    required this.entry,
    required this.locale,
    super.key,
  });

  final EcoDexEntry entry;
  final String locale;

  /// Opens the sheet with the standard modal configuration.
  static Future<void> show(
    BuildContext context, {
    required EcoDexEntry entry,
    required String locale,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => EcoDexLockedSheet(entry: entry, locale: locale),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider).value;
    final progress = user == null
        ? null
        : ecoDexProgressOf(entry.condition, user);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        spacingXxl,
        spacingSm,
        spacingXxl,
        spacingXxxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const SizedBox(height: spacingLg),

          // Locked title
          Text(
            l10n.ecoDexLocked,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingSm),

          // Hint
          Text(
            entry.hint(locale),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (progress != null && progress.hasProgress) ...[
            const SizedBox(height: spacingLg),
            EcoDexProgressBar(progress: progress),
          ],
          const SizedBox(height: spacingSm),
        ],
      ),
    );
  }
}
