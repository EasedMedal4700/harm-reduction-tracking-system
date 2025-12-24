// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Rebuilt RecentActivityList with CommonCard + unified layout. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/buttons/common_chip.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../models/log_entry_model.dart';

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
    final th = context.theme;
    final recent = entries.toList()
      ..sort((a, b) => b.datetime.compareTo(a.datetime));
    final display = recent.take(10).toList();
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(title: 'Recent Activity'),
          CommonSpacer.vertical(th.spacing.md),
          if (display.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(th.spacing.xl),
                child: Text(
                  'No recent activity',
                  style: th.typography.body.copyWith(
                    color: th.colors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Column(
              children: display
                  .map(
                    (e) => _RecentActivityItem(
                      entry: e,
                      category:
                          substanceToCategory[e.substance.toLowerCase()] ??
                          'Unknown',
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _RecentActivityItem extends StatelessWidget {
  final LogEntry entry;
  final String category;
  const _RecentActivityItem({required this.entry, required this.category});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;

    final icon = DrugCategories.categoryIconMap[category] ?? Icons.category;
    final timeAgo = _formatTimeAgo(entry.datetime);
    final hoursSince = DateTime.now().difference(entry.datetime).inHours;
    final remainingPercent = (100 - (hoursSince * 10)).clamp(0, 100).toDouble();
    final categoryColor = th.accent.primary.withValues(
      alpha: 0.4 + (category.hashCode % 20) / 100,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: th.spacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(th.spacing.sm),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(th.spacing.md),
          decoration: BoxDecoration(
            color: th.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(th.spacing.sm),
            border: Border.all(color: th.colors.border),
          ),
          child: Row(
            children: [
              /// Leading icon
              Container(
                padding: EdgeInsets.all(th.spacing.sm),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: th.opacities.low),
                  borderRadius: BorderRadius.circular(th.spacing.sm),
                ),
                child: Icon(icon, color: categoryColor, size: th.sizes.iconMd),
              ),
              SizedBox(width: th.spacing.md),

              /// Content
              Expanded(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    /// Substance + category chip
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.substance,
                            style: th.typography.bodyBold.copyWith(
                              color: th.colors.textPrimary,
                            ),
                            overflow: AppLayout.textOverflowEllipsis,
                          ),
                        ),
                        SizedBox(width: th.spacing.sm),
                        CommonChip(
                          label: category,
                          isSelected: false,
                          showGlow: false,
                          icon: icon,
                          selectedColor: categoryColor,
                          onTap: () {}, // Read-only chip
                        ),
                      ],
                    ),
                    CommonSpacer.vertical(th.spacing.xs),

                    /// Dosage + time ago
                    Text(
                      '${entry.dosage} ${entry.unit} • $timeAgo',
                      style: th.typography.bodySmall.copyWith(
                        color: th.colors.textSecondary,
                      ),
                    ),
                    CommonSpacer.vertical(th.spacing.md),

                    /// Activity bar
                    Row(
                      mainAxisAlignment:
                          AppLayout.mainAxisAlignmentSpaceBetween,
                      children: [
                        Text(
                          'Active',
                          style: th.typography.caption.copyWith(
                            color: th.colors.textSecondary,
                          ),
                        ),
                        Text(
                          '${remainingPercent.toInt()}%',
                          style: th.typography.captionBold.copyWith(
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: th.spacing.xs),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(th.spacing.xs),
                      child: LinearProgressIndicator(
                        value: remainingPercent / 100,
                        backgroundColor: th.colors.border,
                        minHeight: th.spacing.sm,
                        valueColor: AlwaysStoppedAnimation(categoryColor),
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

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}
