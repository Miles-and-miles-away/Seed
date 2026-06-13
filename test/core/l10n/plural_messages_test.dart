import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

void main() {
  group('ICU plural messages', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final es = lookupAppLocalizations(const Locale('es'));
    final ja = lookupAppLocalizations(const Locale('ja'));

    test('English singular forms drop the plural s', () {
      expect(en.pointsLabel(1), '1 point');
      expect(en.pointsLabel(2), '2 points');
      expect(en.sdgActionsLogged(1), '1 action logged');
      expect(en.sdgActionsLogged(3), '3 actions logged');
      expect(en.mascotLevelsToGo(1), '1 level to go');
      expect(en.mascotLevelsToGo(4), '4 levels to go');
      expect(en.profileDaysActive(1), '1 day');
      expect(en.profileDaysActive(7), '7 days');
      expect(en.challengeDays(1), '1 day');
      expect(en.challengeDays(3), '3 days');
    });

    test('Spanish has distinct singular and plural forms', () {
      expect(es.pointsLabel(1), isNot(es.pointsLabel(2)));
      expect(es.profileDaysActive(1), isNot(es.profileDaysActive(2)));
    });

    test('Japanese renders counts without crashing (single form)', () {
      expect(ja.pointsLabel(1), contains('1'));
      expect(ja.pointsLabel(5), contains('5'));
      expect(ja.challengeDays(3), contains('3'));
    });
  });
}
