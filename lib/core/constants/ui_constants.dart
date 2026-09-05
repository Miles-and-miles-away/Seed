import 'package:flutter/material.dart';

// Spacing scale used for SizedBox, EdgeInsets, and gaps.
const double spacingXxs = 2;
const double spacingXs = 4;
const double spacingSm = 8;
const double spacingMd = 12;
const double spacingLg = 16;
const double spacingXl = 20;
const double spacingXxl = 24;
const double spacingXxxl = 32;
const double spacingHuge = 48;

// Border radius values for cards, dialogs, and containers.
const double radiusXs = 4;
const double radiusSm = 8;
const double radiusMd = 12;
const double radiusLg = 16;
const double radiusXl = 20;
const double radiusXxl = 24;

final BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
final BorderRadius borderRadiusXxl = BorderRadius.circular(radiusXxl);

// Bottom-sheet chrome shared by every modal sheet in the app.
const sheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
);
const double sheetMaxChildSize = 0.85;
const double sheetMinChildSize = 0.3;

// Animation durations for transitions and celebrations.
const durationInstant = Duration(milliseconds: 100);
const durationFast = Duration(milliseconds: 200);
const durationNormal = Duration(milliseconds: 300);
const durationEmphasis = Duration(milliseconds: 400);
const durationSlow = Duration(milliseconds: 500);
const durationSlower = Duration(milliseconds: 600);
const durationReveal = Duration(milliseconds: 800);
const durationCelebration = Duration(milliseconds: 1200);
const durationShowcase = Duration(milliseconds: 1500);
const durationParticleLoop = Duration(seconds: 3);
const durationGlowLoop = Duration(seconds: 2);

// Opacity values for visual hierarchy.
const double opacityVeryFaint = 0.08;
const double opacityFaint = 0.1;
const double opacitySubtle = 0.15;
const double opacityLight = 0.2;
const double opacityMuted = 0.3;
const double opacityDisabled = 0.38;
const double opacityMedium = 0.4;
const double opacityHalf = 0.5;
const double opacityModerate = 0.6;
const double opacityStrong = 0.7;
const double opacityHeavy = 0.8;
const double opacityNearOpaque = 0.85;
