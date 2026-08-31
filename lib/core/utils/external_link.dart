import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Character appended to external link text across the app so
/// users can tell at a glance that tapping leaves Seed.
const String externalLinkChar = '\u2197';

final RegExp _markdownLinkRegExp = RegExp(r'\[([^\]]+)\]\(([^)]+)\)');

/// Appends [externalLinkChar] to the visible text of every markdown
/// link in [markdown]. Leaves links that already carry the character
/// untouched so re-processing is a no-op.
String appendExternalLinkArrow(String markdown) {
  return markdown.replaceAllMapped(_markdownLinkRegExp, (match) {
    final text = match.group(1)!;
    final url = match.group(2)!;
    if (text.trimRight().endsWith(externalLinkChar)) {
      return match.group(0)!;
    }
    return '[$text $externalLinkChar]($url)';
  });
}

/// The markdown base config matching the current theme brightness.
MarkdownConfig markdownConfigFor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? MarkdownConfig.darkConfig
    : MarkdownConfig.defaultConfig;

/// Underlined markdown links that leave the app when tapped.
///
/// [color] defaults to the theme primary; the action sheets pass a
/// category colour already made readable against the surface. [onTap]
/// defaults to [openExternalUrl].
LinkConfig externalLinkConfig(
  BuildContext context, {
  Color? color,
  void Function(String url)? onTap,
}) {
  final linkColor = color ?? Theme.of(context).colorScheme.primary;
  return LinkConfig(
    style: TextStyle(
      color: linkColor,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    ),
    onTap: onTap ?? (url) => openExternalUrl(context, url),
  );
}

/// Opens [url] outside the app (browser, mail client, ...).
///
/// Deliberately skips `canLaunchUrl`: on Android 11+ it reports false
/// for schemes missing from the manifest `<queries>` even when a
/// handler exists, which made links silently dead. Instead the launch
/// is attempted directly and any failure surfaces as a SnackBar.
Future<void> openExternalUrl(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  var launched = false;
  if (uri != null) {
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception {
      launched = false;
    }
  }
  if (launched || !context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context).errorOpenLink)),
  );
}
