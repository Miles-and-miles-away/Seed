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

// ignore: avoid_classes_with_only_static_members
/// Namespace for app-wide logging functions.
abstract final class AppLogger {
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
      _logger.e(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
