import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/reduce_motion.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';
import 'package:seed_app/shared/services/streak_service.dart';

const _tailSize = Size(18, 9);
const _maxBubbleWidth = 280.0;

const _greetingStay = Duration(seconds: 4);

/// The mascot's speech: a rounded card with a tail that points up at the
/// mascot below it, or down at the mascot above it.
class SpeechBubble extends StatelessWidget {
  const SpeechBubble({
    required this.text,
    this.title,
    this.pointsUp = false,
    super.key,
  });

  final String text;
  final String? title;
  final bool pointsUp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.surface;
    final tail = CustomPaint(
      size: _tailSize,
      painter: _TailPainter(color: color, pointsUp: pointsUp),
    );
    final title = this.title;
    return Semantics(
      liveRegion: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxBubbleWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pointsUp) tail,
            DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: borderRadiusLg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: opacitySubtle),
                    blurRadius: spacingSm,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacingMd,
                  vertical: spacingSm,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!pointsUp) tail,
          ],
        ),
      ),
    );
  }
}

class _TailPainter extends CustomPainter {
  const _TailPainter({required this.color, required this.pointsUp});

  final Color color;
  final bool pointsUp;

  @override
  void paint(Canvas canvas, Size size) {
    final tip = pointsUp ? 0.0 : size.height;
    final base = size.height - tip;
    canvas.drawPath(
      Path()
        ..moveTo(0, base)
        ..lineTo(size.width / 2, tip)
        ..lineTo(size.width, base)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_TailPainter old) =>
      old.color != color || old.pointsUp != pointsUp;
}

/// Shows the daily greeting over [child] (the content under Home's
/// mascot) while it plays, and hides [child] for that time.
class MascotGreetingBubble extends ConsumerStatefulWidget {
  const MascotGreetingBubble({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MascotGreetingBubble> createState() =>
      _MascotGreetingBubbleState();
}

class _MascotGreetingBubbleState extends ConsumerState<MascotGreetingBubble> {
  bool _showing = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _show() {
    _timer?.cancel();
    setState(() => _showing = true);
    _timer = Timer(_greetingStay, () {
      if (mounted) setState(() => _showing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(dailyGreetedProvider, (_, day) {
      if (day != null) _show();
    });
    final duration = reduceMotionOf(context) ? Duration.zero : durationMedium;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: double.infinity,
          child: AnimatedOpacity(
            opacity: _showing ? 0 : 1,
            duration: duration,
            child: widget.child,
          ),
        ),
        AnimatedSwitcher(
          duration: duration,
          child: _showing ? _bubble(context) : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _bubble(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.read(currentUserProvider).value;
    final streak = displayedStreak(
      storedStreak: user?.currentStreak ?? 0,
      lastActionDate: user?.lastActionDate,
      lastActionUtcOffsetMinutes: user?.lastActionUtcOffsetMinutes,
      now: ref.read(clockProvider)(),
    );
    return SpeechBubble(
      key: const ValueKey('greeting'),
      title: l10n.mascotGreetingWelcome,
      text: streak > 0
          ? l10n.mascotGreetingStreak(streak)
          : l10n.mascotGreetingNoStreak,
      pointsUp: true,
    );
  }
}
