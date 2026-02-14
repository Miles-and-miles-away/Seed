import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logger that suppresses output in release builds.
///
/// Wraps the `logger` package with kDebugMode gating so
/// no log strings leak into production binaries.
abstract final class AppLogger {
  static final _logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
    level: kDebugMode ? Level.debug : Level.off,
  );

  static void debug(String message) {
    if (kDebugMode) _logger.d(message);
  }

  static void info(String message) {
    if (kDebugMode) _logger.i(message);
  }

  static void warning(String message) {
    if (kDebugMode) _logger.w(message);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
