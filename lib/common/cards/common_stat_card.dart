import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class CommonStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  const CommonStatCard({
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
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    final tx = context.text;
    final cardColor = color ?? ac.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sp.md),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(color: c.border, width: 1.0),
          boxShadow: context.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(sp.sm),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: cardColor,
                    size:
                        20, // TODO: Add to constants if needed, or use default
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: c.textSecondary,
                  ),
              ],
            ),
            SizedBox(height: sp.md),
            Text(
              value,
              style: tx.heading3.copyWith(
                color: c.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sp.xs),
            Text(
              title,
              style: tx.caption.copyWith(
                color: c.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              SizedBox(height: sp.xs),
              Text(
                subtitle!,
                style: tx.caption.copyWith(
                  fontSize: 10, // Small caption
                  color: c.textSecondary.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
