// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../models/drug_catalog_entry.dart';

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
    final text = context.text;
    final t = context.theme;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
              style: t.typography.bodySmall.copyWith(
                fontWeight: text.bodyBold.fontWeight,
              ),
            ),
            Text(
              '(Tap to see times)',
              style: t.typography.caption.copyWith(
                color: t.colors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        CommonSpacer.vertical(t.spacing.xs),
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
                padding: EdgeInsets.symmetric(horizontal: t.spacing.xs / 4),
                child: InkWell(
                  onTap: count > 0
                      ? () => onDayTap(
                          entry.name,
                          index,
                          days[index],
                          t.isDark,
                          accentColor,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(t.shapes.radiusSm),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? accentColor.withValues(
                              alpha: 0.2 + (intensity * 0.6),
                            )
                          : t.colors.background.withValues(
                              alpha: t.isDark ? 0.3 : 1.0,
                            ),
                      borderRadius: BorderRadius.circular(t.shapes.radiusSm),
                      border: Border.all(
                        color: count > 0
                            ? accentColor.withValues(
                                alpha: 0.5 + (intensity * 0.5),
                              )
                            : t.colors.border,
                        width: count > 0 ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
                      children: [
                        Text(
                          days[index],
                          style: t.typography.caption.copyWith(
                            fontWeight: count > 0
                                ? text.bodyBold.fontWeight
                                : text.body.fontWeight,
                            color: count > 0
                                ? accentColor
                                : t.colors.textSecondary,
                          ),
                        ),
                        if (count > 0) ...[
                          CommonSpacer.vertical(t.spacing.xs / 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: t.spacing.xs / 2,
                              vertical: t.spacing.xs / 4,
                            ),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(
                                t.shapes.radiusSm,
                              ),
                            ),
                            child: Text(
                              '$count',
                              style: t.typography.caption.copyWith(
                                fontWeight: text.bodyBold.fontWeight,
                                color: Colors.white,
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
