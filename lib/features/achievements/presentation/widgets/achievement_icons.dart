import 'package:flutter/material.dart';

/// Resolves the `iconName` string stored in `data/app/achievements.json`
/// to a Material `IconData`. Falls back to a generic trophy when the
/// name is unrecognized so a typo never crashes the badge widget.
IconData achievementIconFor(String iconName) {
  return switch (iconName) {
    'rocket_launch' => Icons.rocket_launch,
    'emoji_events' => Icons.emoji_events,
    'trending_up' => Icons.trending_up,
    'military_tech' => Icons.military_tech,
    'workspace_premium' => Icons.workspace_premium,
    'explore' => Icons.explore,
    'flare' => Icons.flare,
    'local_fire_department' => Icons.local_fire_department,
    'whatshot' => Icons.whatshot,
    'bolt' => Icons.bolt,
    'auto_awesome' => Icons.auto_awesome,
    'star_outline' => Icons.star_outline,
    'star' => Icons.star,
    'stars' => Icons.stars,
    'public' => Icons.public,
    'travel_explore' => Icons.travel_explore,
    'co2' => Icons.co2,
    'forest' => Icons.forest,
    'eco' => Icons.eco,
    _ => Icons.emoji_events,
  };
}
