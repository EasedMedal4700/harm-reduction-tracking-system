
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Rebuilt RecentActivityList with CommonCard + unified layout. No Riverpod.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/buttons/common_chip.dart';

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

    final recent = entries.toList()
      ..sort((a, b) => b.datetime.compareTo(a.datetime));

    final display = recent.take(10).toList();

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: 'Recent Activity',
          ),

          const CommonSpacer.vertical(16),

          if (display.isEmpty)
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
            Column(
              children: display
                  .map((e) => _RecentActivityItem(
                        entry: e,
                        category: substanceToCategory[e.substance.toLowerCase()] ?? 'Unknown',
                      ))
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

  const _RecentActivityItem({
    required this.entry,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    final icon = DrugCategories.categoryIconMap[category] ?? Icons.category;
    final timeAgo = _formatTimeAgo(entry.datetime);

    final hoursSince = DateTime.now().difference(entry.datetime).inHours;
    final remainingPercent = (100 - (hoursSince * 10)).clamp(0, 100).toDouble();

    final categoryColor = t.accent.primary.withValues(alpha: 0.4 + (category.hashCode % 20) / 100);

    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.md),
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
              /// Leading icon
              Container(
                padding: EdgeInsets.all(t.spacing.sm),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(t.spacing.sm),
                ),
                child: Icon(icon, color: categoryColor, size: 22),
              ),

              SizedBox(width: t.spacing.md),

              /// Content
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
                          ),
                        ),
                        SizedBox(width: t.spacing.sm),
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

                    const CommonSpacer.vertical(4),

                    /// Dosage + time ago
                    Text(
                      '${entry.dosage} ${entry.unit} • $timeAgo',
                      style: t.typography.bodySmall.copyWith(
                        color: t.colors.textSecondary,
                      ),
                    ),

                    const CommonSpacer.vertical(12),

                    /// Activity bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                    const SizedBox(height: 4),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(t.spacing.xs),
                      child: LinearProgressIndicator(
                        value: remainingPercent / 100,
                        backgroundColor: t.colors.border,
                        minHeight: 6,
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
