import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';
import 'package:flutter/material.dart';
import '../../common/old_common/drawer_menu.dart';

/// Placeholder page for physiological monitoring features
class PhysiologicalPage extends StatelessWidget {
  const PhysiologicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Physiological Monitoring',
          style: t.typography.heading3.copyWith(color: c.textPrimary),
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
                Icons.favorite,
                size: 80,
                color: c.error, // Using error color for heart/health related
              ),
              SizedBox(height: sp.lg),
              Text(
                'Physiological Monitoring',
                style: t.typography.heading2.copyWith(
                  fontWeight: AppThemeConstants.fontBold,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.md),
              Text(
                'Track heart rate, blood pressure, and other vital signs',
                style: t.typography.body.copyWith(
                  color: c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: a.primary.withValues(alpha: AppThemeConstants.opacityOverlay),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: a.primary.withValues(alpha: AppThemeConstants.opacitySlow),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.construction,
                      color: a.primary,
                    ),
                    SizedBox(width: sp.sm),
                    Text(
                      'Coming Soon',
                      style: t.typography.heading4.copyWith(
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
