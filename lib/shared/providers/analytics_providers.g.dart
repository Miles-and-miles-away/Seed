// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App analytics service. Overridable in tests to avoid touching Firebase.

@ProviderFor(analyticsService)
final analyticsServiceProvider = AnalyticsServiceProvider._();

/// App analytics service. Overridable in tests to avoid touching Firebase.

final class AnalyticsServiceProvider
    extends
        $FunctionalProvider<
          AnalyticsService,
          AnalyticsService,
          AnalyticsService
        >
    with $Provider<AnalyticsService> {
  /// App analytics service. Overridable in tests to avoid touching Firebase.
  AnalyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsServiceHash();

  @$internal
  @override
  $ProviderElement<AnalyticsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsService create(Ref ref) {
    return analyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsService>(value),
    );
  }
}

String _$analyticsServiceHash() => r'b5a814e5f3e823ec88eb833b119cc21a2c031fcd';

/// Firebase Crashlytics. Overridable in tests to avoid touching Firebase.

@ProviderFor(crashlytics)
final crashlyticsProvider = CrashlyticsProvider._();

/// Firebase Crashlytics. Overridable in tests to avoid touching Firebase.

final class CrashlyticsProvider
    extends
        $FunctionalProvider<
          FirebaseCrashlytics,
          FirebaseCrashlytics,
          FirebaseCrashlytics
        >
    with $Provider<FirebaseCrashlytics> {
  /// Firebase Crashlytics. Overridable in tests to avoid touching Firebase.
  CrashlyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crashlyticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crashlyticsHash();

  @$internal
  @override
  $ProviderElement<FirebaseCrashlytics> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseCrashlytics create(Ref ref) {
    return crashlytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseCrashlytics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseCrashlytics>(value),
    );
  }
}

String _$crashlyticsHash() => r'155108b0d2e2c244304ed72e1be15318f2f933c5';
