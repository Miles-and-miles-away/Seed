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

String _$mealOptionsHash() => r'3352803943f2084e32cc18f24a2f02fd077b46d0';

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
