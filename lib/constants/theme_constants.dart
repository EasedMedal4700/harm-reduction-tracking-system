import 'package:flutter/material.dart';
import 'ui_colors.dart';

/// Reusable theme constants for spacing, radii, shadows, and animations
class ThemeConstants {
  ThemeConstants._();

  // ============================================================================
  // SPACING
  // ============================================================================
  
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  
  // Home Page specific spacing
  static const double homePagePadding = 20.0;
  static const double cardSpacing = 24.0; // Consistent section spacing
  static const double quickActionSpacing = 12.0;
  
  // ============================================================================
  // BORDER RADIUS
  // ============================================================================
  
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 18.0;
  static const double radiusLarge = 22.0;
  static const double radiusExtraLarge = 28.0;
  
  // Component specific radii
  static const double cardRadius = 16.0; // Glassmorphism cards
  static const double darkCardRadius = 16.0; // Dark theme cards
  static const double quickActionRadius = 16.0;
  static const double buttonRadius = 16.0;
  
  // ============================================================================
  // ICON SIZES
  // ============================================================================
  
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 40.0;
  
  // Quick Action icon size
  static const double quickActionIconSize = 28.0;
  
  // ============================================================================
  // FONT SIZES
  // ============================================================================
  
  static const double fontXSmall = 12.0;
  static const double fontSmall = 14.0;
  static const double fontMedium = 16.0;
  static const double fontLarge = 18.0;
  static const double fontXLarge = 20.0;
  static const double font2XLarge = 24.0;
  static const double font3XLarge = 28.0;
  static const double font4XLarge = 32.0;
  
  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================
  
  static const FontWeight fontLight = FontWeight.w300;
  static const FontWeight fontRegular = FontWeight.w400;
  static const FontWeight fontMediumWeight = FontWeight.w500;
  static const FontWeight fontSemiBold = FontWeight.w600;
  static const FontWeight fontBold = FontWeight.w700;
  static const FontWeight fontExtraBold = FontWeight.w800;
  
  // ============================================================================
  // ELEVATION & SHADOWS
  // ============================================================================
  
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // Light theme shadow blur
  static const double lightShadowBlur = 20.0;
  static const double lightShadowOffset = 4.0;
  
  // Dark theme glow blur
  static const double darkGlowBlur = 20.0;
  static const double darkGlowIntense = 40.0;
  
  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================
  
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 400);
  
  // ============================================================================
  // OPACITY VALUES
  // ============================================================================
  
  static const double opacityDisabled = 0.4;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.8;
  static const double opacityFull = 1.0;
  
  // Dark theme glass effect
  static const double glassOpacity = 0.7;
  static const double glowIntensity = 0.4;
  
  // ============================================================================
  // GRID LAYOUT
  // ============================================================================
  
  static const double quickActionGridSpacing = 12.0;
  static const double quickActionMinWidth = 140.0;
  static const double quickActionHeight = 120.0;
  
  // ============================================================================
  // BORDERS
  // ============================================================================
  
  static const double borderThin = 1.0;
  static const double borderMedium = 2.0;
  static const double borderThick = 3.0;
  
  // Glassmorphism constants
  static const double glassBlur = 20.0;
  static const double glassBorderOpacity = 0.08;
  static const double glassBackgroundOpacity = 0.04;
  
  // Card padding
  static const double cardPaddingSmall = 16.0;
  static const double cardPaddingMedium = 20.0;
  static const double cardPaddingLarge = 24.0;
}

// Button constants
class ButtonConstants {
  static const double buttonPaddingHorizontal = 8.0;
  static const double buttonPaddingVertical = 4.0;    // Reduced from 6.0
  static const double buttonBorderRadius = 24.0;
  static const double buttonFontSize = 14.0;          // Reduced from 12.0
  static const FontWeight buttonFontWeight = FontWeight.w600;
  
  // Colors (use from ui_colors.dart)
  static Color getPrimaryColor(bool isDark) => isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;
  static Color getSecondaryColor(bool isDark) => isDark ? UIColors.darkSurface : UIColors.lightSurface;
}