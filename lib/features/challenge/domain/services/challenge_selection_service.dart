import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';

/// Deterministic seed from userId + date.
int dailySeed(String userId, DateTime date) {
  final key = '$userId:${date.year}-${date.month}-${date.day}';
  return key.hashCode;
}

/// Selects today's challenge template, excluding recently
/// used IDs to provide variety.
DailyChallengeTemplate selectDailyChallenge(
  String userId,
  DateTime date,
  List<String> recentIds,
  List<DailyChallengeTemplate> templates,
) {
  final recentSet =
      recentIds.take(AppConstants.recentChallengeIdsLimit).toSet();

  var candidates = templates.where((t) => !recentSet.contains(t.id)).toList();

  // If all excluded, reset to full list
  if (candidates.isEmpty) {
    candidates = templates.toList();
  }

  final seed = dailySeed(userId, date);
  final index = seed.abs() % candidates.length;
  return candidates[index];
}
