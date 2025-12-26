// MIGRATION:
// State: LEGACY
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod TODO.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:intl/intl.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/buttons/common_outlined_button.dart';
import '../../../constants/data/drug_categories.dart';
import '../../../models/drug_catalog_entry.dart';
import '../../../models/stockpile_item.dart';
import 'weekly_usage_display.dart';

const double _buttonHeight = 40.0;

class SubstanceCard extends StatelessWidget {
  final DrugCatalogEntry entry;
  final StockpileItem? stockpile;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onArchive;
  final VoidCallback onManageStockpile;
  final Function(String, int, String, bool, Color) onDayTap;
  const SubstanceCard({
    super.key,
    required this.entry,
    this.stockpile,
    required this.onTap,
    required this.onFavorite,
    required this.onArchive,
    required this.onManageStockpile,
    required this.onDayTap,
  });
  String _selectPrimaryCategory(List<String> categories) {
    if (categories.isEmpty) return 'Unknown';
    final filtered = categories
        .where(
          (cat) =>
              cat.toLowerCase() != 'tentative' &&
              cat.toLowerCase() != 'research chemical' &&
              cat.toLowerCase() != 'habit-forming' &&
              cat.toLowerCase() != 'common' &&
              cat.toLowerCase() != 'inactive',
        )
        .toList();
    if (filtered.isEmpty) return 'Unknown';
    for (final priorityCategory in DrugCategories.categoryPriority) {
      if (filtered.any(
        (cat) => cat.toLowerCase() == priorityCategory.toLowerCase(),
      )) {
        return priorityCategory;
      }
    }
    return filtered.first;
  }

  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final th = context.theme;
    final primaryCategory = _selectPrimaryCategory(entry.categories);
    final categoryColor = DrugCategoryColors.colorFor(primaryCategory);
    final categoryIcon =
        DrugCategories.categoryIconMap[primaryCategory] ?? Icons.science;
    return Container(
      margin: EdgeInsets.only(bottom: th.spacing.md),
      decoration: BoxDecoration(
        color: th.colors.surface,
        borderRadius: BorderRadius.circular(th.shapes.radiusLg),
        border: Border.all(
          color: categoryColor.withValues(alpha: th.isDark ? 0.3 : 0.2),
        ),
        boxShadow: th.isDark
            ? null
            : [
                BoxShadow(
                  color: th.colors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: context.sizes.blurRadiusMd,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Header with name, favorite, archive
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(th.shapes.radiusLg),
            ),
            child: Container(
              padding: EdgeInsets.all(th.spacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    categoryColor.withValues(alpha: 0.2),
                    categoryColor.withValues(alpha: 0.05),
                  ],
                  begin: context.shapes.alignmentTopLeft,
                  end: context.shapes.alignmentBottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(th.shapes.radiusLg),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(th.spacing.sm),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor,
                          categoryColor.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: th.isDark
                          ? th.colors.textPrimary
                          : th.colors.surface,
                      size: th.sizes.iconMd,
                    ),
                  ),
                  CommonSpacer(width: th.spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                      children: [
                        Text(
                          entry.name,
                          style: th.typography.heading3.copyWith(
                            fontWeight: tx.bodyBold.fontWeight,
                          ),
                        ),
                        Text(
                          primaryCategory,
                          style: th.typography.bodySmall.copyWith(
                            color: categoryColor,
                            fontWeight: tx.bodyBold.fontWeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      entry.favorite ? Icons.favorite : Icons.favorite_border,
                      color: entry.favorite
                          ? th.colors.error
                          : th.colors.textSecondary,
                    ),
                    onPressed: onFavorite,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: th.colors.textSecondary),
                    onSelected: (value) {
                      if (value == 'archive') {
                        onArchive();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            Icon(
                              entry.archived ? Icons.unarchive : Icons.archive,
                              size: th.sizes.iconSm,
                            ),
                            CommonSpacer(width: th.spacing.xs),
                            Text(entry.archived ? 'Unarchive' : 'Archive'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(th.spacing.md),
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                // Stats row
                Row(
                  children: [
                    _buildStatItem(
                      'Total Uses',
                      '${entry.totalUses}',
                      Icons.bar_chart,
                      context,
                    ),
                    CommonSpacer(width: th.spacing.lg),
                    _buildStatItem(
                      'Last Used',
                      entry.lastUsed != null
                          ? DateFormat('MMM d').format(entry.lastUsed!)
                          : 'Never',
                      Icons.access_time,
                      context,
                    ),
                  ],
                ), // Stockpile info
                if (stockpile != null) ...[
                  CommonSpacer(height: th.spacing.md),
                  InkWell(
                    onTap: onManageStockpile,
                    borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                    child: Container(
                      padding: EdgeInsets.all(th.spacing.sm),
                      decoration: BoxDecoration(
                        color: th.colors.background.withValues(
                          alpha: th.isDark ? 0.5 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                        border: Border.all(color: th.colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          Row(
                            mainAxisAlignment:
                                AppLayout.mainAxisAlignmentSpaceBetween,
                            children: [
                              Text(
                                'Stockpile',
                                style: th.typography.bodySmall.copyWith(
                                  fontWeight: tx.bodyBold.fontWeight,
                                ),
                              ),
                              Text(
                                '${stockpile!.currentAmountMg.toStringAsFixed(1)} mg',
                                style: th.typography.body.copyWith(
                                  fontWeight: tx.bodyBold.fontWeight,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                          CommonSpacer(height: th.spacing.xs),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              th.shapes.radiusSm,
                            ),
                            child: LinearProgressIndicator(
                              value: stockpile!.getPercentage() / 100,
                              minHeight: 8,
                              backgroundColor: th.colors.border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                stockpile!.isLow()
                                    ? th.colors.error
                                    : categoryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  CommonSpacer(height: th.spacing.sm),
                  CommonOutlinedButton(
                    onPressed: onManageStockpile,
                    icon: Icons.add,
                    label: 'Add to Stockpile',
                    color: categoryColor,
                    borderColor: categoryColor,
                    height: _buttonHeight,
                  ),
                ],
                // Weekly usage display
                CommonSpacer(height: th.spacing.md),
                WeeklyUsageDisplay(
                  entry: entry,
                  categoryColor: categoryColor,
                  onDayTap: onDayTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    final th = context.theme;
    final tx = context.text;

    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: context.sizes.iconSm,
            color: th.colors.textSecondary,
          ),
          CommonSpacer(width: context.spacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  label,
                  style: th.typography.caption.copyWith(
                    color: th.colors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: th.typography.body.copyWith(
                    fontWeight: tx.bodyBold.fontWeight,
                  ),
                  overflow: AppLayout.textOverflowEllipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
