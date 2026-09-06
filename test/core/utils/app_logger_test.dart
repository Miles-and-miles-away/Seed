import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/app_logger.dart';

void main() {
  // Tests run in debug mode, so the logger writes through debugPrint.
  late List<String?> lines;
  late DebugPrintCallback previous;

  setUp(() {
    lines = [];
    previous = debugPrint;
    debugPrint = (message, {wrapWidth}) => lines.add(message);
  });

  tearDown(() => debugPrint = previous);

  test('each level prefixes its tag', () {
    appLogger
      ..debug('d')
      ..info('i')
      ..warning('w');

    expect(lines, ['[DEBUG] d', '[INFO] i', '[WARN] w']);
  });

  test('error prints the message, the error and the stack as lines', () {
    appLogger.error(
      'boom',
      error: Exception('x'),
      stackTrace: StackTrace.fromString('trace-1'),
    );

    expect(lines, ['[ERROR] boom', '[ERROR] Exception: x', '[ERROR] trace-1']);
  });

  test('error without context prints only the message', () {
    appLogger.error('boom');

    expect(lines, ['[ERROR] boom']);
  });
}
