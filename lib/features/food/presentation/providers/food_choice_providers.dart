import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';
import 'package:seed_app/shared/providers/custom_action_providers.dart';

part 'food_choice_providers.g.dart';

/// SDGs a lower-carbon food choice contributes to: 2 (zero hunger),
/// 12 (responsible consumption) and 13 (climate action) -- matching the
/// live food actions in the action library.
const kFoodChoiceSdgs = ['2', '12', '13'];

/// Banks a chosen meal as a real action (Phase 8.12): creates the
/// custom-action template, then logs it through the standard action
/// transaction (points/streak/mascot/daily summary all handled there).
/// No caps -- users are isolated (no leaderboards), so self-reported
/// inflation only affects their own stats (scoring design decision).
/// Reuses the category-agnostic customActions collection and rules that
/// the transport bridge (8.6) already established.
@riverpod
class FoodChoiceLogger extends _$FoodChoiceLogger {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Banks [co2Grams] of avoided emissions under [name]. Returns true
  /// on success. No-ops while a log is already in flight.
  Future<bool> logChoice({required String name, required int co2Grams}) async {
    if (state.isLoading) return false;
    final userId = ref.read(userIdProvider);
    if (userId == null) return false;
    state = const AsyncValue.loading();

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
              category: 'food',
              relatedSdgs: kFoodChoiceSdgs,
            ),
          );
      final logged = await ref
          .read(actionLogProvider.notifier)
          .logAction(
            template.toActionModel(),
            languageCode: ref.read(userLanguageCodeProvider),
          );
      if (logged == null) throw Exception('Action log was rejected');
    });

    if (!ref.mounted) return false;
    state = result;
    return !result.hasError;
  }
}
