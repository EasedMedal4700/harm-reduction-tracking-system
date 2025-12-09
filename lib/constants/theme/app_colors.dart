import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_theme_provider.dart';

/// Extension ONLY for color access.
/// DO NOT expose `.theme` here — that belongs to AppThemeX.
extension AppColorsExt on BuildContext {
  /// Color palette (renamed to avoid conflict)
  AppTheme get palette => AppThemeProvider.of(this);

  // BASIC COLORS
  Color get bg => palette.colors.background;
  Color get surface => palette.colors.surface;
  Color get surfaceVariant => palette.colors.surfaceVariant;

  Color get border => palette.colors.border;
  Color get divider => palette.colors.divider;

  // TEXT COLORS
  Color get textPrimary => palette.colors.textPrimary;
  Color get textSecondary => palette.colors.textSecondary;
  Color get textTertiary => palette.colors.textTertiary;
  Color get textInverse => palette.colors.textInverse;

  // ACCENT COLORS
  Color get accent => palette.accent.primary;
  Color get accentVariant => palette.accent.primaryVariant;
  Color get accentSecondary => palette.accent.secondary;
  LinearGradient get accentGradient => palette.accent.gradient;

  // STATUS COLORS
  Color get success => palette.colors.success;
  Color get warning => palette.colors.warning;
  Color get error => palette.colors.error;
  Color get info => palette.colors.info;

  // OVERLAYS
  Color get overlay => palette.colors.overlay;
  Color get overlayHeavy => palette.colors.overlayHeavy;
}
