import 'package:flutter/material.dart';

/// App color palette
/// Sustainability-themed colors (earthy greens, natural tones)
abstract class AppColors {
  // Primary brand color (seed/plant green)
  static const primary = Color(0xFF2E7D32); // Green 800

  // SDG colors live in data/app/sdg_goals.json (surfaced via the SDG
  // provider) -- a palette copy here drifted from the JSON and was
  // removed. The Material scheme derives from `primary` via
  // ColorScheme.fromSeed.

  // Theme seed per mascot species id (data/app/mascot_species.json).
  // The active species re-seeds the whole ColorScheme; unknown or no
  // species falls back to [primary]. 'fungi' is pre-registered for
  // the planned third species.
  static const speciesThemeSeeds = <String, Color>{
    'seed': primary,
    'coral': Color(0xFF4FC3F7), // light ocean blue
    'fungi': Color(0xFFA1887F), // light chocolate brown
  };

  // Action category colors
  static const categoryRecycling = Color(0xFF4CAF50);
  static const categoryTransport = Color(0xFF2196F3);
  static const categoryFood = Color(0xFFFF9800);
  static const categoryEnergy = Color(0xFFFFC107);
  static const categoryConsumption = Color(0xFF9C27B0);
  static const categoryWater = Color(0xFF00BCD4);
  static const categoryCommunity = Color(0xFF8D6E63);
  static const categoryAdvocacy = Color(0xFFE91E63);
  static const categoryLearning = Color(0xFF607D8B);

  // Semantic colors
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);
  static const streak = Color(0xFFFF9800);

  // Special effect / celebration colors
  static const gold = Color(0xFFFFD700);
  static const celebrationOrange = Color(0xFFFFA500);
  static const celebrationPink = Color(0xFFFF69B4);
  static const glowBlue = Color(0xFF90CAF9);
  static const eggBeige = Color(0xFFF5F5DC);
  static const sunYellow = Color(0xFFFFEB3B);
  static const sunAmber = Color(0xFFFFC107);
  static const sunOrange = Color(0xFFFF9800);

  // Mascot glow colors
  static const glowEarth = Color(0xFF8B6F47);
  static const glowFresh = Color(0xFF8BC34A);
  static const glowVibrant = Color(0xFF4CAF50);

  // Neutral palette (full Material grey ramp). Not every shade is
  // referenced yet -- kept as the available design-system tokens so
  // new UI can pick from a consistent set rather than inventing greys.
  static const neutral50 = Color(0xFFFAFAFA);
  static const neutral100 = Color(0xFFF5F5F5);
  static const neutral200 = Color(0xFFEEEEEE);
  static const neutral300 = Color(0xFFE0E0E0);
  static const neutral400 = Color(0xFFBDBDBD);
  static const neutral500 = Color(0xFF9E9E9E);
  static const neutral600 = Color(0xFF757575);
  static const neutral700 = Color(0xFF616161);
  static const neutral800 = Color(0xFF424242);
  static const neutral900 = Color(0xFF212121);
}
