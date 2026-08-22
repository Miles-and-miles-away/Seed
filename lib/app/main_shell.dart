import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/features/actions/actions.dart';

import '../core/constants/ui_constants.dart';
import '../features/mascot/mascot.dart';
import '../shared/providers/day_change_provider.dart';
import 'app_bottom_nav.dart';
import 'router.dart';

/// Main shell widget that provides bottom navigation.
///
/// Handles showing celebrations in priority order:
/// Evolution > Egg Discovery
class MainShell extends ConsumerStatefulWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  // Shell tabs where the mascot is visible (0 Home, 2 Mascot).
  static const _mascotTabs = {0, 2};

  bool _hasShownEvolutionCelebration = false;
  bool _hasShownEggDiscovery = false;

  @override
  void initState() {
    super.initState();

    ref
      // Bootstrap day-change tracking (keepAlive, so one read suffices
      // to keep the midnight/resume refresh running for the app lifetime)
      ..read(dayChangeProvider)
      // Warm the action library so the first Add-action tap does not
      // pay a cold server-first fetch inside the transition
      ..read(actionLibraryProvider)
      // React to evolution changes only when value flips
      ..listenManual(hasNewEvolutionProvider, (_, next) {
        if (next && !_hasShownEvolutionCelebration) {
          _hasShownEvolutionCelebration = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              showEvolutionCelebration(context);
            }
          });
        }
      })
      // React to egg discovery flag
      ..listenManual(shouldShowEggDiscoveryProvider, (_, next) {
        if (next && !_hasShownEggDiscovery) {
          _hasShownEggDiscovery = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              showEggDiscoveryCelebration(context, ref);
            }
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: widget.navigationShell.currentIndex,
        onTabSelected: _onItemTapped,
        onActionPressed: _onActionPressed,
        onActionHover: _onActionHover,
      ),
    );
  }

  void _onActionPressed() {
    // Touch never hovers, so let the mascot smile briefly before the
    // action log slides in.
    if (_mascotTabs.contains(widget.navigationShell.currentIndex)) {
      ref.read(mascotSmileTriggerProvider.notifier).triggerSmile();
      Future.delayed(durationInstant, () {
        if (mounted) context.push(appRoutes.actionLog);
      });
    } else {
      context.push(appRoutes.actionLog);
    }
  }

  // Mouse-only counterpart: smile while the pointer rests on the button.
  void _onActionHover(bool hovering) {
    if (hovering && _mascotTabs.contains(widget.navigationShell.currentIndex)) {
      ref.read(mascotSmileTriggerProvider.notifier).triggerSmile();
    }
  }

  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
