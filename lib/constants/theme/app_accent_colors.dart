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
  factory AccentColors.light() => const AccentColors(
    primary: AppColorsLight.accentPrimary,
    primaryVariant: AppColorsLight.accentPrimaryVariant,
    secondary: AppColorsLight.accentSecondary,
    gradient: AppColorsLight.accentGradient,
  );
  factory AccentColors.dark() => const AccentColors(
    primary: AppColorsDark.accentPrimary,
    primaryVariant: AppColorsDark.accentPrimaryVariant,
    secondary: AppColorsDark.accentSecondary,
    gradient: AppColorsDark.accentGradient,
  );
}
