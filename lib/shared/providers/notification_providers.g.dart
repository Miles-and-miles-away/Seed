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

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
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
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

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

/// Keeps the pending reminders in step with the settings, today's
/// challenge and logs, and the app language. Kept alive from SeedApp,
/// and rebuilt on resume in case the time zone changed.
///
/// The daily challenge reminders come first; action reminders fill what
/// is left of the OS limit, soonest first.

@ProviderFor(reminderScheduler)
final reminderSchedulerProvider = ReminderSchedulerProvider._();

/// Keeps the pending reminders in step with the settings, today's
/// challenge and logs, and the app language. Kept alive from SeedApp,
/// and rebuilt on resume in case the time zone changed.
///
/// The daily challenge reminders come first; action reminders fill what
/// is left of the OS limit, soonest first.

final class ReminderSchedulerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Keeps the pending reminders in step with the settings, today's
  /// challenge and logs, and the app language. Kept alive from SeedApp,
  /// and rebuilt on resume in case the time zone changed.
  ///
  /// The daily challenge reminders come first; action reminders fill what
  /// is left of the OS limit, soonest first.
  ReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulerHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return reminderScheduler(ref);
  }
}

String _$reminderSchedulerHash() => r'9c6c761878b8b630c315347a98219b652f2a5885';

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

String _$fCMTokenManagerHash() => r'd6e5fb6e2d1f087bccdee75ba6f8928f09d775ca';

/// Provider that handles FCM token registration.
///
/// Watches auth state and updates FCM token when user logs in.

abstract class _$FCMTokenManager extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the OS lets this app post notifications, rechecked on
/// resume since the user changes it in the OS settings.

@ProviderFor(notificationPermissionStatus)
final notificationPermissionStatusProvider =
    NotificationPermissionStatusProvider._();

/// Whether the OS lets this app post notifications, rechecked on
/// resume since the user changes it in the OS settings.

final class NotificationPermissionStatusProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the OS lets this app post notifications, rechecked on
  /// resume since the user changes it in the OS settings.
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
    r'5767746028b3be5b2525cf3801efe6ae69c94371';

/// Provider for FCM authorization status.

@ProviderFor(fcmAuthorizationStatus)
final fcmAuthorizationStatusProvider = FcmAuthorizationStatusProvider._();

/// Provider for FCM authorization status.

final class FcmAuthorizationStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthorizationStatus>,
          AuthorizationStatus,
          FutureOr<AuthorizationStatus>
        >
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthorizationStatus> create(Ref ref) {
    return fcmAuthorizationStatus(ref);
  }
}

String _$fcmAuthorizationStatusHash() =>
    r'7de9b5640453644d977a29d211602c12624f15c4';
