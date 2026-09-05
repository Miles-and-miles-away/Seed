import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// The tinted top band of the action dialogs: icon, title and an
/// optional [trailing] widget beneath them.
class ActionDialogHeader extends StatelessWidget {
  const ActionDialogHeader({
    required this.tint,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    super.key,
  });

  final Color tint;
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(spacingXxl),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: spacingMd),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (trailing != null) ...[
            const SizedBox(height: spacingSm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
