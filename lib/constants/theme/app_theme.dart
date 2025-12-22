import 'package:flutter/material.dart';

import '../../models/app_settings_model.dart';
import 'app_color_palette.dart';
import 'app_accent_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'app_shapes.dart';
import 'app_shadows.dart';
import 'app_animations.dart';
import 'app_sizes.dart';
import 'app_opacities.dart';
import 'app_borders.dart';
import '../layout/app_layout.dart';
import 'app_surfaces.dart';

/// Composed application theme.
/// Responsible ONLY for assembling theme parts and exposing ThemeData.
class AppTheme {
  final bool isDark;
  final double fontSize;
  final bool compactMode;

  late final ColorPalette colors;
  late final AccentColors accent;
  late final Spacing spacing;
  late final TextStyles typography;
  late final AppShapes shapes;

  late final List<BoxShadow> cardShadow;
  late final List<BoxShadow> cardShadowHovered;
  late final List<BoxShadow> buttonShadow;

  late final AppSurfaces surfaces;

  // New theme constants
  final AppAnimations animations = const AppAnimations();
  final AppSizes sizes = const AppSizes();
  final AppOpacities opacities = const AppOpacities();
  final AppBorders borders = const AppBorders();

  TextStyles get text => typography;

  AppTheme._({
    required this.isDark,
    required this.fontSize,
    required this.compactMode,
  }) {
    colors = isDark ? ColorPalette.dark() : ColorPalette.light();
    accent = isDark ? AccentColors.dark() : AccentColors.light();
    spacing = compactMode ? Spacing.compact() : Spacing.normal();
    typography = AppTypography.getTextStyles(fontSize, isDark);
    shapes = AppShapes.defaults();

    surfaces = AppSurfaces.fromAccent(accent);

    if (isDark) {
      cardShadow = DarkShadows.card;
      cardShadowHovered = DarkShadows.cardHovered;
      buttonShadow = DarkShadows.button;
    } else {
      cardShadow = LightShadows.card;
      cardShadowHovered = LightShadows.cardHovered;
      buttonShadow = LightShadows.button;
    }
  }

  factory AppTheme.light({double fontSize = 14, bool compactMode = false}) =>
      AppTheme._(isDark: false, fontSize: fontSize, compactMode: compactMode);

  factory AppTheme.dark({double fontSize = 14, bool compactMode = false}) =>
      AppTheme._(isDark: true, fontSize: fontSize, compactMode: compactMode);

  factory AppTheme.fromSettings(AppSettings settings) => settings.darkMode
      ? AppTheme.dark(
          fontSize: settings.fontSize,
          compactMode: settings.compactMode,
        )
      : AppTheme.light(
          fontSize: settings.fontSize,
          compactMode: settings.compactMode,
        );

  ThemeData get themeData =>
      isDark ? _buildDarkThemeData() : _buildLightThemeData();

  ThemeData _buildLightThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.light(
        primary: accent.primary,
        secondary: accent.secondary,
        surface: colors.surface,
        error: colors.error,
        onPrimary: colors.textInverse,
        onSecondary: colors.textInverse,
        onSurface: colors.textPrimary,
        onError: colors.textInverse,
      ),
      textTheme: _buildTextTheme(),
    );
  }

  ThemeData _buildDarkThemeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.dark(
        primary: accent.primary,
        secondary: accent.secondary,
        surface: colors.surface,
        error: colors.error,
        onPrimary: colors.textInverse,
        onSecondary: colors.textInverse,
        onSurface: colors.textPrimary,
        onError: colors.textInverse,
      ),
      textTheme: _buildTextTheme(),
    );
  }

  TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: typography.heading1,
      displayMedium: typography.heading2,
      displaySmall: typography.heading3,

      headlineLarge: typography.heading2,
      headlineMedium: typography.heading3,
      headlineSmall: typography.heading4,

      titleLarge: typography.heading4,
      titleMedium: typography.bodyBold,
      titleSmall: typography.bodySmall,

      bodyLarge: typography.bodyLarge,
      bodyMedium: typography.body,
      bodySmall: typography.bodySmall,

      labelLarge: typography.button,
      labelMedium: typography.captionBold,
      labelSmall: typography.caption,
    );
  }
}
