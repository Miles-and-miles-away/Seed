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

/// Calculate streak bonus multiplier
double calculateStreakBonus(int streakDays) {
  if (streakDays <= 0) return 1;

  final bonus =
      1.0 + (streakDays * AppConstants.streakBonusPerDay);
  return min(bonus, AppConstants.maxStreakBonus);
}

/// Get mascot evolution stage based on level
int getEvolutionStage(int level) {
  if (level >= AppConstants.evolutionStage4Level) return 4;
  if (level >= AppConstants.evolutionStage3Level) return 3;
  if (level >= AppConstants.evolutionStage2Level) return 2;
  return 1;
}

/// Format CO2 amount for display (full format with CO₂ suffix)
String formatCO2(int grams) {
  if (grams >= 1000) {
    final kg = grams / 1000;
    return '${kg.toStringAsFixed(1)} kg CO₂';
  }
  return '$grams g CO₂';
}

/// Format CO2 amount in compact form (e.g., "1.2kg" or "500g")
String formatCO2Compact(int grams) {
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
