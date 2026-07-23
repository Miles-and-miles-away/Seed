// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_choice_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Banks a chosen transport option as a real action (Phase 8.6):
/// creates the custom-action template, then logs it through the
/// standard action transaction (points/streak/mascot/daily summary
/// all handled there). No caps -- users are isolated (no
/// leaderboards), so self-reported inflation only affects their own
/// stats (scoring design decision).

@ProviderFor(TransportChoiceLogger)
final transportChoiceLoggerProvider = TransportChoiceLoggerProvider._();

/// Banks a chosen transport option as a real action (Phase 8.6):
/// creates the custom-action template, then logs it through the
/// standard action transaction (points/streak/mascot/daily summary
/// all handled there). No caps -- users are isolated (no
/// leaderboards), so self-reported inflation only affects their own
/// stats (scoring design decision).
final class TransportChoiceLoggerProvider
    extends $NotifierProvider<TransportChoiceLogger, AsyncValue<void>> {
  /// Banks a chosen transport option as a real action (Phase 8.6):
  /// creates the custom-action template, then logs it through the
  /// standard action transaction (points/streak/mascot/daily summary
  /// all handled there). No caps -- users are isolated (no
  /// leaderboards), so self-reported inflation only affects their own
  /// stats (scoring design decision).
  TransportChoiceLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportChoiceLoggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportChoiceLoggerHash();

  @$internal
  @override
  TransportChoiceLogger create() => TransportChoiceLogger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$transportChoiceLoggerHash() =>
    r'9a9a94beab1216affb2292d2dc3873fac5261d57';

/// Banks a chosen transport option as a real action (Phase 8.6):
/// creates the custom-action template, then logs it through the
/// standard action transaction (points/streak/mascot/daily summary
/// all handled there). No caps -- users are isolated (no
/// leaderboards), so self-reported inflation only affects their own
/// stats (scoring design decision).

abstract class _$TransportChoiceLogger extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
