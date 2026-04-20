import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/legal_content.dart';

void main() {
  group('PrivacyPolicyContent', () {
    test('returns sections for English, Japanese, and Spanish', () {
      for (final locale in [
        const Locale('en'),
        const Locale('ja'),
        const Locale('es'),
      ]) {
        final sections = PrivacyPolicyContent.forLocale(locale);
        expect(sections, isNotEmpty, reason: 'locale=${locale.languageCode}');
        for (final s in sections) {
          expect(s.title, isNotEmpty);
          expect(s.body, isNotEmpty);
        }
      }
    });

    test('falls back to English for unknown locales', () {
      final en = PrivacyPolicyContent.forLocale(const Locale('en'));
      final fallback = PrivacyPolicyContent.forLocale(const Locale('fr'));

      expect(fallback.length, en.length);
      expect(fallback.first.title, en.first.title);
    });

    test('lastUpdated and contactEmail are published as constants', () {
      expect(PrivacyPolicyContent.lastUpdated, isNotEmpty);
      expect(PrivacyPolicyContent.contactEmail, contains('@'));
    });
  });

  group('TermsOfServiceContent', () {
    test('returns sections for each supported locale', () {
      for (final locale in [
        const Locale('en'),
        const Locale('ja'),
        const Locale('es'),
      ]) {
        final sections = TermsOfServiceContent.forLocale(locale);
        expect(sections, isNotEmpty, reason: 'locale=${locale.languageCode}');
      }
    });

    test('has the same lastUpdated date as the privacy policy', () {
      expect(
        TermsOfServiceContent.lastUpdated,
        PrivacyPolicyContent.lastUpdated,
      );
    });
  });
}
