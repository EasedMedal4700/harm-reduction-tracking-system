import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Widget displaying a loading indicator for the analytics page
class AnalyticsLoadingState extends StatelessWidget {
  const AnalyticsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.spacing.xl),
        child: CircularProgressIndicator(
          color: t.accent.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
