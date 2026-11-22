import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/log_error_message.dart';

/// Runs [log] and reports the outcome on [context]'s messenger: on
/// success [onSuccess] then [successMessage], otherwise the matching
/// error. A null outcome means nothing was attempted, so nothing is
/// shown. Nothing touches the tree once [context] is unmounted.
Future<void> bankAndReport(
  BuildContext context, {
  required Future<AsyncValue<void>?> Function() log,
  required String successMessage,
  required VoidCallback onSuccess,
}) async {
  // A stale Retry would bank the same saving again.
  final messenger = ScaffoldMessenger.of(context)..clearSnackBars();
  final result = await log();
  if (result == null || !context.mounted) return;
  if (result.hasError) {
    final message = logErrorMessage(context, result.error);
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        persist: false,
        action: isOfflineError(result.error)
            ? SnackBarAction(
                label: AppLocalizations.of(context).buttonRetry,
                onPressed: () {
                  // Retry needs its screen, so repeat that nothing was saved.
                  if (!context.mounted) {
                    messenger.showSnackBar(SnackBar(content: Text(message)));
                    return;
                  }
                  unawaited(
                    bankAndReport(
                      context,
                      log: log,
                      successMessage: successMessage,
                      onSuccess: onSuccess,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  } else {
    onSuccess();
    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
  }
}
