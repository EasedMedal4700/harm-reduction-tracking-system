import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.only(top: t.spacing.lg),
      child: Text(
        'Log entries with substance names to see tolerance insights.',
        textAlign: TextAlign.center,
        style: t.typography.bodySmall.copyWith(
          color: t.colors.textSecondary,
        ),
      ),
    );
  }
}
