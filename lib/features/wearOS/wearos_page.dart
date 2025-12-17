import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Placeholder page. Migrated to use AppTheme. No hardcoded values.
import '../../common/old_common/drawer_menu.dart';

/// Placeholder page for WearOS companion app
class WearOSPage extends StatelessWidget {
  const WearOSPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('WearOS Companion'),
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: 0,
      ),
      drawer: const DrawerMenu(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(sp.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.watch,
                size: AppThemeConstants.icon2xl + AppThemeConstants.space16, // 80.0
                color: a.primary,
              ),
              SizedBox(height: sp.lg),
              Text(
                'WearOS Companion',
                style: context.text.headlineMedium.copyWith(
                  fontWeight: AppThemeConstants.fontBold,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.md),
              Text(
                'Connect and sync with your WearOS smartwatch',
                style: context.text.bodyLarge.copyWith(
                  color: c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(AppThemeConstants.radiusMedium),
                  border: Border.all(
                    color: a.primary.withValues(alpha: AppThemeConstants.opacityMedium),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.construction,
                      color: a.primary,
                    ),
                    SizedBox(width: sp.md),
                    Text(
                      'Coming Soon',
                      style: context.text.titleMedium.copyWith(
                        fontWeight: AppThemeConstants.fontSemiBold,
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
