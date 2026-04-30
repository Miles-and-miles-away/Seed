// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the AnalyticsService singleton.
///
/// This provides access to analytics tracking throughout the app.

@ProviderFor(analytics)
const analyticsProvider = AnalyticsProvider._();

/// Provider for the AnalyticsService singleton.
///
/// This provides access to analytics tracking throughout the app.

final class AnalyticsProvider extends $FunctionalProvider<AnalyticsService,
    AnalyticsService, AnalyticsService> with $Provider<AnalyticsService> {
  /// Provider for the AnalyticsService singleton.
  ///
  /// This provides access to analytics tracking throughout the app.
  const AnalyticsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'analyticsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$analyticsHash();

  @$internal
  @override
  $ProviderElement<AnalyticsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsService create(Ref ref) {
    return analytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsService>(value),
    );
  }
}

String _$analyticsHash() => r'dbbddbe6495323c4571b3f685e2a3eb44f8e629b';
