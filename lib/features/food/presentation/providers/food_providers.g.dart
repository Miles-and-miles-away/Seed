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

/// Ephemeral meal ingredients for the builder screen.
///
/// autoDispose by design: meals are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the meal.

@ProviderFor(MealBuilder)
final mealBuilderProvider = MealBuilderProvider._();

/// Ephemeral meal ingredients for the builder screen.
///
/// autoDispose by design: meals are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the meal.
final class MealBuilderProvider
    extends $NotifierProvider<MealBuilder, List<MealIngredient>> {
  /// Ephemeral meal ingredients for the builder screen.
  ///
  /// autoDispose by design: meals are screen state, never persisted
  /// (Phase 8 plan), so leaving the calculator resets the meal.
  MealBuilderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealBuilderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealBuilderHash();

  @$internal
  @override
  MealBuilder create() => MealBuilder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MealIngredient> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MealIngredient>>(value),
    );
  }
}

String _$mealBuilderHash() => r'336099ab617ff4cff09671724ff516d0c451f3b6';

/// Ephemeral meal ingredients for the builder screen.
///
/// autoDispose by design: meals are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the meal.

abstract class _$MealBuilder extends $Notifier<List<MealIngredient>> {
  List<MealIngredient> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<MealIngredient>, List<MealIngredient>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<MealIngredient>, List<MealIngredient>>,
              List<MealIngredient>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Snapshotted meals staged for side-by-side comparison (8.9).
///
/// autoDispose like [MealBuilder]: comparisons are ephemeral screen
/// state, never persisted (Phase 8 plan).

@ProviderFor(MealComparison)
final mealComparisonProvider = MealComparisonProvider._();

/// Snapshotted meals staged for side-by-side comparison (8.9).
///
/// autoDispose like [MealBuilder]: comparisons are ephemeral screen
/// state, never persisted (Phase 8 plan).
final class MealComparisonProvider
    extends $NotifierProvider<MealComparison, List<List<MealIngredient>>> {
  /// Snapshotted meals staged for side-by-side comparison (8.9).
  ///
  /// autoDispose like [MealBuilder]: comparisons are ephemeral screen
  /// state, never persisted (Phase 8 plan).
  MealComparisonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mealComparisonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mealComparisonHash();

  @$internal
  @override
  MealComparison create() => MealComparison();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<MealIngredient>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<MealIngredient>>>(value),
    );
  }
}

String _$mealComparisonHash() => r'22ee41284b983152a2dbed690726490fe249e3eb';

/// Snapshotted meals staged for side-by-side comparison (8.9).
///
/// autoDispose like [MealBuilder]: comparisons are ephemeral screen
/// state, never persisted (Phase 8 plan).

abstract class _$MealComparison extends $Notifier<List<List<MealIngredient>>> {
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
