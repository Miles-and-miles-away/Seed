import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/data/language_store.dart';

const _fileName = 'app_language.json';
const StoredLanguage _picked = (
  pick: (language: 'es', os: 'en'),
  firstLaunchDone: true,
);

void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('language_store_test');
    addTearDown(() => dir.deleteSync(recursive: true));
  });

  File file([String name = _fileName]) => File('${dir.path}/$name');

  Future<FileLanguageStore> load() async {
    final store = FileLanguageStore(directory: () async => dir);
    await store.load();
    return store;
  }

  Future<StoredLanguage> loadText(String text) async {
    file().writeAsStringSync(text);
    return (await load()).value;
  }

  test('save then load round-trips', () async {
    await (await load()).save(_picked);

    expect((await load()).value, _picked);
  });

  test('a missing file is a fresh install', () async {
    expect((await load()).value, noStoredLanguage);
  });

  group('invalid content loads as absent', () {
    test('invalid JSON', () async {
      expect(await loadText('{not json'), noStoredLanguage);
    });

    test('an unknown version', () async {
      expect(
        await loadText('{"v": 2, "firstLaunchDone": true}'),
        noStoredLanguage,
      );
    });

    test('a wrong type keeps the valid flag beside it', () async {
      expect(
        await loadText('{"v": 1, "pick": "es", "firstLaunchDone": true}'),
        (pick: null, firstLaunchDone: true),
      );
    });

    test('an unsupported language keeps the valid flag beside it', () async {
      expect(
        await loadText(
          '{"v": 1, "pick": {"language": "fr", "os": "en"}, '
          '"firstLaunchDone": true}',
        ),
        (pick: null, firstLaunchDone: true),
      );
    });

    test('a non-boolean flag', () async {
      expect(
        await loadText(
          '{"v": 1, "pick": {"language": "ja", "os": "en"}, '
          '"firstLaunchDone": "yes"}',
        ),
        (pick: (language: 'ja', os: 'en'), firstLaunchDone: false),
      );
    });
  });

  test('a leftover temporary file is ignored', () async {
    await (await load()).save(_picked);
    file('$_fileName.tmp').writeAsStringSync('{half a wri');

    expect((await load()).value, _picked);
  });

  test('two quick saves land in order', () async {
    final store = await load();
    const second = (pick: (language: 'ja', os: 'en'), firstLaunchDone: true);

    unawaited(store.save(_picked));
    await store.save(second);

    expect((await load()).value, second);
  });

  test('a slow directory times out to the device language, no sheet', () async {
    final directory = Completer<Directory>();
    final store = FileLanguageStore(directory: () => directory.future);
    await store.load(budget: const Duration(milliseconds: 1));

    expect(store.value, (pick: null, firstLaunchDone: true));
    expect(store.loaded, isFalse);

    final saved = store.save(_picked);
    directory.complete(dir);
    await saved;
    expect((await load()).value, _picked);
  });

  test('the budget starts when load is called, not at the read', () async {
    final directory = Completer<Directory>();
    final store = FileLanguageStore(directory: () => directory.future);
    directory.complete(dir);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await store.load(budget: Duration.zero);

    expect(store.loaded, isTrue);
  });

  test('a loaded store reports it', () async {
    expect((await load()).loaded, isTrue);
  });
}
