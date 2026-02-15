import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../features/mascot/mascot.dart';

/// Main shell widget that provides bottom navigation.
///
/// Handles showing celebrations in priority order:
/// Evolution > Egg Discovery
class MainShell extends ConsumerStatefulWidget {
  const MainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShell> createState() =>
      _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  bool _hasShownEvolutionCelebration = false;
  bool _hasShownEggDiscovery = false;

  @override
  void initState() {
    super.initState();

    // Run migration once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(mascotProvider.notifier)
          .runMigrationIfNeeded();
    });

    ref
      // React to evolution changes only when value flips
      ..listenManual(hasNewEvolutionProvider, (_, next) {
        if (next && !_hasShownEvolutionCelebration) {
          _hasShownEvolutionCelebration = true;
          WidgetsBinding.instance
              .addPostFrameCallback((_) {
            if (mounted) {
              showEvolutionCelebration(context);
            }
          });
        }
      })
      // React to egg discovery flag
      ..listenManual(
        shouldShowEggDiscoveryProvider,
        (_, next) {
          if (next && !_hasShownEggDiscovery) {
            _hasShownEggDiscovery = true;
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              if (mounted) {
                showEggDiscoveryCelebration(
                  context,
                  ref,
                );
              }
            });
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: widget.navigationShell,
      floatingActionButton: FloatingActionButton(
        heroTag: 'log_action_fab',
        onPressed: () => context.push('/log-action'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: l10n.navHome,
              isSelected:
                  widget.navigationShell.currentIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            _NavBarItem(
              icon: Icons.calendar_today_outlined,
              selectedIcon: Icons.calendar_today,
              label: l10n.navProgress,
              isSelected:
                  widget.navigationShell.currentIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            const SizedBox(width: 56),
            _NavBarItem(
              icon: Icons.pets_outlined,
              selectedIcon: Icons.pets,
              label: l10n.navMascot,
              isSelected:
                  widget.navigationShell.currentIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            _NavBarItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: l10n.navProfile,
              isSelected:
                  widget.navigationShell.currentIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation:
          index == widget.navigationShell.currentIndex,
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
    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
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
            Text(
              label,
              style:
                  theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
