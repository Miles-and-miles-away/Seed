import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/app_logger.dart';

void main() {
  group('AppLogger', () {
    // These are smoke tests: the logger short-circuits in release mode and
    // delegates to the logger package in debug. We assert it doesn't throw
    // and that the static API is reachable.

    test('debug does not throw', () {
      expect(() => AppLogger.debug('hello'), returnsNormally);
    });

    test('info does not throw', () {
      expect(() => AppLogger.info('hello'), returnsNormally);
    });

    test('warning does not throw', () {
      expect(() => AppLogger.warning('hello'), returnsNormally);
    });

    test('error does not throw with optional error and stack', () {
      expect(
        () => AppLogger.error(
          'boom',
          error: Exception('x'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });

    test('error accepts a message without additional context', () {
      expect(() => AppLogger.error('boom'), returnsNormally);
    });
  });
}
