import 'dart:async';

import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter/widgets.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// True when [error] is a Firestore write that never reached the server.
bool isOfflineError(Object? error) {
  if (error is TimeoutException) return true;
  return error is FirebaseException &&
      (error.code == 'unavailable' || error.code == 'deadline-exceeded');
}

/// User-facing message for a failed action write.
String logErrorMessage(BuildContext context, Object? error) {
  final l10n = AppLocalizations.of(context);
  if (isOfflineError(error)) return l10n.errorLogActionOffline;
  // permission-denied on a log almost always means the server-side
  // 5s rate limit rejected a rapid second submission.
  if (error is FirebaseException && error.code == 'permission-denied') {
    return l10n.errorActionTooSoon;
  }
  return l10n.errorGeneric;
}
