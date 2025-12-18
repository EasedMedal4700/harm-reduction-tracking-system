
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Overlay for loading state. No hardcoded values.

import 'package:mobile_drug_use_app/constants/OLD_DONT_USE/OLD_THEME_DONT_USE.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    final a = context.accent;

    return Container(
      color: Colors.black.withValues(alpha: AppThemeConstants.opacitySlow),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(a.primary),
        ),
      ),
    );
  }
}
