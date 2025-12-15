import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

class CatalogEmptyState extends StatelessWidget {
  const CatalogEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(t.spacing.xl),
            decoration: BoxDecoration(
              color: t.colors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(t.shapes.radiusLg),
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: t.colors.textSecondary,
            ),
          ),
          SizedBox(height: t.spacing.xl),
          Text(
            'No substances found',
            style: t.typography.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          SizedBox(height: t.spacing.sm),
          Text(
            'Try adjusting your search or filters',
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
