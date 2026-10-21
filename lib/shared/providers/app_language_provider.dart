import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show basicLocaleListResolution;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/app_logger.dart';
import 'package:seed_app/shared/data/language_store.dart';

part 'app_language_provider.g.dart';

const _appLocaleChannel = MethodChannel('seed/app_locale');
const _methodSdk = 'sdk';
const _methodSet = 'set';

/// First Android SDK with a per-app language setting (Android 13).
const _perAppLocaleMinSdk = 33;

/// Overridden in main() with the store loaded before runApp.
final languageStoreProvider = Provider<LanguageStore>(
  (_) => throw UnimplementedError('languageStoreProvider not overridden'),
);

/// The supported language the OS list resolves to, English otherwise.
String resolveOsLanguage(List<Locale> locales) => basicLocaleListResolution(
  locales,
  AppLocalizations.supportedLocales,
).languageCode;

/// The OS language list; SeedApp feeds it from didChangeLocales.
@Riverpod(keepAlive: true)
class OsLocales extends _$OsLocales {
  @override
  List<Locale> build() => PlatformDispatcher.instance.locales;

  // ignore: use_setters_to_change_properties
  void update(List<Locale> locales) => state = locales;
}

/// A language pushed to the account whose echo has not arrived yet. It
/// stands in for the account's language until the echo clears it.
@Riverpod(keepAlive: true)
class PendingLanguagePush extends _$PendingLanguagePush {
  @override
  String? build() => null;

  // ignore: use_setters_to_change_properties
  void set(String? code) => state = code;
}

/// The Android SDK level, asked once at start; null elsewhere.
@Riverpod(keepAlive: true)
Future<int?> androidSdk(Ref ref) async {
  if (defaultTargetPlatform != TargetPlatform.android) return null;
  return _invoke<int>(_methodSdk);
}

/// Null when the host has no handler (iOS, tests) or the call fails.
Future<T?> _invoke<T>(String method, [Object? argument]) async {
  try {
    return await _appLocaleChannel.invokeMethod<T>(method, argument);
  } on MissingPluginException {
    return null;
  } on PlatformException catch (e) {
    appLogger.warning('App locale channel $method failed: $e');
    return null;
  }
}

/// This device's stored pick, its OS snapshot and the first-launch flag.
@Riverpod(keepAlive: true)
class DeviceLanguage extends _$DeviceLanguage {
  @override
  StoredLanguage build() => ref.watch(languageStoreProvider).value;

  /// An in-app pick (picker, sheet, Settings).
  Future<void> pick(String code) => _set(code, resetSnap: true);

  /// The account's value at sign-in: realigns Android unless an OS
  /// override is active, and is skipped while the store read timed out.
  Future<void> mirror(String code) async {
    if (!ref.read(languageStoreProvider).loaded) return;
    final os = resolveOsLanguage(ref.read(osLocalesProvider));
    final pick = state.pick;
    await _set(code, resetSnap: pick == null || os == pick.os);
  }

  /// A live change of the account's language: as a pick.
  Future<void> adopt(String code) => _set(code, resetSnap: true);

  /// The first-launch picker was handled, or someone signed in.
  Future<void> markFirstLaunchDone() async {
    if (!state.firstLaunchDone) {
      await _save((pick: state.pick, firstLaunchDone: true));
    }
  }

  /// Writes state and the snapshot before the Android per-app locale, so
  /// the didChangeLocales echo lands on the non-override state.
  Future<void> _set(String code, {required bool resetSnap}) async {
    final sdk = ref.read(androidSdkProvider).value ?? 0;
    final applies = resetSnap && sdk >= _perAppLocaleMinSdk;
    final os = resolveOsLanguage(ref.read(osLocalesProvider));
    final snap = resetSnap ? (applies ? code : os) : (state.pick?.os ?? os);
    final next = (
      pick: (language: code, os: snap),
      firstLaunchDone: state.firstLaunchDone,
    );
    if (next == state) return;
    await _save(next);
    if (!applies || (await _invoke<bool>(_methodSet, code) ?? false)) return;
    if (!ref.mounted || state.pick?.language != code) return;
    await _save((
      pick: (language: code, os: os),
      firstLaunchDone: state.firstLaunchDone,
    ));
  }

  Future<void> _save(StoredLanguage next) {
    state = next;
    return ref.read(languageStoreProvider).save(next);
  }
}
