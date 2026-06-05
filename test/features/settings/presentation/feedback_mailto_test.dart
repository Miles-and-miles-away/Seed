import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/feedback_category.dart';
import 'package:seed_app/features/settings/presentation/feedback_mailto.dart';

void main() {
  group('buildFeedbackMailto', () {
    Uri buildSample({
      FeedbackCategory category = FeedbackCategory.bug,
      String description = 'My screen froze on launch',
      String buildNumber = '42',
      String? userId,
    }) {
      return buildFeedbackMailto(
        category: category,
        categoryLabel: 'Bug Report',
        description: description,
        appVersion: '1.2.0',
        buildNumber: buildNumber,
        platform: 'ios',
        osVersion: 'Version 18.3',
        locale: 'en',
        userId: userId,
      );
    }

    test('uses mailto scheme and recipient', () {
      final uri = buildSample();
      expect(uri.scheme, 'mailto');
      expect(uri.path, feedbackRecipientEmail);
    });

    test('subject is prefixed by category tag', () {
      final bug = buildSample();
      final feature = buildSample(category: FeedbackCategory.featureRequest);
      final general = buildSample(category: FeedbackCategory.general);

      expect(bug.queryParameters['subject'], startsWith('[Bug] '));
      expect(feature.queryParameters['subject'], startsWith('[Feature] '));
      expect(general.queryParameters['subject'], startsWith('[Feedback] '));
    });

    test('body contains description, app version, platform, locale', () {
      final body = buildSample().queryParameters['body']!;
      expect(body, contains('Category: Bug Report'));
      expect(body, contains('My screen froze on launch'));
      expect(body, contains('App: Seed v1.2.0 (42)'));
      expect(body, contains('Platform: ios Version 18.3'));
      expect(body, contains('Locale: en'));
    });

    test('body omits parens when build number is empty', () {
      final body = buildSample(buildNumber: '').queryParameters['body']!;
      expect(body, contains('App: Seed v1.2.0\n'));
      expect(body, isNot(contains('()')));
    });

    test('body includes user id when provided', () {
      final body = buildSample(userId: 'uid-abc-123').queryParameters['body']!;
      expect(body, contains('User ID: uid-abc-123'));
    });

    test('body omits user id when null', () {
      final body = buildSample().queryParameters['body']!;
      expect(body, isNot(contains('User ID:')));
    });

    test('body omits user id when empty string', () {
      final body = buildSample(userId: '').queryParameters['body']!;
      expect(body, isNot(contains('User ID:')));
    });

    test('description is trimmed before embedding', () {
      final body = buildSample(
        description: '   leading and trailing whitespace   \n',
      ).queryParameters['body']!;
      expect(body, contains('leading and trailing whitespace'));
      expect(body, isNot(contains('   leading')));
    });
  });
}
