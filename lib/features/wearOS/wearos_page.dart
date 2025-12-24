// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Placeholder page. Migrated to use AppTheme. No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import '../../common/layout/common_spacer.dart';

/// Placeholder page for WearOS companion app
class WearOSPage extends StatelessWidget {
  const WearOSPage({super.key});
  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('WearOS Companion'),
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
                Icons.watch,
                size: context.sizes.icon2xl + sp.lg, // 80.0
                color: ac.primary,
              ),
              CommonSpacer.vertical(sp.lg),
              Text(
                'WearOS Companion',
                style: tx.headlineMedium.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'Connect and sync with your WearOS smartwatch',
                style: tx.bodyLarge.copyWith(color: c.textSecondary),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(context.shapes.radiusMd),
                  border: Border.all(
                    color: ac.primary.withValues(
                      alpha: context.opacities.medium,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: AppLayout.mainAxisSizeMin,
                  children: [
                    Icon(Icons.construction, color: ac.primary),
                    CommonSpacer.horizontal(sp.md),
                    Text(
                      'Coming Soon',
                      style: tx.titleMedium.copyWith(
                        fontWeight: tx.bodyBold.fontWeight,
                        color: ac.primary,
                      ),
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
