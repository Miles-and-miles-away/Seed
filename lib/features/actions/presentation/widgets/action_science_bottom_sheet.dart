import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

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
      maxChildSize: sheetMaxChildSize,
      minChildSize: sheetMinChildSize,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: spacingXxl,
                right: spacingSm,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      action.name(languageCode),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: spacingLg),
            const Divider(height: 1),
            Expanded(
              child: MarkdownWidget(
                data: appendExternalLinkArrow(
                  action.descriptionLong(languageCode),
                ),
                padding: const EdgeInsets.all(spacingXxl),
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
        );
      },
    );
  }
}
