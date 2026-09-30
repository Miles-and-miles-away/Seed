import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

void main() {
  group('WalkthroughItem', () {
    test('checklist excludes the intro and has seven entries', () {
      expect(WalkthroughItem.checklist, hasLength(7));
      expect(WalkthroughItem.checklist, isNot(contains(WalkthroughItem.intro)));
    });

    for (final locale in AppLocalizations.supportedLocales) {
      test('every item has a label and pages in $locale', () {
        final l10n = lookupAppLocalizations(locale);
        for (final item in WalkthroughItem.values) {
          final pages = item.pages(l10n, mascotName: 'Pip');
          expect(pages, isNotEmpty, reason: item.name);
          expect(pages.every((p) => p.trim().isNotEmpty), isTrue);
          if (item != WalkthroughItem.intro) {
            expect(item.label(l10n).trim(), isNotEmpty, reason: item.name);
          }
        }
        expect(
          WalkthroughItem.intro.pages(l10n, mascotName: 'Pip').first,
          contains('Pip'),
        );
      });
    }
  });
}
