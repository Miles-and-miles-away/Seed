import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';
import 'package:seed_app/shared/providers/custom_action_providers.dart';

part 'transport_choice_providers.g.dart';

/// SDGs a low-carbon transport choice contributes to: 11 (sustainable
/// cities) and 13 (climate action).
const kTransportChoiceSdgs = ['11', '13'];

/// Banks a chosen transport option as a real action (Phase 8.6):
/// creates the custom-action template, then logs it through the
/// standard action transaction (points/streak/mascot/daily summary
/// all handled there). No caps -- users are isolated (no
/// leaderboards), so self-reported inflation only affects their own
/// stats (scoring design decision).
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
              category: 'transport',
              relatedSdgs: kTransportChoiceSdgs,
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

    if (!ref.mounted) return false;
    state = result;
    return !result.hasError;
  }
}
