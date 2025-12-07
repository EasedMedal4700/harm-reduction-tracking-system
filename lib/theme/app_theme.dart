import 'package:flutter/material.dart';
import '../constants/deprecated/ui_colors.dart';
import '../constants/deprecated/theme_constants.dart';

/// Central theme configuration for the app
/// Provides lightTheme and darkTheme with complete styling
class AppTheme {
  AppTheme._();

  // ============================================================================
  // TEXT STYLES
  // ============================================================================
  
  static TextTheme _buildTextTheme(Color textColor, Color secondaryTextColor) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: ThemeConstants.font4XLarge,
        fontWeight: ThemeConstants.fontBold,
        color: textColor,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: ThemeConstants.font3XLarge,
        fontWeight: ThemeConstants.fontBold,
        color: textColor,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontSize: ThemeConstants.font2XLarge,
        fontWeight: ThemeConstants.fontSemiBold,
        color: textColor,
        height: 1.3,
      ),
      
      // Headline styles
      headlineLarge: TextStyle(
        fontSize: ThemeConstants.fontXLarge,
        fontWeight: ThemeConstants.fontSemiBold,
        color: textColor,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: ThemeConstants.fontLarge,
        fontWeight: ThemeConstants.fontSemiBold,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: ThemeConstants.fontMedium,
        fontWeight: ThemeConstants.fontMediumWeight,
        color: textColor,
        height: 1.4,
      ),
      
      // Title styles
      titleLarge: TextStyle(
        fontSize: ThemeConstants.fontLarge,
        fontWeight: ThemeConstants.fontMediumWeight,
        color: textColor,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: ThemeConstants.fontMedium,
        fontWeight: ThemeConstants.fontMediumWeight,
        color: textColor,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: ThemeConstants.fontSmall,
        fontWeight: ThemeConstants.fontMediumWeight,
        color: textColor,
        height: 1.4,
      ),
      
      // Body styles
      bodyLarge: TextStyle(
        fontSize: ThemeConstants.fontMedium,
        fontWeight: ThemeConstants.fontRegular,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: ThemeConstants.fontSmall,
        fontWeight: ThemeConstants.fontRegular,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: ThemeConstants.fontXSmall,
        fontWeight: ThemeConstants.fontRegular,
        color: secondaryTextColor,
        height: 1.5,
      ),
      
      // Label styles
      labelLarge: TextStyle(
        fontSize: ThemeConstants.fontMedium,
        fontWeight: ThemeConstants.fontMediumWeight,
        color: textColor,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: ThemeConstants.fontSmall,
        fontWeight: ThemeConstants.fontMediumWeight,
        color: secondaryTextColor,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontSize: ThemeConstants.fontXSmall,
        fontWeight: ThemeConstants.fontMediumWeight,
        color: secondaryTextColor,
        height: 1.4,
      ),
    );
  }

  // ============================================================================
  // LIGHT THEME (Wellness / Apple Health Style)
  // ============================================================================
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: UIColors.lightFab,
        secondary: UIColors.lightAccentTeal,
        surface: UIColors.lightSurface,
        background: UIColors.lightBackground,
        error: UIColors.lightAccentRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: UIColors.lightText,
        onBackground: UIColors.lightText,
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: UIColors.lightBackground,
      
      // Text theme
      textTheme: _buildTextTheme(
        UIColors.lightText,
        UIColors.lightTextSecondary,
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: UIColors.lightText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: UIColors.lightText,
          fontSize: ThemeConstants.fontXLarge,
          fontWeight: ThemeConstants.fontSemiBold,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: UIColors.lightSurface,
        elevation: 0,
        shadowColor: UIColors.lightShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        ),
      ),
      
      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: UIColors.lightFab,
        foregroundColor: Colors.white,
        elevation: ThemeConstants.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        ),
      ),
      
      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UIColors.lightFab,
          foregroundColor: Colors.white,
          elevation: ThemeConstants.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space24,
            vertical: ThemeConstants.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
          ),
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: UIColors.lightDivider,
        thickness: 1,
        space: ThemeConstants.space16,
      ),
    );
  }

  // ============================================================================
  // DARK THEME (Futuristic / BioLevels Style)
  // ============================================================================
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: UIColors.darkNeonCyan,
        secondary: UIColors.darkNeonPurple,
        surface: UIColors.darkSurface,
        background: UIColors.darkBackground,
        error: UIColors.darkNeonOrange,
        onPrimary: UIColors.darkBackground,
        onSecondary: UIColors.darkBackground,
        onSurface: UIColors.darkText,
        onBackground: UIColors.darkText,
        onError: UIColors.darkBackground,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: UIColors.darkBackground,
      
      // Text theme
      textTheme: _buildTextTheme(
        UIColors.darkText,
        UIColors.darkTextSecondary,
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: UIColors.darkSurface,
        foregroundColor: UIColors.darkText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: UIColors.darkText,
          fontSize: ThemeConstants.fontXLarge,
          fontWeight: ThemeConstants.fontSemiBold,
        ),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        color: UIColors.darkSurface,
        elevation: 0,
        shadowColor: UIColors.darkShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.darkCardRadius),
          side: BorderSide(
            color: UIColors.darkBorder.withValues(alpha: 0.3),
            width: ThemeConstants.borderThin,
          ),
        ),
      ),
      
      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: UIColors.darkNeonCyan,
        foregroundColor: UIColors.darkBackground,
        elevation: ThemeConstants.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        ),
      ),
      
      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UIColors.darkNeonCyan,
          foregroundColor: UIColors.darkBackground,
          elevation: ThemeConstants.elevationMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space24,
            vertical: ThemeConstants.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
          ),
        ),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: UIColors.darkDivider,
        thickness: 1,
        space: ThemeConstants.space16,
      ),
    );
  }
}
