import 'package:flutter/material.dart';

import '../../data/sdg_data.dart';

/// Tappable SDG infographic thumbnail that expands
/// to a full-screen zoomable view with Hero animation.
class SdgInfographicViewer extends StatelessWidget {
  const SdgInfographicViewer({
    required this.goal,
    this.locale = 'en',
    super.key,
  });

  final SdgGoal goal;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.insert_chart_outlined,
              color: goal.color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'UN Infographic',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showFullScreen(context),
          child: Hero(
            tag: 'sdg_infographic_${goal.number}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                goal.infographicAsset,
                width: double.infinity,
                fit: BoxFit.cover,
                height: 280,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => _FullScreenInfographic(
          goal: goal,
          locale: locale,
        ),
      ),
    );
  }
}

class _FullScreenInfographic extends StatelessWidget {
  const _FullScreenInfographic({
    required this.goal,
    required this.locale,
  });

  final SdgGoal goal;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final animation = ModalRoute.of(context)!.animation!;

    final bounceScale = ConstantTween<double>(1).animate(animation);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Goal ${goal.number}: '
          '${goal.getShortTitle(locale)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: AnimatedBuilder(
            animation: bounceScale,
            builder: (context, child) => Transform.scale(
              scale: bounceScale.value,
              child: child,
            ),
            child: Hero(
              tag: 'sdg_infographic_'
                  '${goal.number}',
              child: Image.asset(
                goal.infographicAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
