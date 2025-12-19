import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/layout/common_drawer.dart';

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
        elevation: context.sizes.elevationNone,
      ),
      drawer: const CommonDrawer(),
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
              CommonSpacer.vertical(sp.lg),
              Text(
                'Physiological Monitoring',
                style: t.typography.heading2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              CommonSpacer.vertical(sp.md),
              Text(
                'Track heart rate, blood pressure, and other vital signs',
                style: t.typography.body.copyWith(
                  color: c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              CommonSpacer.vertical(sp.xl),
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: a.primary.withValues(alpha: context.opacities.overlay),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: a.primary.withValues(alpha: context.opacities.slow),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.construction,
                      color: a.primary,
                      size: context.sizes.iconMd,
                    ),
                    CommonSpacer.horizontal(sp.sm),
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
