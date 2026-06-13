// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Computed level progress (0.0 to 1.0) from user points.

@ProviderFor(levelProgress)
final levelProgressProvider = LevelProgressProvider._();

/// Computed level progress (0.0 to 1.0) from user points.

final class LevelProgressProvider
    extends $FunctionalProvider<double, double, double> with $Provider<double> {
  /// Computed level progress (0.0 to 1.0) from user points.
  LevelProgressProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'levelProgressProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$levelProgressHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return levelProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$levelProgressHash() => r'1c3ca4824c6c4393c75004d8b743f27199c27b7c';

/// Points needed to reach the next level.

@ProviderFor(pointsToNextLevel)
final pointsToNextLevelProvider = PointsToNextLevelProvider._();

/// Points needed to reach the next level.

final class PointsToNextLevelProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Points needed to reach the next level.
  PointsToNextLevelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pointsToNextLevelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pointsToNextLevelHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return pointsToNextLevel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pointsToNextLevelHash() => r'570becc9d9f69885e5849ca41031dc84b7fb4368';

/// Current mascot evolution stage (1-4).

@ProviderFor(evolutionStage)
final evolutionStageProvider = EvolutionStageProvider._();

/// Current mascot evolution stage (1-4).

final class EvolutionStageProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Current mascot evolution stage (1-4).
  EvolutionStageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'evolutionStageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$evolutionStageHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return evolutionStage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$evolutionStageHash() => r'e1e2163c6cd7f2017f0842c40dd85b5418c9fc4b';

/// Total CO2 saved across all actions (grams).
/// Reads denormalized field from user doc instead of
/// streaming entire actionLog subcollection.

@ProviderFor(totalCo2Saved)
final totalCo2SavedProvider = TotalCo2SavedProvider._();

/// Total CO2 saved across all actions (grams).
/// Reads denormalized field from user doc instead of
/// streaming entire actionLog subcollection.

final class TotalCo2SavedProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Total CO2 saved across all actions (grams).
  /// Reads denormalized field from user doc instead of
  /// streaming entire actionLog subcollection.
  TotalCo2SavedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'totalCo2SavedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalCo2SavedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalCo2Saved(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalCo2SavedHash() => r'ee5b1ec886c4669ffbf54b9fc3c0717d08e30b08';

/// Total number of actions logged.
/// Reads denormalized field from user doc.

@ProviderFor(totalActionsCount)
final totalActionsCountProvider = TotalActionsCountProvider._();

/// Total number of actions logged.
/// Reads denormalized field from user doc.

final class TotalActionsCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Total number of actions logged.
  /// Reads denormalized field from user doc.
  TotalActionsCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'totalActionsCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalActionsCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalActionsCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$totalActionsCountHash() => r'6e5504fe2c0ef2a57919b30eca90ead2f56b404b';

/// Number of days since the user joined.

@ProviderFor(daysSinceJoined)
final daysSinceJoinedProvider = DaysSinceJoinedProvider._();

/// Number of days since the user joined.

final class DaysSinceJoinedProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Number of days since the user joined.
  DaysSinceJoinedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'daysSinceJoinedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$daysSinceJoinedHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return daysSinceJoined(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$daysSinceJoinedHash() => r'b1ad070d990cba30297fe8e28bdeb11db2bd6836';
