import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';
import 'package:seed_app/shared/providers/custom_action_providers.dart';

const _templateTimeout = Duration(seconds: 5);

/// Banks [co2Grams] of avoided emissions under [name] as a real action
/// (Phase 8.6 transport, 8.12 food): creates the custom-action
/// template, then logs it through the standard action transaction
/// (points/streak/mascot/daily summary all handled there).
///
/// No caps -- users are isolated (no leaderboards), so self-reported
/// inflation only affects their own stats (scoring design decision).
///
/// The calling notifier must be keepAlive, so a user who leaves the
/// calculator mid-write still gets the action logged.
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
  required Iterable<String> chosenIds,
  required Iterable<String> baselineIds,
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
        )
        .timeout(_templateTimeout);
    final logged = await ref
        .read(actionLogProvider.notifier)
        .logAction(
          template.toActionModel(),
          languageCode: ref.read(userLanguageCodeProvider),
          uniqueKey: bankUniqueKey(category, chosenIds, baselineIds),
        );
    if (logged == null) _throwLogFailure(ref.read(actionLogProvider));
  });

  return ref.mounted ? result : null;
}

/// One unique-action id per kind of choice (category and the mode or
/// food ids on each side), so repeat banks of one kind count once.
String bankUniqueKey(
  String category,
  Iterable<String> chosenIds,
  Iterable<String> baselineIds,
) {
  String ids(Iterable<String> v) => (v.toSet().toList()..sort()).join('+');
  return 'bank:$category:${ids(chosenIds)}>${ids(baselineIds)}';
}

/// Rethrows the action-log failure so the UI can tell offline and rate
/// limits apart from other errors.
Never _throwLogFailure(AsyncValue<ActionLogResult?> logState) {
  final error = logState.error;
  if (error == null) throw StateError('Action log was not written');
  Error.throwWithStackTrace(error, logState.stackTrace ?? StackTrace.current);
}
