import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final result = await log();
  if (result == null || !context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);
  if (result.hasError) {
    messenger.showSnackBar(
      SnackBar(content: Text(logErrorMessage(context, result.error))),
    );
  } else {
    onSuccess();
    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
  }
}
