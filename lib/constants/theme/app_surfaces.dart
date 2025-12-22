import 'package:flutter/material.dart';

import 'app_accent_colors.dart';

/// Structural UI surfaces.
/// Describes *where* content sits, not *how* it is rendered.
class AppSurfaces {
  /// Header surface used on auth-related screens
  final BoxDecoration authHeader;

  const AppSurfaces({
    required this.authHeader,
  });

  factory AppSurfaces.fromAccent(AccentColors accent) {
    return AppSurfaces(
      authHeader: BoxDecoration(
        gradient: accent.gradient,
      ),
    );
  }
}
