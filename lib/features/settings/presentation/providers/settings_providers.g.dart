// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
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
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

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
    r'b5fda680c45b0d745793e729592cb532f5c26802';

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

final class UserSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserSettingsModel>,
          UserSettingsModel,
          Stream<UserSettingsModel>
        >
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
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UserSettingsModel> create(Ref ref) {
    return userSettings(ref);
  }
}

String _$userSettingsHash() => r'9c03e600402f8aec294bba1abebdae1764a6a56d';

/// The app language: the account's choice, else this device's pick,
/// else the OS language. Computed, never stored. On Android 13+ the app
/// owns its per-app locale, so an OS-side change made after the last
/// pick is the user editing this app's language and wins on that device.
/// Elsewhere an OS change is the whole device and never overrides a pick.

@ProviderFor(currentLanguage)
final currentLanguageProvider = CurrentLanguageProvider._();

/// The app language: the account's choice, else this device's pick,
/// else the OS language. Computed, never stored. On Android 13+ the app
/// owns its per-app locale, so an OS-side change made after the last
/// pick is the user editing this app's language and wins on that device.
/// Elsewhere an OS change is the whole device and never overrides a pick.

final class CurrentLanguageProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The app language: the account's choice, else this device's pick,
  /// else the OS language. Computed, never stored. On Android 13+ the app
  /// owns its per-app locale, so an OS-side change made after the last
  /// pick is the user editing this app's language and wins on that device.
  /// Elsewhere an OS change is the whole device and never overrides a pick.
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

String _$currentLanguageHash() => r'e8e0d2163b8e08a05a63b7783e37da0a3f46ae4a';

/// Returns whether the daily reminder is enabled.

@ProviderFor(notificationsEnabled)
final notificationsEnabledProvider = NotificationsEnabledProvider._();

/// Returns whether the daily reminder is enabled.

final class NotificationsEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Returns whether the daily reminder is enabled.
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
    r'773fb279d76a064c1f17b95b37d828ef4aaf9808';

/// The daily reminder time.

@ProviderFor(reminderTime)
final reminderTimeProvider = ReminderTimeProvider._();

/// The daily reminder time.

final class ReminderTimeProvider
    extends $FunctionalProvider<TimeOfDay, TimeOfDay, TimeOfDay>
    with $Provider<TimeOfDay> {
  /// The daily reminder time.
  ReminderTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderTimeHash();

  @$internal
  @override
  $ProviderElement<TimeOfDay> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimeOfDay create(Ref ref) {
    return reminderTime(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimeOfDay value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimeOfDay>(value),
    );
  }
}

String _$reminderTimeHash() => r'1204364f02e926fc02a56ecd1922126d1571fdaa';

/// Whether action reminders are switched on.

@ProviderFor(actionRemindersEnabled)
final actionRemindersEnabledProvider = ActionRemindersEnabledProvider._();

/// Whether action reminders are switched on.

final class ActionRemindersEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether action reminders are switched on.
  ActionRemindersEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'actionRemindersEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$actionRemindersEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return actionRemindersEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$actionRemindersEnabledHash() =>
    r'c017dda568326b00e56e7ee40cf6d5b228647186';

/// Action reminders with a day still to come, by action id; once the
/// library loads, only those for actions it still has.

@ProviderFor(actionReminders)
final actionRemindersProvider = ActionRemindersProvider._();

/// Action reminders with a day still to come, by action id; once the
/// library loads, only those for actions it still has.

final class ActionRemindersProvider
    extends
        $FunctionalProvider<
          Map<String, ActionReminder>,
          Map<String, ActionReminder>,
          Map<String, ActionReminder>
        >
    with $Provider<Map<String, ActionReminder>> {
  /// Action reminders with a day still to come, by action id; once the
  /// library loads, only those for actions it still has.
  ActionRemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'actionRemindersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$actionRemindersHash();

  @$internal
  @override
  $ProviderElement<Map<String, ActionReminder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, ActionReminder> create(Ref ref) {
    return actionReminders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, ActionReminder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, ActionReminder>>(value),
    );
  }
}

String _$actionRemindersHash() => r'604a61f9f8c7abfc5a9051bfdd53a9f7ecba3e9a';

/// Returns whether analytics collection is enabled.

@ProviderFor(analyticsEnabled)
final analyticsEnabledProvider = AnalyticsEnabledProvider._();

/// Returns whether analytics collection is enabled.

final class AnalyticsEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
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

String _$analyticsEnabledHash() => r'b136c3eb860e46f7dee84318115ad619984da3ab';

/// Walkthrough item ids the user has found, or null while signed out or
/// until settings load, so nothing shimmers or pops on a guess.

@ProviderFor(walkthroughFound)
final walkthroughFoundProvider = WalkthroughFoundProvider._();

/// Walkthrough item ids the user has found, or null while signed out or
/// until settings load, so nothing shimmers or pops on a guess.

final class WalkthroughFoundProvider
    extends $FunctionalProvider<Set<String>?, Set<String>?, Set<String>?>
    with $Provider<Set<String>?> {
  /// Walkthrough item ids the user has found, or null while signed out or
  /// until settings load, so nothing shimmers or pops on a guess.
  WalkthroughFoundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walkthroughFoundProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walkthroughFoundHash();

  @$internal
  @override
  $ProviderElement<Set<String>?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Set<String>? create(Ref ref) {
    return walkthroughFound(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>?>(value),
    );
  }
}

String _$walkthroughFoundHash() => r'0cf4a82b84cd39850988493f186736323a119232';

/// Returns the preferred theme mode, defaulting to the system setting.

@ProviderFor(themeMode)
final themeModeProvider = ThemeModeProvider._();

/// Returns the preferred theme mode, defaulting to the system setting.

final class ThemeModeProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  /// Returns the preferred theme mode, defaulting to the system setting.
  ThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return themeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeHash() => r'f37638bc896c8dd117c5e0c5ce92c70f3272cee8';

/// The app locale for [currentLanguageProvider].

@ProviderFor(appLocale)
final appLocaleProvider = AppLocaleProvider._();

/// The app locale for [currentLanguageProvider].

final class AppLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  /// The app locale for [currentLanguageProvider].
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
        isAutoDispose: false,
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

String _$settingsNotifierHash() => r'315bdf10d8e89799881a6592daa23ef2025c0a33';

/// Notifier that handles settings mutations.
/// Uses AsyncValue to track loading and error states.

abstract class _$SettingsNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
