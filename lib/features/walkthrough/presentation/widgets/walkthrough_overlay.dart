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
import 'package:seed_app/shared/widgets/phrase_text.dart';
import '../providers/walkthrough_providers.dart';
import '../walkthrough_items.dart';

/// Bubble text width at 320pt: bubble inset, card margin, card padding.
const _bubbleMinLineWidth =
    phraseNarrowestScreenWidth - 2 * (spacingXxl + cardMargin + spacingLg);

const _mascotSize = 120.0;
const _compactMascotSize = 80.0;

/// Compact bubble height that does not scale with text.
const _bubbleChrome =
    8 * spacingLg + _compactMascotSize + spacingSm + 2 * cardMargin;

/// Name, two lines of page text and the button label at text scale 1.
const _bubbleMinText = 92.0;

/// A band shorter than this gets the full scrim and a centred bubble.
double _minBandHeight(TextScaler scaler) =>
    _bubbleChrome + scaler.scale(_bubbleMinText);

/// Fraction of its height the bubble slides in by, from away from the rect.
const _slideOffset = 0.1;

/// The mascot explaining one walkthrough item over a dark scrim: short
/// pages tapped through in order, with the checklist under the last one.
/// Finding the final checklist entry appends a confetti completion page.
class WalkthroughOverlay extends ConsumerStatefulWidget {
  const WalkthroughOverlay({
    required this.item,
    required this.onDismiss,
    this.spotlight,
    this.onPage,
    super.key,
  });

  final WalkthroughItem item;
  final VoidCallback onDismiss;

  /// A rect on the surface being explained, per page; null for a page
  /// with nothing to show. The scrim leaves it clear and the bubble sits
  /// in the taller free band beside it instead of centred.
  final Rect? Function(int page)? spotlight;

  /// Reports the page being shown, and null on dismiss, so the surface
  /// under a spotlight can highlight the part being explained.
  final ValueChanged<int?>? onPage;

  @override
  ConsumerState<WalkthroughOverlay> createState() => _WalkthroughOverlayState();
}

class _WalkthroughOverlayState extends ConsumerState<WalkthroughOverlay> {
  int _page = 0;
  bool _done = false;
  final _scroll = ScrollController();

  /// Frozen at open so the page count cannot change under the user.
  late final bool _completes;

  @override
  void initState() {
    super.initState();
    final found = {...?ref.read(walkthroughFoundProvider), widget.item.name};
    _completes =
        widget.item != WalkthroughItem.intro &&
        WalkthroughItem.checklist.every((i) => found.contains(i.name));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onPage?.call(0);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final item = widget.item;
    final mascotName =
        ref.watch(activeMascotProvider.select((m) => m.value?.name)) ?? '';
    final assetPath = ref.watch(activeMascotAssetPathProvider);
    final artboardName = ref.watch(
      activeStageDataProvider.select((stage) => stage?.artboardName),
    );
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

    // Per overlay, not per page, so a fallback page keeps the same size.
    final compact = widget.spotlight != null;
    final inset = compact ? spacingLg : spacingXxl;
    final mascotSize = compact ? _compactMascotSize : _mascotSize;
    final height = MediaQuery.sizeOf(context).height;
    final safe = MediaQuery.paddingOf(context);
    final rect = widget.spotlight?.call(_page);
    // The bubble takes the taller of the two bands beside the rect.
    final rectBelow = rect != null && rect.center.dy < height / 2;
    final band = switch (rect) {
      null => 0.0,
      _ when rectBelow => height - safe.bottom - rect.bottom,
      _ => rect.top - safe.top,
    };
    final fits = band >= _minBandHeight(MediaQuery.textScalerOf(context));
    final spotlight = fits ? rect : null;
    final below = fits && rectBelow;
    final (bandTop, bandBottom) = switch (spotlight) {
      null => (0.0, 0.0),
      final clear when below => (clear.bottom, 0.0),
      final clear => (0.0, height - clear.top),
    };
    final still =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.reduceMotionOf(context);
    final slide = spotlight == null || still
        ? 0.0
        : below
        ? _slideOffset
        : -_slideOffset;

    final text = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // A still frame: Home's mascot keeps animating beneath, and two
        // live artboards were enough to stall the UI thread.
        if (assetPath == null)
          SizedBox(height: mascotSize)
        else
          MascotAvatar(
            assetPath: assetPath,
            artboardName: artboardName,
            size: mascotSize,
            animate: false,
          ),
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
            child: PhraseText(
              pages[_page],
              minLineWidth: _bubbleMinLineWidth,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ).animate(key: ValueKey(_page)).fadeIn(duration: durationNormal),
        if (isLast) ...[
          const SizedBox(height: spacingXl),
          _Checklist(found: found, current: item),
        ],
      ],
    );

    return PopScope(
      canPop: false,
      child: CelebrationOverlay(
        clearRect: spotlight,
        children: [
          if (_completes && isLast) const TimedConfettiLayer(),
          Positioned(
            left: 0,
            right: 0,
            top: bandTop,
            bottom: bandBottom,
            child: SafeArea(
              top: !below,
              bottom: spotlight == null || below,
              child: Align(
                alignment: spotlight == null
                    ? Alignment.center
                    : below
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(inset),
                  // Outside the scroll view, so a short band never hides it.
                  child:
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              controller: _scroll,
                              child: text,
                            ),
                          ),
                          SizedBox(height: inset),
                          CelebrationButton(
                            label: buttonLabel,
                            onPressed: () => _advance(isLast: isLast),
                          ),
                        ],
                      ).animate().slideY(
                        begin: slide,
                        end: 0,
                        duration: durationNormal,
                      ),
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
      if (_scroll.hasClients) _scroll.jumpTo(0);
      widget.onPage?.call(_page);
      return;
    }
    if (_done) return;
    _done = true;
    widget.onPage?.call(null);
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
Future<void> showWalkthroughItem(
  BuildContext context,
  WalkthroughItem item, {
  Rect? Function(int page)? spotlight,
  ValueChanged<int?>? onPage,
}) {
  return showCelebrationOverlay(
    context,
    (onDismiss) => WalkthroughOverlay(
      item: item,
      onDismiss: onDismiss,
      spotlight: spotlight,
      onPage: onPage,
    ),
  );
}

/// Pops [item]'s explanation once, the first time this subtree is shown
/// while the item is still pending. Arms again after a Settings reset.
class WalkthroughTrigger extends ConsumerStatefulWidget {
  const WalkthroughTrigger({
    required this.item,
    required this.child,
    this.enabled = true,
    this.spotlight,
    this.onPage,
    super.key,
  });

  final WalkthroughItem item;
  final Widget child;
  final bool enabled;

  /// See [WalkthroughOverlay.spotlight] and [WalkthroughOverlay.onPage].
  final Rect? Function(int page)? spotlight;
  final ValueChanged<int?>? onPage;

  @override
  ConsumerState<WalkthroughTrigger> createState() => _WalkthroughTriggerState();
}

class _WalkthroughTriggerState extends ConsumerState<WalkthroughTrigger> {
  bool _shown = false;
  Animation<double>? _transition;

  @override
  void dispose() {
    _transition?.removeStatusListener(_onTransition);
    super.dispose();
  }

  void _show() {
    if (!mounted) return;
    showWalkthroughItem(
      context,
      widget.item,
      spotlight: widget.spotlight,
      onPage: widget.onPage,
    );
  }

  void _onTransition(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    _transition?.removeStatusListener(_onTransition);
    _transition = null;
    _show();
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(walkthroughPendingProvider(widget.item));
    if (!pending) {
      _shown = false;
    } else if (widget.enabled &&
        !_shown &&
        TickerMode.valuesOf(context).enabled) {
      _shown = true;
      // A route still sliding in would hand the spotlight a moving rect.
      final transition = ModalRoute.of(context)?.animation;
      if (transition != null && transition.status == AnimationStatus.forward) {
        _transition = transition..addStatusListener(_onTransition);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => _show());
      }
    }
    return widget.child;
  }
}
