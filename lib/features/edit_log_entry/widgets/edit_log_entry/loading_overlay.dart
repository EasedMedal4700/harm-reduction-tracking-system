
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Overlay for loading state. No hardcoded values.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import '../../../../common/feedback/common_loader.dart';

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
      color: Colors.black.withValues(alpha: context.opacities.slow),
      child: Center(
        child: CommonLoader(
          color: a.primary,
        ),
      ),
    );
  }
}
