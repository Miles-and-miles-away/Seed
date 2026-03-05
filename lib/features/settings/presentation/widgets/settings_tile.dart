import 'package:flutter/material.dart';

/// A reusable settings row widget with consistent styling.
///
/// Supports leading icon, title, subtitle, trailing widget, and tap action.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showChevron = true,
    this.enabled = true,
    this.dangerous = false,
    super.key,
  });

  /// The main title text.
  final String title;

  /// Optional subtitle text shown below the title.
  final String? subtitle;

  /// Optional leading widget (typically an icon).
  final Widget? leading;

  /// Optional trailing widget (switch, badge, etc.).
  /// If null and [showChevron] is true, a chevron icon is shown.
  final Widget? trailing;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Whether to show a chevron icon when no trailing widget is provided.
  final bool showChevron;

  /// Whether the tile is enabled.
  final bool enabled;

  /// Whether this is a dangerous action (e.g., delete account).
  /// Changes the color scheme to error colors.
  final bool dangerous;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveTextColor = !enabled
        ? colorScheme.onSurface.withValues(alpha: 0.38)
        : dangerous
            ? colorScheme.error
            : null;

    final effectiveIconColor = !enabled
        ? colorScheme.onSurface.withValues(alpha: 0.38)
        : dangerous
            ? colorScheme.error
            : colorScheme.primary;

    var effectiveTrailing = trailing;
    if (effectiveTrailing == null && showChevron && onTap != null) {
      effectiveTrailing = Icon(
        Icons.chevron_right,
        color: colorScheme.onSurfaceVariant,
      );
    }

    return ListTile(
      leading: leading != null
          ? IconTheme(
              data: IconThemeData(
                color: effectiveIconColor,
                size: 24,
              ),
              child: leading!,
            )
          : null,
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: effectiveTextColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: effectiveTrailing,
      onTap: enabled ? onTap : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

/// A settings tile specifically for switches.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.enabled = true,
    super.key,
  });

  /// The main title text.
  final String title;

  /// Optional subtitle text shown below the title.
  final String? subtitle;

  /// Optional leading widget (typically an icon).
  final Widget? leading;

  /// The current switch value.
  final bool value;

  /// Callback when the switch is toggled.
  final ValueChanged<bool>? onChanged;

  /// Whether the tile is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SettingsTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      showChevron: false,
      enabled: enabled,
      trailing: Switch.adaptive(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeTrackColor: colorScheme.primary,
      ),
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
