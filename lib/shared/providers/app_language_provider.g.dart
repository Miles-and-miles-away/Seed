// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The OS language list; SeedApp feeds it from didChangeLocales.

@ProviderFor(OsLocales)
final osLocalesProvider = OsLocalesProvider._();

/// The OS language list; SeedApp feeds it from didChangeLocales.
final class OsLocalesProvider
    extends $NotifierProvider<OsLocales, List<Locale>> {
  /// The OS language list; SeedApp feeds it from didChangeLocales.
  OsLocalesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'osLocalesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$osLocalesHash();

  @$internal
  @override
  OsLocales create() => OsLocales();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Locale> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Locale>>(value),
    );
  }
}

String _$osLocalesHash() => r'9adcafad511deb0ce9520b097688febceb91d3c7';

/// The OS language list; SeedApp feeds it from didChangeLocales.

abstract class _$OsLocales extends $Notifier<List<Locale>> {
  List<Locale> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Locale>, List<Locale>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Locale>, List<Locale>>,
              List<Locale>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// A language pushed to the account whose echo has not arrived yet. It
/// stands in for the account's language until the echo clears it.

@ProviderFor(PendingLanguagePush)
final pendingLanguagePushProvider = PendingLanguagePushProvider._();

/// A language pushed to the account whose echo has not arrived yet. It
/// stands in for the account's language until the echo clears it.
final class PendingLanguagePushProvider
    extends $NotifierProvider<PendingLanguagePush, String?> {
  /// A language pushed to the account whose echo has not arrived yet. It
  /// stands in for the account's language until the echo clears it.
  PendingLanguagePushProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingLanguagePushProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingLanguagePushHash();

  @$internal
  @override
  PendingLanguagePush create() => PendingLanguagePush();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingLanguagePushHash() =>
    r'951bd130a4fa178905bcd5f60a7fd1d11f822185';

/// A language pushed to the account whose echo has not arrived yet. It
/// stands in for the account's language until the echo clears it.

abstract class _$PendingLanguagePush extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The Android SDK level, asked once at start; null elsewhere.

@ProviderFor(androidSdk)
final androidSdkProvider = AndroidSdkProvider._();

/// The Android SDK level, asked once at start; null elsewhere.

final class AndroidSdkProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// The Android SDK level, asked once at start; null elsewhere.
  AndroidSdkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'androidSdkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$androidSdkHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return androidSdk(ref);
  }
}

String _$androidSdkHash() => r'9a3b2772c5c1bdbd59ebc978477527973100755f';

/// This device's stored pick, its OS snapshot and the first-launch flag.

@ProviderFor(DeviceLanguage)
final deviceLanguageProvider = DeviceLanguageProvider._();

/// This device's stored pick, its OS snapshot and the first-launch flag.
final class DeviceLanguageProvider
    extends $NotifierProvider<DeviceLanguage, StoredLanguage> {
  /// This device's stored pick, its OS snapshot and the first-launch flag.
  DeviceLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceLanguageHash();

  @$internal
  @override
  DeviceLanguage create() => DeviceLanguage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoredLanguage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoredLanguage>(value),
    );
  }
}

String _$deviceLanguageHash() => r'a05833a91656e78a28b025379cd0f9a5f93f32cb';

/// This device's stored pick, its OS snapshot and the first-launch flag.

abstract class _$DeviceLanguage extends $Notifier<StoredLanguage> {
  StoredLanguage build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StoredLanguage, StoredLanguage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StoredLanguage, StoredLanguage>,
              StoredLanguage,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
