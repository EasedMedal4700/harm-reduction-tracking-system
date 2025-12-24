import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Modular Quick Action Card component
/// Professional medical dashboard style
class QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;
  const QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    final isDark = context.theme.isDark;
    final cardColor = color ?? ac.primary;
    return Material(
      color: c.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        child: Container(
          padding: EdgeInsets.all(sp.sm),
          decoration: BoxDecoration(
            color: isDark ? c.surface.withValues(alpha: 0.5) : c.surface,
            borderRadius: BorderRadius.circular(sh.radiusMd),
            border: Border.all(
              color: isDark ? c.border.withValues(alpha: 0.5) : c.border,
              width: context.sizes.borderThin,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: c.textPrimary.withValues(alpha: 0.03),
                      blurRadius: context.sizes.blurRadiusSm,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.1),
                  shape: sh.boxShapeCircle,
                ),
                child: Icon(icon, color: cardColor, size: context.sizes.iconMd),
              ),
              SizedBox(height: sp.xs),
              Text(
                title,
                textAlign: AppLayout.textAlignCenter,
                style: TextStyle(
                  fontSize: tx.label.fontSize,
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
                maxLines: 2,
                overflow: AppLayout.textOverflowEllipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
