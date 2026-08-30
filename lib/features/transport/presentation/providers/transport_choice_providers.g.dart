// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_choice_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Banks a chosen transport option as a real action (Phase 8.6).

@ProviderFor(TransportChoiceLogger)
final transportChoiceLoggerProvider = TransportChoiceLoggerProvider._();

/// Banks a chosen transport option as a real action (Phase 8.6).
final class TransportChoiceLoggerProvider
    extends $NotifierProvider<TransportChoiceLogger, AsyncValue<void>> {
  /// Banks a chosen transport option as a real action (Phase 8.6).
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
    r'eafc1a8cc874ea8cef8e06c964e2e6dff0114d23';

/// Banks a chosen transport option as a real action (Phase 8.6).

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
