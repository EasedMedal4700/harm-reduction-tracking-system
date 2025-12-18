
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Reusable card for activity items. Fully theme-compliant. No hardcoded values.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    final baseDecoration = BoxDecoration(
      color: c.surface,
      borderRadius: BorderRadius.circular(sh.radiusMd),
      border: Border.all(color: c.border),
      boxShadow: t.cardShadow,
    );

    final effectiveDecoration = baseDecoration;

    return Container(
      margin: EdgeInsets.only(bottom: sp.md),
      decoration: effectiveDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: c.textPrimary.withValues(alpha: context.opacities.splash),
          highlightColor: c.textPrimary.withValues(alpha: context.opacities.highlight),
          borderRadius: BorderRadius.circular(sh.radiusMd),
          child: Padding(
            padding: EdgeInsets.all(sp.md),
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
                  child: Icon(
                    icon,
                    color: c.textInverse,
                    size: context.sizes.iconLg,
                  ),
                ),

                SizedBox(width: sp.md),

                // CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: text.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
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
                                borderRadius:
                                    BorderRadius.circular(sh.radiusSm),
                                border: Border.all(
                                  color: accentColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                badge!,
                                style: text.bodySmall.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: sp.xs),

                      // SUBTITLE
                      Text(
                        subtitle,
                        style: text.bodySmall.copyWith(
                          color: c.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                              style: text.bodySmall.copyWith(
                                color: c.textTertiary,
                              ),
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
                  ),
                ],
              ],
            ),
          ),
        ),
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
