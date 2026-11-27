import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

/// Width of an info sheet's text on a [phraseNarrowestScreenWidth] phone.
const infoSheetMinLineWidth = phraseNarrowestScreenWidth - 2 * spacingXxl;

/// Generic informational bottom sheet: a centered title above a
/// single body paragraph. Used by the "how does this work" info
/// buttons (e.g. the Eco-Dex header) so explainer sheets stay
/// visually consistent across features.
class InfoSheet extends StatelessWidget {
  const InfoSheet({required this.title, required String this.body, super.key})
    : content = null;

  /// The same frame around [content] in place of a body paragraph.
  const InfoSheet.custom({
    required this.title,
    required Widget this.content,
    super.key,
  }) : body = null;

  final String title;
  final String? body;
  final Widget? content;

  /// Shows the sheet modally. Mirrors the [showModalBottomSheet]
  /// conventions used elsewhere in the app (drag handle, rounded
  /// top corners).
  static void show(
    BuildContext context, {
    required String title,
    required String body,
  }) => present(context, InfoSheet(title: title, body: body));

  /// Shows [sheet], an explainer built on this frame, the same way.
  static void present(BuildContext context, Widget sheet) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: sheetShape,
      builder: (_) => sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          spacingXxl,
          spacingSm,
          spacingXxl,
          spacingXxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhraseText(
              title,
              minLineWidth: infoSheetMinLineWidth,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingLg),
            content ??
                PhraseText(
                  body!,
                  minLineWidth: infoSheetMinLineWidth,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
