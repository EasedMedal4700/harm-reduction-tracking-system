import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: ThemeConstants.space12),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.radiusMedium,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              border: Border.all(color: UIColors.lightBorder),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(ThemeConstants.space12),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: EdgeInsets.all(ThemeConstants.space12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: ThemeConstants.iconMedium,
                  ),
                ),
                SizedBox(width: ThemeConstants.space12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: ThemeConstants.fontMedium,
                                fontWeight: ThemeConstants.fontSemiBold,
                                color: isDark ? UIColors.darkText : UIColors.lightText,
                              ),
                            ),
                          ),
                          if (badge != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ThemeConstants.space8,
                                vertical: ThemeConstants.space4,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                                border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                badge!,
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontXSmall,
                                  fontWeight: ThemeConstants.fontSemiBold,
                                  color: accentColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: ThemeConstants.space4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: ThemeConstants.fontSmall,
                          color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (timestamp != null) ...[
                        SizedBox(height: ThemeConstants.space4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                            ),
                            SizedBox(width: ThemeConstants.space4),
                            Text(
                              _formatTimestamp(timestamp!),
                              style: TextStyle(
                                fontSize: ThemeConstants.fontXSmall,
                                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Arrow icon
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(dt);
    }
  }
}
