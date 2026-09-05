// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The longest quiz streak of this session.
///
/// keepAlive so the score survives leaving the screen, and memory-only
/// like everything else here: the quiz banks nothing (decision 8.18).
/// Only this int is pinned -- the deck holds locale-resolved strings, so
/// it stays widget state and is rebuilt on a language change.

@ProviderFor(QuizBestStreak)
final quizBestStreakProvider = QuizBestStreakProvider._();

/// The longest quiz streak of this session.
///
/// keepAlive so the score survives leaving the screen, and memory-only
/// like everything else here: the quiz banks nothing (decision 8.18).
/// Only this int is pinned -- the deck holds locale-resolved strings, so
/// it stays widget state and is rebuilt on a language change.
final class QuizBestStreakProvider
    extends $NotifierProvider<QuizBestStreak, int> {
  /// The longest quiz streak of this session.
  ///
  /// keepAlive so the score survives leaving the screen, and memory-only
  /// like everything else here: the quiz banks nothing (decision 8.18).
  /// Only this int is pinned -- the deck holds locale-resolved strings, so
  /// it stays widget state and is rebuilt on a language change.
  QuizBestStreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizBestStreakProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizBestStreakHash();

  @$internal
  @override
  QuizBestStreak create() => QuizBestStreak();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$quizBestStreakHash() => r'511b57b29e880cc96ff895f6a37bc4dc86434f14';

/// The longest quiz streak of this session.
///
/// keepAlive so the score survives leaving the screen, and memory-only
/// like everything else here: the quiz banks nothing (decision 8.18).
/// Only this int is pinned -- the deck holds locale-resolved strings, so
/// it stays widget state and is rebuilt on a language change.

abstract class _$QuizBestStreak extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
