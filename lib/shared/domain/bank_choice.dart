import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';
import 'package:seed_app/shared/providers/custom_action_providers.dart';

/// Banks [co2Grams] of avoided emissions under [name] as a real action
/// (Phase 8.6 transport, 8.12 food): creates the custom-action
/// template, then logs it through the standard action transaction
/// (points/streak/mascot/daily summary all handled there).
///
/// No caps -- users are isolated (no leaderboards), so self-reported
/// inflation only affects their own stats (scoring design decision).
///
/// Returns the resulting state, or null when the calling notifier was
/// disposed mid-flight; a null return must not be written to `state`.
Future<AsyncValue<void>?> bankChoice(
  Ref ref, {
  required String userId,
  required String name,
  required int co2Grams,
  required String category,
  required List<String> relatedSdgs,
}) async {
  final result = await AsyncValue.guard(() async {
    final template = await ref
        .read(customActionRepositoryProvider)
        .create(
          userId,
          CustomAction(
            id: '',
            name: name,
            co2Grams: co2Grams,
            points: choicePoints(co2Grams),
            category: category,
            relatedSdgs: relatedSdgs,
          ),
        );
    if (!ref.mounted) return;
    final logged = await ref
        .read(actionLogProvider.notifier)
        .logAction(
          template.toActionModel(),
          languageCode: ref.read(userLanguageCodeProvider),
        );
    if (logged == null) throw Exception('Action log was rejected');
  });

  return ref.mounted ? result : null;
}
