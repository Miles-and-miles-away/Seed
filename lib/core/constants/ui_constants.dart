// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';

/// Spacing scale used for SizedBox, EdgeInsets, and gaps.
abstract final class Spacing {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const huge = 48.0;
}

/// Border radius values for cards, dialogs, and containers.
abstract final class Radii {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;

  static final borderXs = BorderRadius.circular(xs);
  static final borderSm = BorderRadius.circular(sm);
  static final borderMd = BorderRadius.circular(md);
  static final borderLg = BorderRadius.circular(lg);
  static final borderXl = BorderRadius.circular(xl);
  static final borderXxl = BorderRadius.circular(xxl);
}

/// Animation durations for transitions and celebrations.
abstract final class Durations {
  static const instant = Duration(milliseconds: 100);
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 300);
  static const emphasis = Duration(milliseconds: 400);
  static const slow = Duration(milliseconds: 500);
  static const slower = Duration(milliseconds: 600);
  static const reveal = Duration(milliseconds: 800);
  static const celebration = Duration(milliseconds: 1200);
  static const showcase = Duration(milliseconds: 1500);
  static const particleLoop = Duration(seconds: 3);
  static const glowLoop = Duration(seconds: 2);
}

/// Opacity values for visual hierarchy.
abstract final class Opacities {
  static const veryFaint = 0.08;
  static const faint = 0.1;
  static const subtle = 0.15;
  static const light = 0.2;
  static const muted = 0.3;
  static const disabled = 0.38;
  static const medium = 0.4;
  static const half = 0.5;
  static const moderate = 0.6;
  static const strong = 0.7;
  static const heavy = 0.8;
  static const nearOpaque = 0.85;
}
