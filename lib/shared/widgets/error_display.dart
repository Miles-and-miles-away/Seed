import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Reusable error widget that replaces raw `Text('Error: $error')`
/// patterns with a styled, localized display.
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    this.message,
    this.onRetry,
    this.compact = false,
    super.key,
  });

  /// Overrides the default localized generic message.
  final String? message;

  /// When provided, shows a retry button. Riverpod caches failures, so
  /// callers should pass a callback that `ref.invalidate`s the failed
  /// provider to re-trigger the load.
  final VoidCallback? onRetry;

  /// When true, renders a minimal inline version (no icon,
  /// smaller text) suitable for constrained spaces like
  /// calendar cells or snackbars.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (compact) {
      final messageText = Text(
        message ?? l10n.errorGeneric,
        style: TextStyle(
          color: colorScheme.error,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      );
      if (onRetry == null) return messageText;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          messageText,
          TextButton(
            onPressed: onRetry,
            child: Text(l10n.buttonRetry),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          color: colorScheme.error,
          size: 32,
        ),
        const SizedBox(height: spacingSm),
        Text(
          message ?? l10n.errorGeneric,
          style: TextStyle(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
        if (onRetry != null) ...[
          const SizedBox(height: spacingMd),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.buttonRetry),
          ),
        ],
      ],
    );
  }
}
