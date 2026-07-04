import 'dart:math';
import '../constants/app_constants.dart';

/// Calculate level from total points
/// Uses scaling formula: each level requires more points than the last
int calculateLevel(int totalPoints) {
  if (totalPoints <= 0) return 1;

  var level = 1;
  var pointsNeeded = 0;

  while (pointsNeeded <= totalPoints) {
    level++;
    pointsNeeded = calculatePointsForLevel(level);
  }

  return level - 1;
}

/// Calculate total points needed to reach a specific level
int calculatePointsForLevel(int level) {
  if (level <= 1) return 0;

  final base = AppConstants.pointsPerLevel.toDouble();
  final scale = AppConstants.levelScalingFactor;

  // Sum of geometric series
  double total = 0;
  for (var i = 1; i < level; i++) {
    total += base * pow(scale, i - 1);
  }

  return total.round();
}

/// Calculate points remaining to next level
int calculatePointsToNextLevel(int totalPoints) {
  final currentLevel = calculateLevel(totalPoints);
  final pointsForNext = calculatePointsForLevel(currentLevel + 1);
  return pointsForNext - totalPoints;
}

/// Calculate progress percentage to next level (0.0 to 1.0)
double calculateLevelProgress(int totalPoints) {
  final currentLevel = calculateLevel(totalPoints);
  final pointsForCurrent = calculatePointsForLevel(currentLevel);
  final pointsForNext = calculatePointsForLevel(currentLevel + 1);

  final progressPoints = totalPoints - pointsForCurrent;
  final levelRange = pointsForNext - pointsForCurrent;

  if (levelRange <= 0) return 1;

  return (progressPoints / levelRange).clamp(0.0, 1.0);
}

/// Format CO2 amount in compact form (e.g., "3.4t", "1.2kg", "500g")
String formatCO2Compact(int grams) {
  if (grams >= 1000000) {
    return '${(grams / 1000000).toStringAsFixed(1)}t';
  }
  if (grams >= 1000) {
    return '${(grams / 1000).toStringAsFixed(1)}kg';
  }
  return '${grams}g';
}

/// Format points with suffix
String formatPoints(int points) {
  if (points >= 1000000) {
    return '${(points / 1000000).toStringAsFixed(1)}M';
  }
  if (points >= 1000) {
    return '${(points / 1000).toStringAsFixed(1)}K';
  }
  return points.toString();
}
