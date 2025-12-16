import 'package:flutter/material.dart';
import 'app_colors_light.dart';
import 'app_colors_dark.dart';

class UIColors {
  // Light Theme
  static const Color lightBackground = AppColorsLight.background;
  static const Color lightSurface = AppColorsLight.surface;
  static const Color lightText = AppColorsLight.textPrimary;
  static const Color lightTextSecondary = AppColorsLight.textSecondary;
  static const Color lightTextTertiary = AppColorsLight.textTertiary;
  static const Color lightFab = AppColorsLight.accentPrimary;
  static const Color lightAccentBlue = AppColorsLight.accentPrimary;
  static const Color lightAccentTeal = AppColorsLight.accentSecondary;
  static const Color lightAccentRed = AppColorsLight.error;
  static const Color lightDivider = AppColorsLight.divider;
  static final Color lightShadowColor = Colors.black.withValues(alpha: 0.1);
  static const Color lightBorder = AppColorsLight.border;
  static const Color lightAccentGreen = AppColorsLight.success;
  static const Color lightAccentPurple = AppColorsLight.accentSecondary;
  static const Color lightAccentOrange = AppColorsLight.warning;

  // Dark Theme
  static const Color darkBackground = AppColorsDark.background;
  static const Color darkSurface = AppColorsDark.surface;
  static const Color darkText = AppColorsDark.textPrimary;
  static const Color darkTextSecondary = AppColorsDark.textSecondary;
  static const Color darkTextTertiary = AppColorsDark.textTertiary;
  static const Color darkNeonCyan = AppColorsDark.accentPrimary;
  static const Color darkNeonBlue = AppColorsDark.accentPrimary;
  static const Color darkNeonPurple = AppColorsDark.accentSecondary;
  static const Color darkNeonOrange = AppColorsDark.error;
  static const Color darkNeonPink = AppColorsDark.warning;
  static const Color darkDivider = AppColorsDark.divider;
  static final Color darkShadowColor = Colors.black.withValues(alpha: 0.4);
  static const Color darkBorder = AppColorsDark.border;
  static const Color darkNeonGreen = AppColorsDark.success;
  static const Color darkFabStart = AppColorsDark.accentPrimary;
  static const Color darkFabEnd = AppColorsDark.accentSecondary;

  // Missing Methods
  static List<BoxShadow> createNeonGlow(Color color, {double intensity = 0.2}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: 8,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: color.withValues(alpha: intensity * 0.5),
        blurRadius: 16,
        spreadRadius: 2,
      ),
    ];
  }

  static List<BoxShadow> createSoftShadow() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static Color getDarkAccent(String name) {
    return AppColorsDark.accentPrimary;
  }

  static Color getLightAccent(String name) {
    return AppColorsLight.accentPrimary;
  }
}

