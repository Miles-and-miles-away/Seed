import 'dart:async';

import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter/widgets.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// User-facing message for a failed action write.
String logErrorMessage(BuildContext context, Object? error) {
  final l10n = AppLocalizations.of(context);
  if (error is TimeoutException) return l10n.errorOffline;
  if (error is FirebaseException) {
    // permission-denied on a log almost always means the server-side
    // 5s rate limit rejected a rapid second submission.
    if (error.code == 'permission-denied') return l10n.errorActionTooSoon;
    if (error.code == 'unavailable') return l10n.errorOffline;
  }
  return l10n.errorGeneric;
}
