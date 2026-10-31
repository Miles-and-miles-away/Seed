// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps this device's language and the account's in step, and Firebase
/// Auth emails in the app language.

@ProviderFor(LanguageSync)
final languageSyncProvider = LanguageSyncProvider._();

/// Keeps this device's language and the account's in step, and Firebase
/// Auth emails in the app language.
final class LanguageSyncProvider extends $NotifierProvider<LanguageSync, void> {
  /// Keeps this device's language and the account's in step, and Firebase
  /// Auth emails in the app language.
  LanguageSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'languageSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$languageSyncHash();

  @$internal
  @override
  LanguageSync create() => LanguageSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$languageSyncHash() => r'e58974bf6518ca074187029412d54b7547a1d361';

/// Keeps this device's language and the account's in step, and Firebase
/// Auth emails in the app language.

abstract class _$LanguageSync extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
