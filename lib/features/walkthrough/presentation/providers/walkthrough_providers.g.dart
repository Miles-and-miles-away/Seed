// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walkthrough_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether [item] still shimmers and pops. Nothing is pending until the
/// mascot exists and its celebrations are done (the character does the
/// talking), and no checklist item is pending before the intro.

@ProviderFor(walkthroughPending)
final walkthroughPendingProvider = WalkthroughPendingFamily._();

/// Whether [item] still shimmers and pops. Nothing is pending until the
/// mascot exists and its celebrations are done (the character does the
/// talking), and no checklist item is pending before the intro.

final class WalkthroughPendingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether [item] still shimmers and pops. Nothing is pending until the
  /// mascot exists and its celebrations are done (the character does the
  /// talking), and no checklist item is pending before the intro.
  WalkthroughPendingProvider._({
    required WalkthroughPendingFamily super.from,
    required WalkthroughItem super.argument,
  }) : super(
         retry: null,
         name: r'walkthroughPendingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$walkthroughPendingHash();

  @override
  String toString() {
    return r'walkthroughPendingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as WalkthroughItem;
    return walkthroughPending(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WalkthroughPendingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$walkthroughPendingHash() =>
    r'16b0cb676d0de53958c5f927e5631405dc413ec6';

/// Whether [item] still shimmers and pops. Nothing is pending until the
/// mascot exists and its celebrations are done (the character does the
/// talking), and no checklist item is pending before the intro.

final class WalkthroughPendingFamily extends $Family
    with $FunctionalFamilyOverride<bool, WalkthroughItem> {
  WalkthroughPendingFamily._()
    : super(
        retry: null,
        name: r'walkthroughPendingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether [item] still shimmers and pops. Nothing is pending until the
  /// mascot exists and its celebrations are done (the character does the
  /// talking), and no checklist item is pending before the intro.

  WalkthroughPendingProvider call(WalkthroughItem item) =>
      WalkthroughPendingProvider._(argument: item, from: this);

  @override
  String toString() => r'walkthroughPendingProvider';
}
