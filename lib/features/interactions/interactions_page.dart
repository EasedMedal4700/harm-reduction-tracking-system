import 'package:mobile_drug_use_app/constants/OLD_DONT_USE/OLD_THEME_DONT_USE.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Placeholder page. Migrated to use AppTheme. No hardcoded values.
import '../../common/old_common/drawer_menu.dart';

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
                Icons.compare_arrows,
                size: AppThemeConstants.icon2xl + AppThemeConstants.space16, // 80.0
                color: c.warning, // Using warning color for interactions/caution
              ),
              SizedBox(height: sp.lg),
              Text(
                'Drug Interactions',
                style: text.headlineMedium.copyWith(
                  fontWeight: AppThemeConstants.fontBold,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.md),
              Text(
                'Check for potential interactions between substances',
                style: text.bodyMedium.copyWith(
                  color: c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.warning.withValues(alpha: AppThemeConstants.opacityOverlay),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: c.warning.withValues(alpha: AppThemeConstants.opacitySlow),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.construction,
                      color: c.warning,
                    ),
                    SizedBox(width: sp.sm),
                    Text(
                      'Coming Soon',
                      style: text.titleLarge.copyWith(
                        color: c.warning,
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
