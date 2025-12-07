import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_categories.dart';
import '../../constants/deprecated/drug_theme.dart';
import '../../models/log_entry_model.dart';

class RecentActivityList extends StatelessWidget {
  final List<LogEntry> entries;
  final Map<String, String> substanceToCategory;

  const RecentActivityList({
    super.key,
    required this.entries,
    required this.substanceToCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentTeal;

    // Sort entries by date (most recent first) and take top 10
    final recentEntries = entries.toList()
      ..sort((a, b) => b.datetime.compareTo(a.datetime));
    final displayEntries = recentEntries.take(10).toList();

    return Container(
      padding: EdgeInsets.all(ThemeConstants.cardPaddingLarge),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ThemeConstants.space8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: accentColor,
                  size: ThemeConstants.iconMedium,
                ),
              ),
              SizedBox(width: ThemeConstants.space12),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          // Activity list
          if (displayEntries.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(ThemeConstants.space24),
                child: Text(
                  'No recent activity',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                ),
              ),
            )
          else
            ...displayEntries.map((entry) => _buildActivityItem(
                  context,
                  entry,
                  isDark,
                )),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    LogEntry entry,
    bool isDark,
  ) {
    final category = substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder';
    final categoryColor = DrugCategoryColors.colorFor(category);
    final categoryIcon = DrugCategories.categoryIconMap[category] ?? Icons.help_outline;
    final timeAgo = _formatTimeAgo(entry.datetime);

    // Calculate simulated "remaining" percentage (for demo purposes)
    final hoursSince = DateTime.now().difference(entry.datetime).inHours;
    final remainingPercent = (100 - (hoursSince * 10)).clamp(0, 100).toDouble();

    return Padding(
      padding: EdgeInsets.only(bottom: ThemeConstants.space12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to entry detail or edit page
          },
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
          child: Container(
            padding: EdgeInsets.all(ThemeConstants.space12),
            decoration: BoxDecoration(
              color: isDark
                  ? UIColors.darkSurfaceLight.withValues(alpha: 0.5)
                  : UIColors.lightDivider,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              border: Border.all(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
            ),
            child: Row(
              children: [
                // Category icon with colored background
                Container(
                  padding: EdgeInsets.all(ThemeConstants.space8),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: ThemeConstants.iconMedium,
                  ),
                ),
                SizedBox(width: ThemeConstants.space12),
                // Substance name, category, dosage, time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Substance name + category chip
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.substance,
                              style: TextStyle(
                                fontSize: ThemeConstants.fontMedium,
                                fontWeight: ThemeConstants.fontSemiBold,
                                color: isDark ? UIColors.darkText : UIColors.lightText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: ThemeConstants.space8),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ThemeConstants.space8,
                                vertical: ThemeConstants.space4,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                                border: Border.all(
                                  color: categoryColor.withValues(alpha: 0.3),
                                  width: ThemeConstants.borderThin,
                                ),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontXSmall,
                                  fontWeight: ThemeConstants.fontSemiBold,
                                  color: categoryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ThemeConstants.space4),
                      // Dosage and time ago
                      Text(
                        '${entry.dosage} ${entry.unit} • $timeAgo',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontSmall,
                          fontWeight: ThemeConstants.fontRegular,
                          color: isDark
                              ? UIColors.darkTextSecondary
                              : UIColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ThemeConstants.space8),
                      // Progress bar for "remaining"
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Active',
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontXSmall,
                                  fontWeight: ThemeConstants.fontMediumWeight,
                                  color: isDark
                                      ? UIColors.darkTextSecondary
                                      : UIColors.lightTextSecondary,
                                ),
                              ),
                              Text(
                                '${remainingPercent.toInt()}%',
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontXSmall,
                                  fontWeight: ThemeConstants.fontSemiBold,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ThemeConstants.space4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(ThemeConstants.space4),
                            child: LinearProgressIndicator(
                              value: remainingPercent / 100,
                              backgroundColor: isDark
                                  ? UIColors.darkBorder
                                  : UIColors.lightBorder,
                              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}
