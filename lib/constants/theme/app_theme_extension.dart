import 'package:flutter/material.dart';

import 'app_theme_provider.dart';
import 'app_theme.dart';
import 'app_color_palette.dart';
import 'app_accent_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';
import 'app_shapes.dart';

/// Context-based access to the active AppTheme.
/// This is the ONLY approved way for widgets to access theme values.
extension AppThemeX on BuildContext {
  /// Full theme object (use sparingly)
  AppTheme get theme => AppThemeProvider.of(this);

  /// Core theme tokens
  ColorPalette get colors => theme.colors;
  AccentColors get accent => theme.accent;
  Spacing get spacing => theme.spacing;
  TextStyles get text => theme.text;
  AppShapes get shapes => theme.shapes;

  /// Shadows (auto-handled per theme)
  List<BoxShadow> get cardShadow => theme.cardShadow;
  List<BoxShadow> get cardShadowHovered => theme.cardShadowHovered;
  List<BoxShadow> get buttonShadow => theme.buttonShadow;
}
