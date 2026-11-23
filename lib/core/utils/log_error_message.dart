import 'dart:async';

import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter/widgets.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';

/// A banked saving above [AppConstants.maxBankCo2Grams], refused before
/// any write.
class SavingTooLargeException implements Exception {
  const SavingTooLargeException();
}

/// True when [error] is a Firestore write lost to a missing or dropped link.
bool isOfflineError(Object? error) {
  if (error is TimeoutException) return true;
  return error is FirebaseException &&
      (error.code == 'unavailable' ||
          error.code == 'deadline-exceeded' ||
          // gRPC transport reset, e.g. on a network switch.
          (error.code == 'unknown' && error.message == 'Stream removed'));
}

// Monotonic, so a wrong wall clock cannot fake a recent log.
final _sinceLastLog = Stopwatch();
const _rateLimitWindow = Duration(seconds: 10);

/// The rules' minimum gap between two action logs.
const _actionLogGap = Duration(seconds: 5);

/// Records a successful action write for [logErrorMessage].
void markActionLogged() => _sinceLastLog
  ..reset()
  ..start();

@visibleForTesting
void resetActionLogClock() => _sinceLastLog
  ..stop()
  ..reset();

/// What is left of the rules' log gap since the last successful log.
Duration actionLogCooldown() {
  if (!_sinceLastLog.isRunning) return Duration.zero;
  final left = _actionLogGap - _sinceLastLog.elapsed;
  return left.isNegative ? Duration.zero : left;
}

/// User-facing message for a failed action write.
String logErrorMessage(BuildContext context, Object? error) {
  final l10n = AppLocalizations.of(context);
  if (isOfflineError(error)) return l10n.errorLogActionOffline;
  if (error is SavingTooLargeException) {
    final tonnes = formatDecimal(
      AppConstants.maxBankCo2Grams / 1000000,
      l10n.localeName,
      maxDigits: 0,
    );
    return l10n.errorSavingTooLarge('$tonnes${unitSpace}t');
  }
  // permission-denied right after a log here is the 5s rate limit. Else it
  // is a log from another device moments ago, or a wrong device clock.
  if (error is FirebaseException && error.code == 'permission-denied') {
    return _sinceLastLog.isRunning && _sinceLastLog.elapsed < _rateLimitWindow
        ? l10n.errorActionTooSoon
        : l10n.errorActionRejected;
  }
  return l10n.errorGeneric;
}
