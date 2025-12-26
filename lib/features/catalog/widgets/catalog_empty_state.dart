// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';

class CatalogEmptyState extends StatelessWidget {
  const CatalogEmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return Center(
      child: Column(
        mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
        children: [
          Container(
            padding: EdgeInsets.all(th.spacing.xl),
            decoration: BoxDecoration(
              color: th.colors.surfaceVariant.withValues(
                alpha: th.opacities.slow,
              ),
              borderRadius: BorderRadius.circular(th.shapes.radiusLg),
            ),
            child: Icon(
              Icons.search_off,
              size: th.sizes.icon2xl,
              color: th.colors.textSecondary,
            ),
          ),
          const CommonSpacer.vertical(24),
          Text(
            'No substances found',
            style: th.typography.heading3.copyWith(
              color: th.colors.textPrimary,
            ),
          ),
          const CommonSpacer.vertical(8),
          Text(
            'Try adjusting your search or filters',
            style: th.typography.body.copyWith(color: th.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
