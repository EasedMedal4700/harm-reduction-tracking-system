import 'package:flutter/material.dart';

/// Typography constants and system
class AppTypographyConstants {
  AppTypographyConstants._();

  static const double fontXSmall = 12.0;
  static const double fontSmall = 14.0;
  static const double fontMedium = 16.0;
  static const double fontLarge = 18.0;
  static const double fontXLarge = 20.0;
  static const double font2XLarge = 24.0;
  static const double font3XLarge = 32.0;

  static const FontWeight fontBold = FontWeight.w700;
  static const FontWeight fontSemiBold = FontWeight.w600;
  static const FontWeight fontMediumWeight = FontWeight.w500;

  static const double lineHeightTight = 1.2;
}

/// Typography system with responsive font sizes
/// Adapts to user's font size setting
/// 
/// TODO: Typography should not decide colors.
class AppTypography {
  AppTypography._();

  /// Base font sizes (when fontSize setting = 14.0)
  static const double _baseHeading1 = 28.0;
  static const double _baseHeading2 = 24.0;
  static const double _baseHeading3 = 20.0;
  static const double _baseHeading4 = 18.0;
  static const double _baseBody = 14.0;
  static const double _baseBodySmall = 12.0;
  static const double _baseCaption = 11.0;
  static const double _baseOverline = 10.0;

  /// Calculate scaled font size based on user setting
  static double _scale(double baseSize, double userFontSize) {
    const defaultSize = 14.0;
    final scale = userFontSize / defaultSize;
    return baseSize * scale;
  }

  /// Get responsive text styles based on user's font size setting
  static TextStyles getTextStyles(double userFontSize, bool isDark) {
    final textColor = isDark 
        ? const Color(0xFFE5E7EB) 
        : const Color(0xFF1F2937);
    final textColorSecondary = isDark 
        ? const Color(0xFFB0B8C8) 
        : const Color(0xFF6B7280);
    final textColorTertiary = isDark 
        ? const Color(0xFF6B7280) 
        : const Color(0xFF9CA3AF);

    return TextStyles(
      // Headings
      heading1: TextStyle(
        fontSize: _scale(_baseHeading1, userFontSize),
        fontWeight: AppTypographyConstants.fontBold,
        color: textColor,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      heading2: TextStyle(
        fontSize: _scale(_baseHeading2, userFontSize),
        fontWeight: AppTypographyConstants.fontBold,
        color: textColor,
        letterSpacing: -0.3,
        height: 1.3,
      ),
      heading3: TextStyle(
        fontSize: _scale(_baseHeading3, userFontSize),
        fontWeight: AppTypographyConstants.fontSemiBold,
        color: textColor,
        letterSpacing: -0.2,
        height: 1.3,
      ),
      heading4: TextStyle(
        fontSize: _scale(_baseHeading4, userFontSize),
        fontWeight: AppTypographyConstants.fontSemiBold,
        color: textColor,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: _scale(_baseBodySmall, userFontSize),
        fontWeight: AppTypographyConstants.fontSemiBold,
        color: textColor,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      
      // Body text
      bodyLarge: TextStyle(
        fontSize: _scale(_baseBody + 2, userFontSize),
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.5,
      ),
      body: TextStyle(
        fontSize: _scale(_baseBody, userFontSize),
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.5,
      ),
      bodyBold: TextStyle(
        fontSize: _scale(_baseBody, userFontSize),
        fontWeight: AppTypographyConstants.fontSemiBold,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: _scale(_baseBodySmall, userFontSize),
        fontWeight: FontWeight.normal,
        color: textColorSecondary,
        height: 1.4,
      ),
      
      // Utility text
      caption: TextStyle(
        fontSize: _scale(_baseCaption, userFontSize),
        fontWeight: FontWeight.normal,
        color: textColorTertiary,
        height: 1.3,
      ),
      captionBold: TextStyle(
        fontSize: _scale(_baseCaption, userFontSize),
        fontWeight: AppTypographyConstants.fontSemiBold,
        color: textColorSecondary,
        height: 1.3,
      ),
      overline: TextStyle(
        fontSize: _scale(_baseOverline, userFontSize),
        fontWeight: AppTypographyConstants.fontMediumWeight,
        color: textColorTertiary,
        letterSpacing: 1.0,
        height: 1.2,
      ),
      
      // Button text
      button: TextStyle(
        fontSize: _scale(_baseBody, userFontSize),
        fontWeight: AppTypographyConstants.fontSemiBold,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      buttonSmall: TextStyle(
        fontSize: _scale(_baseBodySmall, userFontSize),
        fontWeight: AppTypographyConstants.fontSemiBold,
        letterSpacing: 0.5,
        height: 1.2,
      ),
      
      // Label text (same as caption but with primary text color)
      label: TextStyle(
        fontSize: _scale(_baseCaption, userFontSize),
        fontWeight: AppTypographyConstants.fontMediumWeight,
        color: textColorSecondary,
        height: 1.3,
      ),
    );
  }
}

/// Collection of text styles
class TextStyles {
  // Headings
  final TextStyle heading1;
  final TextStyle heading2;
  final TextStyle heading3;
  final TextStyle heading4;
  final TextStyle titleSmall;
  
  // Body
  final TextStyle bodyLarge;
  final TextStyle body;
  final TextStyle bodyBold;
  final TextStyle bodySmall;
  
  // Utility
  final TextStyle caption;
  final TextStyle captionBold;
  final TextStyle overline;
  final TextStyle label;
  
  // Buttons
  final TextStyle button;
  final TextStyle buttonSmall;

  const TextStyles({
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.heading4,
    required this.titleSmall,
    required this.bodyLarge,
    required this.body,
    required this.bodyBold,
    required this.bodySmall,
    required this.caption,
    required this.captionBold,
    required this.overline,
    required this.button,
    required this.buttonSmall,
    required this.label,
  });

  // Material 3 Aliases
  TextStyle get displayLarge => heading1;
  TextStyle get displayMedium => heading2;
  TextStyle get displaySmall => heading3;
  TextStyle get headlineLarge => heading2;
  TextStyle get headlineMedium => heading3;
  TextStyle get headlineSmall => heading4;
  TextStyle get titleLarge => heading4;
  TextStyle get titleMedium => bodyBold;
  // titleSmall is already defined
  TextStyle get bodyMedium => body;
  // bodyLarge is already defined
  // bodySmall is already defined
  TextStyle get labelLarge => button;
  TextStyle get labelMedium => captionBold;
  TextStyle get labelSmall => caption;
}
