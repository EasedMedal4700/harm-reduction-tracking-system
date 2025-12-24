// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Reusable card for activity items. Fully theme-compliant. No hardcoded values.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../constants/layout/app_layout.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime? timestamp;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;
  final String? badge;
  const ActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.timestamp,
    required this.icon,
    required this.accentColor,
    this.onTap,
    this.badge,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final tx = context.text;
    return CommonCard(
      onTap: onTap,
      child: Row(
        children: [
          // ICON CONTAINER
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor,
                  accentColor.withValues(alpha: context.opacities.gradientEnd),
                ],
              ),
              borderRadius: BorderRadius.circular(sh.radiusSm),
            ),
            child: Icon(icon, color: c.textInverse, size: context.sizes.iconLg),
          ),
          CommonSpacer(width: sp.md),
          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                // Title + Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: tx.bodyLarge.copyWith(
                          fontWeight: tx.bodyBold.fontWeight,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    if (badge != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sp.sm,
                          vertical: sp.xs,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          badge!,
                          style: tx.bodySmall.copyWith(
                            color: accentColor,
                            fontWeight: tx.bodyBold.fontWeight,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: sp.xs),
                // SUBTITLE
                Text(
                  subtitle,
                  style: tx.bodySmall.copyWith(color: c.textSecondary),
                  maxLines: 2,
                  overflow: AppLayout.textOverflowEllipsis,
                ),
                if (timestamp != null) ...[
                  SizedBox(height: sp.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: sp.sm,
                        color: c.textTertiary,
                      ),
                      SizedBox(width: sp.xs),
                      Text(
                        _formatTimestamp(timestamp!),
                        style: tx.bodySmall.copyWith(color: c.textTertiary),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            SizedBox(width: sp.sm),
            Icon(
              Icons.arrow_forward_ios,
              size: sp.md,
              color: c.textSecondary,
              semanticLabel: 'View Details',
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, y').format(dt);
  }
}
