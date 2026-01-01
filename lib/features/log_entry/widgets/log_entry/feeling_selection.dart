// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Feeling selection widget.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class FeelingSelection extends StatelessWidget {
  final String? selectedFeeling;
  final ValueChanged<String> onFeelingSelected;
  const FeelingSelection({
    super.key,
    required this.selectedFeeling,
    required this.onFeelingSelected,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = th.c;
    final tx = th.text;
    final sh = th.shapes;
    final feelings = [
      {
        'label': 'Great',
        'icon': Icons.sentiment_very_satisfied,
        'color': c.success,
      },
      {
        'label': 'Good',
        'icon': Icons.sentiment_satisfied,
        'color': c.success.withValues(alpha: th.opacities.medium),
      },
      {'label': 'Okay', 'icon': Icons.sentiment_neutral, 'color': c.warning},
      {
        'label': 'Bad',
        'icon': Icons.sentiment_dissatisfied,
        'color': c.warning.withValues(alpha: th.opacities.medium),
      },
      {
        'label': 'Awful',
        'icon': Icons.sentiment_very_dissatisfied,
        'color': c.error,
      },
    ];
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          'How are you feeling?',
          style: tx.bodyLarge.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: th.sp.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: feelings.map((feeling) {
              final isSelected = selectedFeeling == feeling['label'];
              final color = feeling['color'] as Color;
              return Padding(
                padding: EdgeInsets.only(right: th.sp.sm),
                child: InkWell(
                  onTap: () => onFeelingSelected(feeling['label'] as String),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: th.sp.md,
                      vertical: th.sp.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: th.opacities.selected)
                          : c.surface,
                      border: Border.all(
                        color: isSelected ? color : c.border,
                        width: isSelected ? th.borders.medium : th.borders.thin,
                      ),
                      borderRadius: BorderRadius.circular(sh.radiusMd),
                    ),
                    child: Column(
                      mainAxisSize: AppLayout.mainAxisSizeMin,
                      children: [
                        Icon(
                          feeling['icon'] as IconData,
                          color: isSelected ? color : c.textSecondary,
                          size: th.sizes.iconLg,
                        ),
                        SizedBox(height: th.sp.xs),
                        Text(
                          feeling['label'] as String,
                          style: tx.bodySmall.copyWith(
                            color: isSelected ? color : c.textSecondary,
                            fontWeight: isSelected
                                ? tx.bodyBold.fontWeight
                                : tx.body.fontWeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
