import 'package:flutter/material.dart';
import 'app_theme_provider.dart';
import 'app_theme.dart';
import 'app_typography.dart';
import 'app_shapes.dart';

extension AppThemeX on BuildContext {
  /// Access the active AppTheme object
  AppTheme get theme => AppThemeProvider.of(this);

  /// Convenience getters (typed)
  ColorPalette get colors => theme.colors;
  TextStyles get text => theme.typography;
  Spacing get spacing => theme.spacing;
  AccentColors get accent => theme.accent;
  AppShapes get shapes => theme.shapes;

  /// Shadows (light/dark auto-handled by AppTheme)
  List<BoxShadow> get cardShadow => theme.cardShadow;
  List<BoxShadow> get cardShadowHovered => theme.cardShadowHovered;
  List<BoxShadow> get buttonShadow => theme.buttonShadow;
}
