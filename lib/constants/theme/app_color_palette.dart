// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: N/A
// Notes: Theme definition.
import 'package:flutter/material.dart';
import '../colors/app_colors_light.dart';
import '../colors/app_colors_dark.dart';

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
  final Color transparent = const Color(0x00000000);
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
  factory ColorPalette.light() => const ColorPalette(
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
  factory ColorPalette.dark() => const ColorPalette(
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
