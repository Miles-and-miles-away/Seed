import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/auth_error_mapper.dart';
import '../providers/auth_providers.dart';

/// Listens to [authProvider] from a screen's `build` and reports failures
/// as a localized error SnackBar.
///
/// [onError] runs before the SnackBar; [onCompleted] runs once a pending
/// operation succeeds. The router tears these screens down on auth-state
/// changes, so the callback can outlive them; touching context after that
/// registers an inherited dependency from a deactivated element, which is
/// why the guard lives here instead of in every caller.
void listenAuthResult(
  BuildContext context,
  WidgetRef ref, {
  VoidCallback? onError,
  VoidCallback? onCompleted,
}) {
  final l10n = AppLocalizations.of(context);
  ref.listen<AsyncValue<void>>(authProvider, (previous, next) {
    if (!context.mounted) return;
    next.whenOrNull(
      data: (_) {
        if (previous?.isLoading ?? false) onCompleted?.call();
      },
      error: (error, _) {
        onError?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mapAuthErrorToMessage(error, l10n)),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  });
}
