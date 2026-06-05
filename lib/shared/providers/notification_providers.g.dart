// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the NotificationService singleton.

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

/// Provider for the NotificationService singleton.

final class NotificationServiceProvider extends $FunctionalProvider<
    NotificationService,
    NotificationService,
    NotificationService> with $Provider<NotificationService> {
  /// Provider for the NotificationService singleton.
  NotificationServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'97ab8da2c4bf2b9340df306858ee0a49b5799c6d';

/// Provider for the FCMService singleton.

@ProviderFor(fcmService)
final fcmServiceProvider = FcmServiceProvider._();

/// Provider for the FCMService singleton.

final class FcmServiceProvider
    extends $FunctionalProvider<FCMService, FCMService, FCMService>
    with $Provider<FCMService> {
  /// Provider for the FCMService singleton.
  FcmServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fcmServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fcmServiceHash();

  @$internal
  @override
  $ProviderElement<FCMService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FCMService create(Ref ref) {
    return fcmService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FCMService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FCMService>(value),
    );
  }
}

String _$fcmServiceHash() => r'ee96047a03c23756073a596e4080dd0c835cda88';

/// Provider that manages notification scheduling based on user settings.
///
/// This watches user settings and reschedules notifications when they change.

@ProviderFor(NotificationScheduler)
final notificationSchedulerProvider = NotificationSchedulerProvider._();

/// Provider that manages notification scheduling based on user settings.
///
/// This watches user settings and reschedules notifications when they change.
final class NotificationSchedulerProvider
    extends $AsyncNotifierProvider<NotificationScheduler, void> {
  /// Provider that manages notification scheduling based on user settings.
  ///
  /// This watches user settings and reschedules notifications when they change.
  NotificationSchedulerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationSchedulerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationSchedulerHash();

  @$internal
  @override
  NotificationScheduler create() => NotificationScheduler();
}

String _$notificationSchedulerHash() =>
    r'402ddf162b7c55fe6193167e23f2405905f51bf4';

/// Provider that manages notification scheduling based on user settings.
///
/// This watches user settings and reschedules notifications when they change.

abstract class _$NotificationScheduler extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider that checks if smart reminder should fire.
///
/// Returns true if the user hasn't logged an action today.

@ProviderFor(shouldShowSmartReminder)
final shouldShowSmartReminderProvider = ShouldShowSmartReminderProvider._();

/// Provider that checks if smart reminder should fire.
///
/// Returns true if the user hasn't logged an action today.

final class ShouldShowSmartReminderProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider that checks if smart reminder should fire.
  ///
  /// Returns true if the user hasn't logged an action today.
  ShouldShowSmartReminderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'shouldShowSmartReminderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$shouldShowSmartReminderHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return shouldShowSmartReminder(ref);
  }
}

String _$shouldShowSmartReminderHash() =>
    r'e7818900a2080302d173491cf07198e17b9a1033';

/// Provider that handles FCM token registration.
///
/// Watches auth state and updates FCM token when user logs in.

@ProviderFor(FCMTokenManager)
final fCMTokenManagerProvider = FCMTokenManagerProvider._();

/// Provider that handles FCM token registration.
///
/// Watches auth state and updates FCM token when user logs in.
final class FCMTokenManagerProvider
    extends $AsyncNotifierProvider<FCMTokenManager, void> {
  /// Provider that handles FCM token registration.
  ///
  /// Watches auth state and updates FCM token when user logs in.
  FCMTokenManagerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fCMTokenManagerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fCMTokenManagerHash();

  @$internal
  @override
  FCMTokenManager create() => FCMTokenManager();
}

String _$fCMTokenManagerHash() => r'343f4f2c8343193aabc8ab4945fe0b9dacb74bf7';

/// Provider that handles FCM token registration.
///
/// Watches auth state and updates FCM token when user logs in.

abstract class _$FCMTokenManager extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Provider for checking notification permission status.

@ProviderFor(notificationPermissionStatus)
final notificationPermissionStatusProvider =
    NotificationPermissionStatusProvider._();

/// Provider for checking notification permission status.

final class NotificationPermissionStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for checking notification permission status.
  NotificationPermissionStatusProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationPermissionStatusProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationPermissionStatusHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return notificationPermissionStatus(ref);
  }
}

String _$notificationPermissionStatusHash() =>
    r'aa226bbd772fe41a196eeaadf5752f87f985151d';

/// Provider for FCM authorization status.

@ProviderFor(fcmAuthorizationStatus)
final fcmAuthorizationStatusProvider = FcmAuthorizationStatusProvider._();

/// Provider for FCM authorization status.

final class FcmAuthorizationStatusProvider extends $FunctionalProvider<
        AsyncValue<AuthorizationStatus>,
        AuthorizationStatus,
        FutureOr<AuthorizationStatus>>
    with
        $FutureModifier<AuthorizationStatus>,
        $FutureProvider<AuthorizationStatus> {
  /// Provider for FCM authorization status.
  FcmAuthorizationStatusProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'fcmAuthorizationStatusProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fcmAuthorizationStatusHash();

  @$internal
  @override
  $FutureProviderElement<AuthorizationStatus> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AuthorizationStatus> create(Ref ref) {
    return fcmAuthorizationStatus(ref);
  }
}

String _$fcmAuthorizationStatusHash() =>
    r'7de9b5640453644d977a29d211602c12624f15c4';
