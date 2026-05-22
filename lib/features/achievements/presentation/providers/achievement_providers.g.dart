// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(achievementsRemoteDataSource)
const achievementsRemoteDataSourceProvider =
    AchievementsRemoteDataSourceProvider._();

final class AchievementsRemoteDataSourceProvider extends $FunctionalProvider<
    AchievementsRemoteDataSource,
    AchievementsRemoteDataSource,
    AchievementsRemoteDataSource> with $Provider<AchievementsRemoteDataSource> {
  const AchievementsRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'achievementsRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$achievementsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AchievementsRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AchievementsRemoteDataSource create(Ref ref) {
    return achievementsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AchievementsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AchievementsRemoteDataSource>(value),
    );
  }
}

String _$achievementsRemoteDataSourceHash() =>
    r'd53a50eee4117efceffef3931077f41f3c83b603';

@ProviderFor(achievementsRepository)
const achievementsRepositoryProvider = AchievementsRepositoryProvider._();

final class AchievementsRepositoryProvider extends $FunctionalProvider<
    AchievementsRepository,
    AchievementsRepository,
    AchievementsRepository> with $Provider<AchievementsRepository> {
  const AchievementsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'achievementsRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$achievementsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AchievementsRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AchievementsRepository create(Ref ref) {
    return achievementsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AchievementsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AchievementsRepository>(value),
    );
  }
}

String _$achievementsRepositoryHash() =>
    r'5a16322d4d2b79da60f6e61862c4d203212133b5';

/// Bundled JSON catalog. `keepAlive` because the asset is static and
/// reading it on every screen mount wastes a frame.

@ProviderFor(achievementDefinitions)
const achievementDefinitionsProvider = AchievementDefinitionsProvider._();

/// Bundled JSON catalog. `keepAlive` because the asset is static and
/// reading it on every screen mount wastes a frame.

final class AchievementDefinitionsProvider extends $FunctionalProvider<
        AsyncValue<List<AchievementDefinition>>,
        List<AchievementDefinition>,
        FutureOr<List<AchievementDefinition>>>
    with
        $FutureModifier<List<AchievementDefinition>>,
        $FutureProvider<List<AchievementDefinition>> {
  /// Bundled JSON catalog. `keepAlive` because the asset is static and
  /// reading it on every screen mount wastes a frame.
  const AchievementDefinitionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'achievementDefinitionsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$achievementDefinitionsHash();

  @$internal
  @override
  $FutureProviderElement<List<AchievementDefinition>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AchievementDefinition>> create(Ref ref) {
    return achievementDefinitions(ref);
  }
}

String _$achievementDefinitionsHash() =>
    r'06f5351ef14dd18b6e5ab5348aa969cf3475f5a5';

/// Streams the raw unlock records for a user (includes unlockedAt
/// timestamps). Use this when the UI needs the unlock date; otherwise
/// prefer [userUnlockedAchievementIds] for cheaper membership checks.

@ProviderFor(userAchievements)
const userAchievementsProvider = UserAchievementsFamily._();

/// Streams the raw unlock records for a user (includes unlockedAt
/// timestamps). Use this when the UI needs the unlock date; otherwise
/// prefer [userUnlockedAchievementIds] for cheaper membership checks.

final class UserAchievementsProvider extends $FunctionalProvider<
        AsyncValue<List<UserAchievementModel>>,
        List<UserAchievementModel>,
        Stream<List<UserAchievementModel>>>
    with
        $FutureModifier<List<UserAchievementModel>>,
        $StreamProvider<List<UserAchievementModel>> {
  /// Streams the raw unlock records for a user (includes unlockedAt
  /// timestamps). Use this when the UI needs the unlock date; otherwise
  /// prefer [userUnlockedAchievementIds] for cheaper membership checks.
  const UserAchievementsProvider._(
      {required UserAchievementsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'userAchievementsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userAchievementsHash();

  @override
  String toString() {
    return r'userAchievementsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<UserAchievementModel>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<UserAchievementModel>> create(Ref ref) {
    final argument = this.argument as String;
    return userAchievements(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserAchievementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userAchievementsHash() => r'cb568cae06770fed3993812964045a02bf5383f4';

/// Streams the raw unlock records for a user (includes unlockedAt
/// timestamps). Use this when the UI needs the unlock date; otherwise
/// prefer [userUnlockedAchievementIds] for cheaper membership checks.

final class UserAchievementsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<UserAchievementModel>>, String> {
  const UserAchievementsFamily._()
      : super(
          retry: null,
          name: r'userAchievementsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Streams the raw unlock records for a user (includes unlockedAt
  /// timestamps). Use this when the UI needs the unlock date; otherwise
  /// prefer [userUnlockedAchievementIds] for cheaper membership checks.

  UserAchievementsProvider call(
    String userId,
  ) =>
      UserAchievementsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userAchievementsProvider';
}

/// Streams just the set of unlocked achievement ids -- the minimal
/// surface most badge/list UI needs.

@ProviderFor(userUnlockedAchievementIds)
const userUnlockedAchievementIdsProvider = UserUnlockedAchievementIdsFamily._();

/// Streams just the set of unlocked achievement ids -- the minimal
/// surface most badge/list UI needs.

final class UserUnlockedAchievementIdsProvider extends $FunctionalProvider<
        AsyncValue<Set<String>>, Set<String>, Stream<Set<String>>>
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  /// Streams just the set of unlocked achievement ids -- the minimal
  /// surface most badge/list UI needs.
  const UserUnlockedAchievementIdsProvider._(
      {required UserUnlockedAchievementIdsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'userUnlockedAchievementIdsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userUnlockedAchievementIdsHash();

  @override
  String toString() {
    return r'userUnlockedAchievementIdsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    final argument = this.argument as String;
    return userUnlockedAchievementIds(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserUnlockedAchievementIdsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userUnlockedAchievementIdsHash() =>
    r'2f9e6cf11011b8e9075aa0ad359f5b5b1a58ae9e';

/// Streams just the set of unlocked achievement ids -- the minimal
/// surface most badge/list UI needs.

final class UserUnlockedAchievementIdsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Set<String>>, String> {
  const UserUnlockedAchievementIdsFamily._()
      : super(
          retry: null,
          name: r'userUnlockedAchievementIdsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Streams just the set of unlocked achievement ids -- the minimal
  /// surface most badge/list UI needs.

  UserUnlockedAchievementIdsProvider call(
    String userId,
  ) =>
      UserUnlockedAchievementIdsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userUnlockedAchievementIdsProvider';
}
