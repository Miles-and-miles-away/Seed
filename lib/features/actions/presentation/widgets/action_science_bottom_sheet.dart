import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

/// Bottom sheet displaying the scientific long description
/// for an action, rendered as markdown with tappable links.
class ActionScienceBottomSheet extends StatelessWidget {
  const ActionScienceBottomSheet({
    required this.action,
    required this.languageCode,
    super.key,
  });

  final ActionModel action;
  final String languageCode;

  /// Shows the bottom sheet.
  static void show(
    BuildContext context, {
    required ActionModel action,
    required String languageCode,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: sheetShape,
      builder: (context) =>
          ActionScienceBottomSheet(action: action, languageCode: languageCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = ActionCategory.fromString(action.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;
    final linkColor = readableTextColor(categoryColor, theme.brightness);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: sheetInitialChildSize(context),
      maxChildSize: sheetMaxChildSize,
      minChildSize: sheetMinChildSize,
      // The close button stays pinned while the title scrolls with the body.
      builder: (context, scrollController) => Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    minHeight: kMinInteractiveDimension,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                    left: spacingXxl + 40,
                    right: spacingSm + kMinInteractiveDimension,
                  ),
                  child: Text(
                    action.name(languageCode),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: readableTextColor(
                        categoryColor,
                        theme.brightness,
                        large: true,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: spacingLg),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(spacingXxl),
                  child: MarkdownBlock(
                    data: appendExternalLinkArrow(
                      action.descriptionLong(languageCode),
                    ),
                    generator: phraseMarkdownGenerator(
                      bodyWidth: phraseNarrowestScreenWidth - 2 * spacingXxl,
                    ),
                    config: markdownConfigFor(context).copy(
                      configs: [
                        PConfig(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.7,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        externalLinkConfig(context, color: linkColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: spacingSm,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor:
                    theme.bottomSheetTheme.backgroundColor ??
                    theme.colorScheme.surfaceContainerLow,
              ),
              icon: const Icon(Icons.close),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
