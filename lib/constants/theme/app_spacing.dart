import 'package:flutter/material.dart';
import 'app_theme_provider.dart';
import 'app_theme.dart';

/// Provides easy access to spacing values from the active AppTheme.
///
/// Usage:
///   context.spacing.sm
///   context.spacing.lg
///   context.spacing.cardPadding
///
extension AppSpacingExt on BuildContext {
  Spacing get spacing => AppThemeProvider.of(this).spacing;
}
