// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_change_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks the current date and invalidates day-sensitive providers
/// when the date changes (at midnight or on app resume).

@ProviderFor(DayChangeNotifier)
final dayChangeProvider = DayChangeNotifierProvider._();

/// Tracks the current date and invalidates day-sensitive providers
/// when the date changes (at midnight or on app resume).
final class DayChangeNotifierProvider
    extends $NotifierProvider<DayChangeNotifier, String> {
  /// Tracks the current date and invalidates day-sensitive providers
  /// when the date changes (at midnight or on app resume).
  DayChangeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dayChangeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dayChangeNotifierHash();

  @$internal
  @override
  DayChangeNotifier create() => DayChangeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$dayChangeNotifierHash() => r'16c8779e26b99d9c2a204560702165508942d340';

/// Tracks the current date and invalidates day-sensitive providers
/// when the date changes (at midnight or on app resume).

abstract class _$DayChangeNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
