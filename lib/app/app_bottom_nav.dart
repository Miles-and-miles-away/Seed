import 'package:flutter/material.dart';

import '../core/constants/ui_constants.dart';
import '../core/l10n/generated/app_localizations.dart';

/// Cap on how far nav labels scale with the user's text setting.
///
/// The same 1.3 Material's own [NavigationBar] applies, and for the
/// same reason: a fixed row of five destinations keeps its hierarchy
/// only if the labels stop growing at some point. Everything else on
/// screen still scales without limit.
const _maxLabelScale = 1.3;

/// Icon, padding and the gap under it: the part of the bar that does
/// not move with the text scale, then the label at the default scale.
/// Together they are the 65 this bar has always been.
const _navChromeHeight = 49.0;
const _navLabelHeight = 16.0;

/// Shared bottom navigation bar.
///
/// Rendered by the [MainShell] for the four shell tabs and by full-screen
/// pushed routes (e.g. the Action log) so every primary screen exposes the
/// same navigation instead of trapping the user behind a back button.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentIndex,
    required this.onTabSelected,
    required this.onActionPressed,
    this.onActionHover,
    this.isActionSelected = false,
    super.key,
  });

  /// Selected shell tab index (0 Home, 1 Progress, 2 Mascot, 3 Profile), or
  /// null when no tab is active (e.g. while the Action log is open).
  final int? currentIndex;

  /// Called with the shell tab index when a tab is tapped.
  final ValueChanged<int> onTabSelected;

  /// Called when the centre Action button is tapped.
  final VoidCallback onActionPressed;

  /// Called when a mouse pointer enters (true) or leaves (false) the
  /// centre Action button. Touch never hovers, so this is mouse-only.
  final ValueChanged<bool>? onActionHover;

  /// Whether the centre Action button should render as selected.
  final bool isActionSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Labels are clamped, so the bar only has to grow over the clamped
    // range -- and it must grow: at the fixed 65 the icon and label
    // column overflowed by 4.7pt once the user's text scale passed
    // about 1.8, on every screen that shows this bar.
    final scaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: _maxLabelScale);

    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: _navChromeHeight + scaler.scale(_navLabelHeight),
      child: Row(
        children: [
          Expanded(
            child: _NavBarItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: l10n.navHome,
              isSelected: currentIndex == 0,
              onTap: () => onTabSelected(0),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.calendar_today_outlined,
              selectedIcon: Icons.calendar_today,
              label: l10n.navProgress,
              isSelected: currentIndex == 1,
              onTap: () => onTabSelected(1),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.add_circle_outline,
              selectedIcon: Icons.add_circle,
              label: l10n.navLogAction,
              isSelected: isActionSelected,
              onTap: onActionPressed,
              onHover: onActionHover,
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.pets_outlined,
              selectedIcon: Icons.pets,
              label: l10n.navMascot,
              isSelected: currentIndex == 2,
              onTap: () => onTabSelected(2),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: l10n.navProfile,
              isSelected: currentIndex == 3,
              onTap: () => onTabSelected(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.onHover,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<bool>? onHover;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      onHover: onHover,
      borderRadius: borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: spacingXs,
          vertical: spacingSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color, size: 24),
            const SizedBox(height: spacingXs),
            // Labels render at natural size; FittedBox.scaleDown only
            // shrinks them when a translation (e.g. JP katakana) would
            // overflow the Expanded cell.
            MediaQuery.withClampedTextScaling(
              maxScaleFactor: _maxLabelScale,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  softWrap: false,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
