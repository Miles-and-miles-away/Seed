import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';

/// A horizontally scrolling carousel of SDG goal
/// cards with infinite scroll.
class SdgCarousel extends StatefulWidget {
  const SdgCarousel({
    required this.goals,
    required this.onGoalTap,
    this.locale = 'en',
    super.key,
  });

  final List<SdgGoal> goals;
  final void Function(SdgGoal goal) onGoalTap;
  final String locale;

  @override
  State<SdgCarousel> createState() => _SdgCarouselState();
}

class _SdgCarouselState extends State<SdgCarousel> {
  // Created lazily once goals are loaded and the viewport width is known so
  // the centered index resolves to goal 1 rather than the empty loading list.
  ScrollController? _scrollController;
  static const _itemWidth = 120.0;
  static const _itemSpacing = 12.0;
  static const _totalItemWidth = _itemWidth + _itemSpacing;
  static const _multiplier = 1000;

  /// Scroll offset that centers the first goal in the viewport, starting from
  /// the middle of the virtual (infinitely repeating) list.
  double _initialOffset(double viewportWidth) {
    final centerIndex = widget.goals.length * (_multiplier ~/ 2);
    return spacingXxl +
        centerIndex * _totalItemWidth +
        _itemWidth / 2 -
        viewportWidth / 2;
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.goals.isNotEmpty) {
          _scrollController ??= ScrollController(
            initialScrollOffset: _initialOffset(constraints.maxWidth),
          );
        }
        return _buildList();
      },
    );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: spacingXxl,
      ),
      itemCount: widget.goals.length * _multiplier,
      itemBuilder: (context, index) {
        final goalIndex = index % widget.goals.length;
        final goal = widget.goals[goalIndex];

        return Padding(
          padding: const EdgeInsets.only(
            right: _itemSpacing,
          ),
          child: SdgCard(
            goal: goal,
            locale: widget.locale,
            onTap: () => widget.onGoalTap(goal),
          ),
        );
      },
    );
  }
}

/// A single SDG goal card showing icon and number.
class SdgCard extends StatelessWidget {
  const SdgCard({
    required this.goal,
    required this.onTap,
    this.locale = 'en',
    super.key,
  });

  final SdgGoal goal;
  final VoidCallback onTap;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: goal.color,
          borderRadius: borderRadiusLg,
          boxShadow: [
            BoxShadow(
              color: goal.color.withValues(
                alpha: opacityMedium,
              ),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: borderRadiusSm,
              child: CachedNetworkImage(
                imageUrl: goal.iconUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.white.withValues(
                    alpha: opacityLight,
                  ),
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
                  color: Colors.white.withValues(
                    alpha: opacityLight,
                  ),
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
            const SizedBox(height: spacingSm),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: spacingSm,
              ),
              child: Text(
                goal.shortTitle(locale),
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
