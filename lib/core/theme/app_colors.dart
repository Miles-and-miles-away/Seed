import 'package:flutter/material.dart';

/// App color palette
/// Sustainability-themed colors (earthy greens, natural tones)
abstract class AppColors {
  // Primary brand color (seed/plant green)
  static const primary = Color(0xFF2E7D32); // Green 800
  static const primaryLight = Color(0xFF60AD5E);
  static const primaryDark = Color(0xFF005005);

  // Secondary accent (earth/soil brown)
  static const secondary = Color(0xFF795548); // Brown 500
  static const secondaryLight = Color(0xFFA98274);
  static const secondaryDark = Color(0xFF4B2C20);

  // SDG-inspired category colors
  static const sdgPoverty = Color(0xFFE5243B); // SDG 1
  static const sdgHunger = Color(0xFFDDA63A); // SDG 2
  static const sdgHealth = Color(0xFF4C9F38); // SDG 3
  static const sdgEducation = Color(0xFFC5192D); // SDG 4
  static const sdgGender = Color(0xFFFF3A21); // SDG 5
  static const sdgWater = Color(0xFF26BDE2); // SDG 6
  static const sdgEnergy = Color(0xFFFCC30B); // SDG 7
  static const sdgWork = Color(0xFFA21942); // SDG 8
  static const sdgIndustry = Color(0xFFFD6925); // SDG 9
  static const sdgInequality = Color(0xFFDD1367); // SDG 10
  static const sdgCities = Color(0xFFFD9D24); // SDG 11
  static const sdgConsumption = Color(0xFFBF8B2E); // SDG 12
  static const sdgClimate = Color(0xFF3F7E44); // SDG 13
  static const sdgOceans = Color(0xFF0A97D9); // SDG 14
  static const sdgLand = Color(0xFF56C02B); // SDG 15
  static const sdgPeace = Color(0xFF00689D); // SDG 16
  static const sdgPartnership = Color(0xFF19486A); // SDG 17

  // Action category colors
  static const categoryRecycling = Color(0xFF4CAF50);
  static const categoryTransport = Color(0xFF2196F3);
  static const categoryFood = Color(0xFFFF9800);
  static const categoryEnergy = Color(0xFFFFC107);
  static const categoryConsumption = Color(0xFF9C27B0);
  static const categoryWater = Color(0xFF00BCD4);

  // Semantic colors
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);

  // Neutral palette
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
