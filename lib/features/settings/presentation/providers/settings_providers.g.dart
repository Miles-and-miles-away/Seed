// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRemoteDataSource)
final settingsRemoteDataSourceProvider = SettingsRemoteDataSourceProvider._();

final class SettingsRemoteDataSourceProvider extends $FunctionalProvider<
    SettingsRemoteDataSource,
    SettingsRemoteDataSource,
    SettingsRemoteDataSource> with $Provider<SettingsRemoteDataSource> {
  SettingsRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SettingsRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsRemoteDataSource create(Ref ref) {
    return settingsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRemoteDataSource>(value),
    );
  }
}

String _$settingsRemoteDataSourceHash() =>
    r'1c79aed826bd7a8ad1de3a4952e38339dd1cdb1c';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider extends $FunctionalProvider<
    SettingsRepository,
    SettingsRepository,
    SettingsRepository> with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'18f122b9b975096acb81f3e04a25762e8e36ab4e';

/// Stream of the current user's settings.
/// Returns default settings if no settings are found.
///
/// Keyed on the user id (not the whole user document) so the settings
/// listener survives unrelated user-doc writes.

@ProviderFor(userSettings)
final userSettingsProvider = UserSettingsProvider._();

/// Stream of the current user's settings.
/// Returns default settings if no settings are found.
///
/// Keyed on the user id (not the whole user document) so the settings
/// listener survives unrelated user-doc writes.

final class UserSettingsProvider extends $FunctionalProvider<
        AsyncValue<UserSettingsModel>,
        UserSettingsModel,
        Stream<UserSettingsModel>>
    with
        $FutureModifier<UserSettingsModel>,
        $StreamProvider<UserSettingsModel> {
  /// Stream of the current user's settings.
  /// Returns default settings if no settings are found.
  ///
  /// Keyed on the user id (not the whole user document) so the settings
  /// listener survives unrelated user-doc writes.
  UserSettingsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userSettingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userSettingsHash();

  @$internal
  @override
  $StreamProviderElement<UserSettingsModel> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<UserSettingsModel> create(Ref ref) {
    return userSettings(ref);
  }
}

String _$userSettingsHash() => r'9c03e600402f8aec294bba1abebdae1764a6a56d';

/// Returns the list of enabled reminder schedules.

@ProviderFor(enabledReminders)
final enabledRemindersProvider = EnabledRemindersProvider._();

/// Returns the list of enabled reminder schedules.

final class EnabledRemindersProvider extends $FunctionalProvider<
        List<NotificationScheduleModel>,
        List<NotificationScheduleModel>,
        List<NotificationScheduleModel>>
    with $Provider<List<NotificationScheduleModel>> {
  /// Returns the list of enabled reminder schedules.
  EnabledRemindersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'enabledRemindersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$enabledRemindersHash();

  @$internal
  @override
  $ProviderElement<List<NotificationScheduleModel>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<NotificationScheduleModel> create(Ref ref) {
    return enabledReminders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NotificationScheduleModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<List<NotificationScheduleModel>>(value),
    );
  }
}

String _$enabledRemindersHash() => r'287947b76f478f8021d0685cfdc8378829a045c2';

/// Returns whether the user can add more reminders.

@ProviderFor(canAddReminder)
final canAddReminderProvider = CanAddReminderProvider._();

/// Returns whether the user can add more reminders.

final class CanAddReminderProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Returns whether the user can add more reminders.
  CanAddReminderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'canAddReminderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$canAddReminderHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return canAddReminder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$canAddReminderHash() => r'fca40fb1a98c6681e527d1262bc2136df3bef733';

/// Returns the current language setting.

@ProviderFor(currentLanguage)
final currentLanguageProvider = CurrentLanguageProvider._();

/// Returns the current language setting.

final class CurrentLanguageProvider
    extends $FunctionalProvider<String, String, String> with $Provider<String> {
  /// Returns the current language setting.
  CurrentLanguageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentLanguageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentLanguageHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentLanguage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentLanguageHash() => r'd2d3a06fa837edd402b67f8418b7628ce5c633f8';

/// Returns whether notifications are enabled.

@ProviderFor(notificationsEnabled)
final notificationsEnabledProvider = NotificationsEnabledProvider._();

/// Returns whether notifications are enabled.

final class NotificationsEnabledProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Returns whether notifications are enabled.
  NotificationsEnabledProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationsEnabledProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationsEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return notificationsEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$notificationsEnabledHash() =>
    r'22949effe74eaaf92edfbcf80f70fcccdae262b5';

/// Returns whether smart reminders are enabled.

@ProviderFor(smartRemindersEnabled)
final smartRemindersEnabledProvider = SmartRemindersEnabledProvider._();

/// Returns whether smart reminders are enabled.

final class SmartRemindersEnabledProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Returns whether smart reminders are enabled.
  SmartRemindersEnabledProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'smartRemindersEnabledProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$smartRemindersEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return smartRemindersEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$smartRemindersEnabledHash() =>
    r'08e5ed2976077c07a36aa10d0856dfb98b9369d4';

/// Returns whether analytics collection is enabled.

@ProviderFor(analyticsEnabled)
final analyticsEnabledProvider = AnalyticsEnabledProvider._();

/// Returns whether analytics collection is enabled.

final class AnalyticsEnabledProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Returns whether analytics collection is enabled.
  AnalyticsEnabledProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'analyticsEnabledProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$analyticsEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return analyticsEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$analyticsEnabledHash() => r'9664fa8a59370dc6bbd0a93381e5f00ea8915ac1';

/// Returns the current app locale based on user settings.
/// Falls back to English if no setting is found.

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

/// Returns the current app locale based on user settings.
/// Falls back to English if no setting is found.

final class AppLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale> with $Provider<Locale> {
  /// Returns the current app locale based on user settings.
  /// Falls back to English if no setting is found.
  AppLocaleProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appLocaleProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return appLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleHash() => r'039b0a604fd9f4a680ba4c0e1357a68e1a63f485';

/// Notifier that handles settings mutations.
/// Uses AsyncValue to track loading and error states.

@ProviderFor(SettingsNotifier)
final settingsProvider = SettingsNotifierProvider._();

/// Notifier that handles settings mutations.
/// Uses AsyncValue to track loading and error states.
final class SettingsNotifierProvider
    extends $NotifierProvider<SettingsNotifier, AsyncValue<void>> {
  /// Notifier that handles settings mutations.
  /// Uses AsyncValue to track loading and error states.
  SettingsNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'settingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$settingsNotifierHash();

  @$internal
  @override
  SettingsNotifier create() => SettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$settingsNotifierHash() => r'c3f54358ef16aca1ad28b80fcffb5c6f272abe09';

/// Notifier that handles settings mutations.
/// Uses AsyncValue to track loading and error states.

abstract class _$SettingsNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
