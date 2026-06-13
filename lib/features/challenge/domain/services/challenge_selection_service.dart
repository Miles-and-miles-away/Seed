import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';

/// 32-bit FNV-1a over the seed key. String.hashCode is not guaranteed
/// stable across platforms or SDK versions, which would let "today's
/// challenge" change mid-day after an app update.
int _fnv1a(String input) {
  var hash = 0x811c9dc5;
  for (final unit in input.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash;
}

/// Deterministic seed from userId + date.
int dailySeed(String userId, DateTime date) {
  final key = '$userId:${date.year}-${date.month}-${date.day}';
  return _fnv1a(key);
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
