import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/data/drug_categories.dart';
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
    final t = context.theme;

    final recentEntries = entries.toList()
      ..sort((a, b) => b.datetime.compareTo(a.datetime));

    final displayEntries = recentEntries.take(10).toList();

    return Container(
      padding: EdgeInsets.all(t.spacing.xl),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.spacing.md),
        border: Border.all(color: t.colors.border),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(t.spacing.sm),
                decoration: BoxDecoration(
                  color: t.accent.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(t.spacing.sm),
                ),
                child: Icon(
                  Icons.history_rounded,
                  color: t.accent.primary,
                  size: 22,
                ),
              ),
              SizedBox(width: t.spacing.md),
              Text(
                'Recent Activity',
                style: t.typography.heading3.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: t.spacing.lg),

          if (displayEntries.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(t.spacing.xl),
                child: Text(
                  'No recent activity',
                  style: t.typography.body.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...displayEntries.map((entry) =>
                _buildActivityItem(context, entry)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, LogEntry entry) {
    final t = context.theme;

    final category =
        substanceToCategory[entry.substance.toLowerCase()] ?? 'Unknown';

    /// Simulate category color using accent variations  
    final categoryColor = t.accent.primary
        .withOpacity(0.4 + (category.hashCode % 30) / 100);

    final categoryIcon =
        DrugCategories.categoryIconMap[category] ?? Icons.help_outline;

    final timeAgo = _formatTimeAgo(entry.datetime);

    final hoursSince = DateTime.now().difference(entry.datetime).inHours;
    final remainingPercent =
        (100 - (hoursSince * 10)).clamp(0, 100).toDouble();

    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(t.spacing.sm),
          onTap: () {},

          child: Container(
            padding: EdgeInsets.all(t.spacing.md),
            decoration: BoxDecoration(
              color: t.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(t.spacing.sm),
              border: Border.all(color: t.colors.border),
            ),
            child: Row(
              children: [
                /// Category icon
                Container(
                  padding: EdgeInsets.all(t.spacing.sm),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(t.spacing.sm),
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 22,
                  ),
                ),

                SizedBox(width: t.spacing.md),

                /// Substance information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Substance + category chip
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.substance,
                              style: t.typography.bodyBold.copyWith(
                                color: t.colors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(width: t.spacing.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: t.spacing.sm,
                              vertical: t.spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(t.spacing.sm),
                              border: Border.all(
                                color: categoryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              category,
                              style: t.typography.captionBold.copyWith(
                                color: categoryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: t.spacing.xs),

                      /// dosage + time ago
                      Text(
                        '${entry.dosage} ${entry.unit} • $timeAgo',
                        style: t.typography.bodySmall.copyWith(
                          color: t.colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: t.spacing.sm),

                      /// "Active" progress bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Active',
                                style: t.typography.caption.copyWith(
                                  color: t.colors.textSecondary,
                                ),
                              ),
                              Text(
                                '${remainingPercent.toInt()}%',
                                style: t.typography.captionBold.copyWith(
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: t.spacing.xs),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(t.spacing.xs),
                            child: LinearProgressIndicator(
                              value: remainingPercent / 100,
                              backgroundColor: t.colors.border,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(categoryColor),
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
