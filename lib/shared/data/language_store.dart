import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/app_logger.dart';

/// This device's language state: the last pick with the OS language
/// recorded beside it, and whether the first-launch picker was handled.
typedef StoredLanguage = ({
  ({String language, String os})? pick,
  bool firstLaunchDone,
});

/// A fresh install: no pick, first-launch picker still due.
const StoredLanguage noStoredLanguage = (pick: null, firstLaunchDone: false);

/// Upper bound the startup read may add, counted once Firebase is ready.
const languageLoadBudget = Duration(milliseconds: 150);

/// Persists [StoredLanguage] for this device, before and after sign-in.
abstract interface class LanguageStore {
  StoredLanguage get value;

  /// False when the startup read timed out, so [value] is a stand-in that
  /// must not be written back on its own account.
  bool get loaded;

  Future<void> save(StoredLanguage value);
}

const _fileName = 'app_language.json';
const _tempFileName = '$_fileName.tmp';
const _formatVersion = 1;
const _keyVersion = 'v';
const _keyPick = 'pick';
const _keyLanguage = 'language';
const _keyOs = 'os';
const _keyFirstLaunchDone = 'firstLaunchDone';

/// A slow read is not evidence of a first launch, so it skips the picker.
const StoredLanguage _timedOut = (pick: null, firstLaunchDone: true);

/// [LanguageStore] backed by one small JSON file in the app support
/// directory. Writes go through a temporary file and a rename, one at
/// a time, so an interrupted write leaves the previous file intact.
class FileLanguageStore implements LanguageStore {
  /// Starts reading the file at once; [load] waits for the result.
  FileLanguageStore({
    Future<Directory> Function() directory = getApplicationSupportDirectory,
  }) : _directory = directory() {
    _firstRead = _read();
  }

  final Future<Directory> _directory;
  late final Future<StoredLanguage> _firstRead;
  Future<void> _writes = Future.value();

  @override
  StoredLanguage value = noStoredLanguage;

  @override
  bool loaded = false;

  /// Waits at most [budget] for the read started by the constructor.
  Future<void> load({Duration budget = languageLoadBudget}) async {
    var timedOut = false;
    value = await _firstRead.timeout(
      budget,
      onTimeout: () {
        timedOut = true;
        appLogger.warning('Language file read exceeded $budget');
        return _timedOut;
      },
    );
    loaded = !timedOut;
  }

  Future<File> _file(String name) async =>
      File('${(await _directory).path}/$name');

  Future<StoredLanguage> _read() async {
    try {
      final text = await (await _file(_fileName)).readAsString();
      return _decode(text);
    } on PathNotFoundException {
      return noStoredLanguage;
    } on Object catch (e) {
      appLogger.warning('Language file unreadable: $e');
      return noStoredLanguage;
    }
  }

  @override
  Future<void> save(StoredLanguage next) {
    value = next;
    return _writes = _writes.then((_) => _write(next));
  }

  Future<void> _write(StoredLanguage next) async {
    try {
      final directory = await _directory;
      await directory.create(recursive: true);
      final temp = await _file(_tempFileName);
      await temp.writeAsString(_encode(next), flush: true);
      await temp.rename((await _file(_fileName)).path);
    } on Object catch (e) {
      appLogger.warning('Language file write failed: $e');
    }
  }
}

/// [value] as the file's JSON.
String _encode(StoredLanguage value) => jsonEncode({
  _keyVersion: _formatVersion,
  if (value.pick case final pick?)
    _keyPick: {_keyLanguage: pick.language, _keyOs: pick.os},
  _keyFirstLaunchDone: value.firstLaunchDone,
});

/// Parses the file's JSON. Anything invalid reads as absent, field by
/// field where the rest is valid.
StoredLanguage _decode(String text) {
  final Object? json;
  try {
    json = jsonDecode(text);
  } on FormatException {
    appLogger.warning('Language file is not JSON');
    return noStoredLanguage;
  }
  if (json is! Map<String, Object?> || json[_keyVersion] != _formatVersion) {
    appLogger.warning('Language file has an unknown format');
    return noStoredLanguage;
  }

  final done = json[_keyFirstLaunchDone];
  final pick = switch (json[_keyPick]) {
    {_keyLanguage: final String language, _keyOs: final String os}
        when isSupportedLanguage(language) && isSupportedLanguage(os) =>
      (language: language, os: os),
    _ => null,
  };
  if (json[_keyPick] != null && pick == null) {
    appLogger.warning('Language file has an invalid pick');
  }
  return (pick: pick, firstLaunchDone: done is bool && done);
}

/// Whether the app has a translation for [code].
bool isSupportedLanguage(String code) => AppLocalizations.supportedLocales.any(
  (locale) => locale.languageCode == code,
);
