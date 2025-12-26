// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Placeholder page for physiological monitoring features.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/layout/common_drawer.dart';

/// Placeholder page for physiological monitoring features
class PhysiologicalPage extends StatelessWidget {
  const PhysiologicalPage({super.key});
  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Physiological Monitoring',
          style: th.typography.heading3.copyWith(color: c.textPrimary),
        ),
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: context.sizes.elevationNone,
      ),
      drawer: const CommonDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(sp.xl),
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              Icon(
                Icons.favorite,
                size: 80,
                color: c.error, // Using error color for heart/health related
              ),
              CommonSpacer.vertical(sp.lg),
              Text(
                'Physiological Monitoring',
                style: th.typography.heading2.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'Track heart rate, blood pressure, and other vital signs',
                style: th.typography.body.copyWith(color: c.textSecondary),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: ac.primary.withValues(
                    alpha: context.opacities.overlay,
                  ),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: ac.primary.withValues(alpha: context.opacities.slow),
                  ),
                ),
                child: Row(
                  mainAxisSize: AppLayout.mainAxisSizeMin,
                  children: [
                    Icon(
                      Icons.construction,
                      color: ac.primary,
                      size: context.sizes.iconMd,
                    ),
                    CommonSpacer.horizontal(sp.sm),
                    Text(
                      'Coming Soon',
                      style: th.typography.heading4.copyWith(color: ac.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
