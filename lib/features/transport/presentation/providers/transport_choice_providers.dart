import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/domain/bank_choice.dart';

part 'transport_choice_providers.g.dart';

/// SDGs a low-carbon transport choice contributes to: 11 (sustainable
/// cities) and 13 (climate action).
const kTransportChoiceSdgs = ['11', '13'];

/// Banks a chosen transport option as a real action (Phase 8.6).
@riverpod
class TransportChoiceLogger extends _$TransportChoiceLogger {
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
      category: 'transport',
      relatedSdgs: kTransportChoiceSdgs,
    );
    if (result == null) return false;
    state = result;
    return !result.hasError;
  }
}
