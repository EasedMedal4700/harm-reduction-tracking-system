// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard.
import 'package:flutter/material.dart';
import '../../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/data/drug_categories.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/stockpile_item.dart';
import '../../../repo/stockpile_repository.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';

const double _borderWidth = 1.5;
const double _dividerHeight = 1.0;
const double _tagSpacing = 6.0;
const double _tagPaddingH = 6.0;
const double _tagPaddingV = 2.0;

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
    final tx = context.text;
    final th = context.theme;
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
      padding: EdgeInsets.only(bottom: th.spacing.md),
      child: CommonCard(
        borderColor: th.isDark
            ? categoryColor.withValues(alpha: 0.3)
            : th.colors.border,
        child: Column(
          children: [
            // Main card content
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(th.shapes.radiusLg),
                topRight: Radius.circular(th.shapes.radiusLg),
              ),
              child: Padding(
                padding: EdgeInsets.all(th.spacing.md),
                child: Row(
                  children: [
                    // Left circular icon
                    Container(
                      width: th.sizes.buttonHeightLg,
                      height: th.sizes.buttonHeightLg,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            categoryColor.withValues(alpha: 0.2),
                            categoryColor.withValues(alpha: 0.05),
                          ],
                          begin: context.shapes.alignmentTopLeft,
                          end: context.shapes.alignmentBottomRight,
                        ),
                        shape: context.shapes.boxShapeCircle,
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.3),
                          width: _borderWidth,
                        ),
                      ),
                      child: Icon(
                        categoryIcon,
                        color: categoryColor,
                        size: context.sizes.iconLg,
                      ),
                    ),
                    SizedBox(width: th.spacing.md),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          Text(
                            name,
                            style: th.typography.heading3.copyWith(
                              color: th.colors.textPrimary,
                            ),
                          ),
                          SizedBox(height: th.spacing.xs),
                          Wrap(
                            spacing: _tagSpacing,
                            runSpacing: th.spacing.xs,
                            children: categories.take(3).map((cat) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: _tagPaddingH,
                                  vertical: _tagPaddingV,
                                ),
                                decoration: BoxDecoration(
                                  color: categoryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    th.shapes.radiusXs,
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    fontSize: tx.caption.fontSize,
                                    color: categoryColor,
                                    fontWeight: tx.bodyBold.fontWeight,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (additionalInfo != null) ...[
                            SizedBox(height: th.spacing.xs),
                            Text(
                              additionalInfo,
                              style: th.typography.bodySmall.copyWith(
                                color: th.colors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: th.colors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            // Divider
            Divider(height: _dividerHeight, color: th.colors.divider),
            // Action bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: th.spacing.md,
                vertical: th.spacing.sm,
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
                            horizontal: th.spacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: th.colors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              th.shapes.radiusSm,
                            ),
                            border: Border.all(
                              color: th.colors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: th.spacing.md,
                                color: th.colors.success,
                              ),
                              CommonSpacer.horizontal(th.spacing.xs),
                              Text(
                                '${amount.toStringAsFixed(1)} $unit',
                                style: th.typography.label.copyWith(
                                  color: th.colors.success,
                                  fontWeight: tx.bodyBold.fontWeight,
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
                    onPressed: () =>
                        onAddStockpile(substanceId, name, substance),
                    icon: Icon(
                      Icons.add,
                      size: th.spacing.lg,
                      color: th.accent.primary,
                    ),
                    label: Text(
                      'Add Stockpile',
                      style: th.typography.label.copyWith(
                        color: th.accent.primary,
                        fontWeight: tx.bodyBold.fontWeight,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: th.spacing.sm,
                        vertical: th.spacing.xs,
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
