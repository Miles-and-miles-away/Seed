// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_change_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks the current date and invalidates day-sensitive providers
/// when the date changes (at midnight or on app resume).
///
/// Must be keepAlive: it is bootstrapped by a single `ref.read` in
/// MainShell's initState with no listeners, so an autoDispose provider
/// would be disposed immediately and the midnight timer would never fire.

@ProviderFor(DayChangeNotifier)
final dayChangeProvider = DayChangeNotifierProvider._();

/// Tracks the current date and invalidates day-sensitive providers
/// when the date changes (at midnight or on app resume).
///
/// Must be keepAlive: it is bootstrapped by a single `ref.read` in
/// MainShell's initState with no listeners, so an autoDispose provider
/// would be disposed immediately and the midnight timer would never fire.
final class DayChangeNotifierProvider
    extends $NotifierProvider<DayChangeNotifier, String> {
  /// Tracks the current date and invalidates day-sensitive providers
  /// when the date changes (at midnight or on app resume).
  ///
  /// Must be keepAlive: it is bootstrapped by a single `ref.read` in
  /// MainShell's initState with no listeners, so an autoDispose provider
  /// would be disposed immediately and the midnight timer would never fire.
  DayChangeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dayChangeProvider',
          isAutoDispose: false,
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

String _$dayChangeNotifierHash() => r'af21dba9de1cf553bbd57cd04262c8e9b61ffb60';

/// Tracks the current date and invalidates day-sensitive providers
/// when the date changes (at midnight or on app resume).
///
/// Must be keepAlive: it is bootstrapped by a single `ref.read` in
/// MainShell's initState with no listeners, so an autoDispose provider
/// would be disposed immediately and the midnight timer would never fire.

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
