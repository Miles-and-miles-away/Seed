import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/domain/bank_choice.dart';

part 'food_choice_providers.g.dart';

/// SDGs a lower-carbon food choice contributes to: 2 (zero hunger),
/// 12 (responsible consumption) and 13 (climate action) -- matching the
/// live food actions in the action library.
const kFoodChoiceSdgs = ['2', '12', '13'];

/// Banks a chosen meal as a real action (Phase 8.12). Reuses the
/// category-agnostic customActions collection and rules that the
/// transport bridge (8.6) already established.
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

    final result = await bankChoice(
      ref,
      userId: userId,
      name: name,
      co2Grams: co2Grams,
      category: 'food',
      relatedSdgs: kFoodChoiceSdgs,
    );
    if (result == null) return false;
    state = result;
    return !result.hasError;
  }
}
