import 'package:flutter/material.dart';

/// Central constants for spacing, radii, shadows, and layout
/// Used across both light and dark themes for consistency
class AppThemeConstants {
  AppThemeConstants._();

  // ============================================================================
  // SPACING
  // ============================================================================
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 24.0;
  static const double space2xl = 32.0;
  static const double space3xl = 48.0;

  // Compact mode spacing (reduced by 25%)
  static const double spaceXsCompact = 3.0;
  static const double spaceSmCompact = 6.0;
  static const double spaceMdCompact = 9.0;
  static const double spaceLgCompact = 12.0;
  static const double spaceXlCompact = 18.0;
  static const double space2xlCompact = 24.0;
  static const double space3xlCompact = 36.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 999.0;

  // ============================================================================
  // CARD DIMENSIONS
  // ============================================================================
  static const double cardElevation = 4.0;
  static const double cardElevationHovered = 8.0;
  static const double cardPadding = 16.0;
  static const double cardPaddingCompact = 12.0;
  static const double cardMargin = 12.0;
  static const double cardMarginCompact = 8.0;

  // ============================================================================
  // ICON SIZES
  // ============================================================================
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double icon2xl = 64.0;

  // ============================================================================
  // BUTTON SIZES
  // ============================================================================
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  static const double buttonPaddingHorizontal = 24.0;

  // ============================================================================
  // ANIMATIONS
  // ============================================================================
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  static const Curve animationCurve = Curves.easeInOut;
  static const Curve animationCurveEmphasized = Curves.easeOutCubic;

  // ============================================================================
  // BLUR
  // ============================================================================
  static const double blurLight = 10.0;
  static const double blurMedium = 20.0;
  static const double blurHeavy = 40.0;

  // ============================================================================
  // GLOW/NEON EFFECTS (for dark theme)
  // ============================================================================
  static const double glowSpread = 0.0;
  static const double glowBlur = 8.0;
  static const double glowBlurIntense = 16.0;
}

/// Light theme shadows
class LightShadows {
  LightShadows._();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> cardShadowHovered = [
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

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
}

/// Dark theme shadows (with subtle glow effects)
class DarkShadows {
  DarkShadows._();

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> cardShadowHovered = [
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

  static const List<BoxShadow> buttonShadow = [
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
        color: color.withOpacity(intensity),
        blurRadius: AppThemeConstants.glowBlur,
        offset: Offset.zero,
        spreadRadius: AppThemeConstants.glowSpread,
      ),
    ];
  }

  static List<BoxShadow> neonGlowIntense(Color color, {double intensity = 0.6}) {
    return [
      BoxShadow(
        color: color.withOpacity(intensity),
        blurRadius: AppThemeConstants.glowBlurIntense,
        offset: Offset.zero,
        spreadRadius: AppThemeConstants.glowSpread,
      ),
    ];
  }
}
