import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import '../providers/walkthrough_providers.dart';
import '../walkthrough_items.dart';

const _sweepGap = Duration(seconds: 1);
const _sweepDuration = Duration(seconds: 1);

/// Sweeps gold over [child] until [item] is found, then returns [child]
/// untouched. The controller only runs during a sweep and sits idle for
/// the gap, so no frames are requested in between.
class WalkthroughShimmer extends ConsumerWidget {
  const WalkthroughShimmer({
    required this.item,
    required this.child,
    super.key,
  });

  final WalkthroughItem item;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(walkthroughPendingProvider(item))) return child;

    if (MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.reduceMotionOf(context)) {
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: _border,
        child: child,
      );
    }

    return _Sweep(child: child);
  }
}

final _border = BoxDecoration(
  border: Border.all(color: AppColors.gold, width: 2),
  borderRadius: borderRadiusMd,
);

class _Sweep extends StatefulWidget {
  const _Sweep({required this.child});

  final Widget child;

  @override
  State<_Sweep> createState() => _SweepState();
}

class _SweepState extends State<_Sweep> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _rest;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _sweepDuration)
      ..addStatusListener((status) {
        if (status != AnimationStatus.completed) return;
        _rest = Timer(_sweepGap, () {
          if (mounted) _controller.forward(from: 0);
        });
      })
      ..forward();
  }

  @override
  void dispose() {
    _rest?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.child
          .animate(controller: _controller, autoPlay: false)
          .shimmer(
            duration: _sweepDuration,
            color: AppColors.gold.withValues(alpha: opacityModerate),
          ),
    );
  }
}
