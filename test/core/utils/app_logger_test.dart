import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/app_logger.dart';

void main() {
  group('AppLogger', () {
    // These are smoke tests: the logger short-circuits in release mode and
    // delegates to the logger package in debug. We assert it doesn't throw
    // and that the public API is reachable.

    test('debug does not throw', () {
      expect(() => appLogger.debug('hello'), returnsNormally);
    });

    test('info does not throw', () {
      expect(() => appLogger.info('hello'), returnsNormally);
    });

    test('warning does not throw', () {
      expect(() => appLogger.warning('hello'), returnsNormally);
    });

    test('error does not throw with optional error and stack', () {
      expect(
        () => appLogger.error(
          'boom',
          error: Exception('x'),
          stackTrace: StackTrace.current,
        ),
        returnsNormally,
      );
    });

    test('error accepts a message without additional context', () {
      expect(() => appLogger.error('boom'), returnsNormally);
    });
  });
}
