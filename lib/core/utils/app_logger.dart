import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging that suppresses output in release builds.
///
/// Wraps the `logger` package with kDebugMode gating so
/// no log strings leak into production binaries.
final _logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
  level: kDebugMode ? Level.debug : Level.off,
);

/// App-wide logging entry point.
const appLogger = AppLogger._();

/// Debug-gated logging functions, used via [appLogger].
class AppLogger {
  const AppLogger._();

  void debug(String message) {
    if (kDebugMode) _logger.d(message);
  }

  void info(String message) {
    if (kDebugMode) _logger.i(message);
  }

  void warning(String message) {
    if (kDebugMode) _logger.w(message);
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      _logger.e(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
