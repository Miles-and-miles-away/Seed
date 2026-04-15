import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/external_link.dart';

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
      const expected = 'Read [one $externalLinkChar](https://a.org) and '
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
}
