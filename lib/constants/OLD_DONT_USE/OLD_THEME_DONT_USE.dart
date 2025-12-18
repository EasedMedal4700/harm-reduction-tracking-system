import 'package:flutter/material.dart';

/// Central constants for spacing, radii, shadows, and layout
/// Used across both light and dark themes for consistency
/// 
/// DEPRECATED: Use AppThemeX extension on BuildContext instead.
/// This file is kept for legacy compatibility and will be removed.
class AppThemeConstants {
  AppThemeConstants._();

  // ============================================================================
  // LEGACY COMPATIBILITY (for old widgets)
  // ============================================================================
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 3.0;

  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double cardRadius = 16.0;

  static const double fontXSmall = 12.0;
  static const double fontSmall = 14.0;
  static const double fontMedium = 16.0;
  static const double fontLarge = 18.0;
  static const double fontXLarge = 20.0;
  static const FontWeight fontBold = FontWeight.w700;
  static const FontWeight fontSemiBold = FontWeight.w600;
  static const double font2XLarge = 24.0;
  static const double font3XLarge = 32.0;
  static const FontWeight fontMediumWeight = FontWeight.w500;

  static const double cardPaddingMedium = 16.0;
  
  // ============================================================================
  // ANIMATIONS (Legacy)
  // ============================================================================
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration durationToast = Duration(seconds: 3);
  
  // ============================================================================
  // ICON SIZES (Legacy)
  // ============================================================================
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  static const double icon2xl = 64.0;

  // ============================================================================
  // RESTORED LEGACY CONSTANTS (Deprecated)
  // ============================================================================
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 16.0;
  static const double spaceXl = 24.0;
  static const double space2xl = 32.0;
  static const double space3xl = 48.0;
  
  static const double cardPadding = 16.0;
  static const double cardPaddingCompact = 12.0;
  static const double cardMargin = 12.0;
  static const double cardMarginCompact = 8.0;

  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 999.0;

  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  static const double opacityDisabled = 0.38;
  static const double opacityVeryLow = 0.12;
  static const double opacityBorder = 0.4;
  static const double opacitySlow = 0.5;
  static const double opacityLow = 0.15;
  static const double opacityMedium = 0.3;
  static const double opacityHigh = 0.6;
  static const double opacityVeryHigh = 0.8;
  static const double opacityOverlay = 0.1;
}

typedef ThemeConstants = AppThemeConstants;

