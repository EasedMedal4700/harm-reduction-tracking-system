// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Widget displaying a loading indicator for the analytics page
class AnalyticsLoadingState extends StatelessWidget {
  const AnalyticsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;
    final acc = context.accent;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: SizedBox(
          width: 42,
          height: 42,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation(acc.primary),
          ),
        ),
      ),
    );
  }
}
