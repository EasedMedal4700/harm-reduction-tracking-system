// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

class CatalogEmptyState extends StatelessWidget {
  const CatalogEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Center(
      child: Column(
        mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
        children: [
          Container(
            padding: EdgeInsets.all(t.spacing.xl),
            decoration: BoxDecoration(
              color: t.colors.surfaceVariant.withValues(alpha: t.opacities.slow),
              borderRadius: BorderRadius.circular(t.shapes.radiusLg),
            ),
            child: Icon(
              Icons.search_off,
              size: t.sizes.icon2xl,
              color: t.colors.textSecondary,
            ),
          ),
          const CommonSpacer.vertical(24),
          Text(
            'No substances found',
            style: t.typography.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          const CommonSpacer.vertical(8),
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
