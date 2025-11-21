import 'package:flutter/material.dart';
import '../constants/app_theme_constants.dart';
import '../constants/color_schemes.dart';
import '../constants/app_typography.dart';
import '../models/app_settings_model.dart';

/// Main theme data class that provides all styling based on user settings
class AppTheme {
  final bool isDark;
  final String themeColor;
  final double fontSize;
  final bool compactMode;
  
  late final AccentColors accent;
  late final TextStyles typography;
  late final ColorPalette colors;
  late final Spacing spacing;
  late final List<BoxShadow> cardShadow;
  late final List<BoxShadow> cardShadowHovered;
  late final List<BoxShadow> buttonShadow;

  AppTheme({
    required this.isDark,
    required this.themeColor,
    required this.fontSize,
    required this.compactMode,
  }) {
    accent = AppColorSchemes.getAccentColors(themeColor, isDark);
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

  /// Create theme from app settings
  factory AppTheme.fromSettings(AppSettings settings) {
    return AppTheme(
      isDark: settings.darkMode,
      themeColor: settings.themeColor,
      fontSize: settings.fontSize,
      compactMode: settings.compactMode,
    );
  }

  ColorPalette _buildLightColors() {
    return ColorPalette(
      background: AppColorSchemes.lightBackground,
      surface: AppColorSchemes.lightSurface,
      surfaceVariant: AppColorSchemes.lightSurfaceVariant,
      border: AppColorSchemes.lightBorder,
      divider: AppColorSchemes.lightDivider,
      textPrimary: AppColorSchemes.lightTextPrimary,
      textSecondary: AppColorSchemes.lightTextSecondary,
      textTertiary: AppColorSchemes.lightTextTertiary,
      textInverse: AppColorSchemes.lightTextInverse,
      success: AppColorSchemes.lightSuccess,
      warning: AppColorSchemes.lightWarning,
      error: AppColorSchemes.lightError,
      info: AppColorSchemes.lightInfo,
      overlay: AppColorSchemes.lightOverlay,
      overlayHeavy: AppColorSchemes.lightOverlayHeavy,
    );
  }

  ColorPalette _buildDarkColors() {
    return ColorPalette(
      background: AppColorSchemes.darkBackground,
      surface: AppColorSchemes.darkSurface,
      surfaceVariant: AppColorSchemes.darkSurfaceVariant,
      border: AppColorSchemes.darkBorder,
      divider: AppColorSchemes.darkDivider,
      textPrimary: AppColorSchemes.darkTextPrimary,
      textSecondary: AppColorSchemes.darkTextSecondary,
      textTertiary: AppColorSchemes.darkTextTertiary,
      textInverse: AppColorSchemes.darkTextInverse,
      success: AppColorSchemes.darkSuccess,
      warning: AppColorSchemes.darkWarning,
      error: AppColorSchemes.darkError,
      info: AppColorSchemes.darkInfo,
      overlay: AppColorSchemes.darkOverlay,
      overlayHeavy: AppColorSchemes.darkOverlayHeavy,
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
