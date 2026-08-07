// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All food items from the bundled dataset.

@ProviderFor(foodItems)
final foodItemsProvider = FoodItemsProvider._();

/// All food items from the bundled dataset.

final class FoodItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FoodItem>>,
          List<FoodItem>,
          FutureOr<List<FoodItem>>
        >
    with $FutureModifier<List<FoodItem>>, $FutureProvider<List<FoodItem>> {
  /// All food items from the bundled dataset.
  FoodItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<FoodItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FoodItem>> create(Ref ref) {
    return foodItems(ref);
  }
}

String _$foodItemsHash() => r'c46c8410ce27dee48259d9c3983f8c3c5dc40f92';

/// Dataset metadata (scope statement, primary source) for the
/// methodology sheet (Phase 8.10).

@ProviderFor(foodMetadata)
final foodMetadataProvider = FoodMetadataProvider._();

/// Dataset metadata (scope statement, primary source) for the
/// methodology sheet (Phase 8.10).

final class FoodMetadataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Dataset metadata (scope statement, primary source) for the
  /// methodology sheet (Phase 8.10).
  FoodMetadataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodMetadataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodMetadataHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return foodMetadata(ref);
  }
}

String _$foodMetadataHash() => r'804ffb6f68d5f856f988caebbd8cc36d40facbb9';

/// Items indexed by id for calculator lookups.

@ProviderFor(foodItemsById)
final foodItemsByIdProvider = FoodItemsByIdProvider._();

/// Items indexed by id for calculator lookups.

final class FoodItemsByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, FoodItem>>,
          Map<String, FoodItem>,
          FutureOr<Map<String, FoodItem>>
        >
    with
        $FutureModifier<Map<String, FoodItem>>,
        $FutureProvider<Map<String, FoodItem>> {
  /// Items indexed by id for calculator lookups.
  FoodItemsByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodItemsByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodItemsByIdHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, FoodItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, FoodItem>> create(Ref ref) {
    return foodItemsById(ref);
  }
}

String _$foodItemsByIdHash() => r'6d144f46b7a96a67e2a98a689731b9d5f380c804';

/// Ids of items picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only
/// like everything else in the calculator -- persisting it would mean
/// adding a local-storage dependency for a convenience, and the payoff
/// is within a session anyway: building two comparable meals means
/// reaching for the same handful of items twice.

@ProviderFor(RecentFoodItemIds)
final recentFoodItemIdsProvider = RecentFoodItemIdsProvider._();

/// Ids of items picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only
/// like everything else in the calculator -- persisting it would mean
/// adding a local-storage dependency for a convenience, and the payoff
/// is within a session anyway: building two comparable meals means
/// reaching for the same handful of items twice.
final class RecentFoodItemIdsProvider
    extends $NotifierProvider<RecentFoodItemIds, List<String>> {
  /// Ids of items picked this session, most recent first.
  ///
  /// keepAlive so the list survives closing the picker, but memory-only
  /// like everything else in the calculator -- persisting it would mean
  /// adding a local-storage dependency for a convenience, and the payoff
  /// is within a session anyway: building two comparable meals means
  /// reaching for the same handful of items twice.
  RecentFoodItemIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentFoodItemIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentFoodItemIdsHash();

  @$internal
  @override
  RecentFoodItemIds create() => RecentFoodItemIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentFoodItemIdsHash() => r'680a2ddbf43fbb287249d62a2e44fc4f31f6d81a';

/// Ids of items picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only
/// like everything else in the calculator -- persisting it would mean
/// adding a local-storage dependency for a convenience, and the payoff
/// is within a session anyway: building two comparable meals means
/// reaching for the same handful of items twice.

abstract class _$RecentFoodItemIds extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The ingredients of both meal options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back, which autoDispose silently wiped. Still memory-only --
/// nothing is persisted (Phase 8 plan).

@ProviderFor(MealOptions)
final mealOptionsProvider = MealOptionsProvider._();

/// The ingredients of both meal options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back, which autoDispose silently wiped. Still memory-only --
/// nothing is persisted (Phase 8 plan).
final class MealOptionsProvider
    extends $NotifierProvider<MealOptions, List<List<MealIngredient>>> {
  /// The ingredients of both meal options, indexed [optionA] / [optionB].
  ///
  /// keepAlive: an in-progress comparison must survive navigating away
  /// and back, which autoDispose silently wiped. Still memory-only --
  /// nothing is persisted (Phase 8 plan).
  MealOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealOptionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealOptionsHash();

  @$internal
  @override
  MealOptions create() => MealOptions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<MealIngredient>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<MealIngredient>>>(value),
    );
  }
}

String _$mealOptionsHash() => r'3fc9d54337bcecbe9f233c726504eae144d72c5c';

/// The ingredients of both meal options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back, which autoDispose silently wiped. Still memory-only --
/// nothing is persisted (Phase 8 plan).

abstract class _$MealOptions extends $Notifier<List<List<MealIngredient>>> {
  List<List<MealIngredient>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<List<List<MealIngredient>>, List<List<MealIngredient>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<List<MealIngredient>>,
                List<List<MealIngredient>>
              >,
              List<List<MealIngredient>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
