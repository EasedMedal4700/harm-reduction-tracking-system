import 'package:flutter/material.dart';
import 'app_theme_provider.dart';
import 'app_theme.dart';

extension AppThemeX on BuildContext {
  AppTheme get theme => AppThemeProvider.of(this);

  // Convenience getters:
  get colors => theme.colors;
  get text => theme.typography;
  get spacing => theme.spacing;
  get accent => theme.accent;
}
