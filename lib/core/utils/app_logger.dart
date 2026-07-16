import 'package:flutter/foundation.dart';

/// App-wide logging entry point.
const appLogger = AppLogger._();

/// Centralized logging that suppresses output in release builds.
///
/// The kDebugMode guard is compile-time constant, so log calls (and
/// their message interpolation work) are tree-shaken out of release
/// binaries.
class AppLogger {
  const AppLogger._();

  void debug(String message) => _log('DEBUG', message);

  void info(String message) => _log('INFO', message);

  void warning(String message) => _log('WARN', message);

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message);
    if (error != null) _log('ERROR', error.toString());
    if (stackTrace != null) _log('ERROR', stackTrace.toString());
  }

  void _log(String level, String message) {
    if (kDebugMode) debugPrint('[$level] $message');
  }
}
