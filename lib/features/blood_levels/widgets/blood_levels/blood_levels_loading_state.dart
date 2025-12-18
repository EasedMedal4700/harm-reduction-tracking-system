// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated. Uses new theme colors for loader indicator.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Loading state for blood levels
class BloodLevelsLoadingState extends StatelessWidget {
  const BloodLevelsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final acc = context.accent;   // <-- FIX

    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          acc.primary,             // <-- FIXED
        ),
      ),
    );
  }
}
