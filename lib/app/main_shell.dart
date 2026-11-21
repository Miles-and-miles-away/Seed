import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/features/actions/actions.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/eco_dex.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';

import '../core/constants/ui_constants.dart';
import '../features/mascot/mascot.dart';
import '../shared/providers/analytics_providers.dart';
import '../shared/providers/day_change_provider.dart';
import '../shared/providers/notification_providers.dart';
import 'app_bottom_nav.dart';
import 'router.dart';

/// Main shell widget that provides bottom navigation.
///
/// Queues celebrations in this order: Streak Milestone, Evolution,
/// Egg Discovery, Egg Hatching. Eco-Dex discoveries follow once loaded.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  // Shell tabs where the mascot is visible (0 Home).
  static const _mascotTabs = {0};
  static const _tabRouteNames = ['home', 'progress', 'explore', 'profile'];

  bool _hasShownEggDiscovery = false;
  bool _actionPushPending = false;
  late final _tappedRoute = ref.read(notificationServiceProvider).tappedRoute;
  bool _celebrationsScheduled = false;
  final _shownMilestoneWeeks = <int>{};
  final _shownEvolutions = <String>{};
  final _shownHatchIds = <String>{};
  String? _ecoDexCheckedUid;

  @override
  void initState() {
    super.initState();
    // The shell only shows once signed in, so a tap from a cold start
    // waits here for the auth redirects to settle.
    _tappedRoute.addListener(_openTappedRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) => _openTappedRoute());

    ref
      // Bootstrap day-change tracking (keepAlive, so one read suffices
      // to keep the midnight/resume refresh running for the app lifetime)
      ..read(dayChangeProvider)
      // Warm the action library so the first Add-action tap does not
      // pay a cold server-first fetch inside the transition
      ..read(actionLibraryProvider)
      ..listenManual(
        pendingStreakMilestoneProvider,
        (_, _) => _scheduleCelebrations(),
        fireImmediately: true,
      )
      ..listenManual(
        hasNewEvolutionProvider,
        (_, _) => _scheduleCelebrations(),
        fireImmediately: true,
      )
      ..listenManual(
        shouldShowEggDiscoveryProvider,
        (_, _) => _scheduleCelebrations(),
        fireImmediately: true,
      )
      ..listenManual(
        allMascotsProvider.select(
          (a) => a.value?.where((m) => m.name.isEmpty).firstOrNull,
        ),
        (_, _) => _scheduleCelebrations(),
        fireImmediately: true,
      )
      ..listenManual(currentUserProvider.select((u) => u.value?.uid), (_, uid) {
        if (uid == null || uid == _ecoDexCheckedUid) return;
        _ecoDexCheckedUid = uid;
        unawaited(discoverAndCelebrateEcoDex(context, ref));
      }, fireImmediately: true);
  }

  // One pass per frame, so changes that land together queue in a fixed order.
  void _scheduleCelebrations() {
    if (_celebrationsScheduled) return;
    _celebrationsScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _celebrationsScheduled = false;
      if (mounted) _queueCelebrations();
    });
  }

  void _queueCelebrations() {
    final milestone = ref.read(pendingStreakMilestoneProvider);
    if (milestone != null && _shownMilestoneWeeks.add(milestone.week)) {
      unawaited(
        showStreakMilestoneCelebration(
          context,
          ref,
          weekNumber: milestone.week,
          totalDays: milestone.days,
        ),
      );
    }
    if (ref.read(hasNewEvolutionProvider)) {
      final mascotId = ref.read(activeMascotProvider).value?.id;
      final stage = ref.read(activeMascotStageProvider);
      if (_shownEvolutions.add('$mascotId:$stage')) {
        unawaited(showEvolutionCelebration(context, ref));
      }
    }
    if (!ref.read(shouldShowEggDiscoveryProvider)) {
      _hasShownEggDiscovery = false;
    } else if (!_hasShownEggDiscovery) {
      _hasShownEggDiscovery = true;
      unawaited(showEggDiscoveryCelebration(context, ref));
    }
    final hatched = ref
        .read(allMascotsProvider)
        .value
        ?.where((m) => m.name.isEmpty)
        .firstOrNull;
    if (hatched != null && _shownHatchIds.add(hatched.id)) {
      unawaited(showEggHatchingCelebration(context, hatched));
    }
  }

  @override
  void dispose() {
    _tappedRoute.removeListener(_openTappedRoute);
    super.dispose();
  }

  void _openTappedRoute() {
    final route = _tappedRoute.value;
    if (route == null || !mounted) return;
    _tappedRoute.value = null;
    final router = GoRouter.of(context);
    // Replace an open action log rather than stack a second one.
    if (router.state.uri.path == appRoutes.actionLog) {
      router.pushReplacement(route);
    } else {
      router.push(route);
    }
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
    // Touch never hovers, so let the mascot smile before the action log
    // opens; the push lands while the 0.5s smile timeline is still on
    // the happy mouth.
    if (_mascotTabs.contains(widget.navigationShell.currentIndex)) {
      // The delayed push would otherwise stack one Log Action per tap.
      if (_actionPushPending) return;
      _actionPushPending = true;
      ref
          .read(mascotSmileTriggerProvider.notifier)
          .triggerSmile(hold: durationMedium - durationInstant);
      Future.delayed(durationMedium, () {
        _actionPushPending = false;
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
    // Tab switches swap an IndexedStack, so the navigator observer that
    // records the route key for Crashlytics never sees them.
    unawaited(
      ref
          .read(crashlyticsProvider)
          .setCustomKey('route', _tabRouteNames[index]),
    );
  }
}
