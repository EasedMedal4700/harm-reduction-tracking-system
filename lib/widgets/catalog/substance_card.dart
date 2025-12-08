import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_categories.dart';
import '../../models/stockpile_item.dart';
import '../../repo/stockpile_repository.dart';

class SubstanceCard extends StatelessWidget {
  final Map<String, dynamic> substance;
  final bool isDark;
  final VoidCallback onTap;
  final Function(
    String substanceId,
    String name,
    Map<String, dynamic> substance,
  )
  onAddStockpile;
  final Future<String?> Function(String name) getMostActiveDay;

  const SubstanceCard({
    super.key,
    required this.substance,
    required this.isDark,
    required this.onTap,
    required this.onAddStockpile,
    required this.getMostActiveDay,
  });

  String _resolvePrimaryCategory(List<String> categories) {
    if (categories.isEmpty) return 'Other';
    for (final category in DrugCategories.categoryPriority) {
      if (categories.contains(category)) return category;
    }
    return categories.first;
  }

  @override
  Widget build(BuildContext context) {
    final name = substance['pretty_name'] ?? substance['name'] ?? 'Unknown';
    final substanceId = substance['name'] ?? 'unknown';
    final categories =
        (substance['categories'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final aliases =
        (substance['aliases'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final primaryCategory = _resolvePrimaryCategory(categories);
    final categoryColor = DrugCategoryColors.colorFor(primaryCategory);
    final categoryIcon =
        DrugCategories.categoryIconMap[primaryCategory] ?? Icons.science;

    // Get half-life or dose info
    String? additionalInfo;
    try {
      final properties = substance['properties'] as Map<String, dynamic>?;
      if (properties != null && properties['half-life'] != null) {
        additionalInfo = 'Half-life: ${properties['half-life']}';
      }
    } catch (e) {
      // Ignore
    }

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
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            // Main card content
            InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ThemeConstants.radiusLarge),
                topRight: Radius.circular(ThemeConstants.radiusLarge),
              ),
              child: Padding(
                padding: EdgeInsets.all(ThemeConstants.space16),
                child: Row(
                  children: [
                    // Left circular icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor,
                            categoryColor.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.radiusLarge,
                        ),
                        boxShadow: UIColors.createNeonGlow(
                          categoryColor,
                          intensity: 0.3,
                        ),
                      ),
                      child: Icon(
                        categoryIcon,
                        color: Colors.white,
                        size: ThemeConstants.iconLarge,
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space16),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: ThemeConstants.fontLarge,
                              fontWeight: ThemeConstants.fontBold,
                              color: isDark
                                  ? UIColors.darkText
                                  : UIColors.lightText,
                              letterSpacing: -0.5,
                            ),
                          ),
                          if (aliases.isNotEmpty) ...[
                            SizedBox(height: ThemeConstants.space4),
                            Text(
                              'Also known as: ${aliases.take(2).join(', ')}${aliases.length > 2 ? '...' : ''}',
                              style: TextStyle(
                                fontSize: ThemeConstants.fontSmall,
                                color: isDark
                                    ? UIColors.darkTextSecondary
                                    : UIColors.lightTextSecondary,
                              ),
                            ),
                          ],
                          if (additionalInfo != null) ...[
                            SizedBox(height: ThemeConstants.space4),
                            Text(
                              additionalInfo,
                              style: TextStyle(
                                fontSize: ThemeConstants.fontSmall,
                                fontWeight: ThemeConstants.fontMediumWeight,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space12),
                    // Category chip
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space12,
                        vertical: ThemeConstants.space8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor,
                            categoryColor.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.radiusMedium,
                        ),
                        boxShadow: UIColors.createNeonGlow(
                          categoryColor,
                          intensity: 0.2,
                        ),
                      ),
                      child: Text(
                        primaryCategory,
                        style: TextStyle(
                          fontSize: ThemeConstants.fontXSmall,
                          fontWeight: ThemeConstants.fontSemiBold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Stockpile section with FutureBuilder
            FutureBuilder<StockpileItem?>(
              future: StockpileRepository().getStockpile(substanceId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }

                final stockpile = snapshot.data;
                return Container(
                  padding: EdgeInsets.all(ThemeConstants.space12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? UIColors.darkBorder
                            : UIColors.lightBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Stockpile status
                          Expanded(
                            child: stockpile != null
                                ? _buildStockpileStatus(
                                    stockpile,
                                    isDark,
                                    categoryColor,
                                  )
                                : Text(
                                    'No stockpile tracked',
                                    style: TextStyle(
                                      fontSize: ThemeConstants.fontSmall,
                                      color: isDark
                                          ? UIColors.darkTextSecondary
                                          : UIColors.lightTextSecondary,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      // Weekly usage stats
                      FutureBuilder<String?>(
                        future: getMostActiveDay(name),
                        builder: (context, daySnapshot) {
                          if (daySnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          final mostActiveDay = daySnapshot.data;
                          if (mostActiveDay == null) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                              top: ThemeConstants.space8,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: isDark
                                      ? UIColors.darkTextSecondary
                                      : UIColors.lightTextSecondary,
                                ),
                                SizedBox(width: ThemeConstants.space4),
                                Text(
                                  'Most active: $mostActiveDay',
                                  style: TextStyle(
                                    fontSize: ThemeConstants.fontXSmall,
                                    color: isDark
                                        ? UIColors.darkTextSecondary
                                        : UIColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockpileStatus(
    StockpileItem stockpile,
    bool isDark,
    Color categoryColor,
  ) {
    final percentage = stockpile.getPercentage();
    final isLow = stockpile.isLow();
    final isEmpty = stockpile.isEmpty();

    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isEmpty) {
      statusColor = Colors.red;
      statusIcon = Icons.warning;
      statusText = 'Empty';
    } else if (isLow) {
      statusColor = Colors.orange;
      statusIcon = Icons.warning_amber;
      statusText = 'Low';
    } else {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Stocked';
    }

    return Row(
      children: [
        Icon(statusIcon, color: statusColor, size: 16),
        SizedBox(width: ThemeConstants.space4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$statusText: ${stockpile.currentAmountMg.toStringAsFixed(1)} mg',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontMediumWeight,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              SizedBox(height: ThemeConstants.space4),
              ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: isDark
                      ? UIColors.darkBorder
                      : UIColors.lightBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
