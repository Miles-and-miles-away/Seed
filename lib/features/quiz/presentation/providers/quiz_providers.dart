import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_providers.g.dart';

/// The longest quiz streak of this session.
///
/// keepAlive so the score survives leaving the screen, and memory-only
/// like everything else here: the quiz banks nothing (decision 8.18).
/// Only this int is pinned -- the deck holds locale-resolved strings, so
/// it stays widget state and is rebuilt on a language change.
@Riverpod(keepAlive: true)
class QuizBestStreak extends _$QuizBestStreak {
  @override
  int build() => 0;

  /// Keeps [streak] if it beats the session best.
  void record(int streak) {
    if (streak > state) state = streak;
  }
}
