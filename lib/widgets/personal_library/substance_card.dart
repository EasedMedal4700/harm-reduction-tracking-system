// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../models/drug_catalog_entry.dart';
import '../../models/stockpile_item.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_categories.dart';
import 'package:intl/intl.dart';
import 'weekly_usage_display.dart';

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
    
    final filtered = categories.where((cat) =>
        cat.toLowerCase() != 'tentative' &&
        cat.toLowerCase() != 'research chemical' &&
        cat.toLowerCase() != 'habit-forming' &&
        cat.toLowerCase() != 'common' &&
        cat.toLowerCase() != 'inactive').toList();

    if (filtered.isEmpty) return 'Unknown';

    for (final priorityCategory in DrugCategories.categoryPriority) {
      if (filtered.any((cat) => cat.toLowerCase() == priorityCategory.toLowerCase())) {
        return priorityCategory;
      }
    }
    
    return filtered.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryCategory = _selectPrimaryCategory(entry.categories);
    final categoryColor = DrugCategoryColors.colorFor(primaryCategory);
    final categoryIcon = DrugCategories.categoryIconMap[primaryCategory] ?? Icons.science;

    return Container(
      margin: EdgeInsets.only(bottom: ThemeConstants.space16),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: categoryColor,
              radius: ThemeConstants.radiusLarge,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
              border: Border.all(color: UIColors.lightBorder),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name, favorite, archive
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(ThemeConstants.radiusLarge),
            ),
            child: Container(
              padding: EdgeInsets.all(ThemeConstants.space16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    categoryColor.withValues(alpha: 0.2),
                    categoryColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ThemeConstants.radiusLarge),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ThemeConstants.space12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: Colors.white,
                      size: ThemeConstants.iconMedium,
                    ),
                  ),
                  SizedBox(width: ThemeConstants.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          style: TextStyle(
                            fontSize: ThemeConstants.fontLarge,
                            fontWeight: ThemeConstants.fontBold,
                            color: isDark ? UIColors.darkText : UIColors.lightText,
                          ),
                        ),
                        Text(
                          primaryCategory,
                          style: TextStyle(
                            fontSize: ThemeConstants.fontSmall,
                            color: categoryColor,
                            fontWeight: ThemeConstants.fontSemiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      entry.favorite ? Icons.favorite : Icons.favorite_border,
                      color: entry.favorite ? Colors.red : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                    ),
                    onPressed: onFavorite,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                    ),
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
                              size: ThemeConstants.iconSmall,
                            ),
                            SizedBox(width: ThemeConstants.space8),
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
            padding: EdgeInsets.all(ThemeConstants.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats row
                  Row(
                    children: [
                      _buildStatItem(
                        'Total Uses',
                        '${entry.totalUses}',
                        Icons.bar_chart,
                        isDark,
                      ),
                      SizedBox(width: ThemeConstants.space20),
                      _buildStatItem(
                        'Last Used',
                        entry.lastUsed != null 
                            ? DateFormat('MMM d').format(entry.lastUsed!)
                            : 'Never',
                        Icons.access_time,
                        isDark,
                      ),
                    ],
                  ),                // Stockpile info
                if (stockpile != null) ...[
                  SizedBox(height: ThemeConstants.space16),
                  InkWell(
                    onTap: onManageStockpile,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    child: Container(
                      padding: EdgeInsets.all(ThemeConstants.space12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? UIColors.darkBackground.withValues(alpha: 0.5)
                            : UIColors.lightBackground,
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                        border: Border.all(
                          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stockpile',
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontSmall,
                                  fontWeight: ThemeConstants.fontSemiBold,
                                  color: isDark ? UIColors.darkText : UIColors.lightText,
                                ),
                              ),
                              Text(
                                '${stockpile!.currentAmountMg.toStringAsFixed(1)} mg',
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontMedium,
                                  fontWeight: ThemeConstants.fontBold,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ThemeConstants.space8),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                            child: LinearProgressIndicator(
                              value: stockpile!.getPercentage() / 100,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? UIColors.darkBorder
                                  : UIColors.lightBorder,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                stockpile!.isLow()
                                    ? Colors.red
                                    : categoryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(height: ThemeConstants.space12),
                  OutlinedButton.icon(
                    onPressed: onManageStockpile,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add to Stockpile'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: categoryColor),
                      foregroundColor: categoryColor,
                    ),
                  ),
                ],

                // Weekly usage display
                SizedBox(height: ThemeConstants.space16),
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

  Widget _buildStatItem(String label, String value, IconData icon, bool isDark) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: ThemeConstants.iconSmall,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
          SizedBox(width: ThemeConstants.space8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontXSmall,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    fontWeight: ThemeConstants.fontSemiBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
