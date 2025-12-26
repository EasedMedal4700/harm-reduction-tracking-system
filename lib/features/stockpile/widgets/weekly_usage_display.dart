// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../models/drug_catalog_entry.dart';

class WeeklyUsageDisplay extends StatelessWidget {
  final DrugCatalogEntry entry;
  final Color categoryColor;
  final Function(String, int, String, bool, Color) onDayTap;
  const WeeklyUsageDisplay({
    super.key,
    required this.entry,
    required this.categoryColor,
    required this.onDayTap,
  });
  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final th = context.theme;
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final counts = entry.weekdayUsage.counts;
    final maxUses = counts.isEmpty ? 1 : counts.reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Text(
              'Weekly Pattern',
              style: th.typography.bodySmall.copyWith(
                fontWeight: tx.bodyBold.fontWeight,
              ),
            ),
            Text(
              '(Tap to see times)',
              style: th.typography.caption.copyWith(
                color: th.colors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        CommonSpacer.vertical(th.spacing.xs),
        Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: List.generate(7, (index) {
            final count = counts.isNotEmpty && index < counts.length
                ? counts[index]
                : 0;
            final intensity = maxUses > 0 ? count / maxUses : 0.0;
            final accentColor = categoryColor;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: th.spacing.xs / 4),
                child: InkWell(
                  onTap: count > 0
                      ? () => onDayTap(
                          entry.name,
                          index,
                          days[index],
                          th.isDark,
                          accentColor,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(th.shapes.radiusSm),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? accentColor.withValues(
                              alpha: 0.2 + (intensity * 0.6),
                            )
                          : th.colors.background.withValues(
                              alpha: th.isDark ? 0.3 : 1.0,
                            ),
                      borderRadius: BorderRadius.circular(th.shapes.radiusSm),
                      border: Border.all(
                        color: count > 0
                            ? accentColor.withValues(
                                alpha: 0.5 + (intensity * 0.5),
                              )
                            : th.colors.border,
                        width: count > 0 ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
                      children: [
                        Text(
                          days[index],
                          style: th.typography.caption.copyWith(
                            fontWeight: count > 0
                                ? tx.bodyBold.fontWeight
                                : tx.body.fontWeight,
                            color: count > 0
                                ? accentColor
                                : th.colors.textSecondary,
                          ),
                        ),
                        if (count > 0) ...[
                          CommonSpacer.vertical(th.spacing.xs / 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: th.spacing.xs / 2,
                              vertical: th.spacing.xs / 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(
                                th.shapes.radiusSm,
                              ),
                            ),
                            child: Text(
                              '$count',
                              style: th.typography.caption.copyWith(
                                fontWeight: tx.bodyBold.fontWeight,
                                color: th.isDark
                                    ? th.colors.textPrimary
                                    : th.colors.surface,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
