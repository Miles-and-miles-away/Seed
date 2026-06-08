import 'package:flutter/material.dart';

import '../core/constants/ui_constants.dart';
import '../core/l10n/generated/app_localizations.dart';

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

  /// Whether the centre Action button should render as selected.
  final bool isActionSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BottomAppBar(
      padding: EdgeInsets.zero,
      height: 65,
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
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color =
        isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadiusMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            // Labels render at natural size; FittedBox.scaleDown only
            // shrinks them when a translation (e.g. JP katakana) would
            // overflow the Expanded cell.
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
