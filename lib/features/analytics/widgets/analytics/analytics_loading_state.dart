// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-compliant. Uses CommonLoader.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';

/// Widget displaying a loading indicator for the analytics page
class AnalyticsLoadingState extends StatelessWidget {
  const AnalyticsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    final acc = context.accent;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: CommonLoader(
          size: context.sizes.iconXl,
          color: acc.primary,
        ),
      ),
    );
  }
}
