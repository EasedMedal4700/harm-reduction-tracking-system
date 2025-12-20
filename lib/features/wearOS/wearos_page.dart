import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import '../../common/layout/common_spacer.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Placeholder page. Migrated to use AppTheme. No hardcoded values.

/// Placeholder page for WearOS companion app
class WearOSPage extends StatelessWidget {
  const WearOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final a = context.accent;
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
                size: context.sizes.icon2xl + context.spacing.lg, // 80.0
                color: a.primary,
              ),
              CommonSpacer.vertical(sp.lg),
              Text(
                'WearOS Companion',
                style: context.text.headlineMedium.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'Connect and sync with your WearOS smartwatch',
                style: context.text.bodyLarge.copyWith(color: c.textSecondary),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(context.shapes.radiusMd),
                  border: Border.all(
                    color: a.primary.withValues(
                      alpha: context.opacities.medium,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: AppLayout.mainAxisSizeMin,
                  children: [
                    Icon(Icons.construction, color: a.primary),
                    CommonSpacer.horizontal(sp.md),
                    Text(
                      'Coming Soon',
                      style: context.text.titleMedium.copyWith(
                        fontWeight: text.bodyBold.fontWeight,
                        color: a.primary,
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
