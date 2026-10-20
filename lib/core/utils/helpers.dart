import 'dart:math';

import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Calculate level from total points
/// Uses scaling formula: each level requires more points than the last
int calculateLevel(int totalPoints) {
  if (totalPoints <= 0) return 1;

  var level = 1;
  var pointsNeeded = 0;

  while (pointsNeeded <= totalPoints) {
    level++;
    pointsNeeded = calculatePointsForLevel(level);
  }

  return level - 1;
}

/// Calculate total points needed to reach a specific level
int calculatePointsForLevel(int level) {
  if (level <= 1) return 0;

  final base = AppConstants.pointsPerLevel.toDouble();
  final scale = AppConstants.levelScalingFactor;

  // Sum of geometric series
  double total = 0;
  for (var i = 1; i < level; i++) {
    total += base * pow(scale, i - 1);
  }

  return total.round();
}

/// Calculate points remaining to next level
int calculatePointsToNextLevel(int totalPoints) {
  final currentLevel = calculateLevel(totalPoints);
  final pointsForNext = calculatePointsForLevel(currentLevel + 1);
  return pointsForNext - totalPoints;
}

/// Calculate progress percentage to next level (0.0 to 1.0)
double calculateLevelProgress(int totalPoints) {
  final currentLevel = calculateLevel(totalPoints);
  final pointsForCurrent = calculatePointsForLevel(currentLevel);
  final pointsForNext = calculatePointsForLevel(currentLevel + 1);

  final progressPoints = totalPoints - pointsForCurrent;
  final levelRange = pointsForNext - pointsForCurrent;

  if (levelRange <= 0) return 1;

  return (progressPoints / levelRange).clamp(0.0, 1.0);
}

/// Joins a value to its unit so a line never breaks between them.
const unitSpace = '\u00A0';

/// [value] in [locale]'s number style: grouping, decimal separator, and
/// between [minDigits] and [maxDigits] fraction digits.
String formatDecimal(
  num value,
  String locale, {
  required int maxDigits,
  int minDigits = 0,
}) {
  final format = NumberFormat.decimalPattern(locale)
    ..minimumFractionDigits = minDigits
    ..maximumFractionDigits = maxDigits;
  return format.format(value);
}

/// CO2 in compact form: "3.4 t", "1.2 kg", "500 g" (separators per
/// [locale], [unitSpace] before the unit).
String formatCO2Compact(int grams, String locale) {
  String oneDecimal(num v) =>
      formatDecimal(v, locale, minDigits: 1, maxDigits: 1);
  // Pick the unit after rounding, so 999950 g reads "1.0 t", not "1000.0 kg".
  final tenthsOfKg = (grams / 100).round();
  if (tenthsOfKg >= 10000) return '${oneDecimal(grams / 1000000)}${unitSpace}t';
  if (grams >= 1000) return '${oneDecimal(grams / 1000)}${unitSpace}kg';
  return '${formatDecimal(grams, locale, maxDigits: 0)}${unitSpace}g';
}

/// Points in [locale]'s compact notation ("1.2K", "1,2 mil", "1.2万").
String formatPoints(int points, String locale) =>
    NumberFormat.compact(locale: locale).format(points);

final _unitAfterNumber = RegExp(
  r'(\d) (g|kg|ml|L|km|h|min|kWh|W|lm|°C|C|%)(?![\p{L}\p{N}])',
  unicode: true,
);

/// [text] with [unitSpace] between each number and the unit after it, so
/// "15 ml" in data strings never splits across lines.
String keepUnitsTogether(String text) =>
    text.replaceAllMapped(_unitAfterNumber, (m) => '${m[1]}$unitSpace${m[2]}');

/// Accent-insensitive, case-insensitive key for search matching.
///
/// A Spanish user types "platano", not "plátano", and "jalapeno" for
/// "jalapeño" -- without folding, the two most common ES queries miss.
/// The same holds for place names: nobody types "São Paulo" or
/// "Zürich" on a phone keyboard, so [_diacritics] covers every mark
/// the Latin-script food and city names carry, English and Spanish
/// alike. Japanese names carry no marks and are matched as typed.
String foldForSearch(String value) {
  final buffer = StringBuffer();
  for (final rune in value.toLowerCase().runes) {
    buffer.write(_diacritics[rune] ?? String.fromCharCode(rune));
  }
  return buffer.toString();
}

const _diacritics = <int, String>{
  0xE1: 'a', 0xE0: 'a', 0xE2: 'a', 0xE4: 'a', 0xE3: 'a', // á à â ä ã
  0xE5: 'a', 0x101: 'a', 0x103: 'a', 0x1EA7: 'a', // å ā ă ầ
  0xE9: 'e', 0xE8: 'e', 0xEA: 'e', 0xEB: 'e', // é è ê ë
  0x113: 'e', 0x117: 'e', 0x1EBF: 'e', // ē ė ế
  0xED: 'i', 0xEC: 'i', 0xEE: 'i', 0xEF: 'i', 0x12B: 'i', // í ì î ï ī
  0xF3: 'o', 0xF2: 'o', 0xF4: 'o', 0xF6: 'o', 0xF5: 'o', // ó ò ô ö õ
  0x14D: 'o', 0x14F: 'o', 0x1A1: 'o', // ō ŏ ơ
  0xFA: 'u', 0xF9: 'u', 0xFB: 'u', 0xFC: 'u', // ú ù û ü
  0x16B: 'u', 0x16D: 'u', // ū ŭ
  0xE7: 'c', 0x107: 'c', 0x10D: 'c', // ç ć č
  0xF0: 'd', 0x142: 'l', 0xE6: 'ae', // ð ł æ
  0x127: 'h', 0x1E29: 'h', 0x1E96: 'h', // ħ ḩ ẖ
  0xF1: 'n', 0x144: 'n', // ñ ń
  0x15F: 's', 0x161: 's', 0x219: 's', // ş š ș
  0x163: 't', 0x21B: 't', // ţ ț
  0xFD: 'y', // ý
  0x17A: 'z', 0x17E: 'z', // ź ž
  // Dropped, not folded: Dart lowercases İ to "i" plus a combining
  // dot, and "Nampo" has to reach "Namp’o".
  0x307: '', 0x327: '', 0x2018: '', 0x2019: '',
};
