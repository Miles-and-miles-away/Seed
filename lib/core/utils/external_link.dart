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
