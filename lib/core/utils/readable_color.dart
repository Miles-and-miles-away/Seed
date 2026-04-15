import 'dart:math' as math;
import 'dart:ui';

const double _kWcagAaContrast = 4.5;
const double _kLightnessStep = 0.02;
const int _kMaxSteps = 50;

/// Returns [brand] adjusted in HSL lightness until it meets [minContrast]
/// against [surface] (defaults to WCAG AA for body text, 4.5:1).
///
/// Why: official palette colors (SDG, action category) include low-luminance
/// yellows that fail contrast as link/text on light surfaces. Keep the brand
/// hue for badges/icons and run text usages through this helper.
Color readableOn(
  Color brand,
  Color surface, {
  double minContrast = _kWcagAaContrast,
}) {
  if (_contrast(brand, surface) >= minContrast) return brand;

  final brandLuma = _relativeLuminance(brand);
  final surfaceLuma = _relativeLuminance(surface);
  final shouldDarken = surfaceLuma > brandLuma;

  var hsl = _HslColor.fromColor(brand);
  for (var i = 0; i < _kMaxSteps; i++) {
    final next =
        hsl.lightness + (shouldDarken ? -_kLightnessStep : _kLightnessStep);
    if (next <= 0 || next >= 1) break;
    hsl = hsl.withLightness(next);
    final candidate = hsl.toColor();
    if (_contrast(candidate, surface) >= minContrast) return candidate;
  }
  return hsl.toColor();
}

double _contrast(Color a, Color b) {
  final la = _relativeLuminance(a);
  final lb = _relativeLuminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

double _relativeLuminance(Color c) {
  return 0.2126 * _channel(c.r) +
      0.7152 * _channel(c.g) +
      0.0722 * _channel(c.b);
}

double _channel(double v) {
  return v <= 0.03928
      ? v / 12.92
      : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
}

class _HslColor {
  const _HslColor(this.hue, this.saturation, this.lightness, this.alpha);

  factory _HslColor.fromColor(Color color) {
    final r = color.r;
    final g = color.g;
    final b = color.b;
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;
    final lightness = (max + min) / 2;

    double hue;
    double saturation;
    if (delta == 0) {
      hue = 0;
      saturation = 0;
    } else {
      saturation =
          lightness < 0.5 ? delta / (max + min) : delta / (2 - max - min);
      if (max == r) {
        hue = ((g - b) / delta) % 6;
      } else if (max == g) {
        hue = (b - r) / delta + 2;
      } else {
        hue = (r - g) / delta + 4;
      }
      hue *= 60;
      if (hue < 0) hue += 360;
    }
    return _HslColor(hue, saturation, lightness, color.a);
  }

  final double hue;
  final double saturation;
  final double lightness;
  final double alpha;

  _HslColor withLightness(double value) {
    return _HslColor(hue, saturation, value.clamp(0.0, 1.0), alpha);
  }

  Color toColor() {
    if (saturation == 0) {
      return Color.from(
        alpha: alpha,
        red: lightness,
        green: lightness,
        blue: lightness,
      );
    }
    final q = lightness < 0.5
        ? lightness * (1 + saturation)
        : lightness + saturation - lightness * saturation;
    final p = 2 * lightness - q;
    final hk = hue / 360;
    return Color.from(
      alpha: alpha,
      red: _hueToRgb(p, q, hk + 1 / 3),
      green: _hueToRgb(p, q, hk),
      blue: _hueToRgb(p, q, hk - 1 / 3),
    );
  }

  static double _hueToRgb(double p, double q, double t) {
    var tt = t;
    if (tt < 0) tt += 1;
    if (tt > 1) tt -= 1;
    if (tt < 1 / 6) return p + (q - p) * 6 * tt;
    if (tt < 1 / 2) return q;
    if (tt < 2 / 3) return p + (q - p) * (2 / 3 - tt) * 6;
    return p;
  }
}
