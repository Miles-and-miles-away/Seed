import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';

// ignore_for_file: constant_identifier_names
const FOOD_ITEM_COUNT = 166;
const _ASSET_PATH = 'data/app/food_items.json';

/// Loads all food items from the bundled JSON asset.
///
/// The asset also carries a `metadata` block (scope statement, primary
/// source), which nothing reads: the methodology screen derives its
/// source list from the items themselves.
Future<List<FoodItem>> loadFoodItems() =>
    loadJsonListUnder(_ASSET_PATH, 'items', FoodItem.fromJson);
