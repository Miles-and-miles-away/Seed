import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/external_link.dart';

import '../../helpers/test_helpers.dart';

const MethodChannel _launcherChannel = MethodChannel(
  'plugins.flutter.io/url_launcher',
);
const String _testUrl = 'https://example.org';

Widget _wrap() => createTestWidget(
  scaffold: true,
  child: Builder(
    builder: (context) => TextButton(
      onPressed: () => openExternalUrl(context, _testUrl),
      child: const Text('open'),
    ),
  ),
);

void main() {
  group('appendExternalLinkArrow', () {
    test('returns input unchanged when no links present', () {
      const input = 'Just some plain text with no links.';
      expect(appendExternalLinkArrow(input), input);
    });

    test('appends arrow to a single markdown link', () {
      expect(
        appendExternalLinkArrow('See [the study](https://science.org).'),
        'See [the study $externalLinkChar](https://science.org).',
      );
    });

    test('appends arrow to every link when multiple are present', () {
      const input = 'Read [one](https://a.org) and [two](https://b.org).';
      const expected =
          'Read [one $externalLinkChar](https://a.org) and '
          '[two $externalLinkChar](https://b.org).';
      expect(appendExternalLinkArrow(input), expected);
    });

    test('is idempotent when arrow already present', () {
      const input = '[already tagged $externalLinkChar](https://x.org)';
      expect(appendExternalLinkArrow(input), input);
    });

    test('leaves URLs untouched', () {
      const url = 'https://example.org/path?q=1&r=2';
      final result = appendExternalLinkArrow('[text]($url)');
      expect(result, '[text $externalLinkChar]($url)');
    });

    test('preserves surrounding markdown formatting', () {
      const input = '**Bold** and [linked](https://x.org) together.';
      expect(
        appendExternalLinkArrow(input),
        '**Bold** and [linked $externalLinkChar](https://x.org) together.',
      );
    });
  });

  group('openExternalUrl', () {
    void mockLauncher(
      WidgetTester tester,
      Future<Object?> Function(MethodCall call) handler,
    ) {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        _launcherChannel,
        handler,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          _launcherChannel,
          null,
        ),
      );
    }

    testWidgets('launches URL externally without a SnackBar', (tester) async {
      final calls = <MethodCall>[];
      mockLauncher(tester, (call) async {
        calls.add(call);
        return true;
      });

      await tester.pumpWidget(_wrap());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(calls.single.method, 'launch');
      expect(calls.single.arguments, containsPair('url', _testUrl));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows SnackBar when the launch is refused', (tester) async {
      mockLauncher(tester, (call) async => false);

      await tester.pumpWidget(_wrap());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Could not open link.'), findsOneWidget);
    });

    testWidgets('shows SnackBar when the launch throws', (tester) async {
      mockLauncher(tester, (call) async {
        throw PlatformException(code: 'ACTIVITY_NOT_FOUND');
      });

      await tester.pumpWidget(_wrap());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Could not open link.'), findsOneWidget);
    });
  });
}
