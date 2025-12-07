import 'package:flutter/material.dart';
import '../constants/deprecated/ui_colors.dart';
import '../constants/deprecated/theme_constants.dart';
import '../constants/theme/app_theme_constants.dart';
import '../constants/colors/app_colors_light.dart';
import '../constants/colors/app_colors_dark.dart';
import '../constants/theme/app_typography.dart';
import '../models/app_settings_model.dart';

/// Main theme data class that provides all styling based on user settings
/// Combines the simplicity of direct ThemeData with advanced theming capabilities
class AppTheme {
  final bool isDark;
  final double fontSize;
  final bool compactMode;

  late final AccentColors accent;
  late final TextStyles typography;
  late final ColorPalette colors;
  late final Spacing spacing;
  late final List<BoxShadow> cardShadow;
  late final List<BoxShadow> cardShadowHovered;
  late final List<BoxShadow> buttonShadow;

  AppTheme._({
    required this.isDark,
    required this.fontSize,
    required this.compactMode,
  }) {
    accent = isDark ? _buildDarkAccent() : _buildLightAccent();
    typography = AppTypography.getTextStyles(fontSize, isDark);
    colors = isDark ? _buildDarkColors() : _buildLightColors();
    spacing = compactMode ? _buildCompactSpacing() : _buildNormalSpacing();

    if (isDark) {
      cardShadow = DarkShadows.cardShadow;
      cardShadowHovered = DarkShadows.cardShadowHovered;
      buttonShadow = DarkShadows.buttonShadow;
    } else {
      cardShadow = LightShadows.cardShadow;
      cardShadowHovered = LightShadows.cardShadowHovered;
      buttonShadow = LightShadows.buttonShadow;
    }
  }

  /// Create light theme (wellness-focused, inviting)
  factory AppTheme.light({
    double fontSize = 14.0,
    bool compactMode = false,
  }) {
    return AppTheme._(
      isDark: false,
      fontSize: fontSize,
      compactMode: compactMode,
    );
  }

  /// Create dark theme (futuristic, neon-accented)
  factory AppTheme.dark({
    double fontSize = 14.0,
    bool compactMode = false,
  }) {
    return AppTheme._(
      isDark: true,
      fontSize: fontSize,
      compactMode: compactMode,
    );
  }

  /// Create theme from app settings
  factory AppTheme.fromSettings(AppSettings settings) {
    if (settings.darkMode) {
      return AppTheme.dark(
        fontSize: settings.fontSize,
        compactMode: settings.compactMode,
      );
    } else {
      return AppTheme.light(
        fontSize: settings.fontSize,
        compactMode: settings.compactMode,
      );
    }
  }

  AccentColors _buildLightAccent() {
    return const AccentColors(
      primary: AppColorsLight.accentPrimary,
      primaryVariant: AppColorsLight.accentPrimaryVariant,
      secondary: AppColorsLight.accentSecondary,
      gradient: AppColorsLight.accentGradient,
    );
  }

  AccentColors _buildDarkAccent() {
    return const AccentColors(
      primary: AppColorsDark.accentPrimary,
      primaryVariant: AppColorsDark.accentPrimaryVariant,
      secondary: AppColorsDark.accentSecondary,
      gradient: AppColorsDark.accentGradient,
    );
  }

  ColorPalette _buildLightColors() {
    return const ColorPalette(
      background: AppColorsLight.background,
      surface: AppColorsLight.surface,
      surfaceVariant: AppColorsLight.surfaceVariant,
      border: AppColorsLight.border,
      divider: AppColorsLight.divider,
      textPrimary: AppColorsLight.textPrimary,
      textSecondary: AppColorsLight.textSecondary,
      textTertiary: AppColorsLight.textTertiary,
      textInverse: AppColorsLight.textInverse,
      success: AppColorsLight.success,
      warning: AppColorsLight.warning,
      error: AppColorsLight.error,
      info: AppColorsLight.info,
      overlay: AppColorsLight.overlay,
      overlayHeavy: AppColorsLight.overlayHeavy,
    );
  }

  ColorPalette _buildDarkColors() {
    return const ColorPalette(
      background: AppColorsDark.background,
      surface: AppColorsDark.surface,
      surfaceVariant: AppColorsDark.surfaceVariant,
      border: AppColorsDark.border,
      divider: AppColorsDark.divider,
      textPrimary: AppColorsDark.textPrimary,
      textSecondary: AppColorsDark.textSecondary,
      textTertiary: AppColorsDark.textTertiary,
      textInverse: AppColorsDark.textInverse,
      success: AppColorsDark.success,
      warning: AppColorsDark.warning,
      error: AppColorsDark.error,
      info: AppColorsDark.info,
      overlay: AppColorsDark.overlay,
      overlayHeavy: AppColorsDark.overlayHeavy,
    );
  }

  Spacing _buildNormalSpacing() {
    return const Spacing(
      xs: AppThemeConstants.spaceXs,
      sm: AppThemeConstants.spaceSm,
      md: AppThemeConstants.spaceMd,
      lg: AppThemeConstants.spaceLg,
      xl: AppThemeConstants.spaceXl,
      xl2: AppThemeConstants.space2xl,
      xl3: AppThemeConstants.space3xl,
      cardPadding: AppThemeConstants.cardPadding,
      cardMargin: AppThemeConstants.cardMargin,
    );
  }

  Spacing _buildCompactSpacing() {
    return const Spacing(
      xs: AppThemeConstants.spaceXsCompact,
      sm: AppThemeConstants.spaceSmCompact,
      md: AppThemeConstants.spaceMdCompact,
      lg: AppThemeConstants.spaceLgCompact,
      xl: AppThemeConstants.spaceXlCompact,
      xl2: AppThemeConstants.space2xlCompact,
      xl3: AppThemeConstants.space3xlCompact,
      cardPadding: AppThemeConstants.cardPaddingCompact,
      cardMargin: AppThemeConstants.cardMarginCompact,
    );
  }

  /// Get neon glow for dark theme
  List<BoxShadow> getNeonGlow({double intensity = 0.4}) {
    if (!isDark) return [];
    return DarkShadows.neonGlow(accent.primary, intensity: intensity);
  }

  /// Get intense neon glow for dark theme
  List<BoxShadow> getNeonGlowIntense({double intensity = 0.6}) {
    if (!isDark) return [];
    return DarkShadows.neonGlowIntense(accent.primary, intensity: intensity);
  }

  /// Build card decoration with theme-aware styling
  BoxDecoration cardDecoration({
    bool hovered = false,
    bool neonBorder = false,
    Color? customBackground,
  }) {
    return BoxDecoration(
      color: customBackground ?? colors.surface,
      borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
      border: neonBorder && isDark
          ? Border.all(color: accent.primary.withOpacity(0.5), width: 1)
          : Border.all(color: colors.border, width: 1),
      boxShadow: [
        ...(hovered ? cardShadowHovered : cardShadow),
        if (neonBorder && isDark) ...getNeonGlow(intensity: 0.3),
      ],
    );
  }

  /// Build gradient card decoration (for hero cards)
  BoxDecoration gradientCardDecoration({
    bool hovered = false,
    bool useAccentGradient = false,
  }) {
    final gradient = useAccentGradient
        ? accent.gradient
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    colors.surfaceVariant,
                    colors.surface,
                  ]
                : [
                    colors.surface,
                    colors.surfaceVariant,
                  ],
          );

    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
      border: isDark
          ? Border.all(color: accent.primary.withOpacity(0.3), width: 1)
          : null,
      boxShadow: [
        ...(hovered ? cardShadowHovered : cardShadow),
        if (isDark) ...getNeonGlow(intensity: 0.2),
      ],
    );
  }

  /// Build glassmorphic decoration (primarily for dark theme)
  BoxDecoration glassmorphicDecoration({Color? tintColor}) {
    return BoxDecoration(
      color: isDark
          ? colors.surface.withOpacity(0.6)
          : colors.surface.withOpacity(0.8),
      borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
      border: Border.all(
        color: isDark
            ? colors.border.withOpacity(0.3)
            : colors.border,
        width: 1,
      ),
      boxShadow: cardShadow,
    );
  }

  // ============================================================================
  // LEGACY THEME DATA METHODS (for backward compatibility)
  // ============================================================================

  /// Get the complete ThemeData for MaterialApp
  ThemeData get themeData {
    return isDark ? _buildDarkThemeData() : _buildLightThemeData();
  }

  ThemeData _buildLightThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: accent.primary,
        secondary: accent.secondary,
        surface: colors.surface,
        background: colors.background,
        error: colors.error,
        onPrimary: colors.textInverse,
        onSecondary: colors.textInverse,
        onSurface: colors.textPrimary,
        onBackground: colors.textPrimary,
        onError: colors.textInverse,
      ),

      // Scaffold
      scaffoldBackgroundColor: colors.background,

      // Text theme
      textTheme: _buildTextTheme(colors.textPrimary, colors.textSecondary),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: ThemeConstants.fontXLarge,
          fontWeight: ThemeConstants.fontSemiBold,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shadowColor: UIColors.lightShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        ),
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent.primary,
        foregroundColor: colors.textInverse,
        elevation: ThemeConstants.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent.primary,
          foregroundColor: colors.textInverse,
          elevation: ThemeConstants.elevationLow,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xl,
            vertical: spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
          ),
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: spacing.md,
      ),
    );
  }

  ThemeData _buildDarkThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: accent.primary,
        secondary: accent.secondary,
        surface: colors.surface,
        background: colors.background,
        error: colors.error,
        onPrimary: colors.textInverse,
        onSecondary: colors.textInverse,
        onSurface: colors.textPrimary,
        onBackground: colors.textPrimary,
        onError: colors.textInverse,
      ),

      // Scaffold
      scaffoldBackgroundColor: colors.background,

      // Text theme
      textTheme: _buildTextTheme(colors.textPrimary, colors.textSecondary),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: ThemeConstants.fontXLarge,
          fontWeight: ThemeConstants.fontSemiBold,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shadowColor: UIColors.darkShadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.darkCardRadius),
          side: BorderSide(
            color: colors.border.withOpacity(0.3),
            width: ThemeConstants.borderThin,
          ),
        ),
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent.primary,
        foregroundColor: colors.textInverse,
        elevation: ThemeConstants.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent.primary,
          foregroundColor: colors.textInverse,
          elevation: ThemeConstants.elevationMedium,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xl,
            vertical: spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
          ),
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: spacing.md,
      ),
    );
  }

  TextTheme _buildTextTheme(Color textColor, Color secondaryTextColor) {
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
  // STATIC METHODS (for backward compatibility)
  // ============================================================================

  /// Get light theme (legacy method)
  static ThemeData get lightTheme => AppTheme.light().themeData;

  /// Get dark theme (legacy method)
  static ThemeData get darkTheme => AppTheme.dark().themeData;
}

/// Color palette for a theme
class ColorPalette {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textInverse;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color overlay;
  final Color overlayHeavy;

  const ColorPalette({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverse,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.overlay,
    required this.overlayHeavy,
  });
}

/// Spacing values
class Spacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xl2;
  final double xl3;
  final double cardPadding;
  final double cardMargin;

  const Spacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.cardPadding,
    required this.cardMargin,
  });
}

/// Accent color set for a theme
class AccentColors {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final LinearGradient gradient;

  const AccentColors({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.gradient,
  });
}
