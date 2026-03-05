import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/action_model.dart';
import '../../domain/enums/action_category.dart';

const _kMaxChildSize = 0.85;
const _kMinChildSize = 0.3;

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => ActionScienceBottomSheet(
        action: action,
        languageCode: languageCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = ActionCategory.fromString(action.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final mdConfig =
        isDark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;

    return DraggableScrollableSheet(
      maxChildSize: _kMaxChildSize,
      minChildSize: _kMinChildSize,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 8,
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
            const SizedBox(height: 16),
            const Divider(height: 1),
            Expanded(
              child: MarkdownWidget(
                data: action.descriptionLong(
                  languageCode,
                ),
                padding: const EdgeInsets.all(24),
                config: mdConfig.copy(
                  configs: [
                    PConfig(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.7,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    LinkConfig(
                      style: TextStyle(
                        color: categoryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: categoryColor,
                      ),
                      onTap: _onLinkTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onLinkTap(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
