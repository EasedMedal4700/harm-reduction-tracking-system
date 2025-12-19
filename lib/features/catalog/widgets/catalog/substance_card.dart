// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../models/stockpile_item.dart';
import '../../../../repo/stockpile_repository.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';

class SubstanceCard extends StatelessWidget {
  final Map<String, dynamic> substance;
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
    final t = context.theme;
    final name = substance['pretty_name'] ?? substance['name'] ?? 'Unknown';
    final substanceId = substance['name'] ?? 'unknown';
    final categories =
        (substance['categories'] as List<dynamic>?)
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

    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.md),
      child: CommonCard(
        borderColor: t.isDark
            ? categoryColor.withValues(alpha: 0.3)
            : t.colors.border,
        child: Column(
        children: [
          // Main card content
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(t.shapes.radiusLg),
              topRight: Radius.circular(t.shapes.radiusLg),
            ),
            child: Padding(
              padding: EdgeInsets.all(t.spacing.md),
              child: Row(
                children: [
                  // Left circular icon
                  Container(
                    width: t.sizes.buttonHeightLg,
                    height: t.sizes.buttonHeightLg,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor.withValues(alpha: 0.2),
                          categoryColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(categoryIcon, color: categoryColor, size: context.sizes.iconLg),
                    ),
                    SizedBox(width: t.spacing.md),

                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          Text(
                            name,
                            style: t.typography.heading3.copyWith(
                              color: t.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: t.spacing.xs),
                          Wrap(
                            spacing: 6,
                            runSpacing: t.spacing.xs,
                            children: categories.take(3).map((cat) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(t.shapes.radiusXs),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    fontSize: context.text.caption.fontSize,
                                    color: categoryColor,
                                    fontWeight: text.bodyBold.fontWeight,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (additionalInfo != null) ...[
                            SizedBox(height: t.spacing.xs),
                            Text(
                              additionalInfo,
                              style: t.typography.bodySmall.copyWith(
                                color: t.colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: t.colors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            Divider(height: 1, color: t.colors.divider),

            // Action bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.md,
                vertical: t.spacing.sm,
              ),
              child: Row(
                children: [
                  // Stockpile status
                  FutureBuilder<StockpileItem?>(
                    future: StockpileRepository().getStockpile(substanceId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final item = snapshot.data!;
                        final amount = item.unitMg != null && item.unitMg! > 1.0
                            ? (item.currentAmountMg / item.unitMg!)
                            : item.currentAmountMg;
                        final unit = item.unitMg != null && item.unitMg! > 1.0
                            ? 'units'
                            : 'mg';
                        
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: t.spacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: t.colors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              t.shapes.radiusSm,
                            ),
                            border: Border.all(
                              color: t.colors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: t.spacing.md,
                                color: t.colors.success,
                              ),
                              CommonSpacer.horizontal(t.spacing.xs),
                              Text(
                                '${amount.toStringAsFixed(1)} $unit',
                                style: t.typography.label.copyWith(
                                  color: t.colors.success,
                                  fontWeight: text.bodyBold.fontWeight,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const Spacer(),

                  // Add to stockpile button
                  TextButton.icon(
                    onPressed: () => onAddStockpile(
                      substanceId,
                      name,
                      substance,
                    ),
                    icon: Icon(Icons.add, size: t.spacing.lg, color: t.accent.primary),
                    label: Text(
                      'Add Stockpile',
                      style: t.typography.label.copyWith(
                        color: t.accent.primary,
                        fontWeight: text.bodyBold.fontWeight,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: t.spacing.sm,
                        vertical: t.spacing.xs,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
