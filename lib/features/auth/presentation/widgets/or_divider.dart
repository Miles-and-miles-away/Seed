import 'dart:math';

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// A horizontal rule with [label] set into its middle. A label too long
/// for the row wraps, keeping a short rule on each side.
class OrDivider extends StatelessWidget {
  const OrDivider({required this.label, super.key});

  final String label;

  static const _labelPadding = spacingLg;
  static const _minRuleWidth = spacingXxl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLabelWidth = max<double>(
          0,
          constraints.maxWidth - 2 * (_labelPadding + _minRuleWidth),
        );
        return Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _labelPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxLabelWidth),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        );
      },
    );
  }
}
