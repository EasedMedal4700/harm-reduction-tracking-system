import 'package:flutter/material.dart';

/// Shadow constants
class AppShadowConstants {
  AppShadowConstants._();

  static const Color shadowLight = Color(0x1A000000); // 10% opacity
  static const Color shadowDark = Color(0x66000000); // 40% opacity

  static const double blurLight = 10.0;
  static const double blurMedium = 20.0;
  static const double blurHeavy = 40.0;

  static const double glowSpread = 0.0;
  static const double glowBlur = 8.0;
  static const double glowBlurIntense = 16.0;
}

class LightShadows {
  LightShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> cardHovered = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
}

class DarkShadows {
  DarkShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> cardHovered = [
    BoxShadow(
      color: Color(0x60000000),
      blurRadius: 16,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 8,
      offset: Offset(0, 3),
      spreadRadius: 0,
    ),
  ];

  // Neon glow effects
  static List<BoxShadow> neonGlow(Color color, {double intensity = 0.4}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: AppShadowConstants.glowBlur,
        offset: Offset.zero,
        spreadRadius: AppShadowConstants.glowSpread,
      ),
    ];
  }

  static List<BoxShadow> neonGlowIntense(
    Color color, {
    double intensity = 0.6,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: AppShadowConstants.glowBlurIntense,
        offset: Offset.zero,
        spreadRadius: AppShadowConstants.glowSpread,
      ),
    ];
  }
}
