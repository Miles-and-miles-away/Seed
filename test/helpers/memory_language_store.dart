import 'package:seed_app/shared/data/language_store.dart';

/// A returning device: no pick, first-launch picker already handled.
const StoredLanguage returningDevice = (pick: null, firstLaunchDone: true);

/// In-memory [LanguageStore] that records every save.
class MemoryLanguageStore implements LanguageStore {
  MemoryLanguageStore([this.value = returningDevice]);

  @override
  StoredLanguage value;

  @override
  bool loaded = true;

  final saved = <StoredLanguage>[];

  @override
  Future<void> save(StoredLanguage value) async {
    this.value = value;
    saved.add(value);
  }
}
