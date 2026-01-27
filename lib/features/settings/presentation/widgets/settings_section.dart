import 'package:flutter/material.dart';

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
          Divider(
            color: colorScheme.outlineVariant,
            height: 32,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
