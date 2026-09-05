import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Section heading in a grouped picker list.
class GroupHeading extends StatelessWidget {
  const GroupHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(spacingLg, spacingMd, spacingLg, 0),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
