import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';
import '../providers/walkthrough_providers.dart';
import '../walkthrough_items.dart';

/// The mascot explaining one walkthrough item over a dark scrim: short
/// pages tapped through in order, with the checklist under the last one.
/// Finding the final checklist entry appends a confetti completion page.
class WalkthroughOverlay extends ConsumerStatefulWidget {
  const WalkthroughOverlay({
    required this.item,
    required this.onDismiss,
    super.key,
  });

  final WalkthroughItem item;
  final VoidCallback onDismiss;

  @override
  ConsumerState<WalkthroughOverlay> createState() => _WalkthroughOverlayState();
}

class _WalkthroughOverlayState extends ConsumerState<WalkthroughOverlay> {
  int _page = 0;
  bool _done = false;

  /// Frozen at open so the page count cannot change under the user.
  late final bool _completes;

  @override
  void initState() {
    super.initState();
    final found = {...?ref.read(walkthroughFoundProvider), widget.item.name};
    _completes =
        widget.item != WalkthroughItem.intro &&
        WalkthroughItem.checklist.every((i) => found.contains(i.name));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final item = widget.item;
    final mascotName =
        ref.watch(activeMascotProvider.select((m) => m.value?.name)) ?? '';
    final found = {...?ref.watch(walkthroughFoundProvider), item.name};
    final pages = [
      ...item.pages(l10n, mascotName: mascotName),
      if (_completes) l10n.walkthroughComplete,
    ];
    final isLast = _page == pages.length - 1;
    final buttonLabel = !isLast
        ? l10n.walkthroughNext
        : item == WalkthroughItem.intro
        ? l10n.walkthroughStart
        : l10n.walkthroughGotIt;

    return PopScope(
      canPop: false,
      child: CelebrationOverlay(
        children: [
          if (_completes && isLast) const TimedConfettiLayer(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(spacingXxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MascotDisplay(size: 120, showGlow: false),
                    const SizedBox(height: spacingSm),
                    Text(
                      mascotName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: spacingLg),
                    Card(
                          child: Padding(
                            padding: const EdgeInsets.all(spacingLg),
                            child: Text(
                              pages[_page],
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        .animate(key: ValueKey(_page))
                        .fadeIn(duration: durationNormal),
                    if (isLast) ...[
                      const SizedBox(height: spacingXl),
                      _Checklist(found: found, current: item),
                    ],
                    const SizedBox(height: spacingXxl),
                    CelebrationButton(
                      label: buttonLabel,
                      onPressed: () => _advance(isLast: isLast),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _advance({required bool isLast}) {
    if (!isLast) {
      setState(() => _page++);
      return;
    }
    if (_done) return;
    _done = true;
    final analytics = ref.read(analyticsServiceProvider);
    ref.read(settingsProvider.notifier).markWalkthroughFound(widget.item.name);
    analytics.logWalkthroughItemFound(item: widget.item.name);
    if (_completes) analytics.logWalkthroughCompleted();
    widget.onDismiss();
  }
}

class _Checklist extends StatelessWidget {
  const _Checklist({required this.found, required this.current});

  final Set<String> found;
  final WalkthroughItem current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.walkthroughChecklistTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            color: Colors.white.withValues(alpha: opacityStrong),
          ),
        ),
        const SizedBox(height: spacingSm),
        for (final item in WalkthroughItem.checklist)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: spacingXs),
            child: Row(
              children: [
                Icon(
                  found.contains(item.name)
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: found.contains(item.name)
                      ? AppColors.gold
                      : Colors.white.withValues(alpha: opacityMedium),
                  size: 20,
                ),
                const SizedBox(width: spacingSm),
                Expanded(
                  child: Text(
                    item.label(l10n),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: item == current
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Shows [item]'s explanation; resolves when dismissed. Callers check
/// [walkthroughPendingProvider] first, or use [WalkthroughTrigger].
Future<void> showWalkthroughItem(BuildContext context, WalkthroughItem item) {
  return showCelebrationOverlay(
    context,
    (onDismiss) => WalkthroughOverlay(item: item, onDismiss: onDismiss),
  );
}

/// Pops [item]'s explanation once, the first time this subtree is shown
/// while the item is still pending. Arms again after a Settings reset.
class WalkthroughTrigger extends ConsumerStatefulWidget {
  const WalkthroughTrigger({
    required this.item,
    required this.child,
    this.enabled = true,
    super.key,
  });

  final WalkthroughItem item;
  final Widget child;
  final bool enabled;

  @override
  ConsumerState<WalkthroughTrigger> createState() => _WalkthroughTriggerState();
}

class _WalkthroughTriggerState extends ConsumerState<WalkthroughTrigger> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(walkthroughPendingProvider(widget.item));
    if (!pending) {
      _shown = false;
    } else if (widget.enabled &&
        !_shown &&
        TickerMode.valuesOf(context).enabled) {
      _shown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showWalkthroughItem(context, widget.item);
      });
    }
    return widget.child;
  }
}
