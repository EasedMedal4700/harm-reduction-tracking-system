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
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubstanceCard extends StatelessWidget {
  final Map<String, dynamic> substance;
  final VoidCallback onTap;
  final void Function(String substanceId, String name, Map<String, dynamic>)
  onAddStockpile;
  final Future<String?> Function(String substanceName) getMostActiveDay;

  const SubstanceCard({
    super.key,
    required this.substance,
    required this.onTap,
    required this.onAddStockpile,
    required this.getMostActiveDay,
  });

  @override
  Widget build(BuildContext context) {
    final th = context.theme;

    final name = (substance['pretty_name'] ?? substance['name'] ?? '')
        .toString();
    final substanceId =
        ((substance['id'] ?? substance['substance_id']) ??
                substance['name'] ??
                substance['pretty_name'] ??
                '')
            .toString();
    final categories =
        (substance['categories'] as List?)?.map((e) => e.toString()).toList() ??
        <String>[];
    final primaryCategory = categories.isNotEmpty
        ? categories.first
        : 'Placeholder';
    final categoryColor = DrugCategoryColors.colorFor(primaryCategory);
    final categoryIcon =
        DrugCategories.categoryIconMap[primaryCategory] ??
        DrugCategories.categoryIconMap['Placeholder']!;

    final additionalInfoRaw = substance['summary'] ?? substance['description'];
    final additionalInfo =
        (additionalInfoRaw is String && additionalInfoRaw.trim().isNotEmpty)
        ? additionalInfoRaw.trim()
        : null;

    return CommonCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(th.shapes.radiusLg),
              topRight: Radius.circular(th.shapes.radiusLg),
            ),
            child: Padding(
              padding: EdgeInsets.all(th.sp.md),
              child: Row(
                children: [
                  Container(
                    width: th.sizes.buttonHeightLg,
                    height: th.sizes.buttonHeightLg,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor.withValues(alpha: th.opacities.selected),
                          categoryColor.withValues(alpha: th.opacities.splash),
                        ],
                        begin: context.shapes.alignmentTopLeft,
                        end: context.shapes.alignmentBottomRight,
                      ),
                      shape: context.shapes.boxShapeCircle,
                      border: Border.all(
                        color: categoryColor.withValues(alpha: th.opacities.medium),
                        width: th.borders.thin,
                      ),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: categoryColor,
                      size: th.sizes.iconLg,
                    ),
                  ),
                  SizedBox(width: th.sp.md),
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
                        SizedBox(height: th.sp.xs),
                        Wrap(
                          spacing: th.sp.xs,
                          runSpacing: th.sp.xs,
                          children: categories.take(3).map((cat) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: th.sp.xs,
                                vertical: th.sizes.borderRegular,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: th.opacities.overlay),
                                borderRadius: BorderRadius.circular(
                                  th.shapes.radiusXs,
                                ),
                              ),
                              child: Text(
                                cat,
                                style: th.tx.captionBold.copyWith(
                                  color: categoryColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (additionalInfo != null) ...[
                          SizedBox(height: th.sp.xs),
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
                    color: th.colors.textSecondary.withValues(alpha: th.opacities.slow),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: th.borders.thin, color: th.colors.divider),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: th.sp.md,
              vertical: th.sp.sm,
            ),
            child: Row(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    return FutureBuilder<StockpileItem?>(
                      future: ref
                          .read(stockpileRepositoryProvider)
                          .getStockpile(substanceId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final item = snapshot.data!;
                          final amount =
                              item.unitMg != null && item.unitMg! > 1.0
                              ? (item.currentAmountMg / item.unitMg!)
                              : item.currentAmountMg;
                          final unit = item.unitMg != null && item.unitMg! > 1.0
                              ? 'units'
                              : 'mg';
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: th.sp.sm,
                              vertical: th.sizes.borderRegular,
                            ),
                            decoration: BoxDecoration(
                              color: th.colors.success.withValues(alpha: th.opacities.overlay),
                              borderRadius: BorderRadius.circular(
                                th.shapes.radiusSm,
                              ),
                              border: Border.all(
                                color: th.colors.success.withValues(alpha: th.opacities.medium),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: th.sizes.iconSm,
                                  color: th.colors.success,
                                ),
                                CommonSpacer.horizontal(th.sp.xs),
                                Text(
                                  '${amount.toStringAsFixed(1)} $unit',
                                  style: th.tx.label.copyWith(
                                    color: th.colors.success,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => onAddStockpile(substanceId, name, substance),
                  icon: Icon(
                    Icons.add,
                    size: th.sizes.iconSm,
                    color: th.accent.primary,
                  ),
                  label: Text(
                    'Add Stockpile',
                    style: th.tx.label.copyWith(color: th.accent.primary),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: th.sp.sm,
                      vertical: th.sp.xs,
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
    );
  }
}
