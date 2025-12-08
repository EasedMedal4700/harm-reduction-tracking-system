import 'package:flutter/material.dart';
import 'app_theme.dart';  // where AppTheme is defined
import 'app_theme_provider.dart';  // <-- THIS IS REQUIRED

extension AppColorsExt on BuildContext {
  /// Shorthand access to the active theme
  AppTheme get theme => AppThemeProvider.of(this);

  /// Basic colors
  Color get bg => theme.colors.background;
  Color get surface => theme.colors.surface;
  Color get surfaceVariant => theme.colors.surfaceVariant;

  Color get border => theme.colors.border;
  Color get divider => theme.colors.divider;

  /// Text colors
  Color get textPrimary => theme.colors.textPrimary;
  Color get textSecondary => theme.colors.textSecondary;
  Color get textTertiary => theme.colors.textTertiary;
  Color get textInverse => theme.colors.textInverse;

  /// Accent colors
  Color get accent => theme.accent.primary;
  Color get accentVariant => theme.accent.primaryVariant;
  Color get accentSecondary => theme.accent.secondary;
  LinearGradient get accentGradient => theme.accent.gradient;

  /// Status colors
  Color get success => theme.colors.success;
  Color get warning => theme.colors.warning;
  Color get error => theme.colors.error;
  Color get info => theme.colors.info;

  /// Overlays
  Color get overlay => theme.colors.overlay;
  Color get overlayHeavy => theme.colors.overlayHeavy;
}
