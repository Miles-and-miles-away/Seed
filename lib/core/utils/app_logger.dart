import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// App-wide logging entry point.
const appLogger = AppLogger._();

/// Debug builds print to the console. Release builds send info and
/// warnings to Crashlytics as breadcrumbs and errors as non-fatal
/// reports, so caught exceptions still surface. Debug lines never leave
/// the device.
class AppLogger {
  const AppLogger._();

  void debug(String message) {
    if (kDebugMode) debugPrint('[DEBUG] $message');
  }

  void info(String message) => _log('INFO', message);

  void warning(String message) => _log('WARN', message);

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      _log('ERROR', message);
      if (error != null) _log('ERROR', error.toString());
      if (stackTrace != null) _log('ERROR', stackTrace.toString());
      return;
    }
    unawaited(
      FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: error == null ? null : message,
      ),
    );
  }

  void _log(String level, String message) {
    if (kDebugMode) {
      debugPrint('[$level] $message');
    } else {
      unawaited(FirebaseCrashlytics.instance.log('[$level] $message'));
    }
  }
}
