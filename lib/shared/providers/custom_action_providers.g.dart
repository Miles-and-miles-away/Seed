// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_action_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository for banking user-created calculator actions (Phase 8).
/// Shared by every calculator's choice logger (transport, food).

@ProviderFor(customActionRepository)
final customActionRepositoryProvider = CustomActionRepositoryProvider._();

/// Repository for banking user-created calculator actions (Phase 8).
/// Shared by every calculator's choice logger (transport, food).

final class CustomActionRepositoryProvider
    extends
        $FunctionalProvider<
          CustomActionRepository,
          CustomActionRepository,
          CustomActionRepository
        >
    with $Provider<CustomActionRepository> {
  /// Repository for banking user-created calculator actions (Phase 8).
  /// Shared by every calculator's choice logger (transport, food).
  CustomActionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customActionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customActionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomActionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomActionRepository create(Ref ref) {
    return customActionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomActionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomActionRepository>(value),
    );
  }
}

String _$customActionRepositoryHash() =>
    r'e24bc64d43ee8776757ac60a7c4e990ddfea80b7';
