import 'package:flutter/material.dart';
import 'app_theme_constants.dart';
import '../colors/app_colors_light.dart';
import '../colors/app_colors_dark.dart';
import 'app_typography.dart';
import '../../models/app_settings_model.dart';
import 'app_typography.dart';
import 'app_shapes.dart';



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
  late final AppShapes shapes;

  // Convenience getter for typography
  TextStyles get text => typography;


  AppTheme._({
    required this.isDark,
    required this.fontSize,
    required this.compactMode,
  }) {
    accent = isDark ? _buildDarkAccent() : _buildLightAccent();
    typography = AppTypography.getTextStyles(fontSize, isDark);
    colors = isDark ? _buildDarkColors() : _buildLightColors();
    spacing = compactMode ? _buildCompactSpacing() : _buildNormalSpacing();

    shapes = AppShapes.defaults();


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
      textTheme: _buildTextTheme(),


      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: typography.heading2.copyWith(
          color: colors.textPrimary,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shadowColor: AppThemeConstants.shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        ),
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent.primary,
        foregroundColor: colors.textInverse,
        elevation: AppThemeConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent.primary,
          foregroundColor: colors.textInverse,
          elevation: AppThemeConstants.cardElevation,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xl,
            vertical: spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
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
      textTheme: _buildTextTheme(),

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colors.textPrimary,
          fontSize: typography.heading2.fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shadowColor: AppThemeConstants.shadowLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
          side: BorderSide(
            color: colors.border.withOpacity(0.3),
            width: 1.0,
          ),
        ),
      ),

      // Floating Action Button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent.primary,
        foregroundColor: colors.textInverse,
        elevation: AppThemeConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd ),
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent.primary,
          foregroundColor: colors.textInverse,
          elevation: AppThemeConstants.cardElevation,
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xl,
            vertical: spacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeConstants.radiusLg),
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

  TextTheme _buildTextTheme() {
    return TextTheme(
      // Big “hero” text
      displayLarge: typography.heading1,
      displayMedium: typography.heading2,
      displaySmall: typography.heading3,

      // Section headings
      headlineLarge: typography.heading2,
      headlineMedium: typography.heading3,
      headlineSmall: typography.heading4,

      // Titles (e.g. ListTile, dialogs)
      titleLarge: typography.heading4,
      titleMedium: typography.bodyBold,
      titleSmall: typography.bodySmall,

      // Body text
      bodyLarge: typography.bodyLarge,
      bodyMedium: typography.body,
      bodySmall: typography.bodySmall,

      // Labels / helper text
      labelLarge: typography.bodyBold,
      labelMedium: typography.captionBold,
      labelSmall: typography.caption,
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

  // Convenience getters for common aliases
  Color get text => textPrimary;
  Color get onPrimary => textInverse;
  Color get onAccent => textInverse;
  Color get onError => textInverse;
  Color get secondary => textSecondary;
  Color get surfaceBright => surfaceVariant;
  Color get warningDark => warning;
  Color get danger => error;
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

  // Convenience getters for radius values (commonly accessed from spacing)
  double get radiusSm => 8.0;
  double get radiusMd => 12.0;
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

  // Convenience getter
  Color get success => const Color(0xFF10B981);
}
