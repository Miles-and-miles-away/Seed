import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Runs [log] and reports the outcome on [context]'s messenger: on
/// success [onSuccess] then [successMessage], otherwise the generic
/// error. Nothing touches the tree once [context] is unmounted.
Future<void> bankAndReport(
  BuildContext context, {
  required Future<bool> Function() log,
  required String successMessage,
  required VoidCallback onSuccess,
}) async {
  final ok = await log();
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  if (ok) {
    onSuccess();
    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
  } else {
    messenger.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).errorGeneric)),
    );
  }
}
