import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/sdg_data.dart';

/// A horizontally scrolling carousel of SDG goal cards with infinite scroll
class SdgCarousel extends StatefulWidget {
  const SdgCarousel({
    required this.goals,
    required this.onGoalTap,
    super.key,
  });

  final List<SdgGoal> goals;
  final void Function(SdgGoal goal) onGoalTap;

  @override
  State<SdgCarousel> createState() => _SdgCarouselState();
}

class _SdgCarouselState extends State<SdgCarousel> {
  late final ScrollController _scrollController;
  static const _itemWidth = 120.0;
  static const _itemSpacing = 12.0;
  static const _totalItemWidth = _itemWidth + _itemSpacing;

  // For infinite scroll, we use a large initial offset and wrap indices
  static const _multiplier = 1000;

  @override
  void initState() {
    super.initState();
    // Start in the middle to allow scrolling in both directions
    final initialOffset = _totalItemWidth * widget.goals.length * (_multiplier ~/ 2);
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // Use a very large item count for infinite scroll effect
      itemCount: widget.goals.length * _multiplier,
      itemBuilder: (context, index) {
        // Wrap the index to get the actual goal
        final goalIndex = index % widget.goals.length;
        final goal = widget.goals[goalIndex];

        return Padding(
          padding: const EdgeInsets.only(right: _itemSpacing),
          child: SdgCard(
            goal: goal,
            onTap: () => widget.onGoalTap(goal),
          ),
        );
      },
    );
  }
}

/// A single SDG goal card showing the icon and number
class SdgCard extends StatelessWidget {
  const SdgCard({
    required this.goal,
    required this.onTap,
    super.key,
  });

  final SdgGoal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: goal.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: goal.color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SDG Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: goal.iconUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.white.withValues(alpha: 0.2),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.white.withValues(alpha: 0.2),
                  child: Center(
                    child: Text(
                      '${goal.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Goal short title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                goal.shortTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
