import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Generic informational bottom sheet: a centered title above a
/// single body paragraph. Used by the "how does this work" info
/// buttons (Eco-Dex header, Achievements app bar) so explainer
/// sheets stay visually consistent across features.
class InfoSheet extends StatelessWidget {
  const InfoSheet({required this.title, required this.body, super.key});

  final String title;
  final String body;

  /// Shows the sheet modally. Mirrors the [showModalBottomSheet]
  /// conventions used elsewhere in the app (drag handle, rounded
  /// top corners).
  static void show(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => InfoSheet(title: title, body: body),
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
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingLg),
            Text(
              body,
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
