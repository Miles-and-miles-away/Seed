import 'package:seed_app/features/settings/presentation/feedback_category.dart';

/// Recipient inbox for in-app feedback submissions.
const String feedbackRecipientEmail = 'support@seedhabit.app';

/// Caps the feedback description length. Overly long `mailto:` URIs can
/// exceed platform intent limits and silently fail to launch the client.
const int feedbackDescriptionMaxLength = 2000;

/// Builds the `mailto:` URI launched when a user submits feedback.
///
/// The subject is prefixed by [category]'s tag (e.g. `[Bug]`) and the
/// body bundles the user's description with app/device metadata so the
/// developer has context without round-tripping.
///
/// [appVersion] / [buildNumber] come from `package_info_plus`.
/// [platform] / [osVersion] come from `dart:io` Platform.
/// [locale] is the active locale tag (e.g. `en`, `ja`).
/// [userId] is omitted from the body when null (unauthenticated users).
///
/// The description is capped at [feedbackDescriptionMaxLength]; the UI also
/// enforces this, but the cap is applied here too so any caller is safe from
/// producing an over-long `mailto:` URI.
Uri buildFeedbackMailto({
  required FeedbackCategory category,
  required String categoryLabel,
  required String description,
  required String appVersion,
  required String buildNumber,
  required String platform,
  required String osVersion,
  required String locale,
  String? userId,
  String recipient = feedbackRecipientEmail,
}) {
  final subject = '${category.subjectPrefix} Seed App Feedback';

  // Match _MetadataFooter: no empty parens when the build number is absent.
  final buildSuffix = buildNumber.isEmpty ? '' : ' ($buildNumber)';
  final trimmed = description.trim();
  final cappedDescription = trimmed.length <= feedbackDescriptionMaxLength
      ? trimmed
      : trimmed.substring(0, feedbackDescriptionMaxLength);
  final body = StringBuffer()
    ..writeln('Category: $categoryLabel')
    ..writeln('---')
    ..writeln(cappedDescription)
    ..writeln('---')
    ..writeln('App: Seed v$appVersion$buildSuffix')
    ..writeln('Platform: $platform $osVersion')
    ..writeln('Locale: $locale');
  if (userId != null && userId.isNotEmpty) {
    body.writeln('User ID: $userId');
  }

  // Build the query string manually so spaces encode as `%20` (RFC 6068)
  // instead of `+`, which some mail clients render literally in the body.
  final query = 'subject=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(body.toString())}';

  return Uri.parse('mailto:$recipient?$query');
}
