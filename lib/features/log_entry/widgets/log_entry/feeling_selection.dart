// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
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
    final c = context.colors;
    final text = context.text;
    // acc unused
    final sp = context.spacing;
    final sh = context.shapes;

    final feelings = [
      {
        'label': 'Great',
        'icon': Icons.sentiment_very_satisfied,
        'color': c.success,
      },
      {
        'label': 'Good',
        'icon': Icons.sentiment_satisfied,
        'color': c.success.withValues(alpha: 0.7),
      },
      {'label': 'Okay', 'icon': Icons.sentiment_neutral, 'color': c.warning},
      {
        'label': 'Bad',
        'icon': Icons.sentiment_dissatisfied,
        'color': c.warning.withValues(alpha: 0.7),
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
          style: text.bodyLarge.copyWith(
            fontWeight: text.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: sp.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: feelings.map((feeling) {
              final isSelected = selectedFeeling == feeling['label'];
              final color = feeling['color'] as Color;

              return Padding(
                padding: EdgeInsets.only(right: sp.sm),
                child: InkWell(
                  onTap: () => onFeelingSelected(feeling['label'] as String),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sp.md,
                      vertical: sp.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: context.opacities.selected)
                          : c.surface,
                      border: Border.all(
                        color: isSelected ? color : c.border,
                        width: isSelected
                            ? context.borders.medium
                            : context.borders.thin,
                      ),
                      borderRadius: BorderRadius.circular(sh.radiusMd),
                    ),
                    child: Column(
                      mainAxisSize: AppLayout.mainAxisSizeMin,
                      children: [
                        Icon(
                          feeling['icon'] as IconData,
                          color: isSelected ? color : c.textSecondary,
                          size: context.sizes.iconLg,
                        ),
                        SizedBox(height: sp.xs),
                        Text(
                          feeling['label'] as String,
                          style: text.bodySmall.copyWith(
                            color: isSelected ? color : c.textSecondary,
                            fontWeight: isSelected
                                ? text.bodyBold.fontWeight
                                : text.body.fontWeight,
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
