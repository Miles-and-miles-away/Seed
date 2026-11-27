import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/utils/app_logger.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';

part 'language_sync_provider.g.dart';

/// Keeps this device's language and the account's in step, and Firebase
/// Auth emails in the app language.
@Riverpod(keepAlive: true)
class LanguageSync extends _$LanguageSync {
  String? _uid;
  String? _seen;
  bool _baselineSeen = false;
  final _backfilled = <String>{};

  @override
  void build() {
    ref
      ..listen(userIdProvider, (_, uid) => _onUser(uid))
      ..listen(userSettingsProvider, (_, settings) => _onSettings(settings))
      ..listen(
        currentLanguageProvider,
        (_, code) => unawaited(_setAuthLanguage(code)),
        fireImmediately: true,
      );
    // Deferred: a provider may not modify others while it builds.
    scheduleMicrotask(_catchUp);
  }

  void _catchUp() {
    if (!ref.mounted) return;
    _onUser(ref.read(userIdProvider));
    _onSettings(ref.read(userSettingsProvider));
  }

  DeviceLanguage get _device => ref.read(deviceLanguageProvider.notifier);

  /// Applies an in-app pick here and, when signed in, on the account.
  Future<void> choose(String code) async {
    final signedIn = ref.read(userIdProvider) != null;
    final inFlight = ref.read(pendingLanguagePushProvider);
    final pending = ref.read(pendingLanguagePushProvider.notifier);
    if (signedIn) pending.set(inFlight == null && code == _seen ? null : code);
    await _device.pick(code);
    if (!ref.mounted) return;
    unawaited(
      ref.read(analyticsServiceProvider).logLanguageChanged(language: code),
    );
    if (!signedIn) return;

    final settings = ref.read(settingsProvider.notifier);
    await settings.updateLanguage(code);
    if (ref.mounted && ref.read(settingsProvider).hasError) pending.set(null);
  }

  void _track(String? uid) {
    if (uid == _uid) return;
    _uid = uid;
    _seen = null;
    _baselineSeen = false;
    if (ref.read(pendingLanguagePushProvider) != null) _clearPending();
  }

  void _clearPending() =>
      ref.read(pendingLanguagePushProvider.notifier).set(null);

  void _onUser(String? uid) {
    _track(uid);
    if (uid != null && !ref.read(deviceLanguageProvider).firstLaunchDone) {
      unawaited(_device.markFirstLaunchDone());
    }
  }

  void _onSettings(AsyncValue<UserSettingsModel> settings) {
    final uid = ref.read(userIdProvider);
    _track(uid);
    if (uid == null || settings.isLoading || !settings.hasValue) return;

    final next = settings.requireValue.language;
    if (next == null) {
      if (_backfilled.add(uid)) unawaited(_backfill(uid));
      return;
    }
    final pending = ref.read(pendingLanguagePushProvider);
    if (pending == next) _clearPending();
    if (!_baselineSeen) {
      _baselineSeen = true;
      _seen = next;
      // A pick made before the first snapshot outranks that snapshot.
      if (pending == null || pending == next) unawaited(_device.mirror(next));
      return;
    }
    if (next == _seen) return;
    _seen = next;
    if (pending == null) unawaited(_device.adopt(next));
  }

  Future<void> _backfill(String uid) async {
    try {
      await ref
          .read(settingsRepositoryProvider)
          .backfillLanguage(uid, ref.read(currentLanguageProvider));
    } on Object catch (e) {
      appLogger.info('Language backfill deferred to the next launch: $e');
    }
  }

  Future<void> _setAuthLanguage(String code) async {
    try {
      await ref.read(firebaseAuthProvider).setLanguageCode(code);
    } on Object catch (e) {
      appLogger.warning('Auth email language not set: $e');
    }
  }
}
