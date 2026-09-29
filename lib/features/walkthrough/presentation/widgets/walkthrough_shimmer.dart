import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import '../providers/walkthrough_providers.dart';
import '../walkthrough_items.dart';

const _sweepGap = Duration(seconds: 2);
const _sweepDuration = Duration(milliseconds: 1500);

/// Sweeps a gold highlight over [child] until [item] is found, then
/// returns [child] untouched. The sweep pauses between passes so the
/// anchor's own colours stay visible.
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
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gold, width: 2),
          borderRadius: borderRadiusMd,
        ),
        child: child,
      );
    }

    return RepaintBoundary(
      child: Animate(
        onPlay: (controller) => controller.repeat(),
        effects: [
          ShimmerEffect(
            delay: _sweepGap,
            duration: _sweepDuration,
            color: AppColors.gold.withValues(alpha: opacityModerate),
          ),
        ],
        child: child,
      ),
    );
  }
}
