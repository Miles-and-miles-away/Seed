import 'package:seed_app/core/constants/app_constants.dart';

/// Typed data for an active multi-day challenge.
class ActiveMultiDayChallenge {
  const ActiveMultiDayChallenge({
    required this.templateId,
    required this.currentDay,
    required this.targetDays,
    required this.lastCompletionDate,
  });

  final String templateId;
  final int currentDay;
  final int targetDays;
  final String lastCompletionDate;

  /// Fraction of [targetDays] reached by [currentDay], clamped to 0..1.
  static double progress(int currentDay, int targetDays) =>
      targetDays > 0 ? (currentDay / targetDays).clamp(0.0, 1.0) : 0.0;

  static ActiveMultiDayChallenge? fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return null;
    final templateId = map[AppConstants.fieldTemplateId] as String?;
    if (templateId == null || templateId.isEmpty) {
      return null;
    }
    return ActiveMultiDayChallenge(
      templateId: templateId,
      currentDay: (map[AppConstants.fieldCurrentDay] as num?)?.toInt() ?? 0,
      targetDays: (map[AppConstants.fieldTargetDays] as num?)?.toInt() ?? 0,
      lastCompletionDate:
          (map[AppConstants.fieldLastCompletionDate] as String?) ?? '',
    );
  }
}
