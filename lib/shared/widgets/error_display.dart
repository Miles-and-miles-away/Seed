import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Reusable error widget that replaces raw `Text('Error: $error')`
/// patterns with a styled, localized display.
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    this.compact = false,
    super.key,
  });

  /// When true, renders a minimal inline version (no icon,
  /// smaller text) suitable for constrained spaces like
  /// calendar cells or snackbars.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (compact) {
      return Text(
        l10n.errorGeneric,
        style: TextStyle(
          color: colorScheme.error,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
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
        const SizedBox(height: Spacing.sm),
        Text(
          l10n.errorGeneric,
          style: TextStyle(color: colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
