import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

import '../../helpers/test_helpers.dart';
import 'walkthrough_test_support.dart';

void main() {
  group('walkthroughFoundProvider', () {
    test('is null while signed out even when settings exist', () async {
      final c = await pumpedContainer(
        walkthroughOverrides(
          settings: Stream.value(settingsWith([WalkthroughItem.intro])),
          signedIn: false,
        ),
        warm: walkthroughFoundProvider,
      );

      expect(c.read(walkthroughFoundProvider), isNull);
    });

    test('is null until settings load', () async {
      final c = await pumpedContainer(
        walkthroughOverrides(
          settings: StreamController<UserSettingsModel>().stream,
        ),
        warm: walkthroughFoundProvider,
      );

      expect(c.read(walkthroughFoundProvider), isNull);
    });

    test('is the found set once loaded', () async {
      final c = await pumpedContainer(
        walkthroughOverrides(
          settings: Stream.value(settingsWith([WalkthroughItem.intro])),
        ),
        warm: walkthroughFoundProvider,
      );

      expect(c.read(walkthroughFoundProvider), {'intro'});
    });
  });

  group('walkthroughPendingProvider', () {
    Future<bool> pending(
      WalkthroughItem item, {
      Iterable<WalkthroughItem> found = const [],
      bool hasMascot = true,
      bool hasNewEvolution = false,
      bool eggPending = false,
    }) async {
      final c = await pumpedContainer(
        walkthroughOverrides(
          settings: Stream.value(settingsWith(found)),
          hasMascot: hasMascot,
          hasNewEvolution: hasNewEvolution,
          eggPending: eggPending,
        ),
        warm: walkthroughPendingProvider(item),
      );
      return c.read(walkthroughPendingProvider(item));
    }

    test('the intro is pending first, and items only after it', () async {
      expect(await pending(WalkthroughItem.intro), isTrue);
      expect(await pending(WalkthroughItem.quiz), isFalse);
      expect(
        await pending(WalkthroughItem.quiz, found: [WalkthroughItem.intro]),
        isTrue,
      );
    });

    test('a found item is not pending', () async {
      expect(
        await pending(
          WalkthroughItem.quiz,
          found: [WalkthroughItem.intro, WalkthroughItem.quiz],
        ),
        isFalse,
      );
      expect(
        await pending(WalkthroughItem.intro, found: [WalkthroughItem.intro]),
        isFalse,
      );
    });

    test(
      'nothing is pending without a mascot or during a celebration',
      () async {
        expect(await pending(WalkthroughItem.intro, hasMascot: false), isFalse);
        expect(
          await pending(WalkthroughItem.intro, hasNewEvolution: true),
          isFalse,
        );
        expect(await pending(WalkthroughItem.intro, eggPending: true), isFalse);
      },
    );
  });
}
