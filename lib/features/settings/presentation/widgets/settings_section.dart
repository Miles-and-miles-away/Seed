import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// A section header widget for grouping related settings.
///
/// Displays a title with optional padding and divider.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    this.showTopDivider = false,
    super.key,
  });

  /// The section title displayed above the children.
  final String title;

  /// The settings tiles within this section.
  final List<Widget> children;

  /// Whether to show a divider above the section.
  final bool showTopDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTopDivider)
          Divider(color: colorScheme.outlineVariant, height: spacingXxxl),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingSm,
          ),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
