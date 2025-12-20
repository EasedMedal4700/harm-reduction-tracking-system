import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Placeholder page. Migrated to use AppTheme. No hardcoded values.
import '../../common/layout/common_drawer.dart';

/// Placeholder page for drug interaction checking
class InteractionsPage extends StatelessWidget {
  const InteractionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Drug Interactions',
          style: text.headlineSmall.copyWith(color: c.textPrimary),
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
                Icons.compare_arrows,
                size: context.sizes.icon2xl + context.spacing.md, // 80.0
                color:
                    c.warning, // Using warning color for interactions/caution
              ),
              CommonSpacer.vertical(sp.lg),
              Text(
                'Drug Interactions',
                style: text.headlineMedium.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'Check for potential interactions between substances',
                style: text.bodyMedium.copyWith(color: c.textSecondary),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.warning.withValues(alpha: context.opacities.overlay),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: c.warning.withValues(alpha: context.opacities.slow),
                  ),
                ),
                child: Row(
                  mainAxisSize: AppLayout.mainAxisSizeMin,
                  children: [
                    Icon(
                      Icons.construction,
                      color: c.warning,
                      size: context.sizes.iconMd,
                    ),
                    CommonSpacer.horizontal(sp.sm),
                    Text(
                      'Coming Soon',
                      style: text.titleLarge.copyWith(color: c.warning),
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
