// MIGRATION
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_radius.dart';
import '../../constants/theme/app_spacing.dart';

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
    final spacing = t.spacing;

    final decoration = BoxDecoration(
      color: t.colors.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border.all(color: t.colors.border),
      boxShadow: t.cardShadow,
    );

    final darkGlass = t.isDark
        ? t.glassmorphicDecoration()
        : decoration;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.md),
      decoration: darkGlass,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Row(
              children: [
                /// ICON CONTAINER
                Container(
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor,
                        accentColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),

                SizedBox(width: spacing.md),

                /// CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: t.typography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: t.colors.textPrimary,
                              ),
                            ),
                          ),

                          if (badge != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.sm,
                                vertical: spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                                border: Border.all(
                                  color: accentColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                badge!,
                                style: t.typography.bodySmall.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: spacing.xs),

                      /// Subtitle
                      Text(
                        subtitle,
                        style: t.typography.bodySmall.copyWith(
                          color: t.colors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (timestamp != null) ...[
                        SizedBox(height: spacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: t.colors.textTertiary,
                            ),
                            SizedBox(width: spacing.xs),
                            Text(
                              _formatTimestamp(timestamp!),
                              style: t.typography.bodySmall.copyWith(
                                color: t.colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                if (onTap != null) ...[
                  SizedBox(width: spacing.sm),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: t.colors.textSecondary,
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
