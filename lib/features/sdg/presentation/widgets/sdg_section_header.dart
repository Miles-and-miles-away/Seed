import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Icon and bold title that open each section of the SDG detail
/// screen; the title only flexes when [trailing] needs the rest of the row.
class SdgSectionHeader extends StatelessWidget {
  const SdgSectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
    super.key,
  });

  final IconData icon;
  final String title;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final text = Text(title, style: style);
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: spacingSm),
        if (trailing == null) text else Expanded(child: text),
        ?trailing,
      ],
    );
  }
}
