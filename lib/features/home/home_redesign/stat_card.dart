import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Modular Stat Card component
/// Professional medical dashboard style
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final acc = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = color ?? acc.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sp.md),
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
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: context.sizes.blurRadiusSm,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            Row(
              mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: cardColor,
                    size: context.sizes.iconMd,
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: context.sizes.iconSm,
                    color: c.textSecondary,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: context.text.heading2.fontSize,
                fontWeight: context.text.bodyBold.fontWeight,
                color: c.textPrimary,
              ),
            ),
            SizedBox(height: sp.xs),
            Text(
              title,
              style: TextStyle(
                fontSize: context.text.label.fontSize,
                color: c.textSecondary,
                fontWeight: text.bodyMedium.fontWeight,
              ),
              maxLines: 1,
              overflow: AppLayout.textOverflowEllipsis,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: context.text.caption.fontSize,
                  color: c.textSecondary.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: AppLayout.textOverflowEllipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
