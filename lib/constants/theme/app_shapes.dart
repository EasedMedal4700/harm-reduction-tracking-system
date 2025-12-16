import 'package:flutter/material.dart';
import 'app_theme_constants.dart';

class AppShapes {
  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radiusFull;

  const AppShapes({
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.radiusFull,
  });

  factory AppShapes.defaults() {
    return const AppShapes(
      radiusXs: AppThemeConstants.radiusXs,
      radiusSm: AppThemeConstants.radiusSm,
      radiusMd: AppThemeConstants.radiusMd,
      radiusLg: AppThemeConstants.radiusLg,
      radiusXl: AppThemeConstants.radiusXl,
      radiusFull: AppThemeConstants.radiusFull,
    );
  }

  // Aliases
  double get radiusS => radiusSm;
  double get radiusM => radiusMd;
}

