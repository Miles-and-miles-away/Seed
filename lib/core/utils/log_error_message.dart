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

// Monotonic, so a wrong wall clock cannot fake a recent log.
final _sinceLastLog = Stopwatch();
const _rateLimitWindow = Duration(seconds: 10);

/// Records a successful action write for [logErrorMessage].
void markActionLogged() => _sinceLastLog
  ..reset()
  ..start();

/// User-facing message for a failed action write.
String logErrorMessage(BuildContext context, Object? error) {
  final l10n = AppLocalizations.of(context);
  if (isOfflineError(error)) return l10n.errorLogActionOffline;
  // permission-denied right after a log is the server's 5s rate limit;
  // otherwise it is a device clock too far off for the rules.
  if (error is FirebaseException && error.code == 'permission-denied') {
    return _sinceLastLog.isRunning && _sinceLastLog.elapsed < _rateLimitWindow
        ? l10n.errorActionTooSoon
        : l10n.errorActionRejected;
  }
  return l10n.errorGeneric;
}
