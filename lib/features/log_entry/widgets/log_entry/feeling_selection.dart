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

  final List<Map<String, dynamic>> _feelings = const [
    {
      'label': 'Great',
      'icon': Icons.sentiment_very_satisfied,
      'color': Colors.green,
    },
    {
      'label': 'Good',
      'icon': Icons.sentiment_satisfied,
      'color': Colors.lightGreen,
    },
    {'label': 'Okay', 'icon': Icons.sentiment_neutral, 'color': Colors.amber},
    {
      'label': 'Bad',
      'icon': Icons.sentiment_dissatisfied,
      'color': Colors.orange,
    },
    {
      'label': 'Awful',
      'icon': Icons.sentiment_very_dissatisfied,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    // acc unused
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: text.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: sp.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _feelings.map((feeling) {
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
                        SizedBox(height: 4.0),
                        Text(
                          feeling['label'] as String,
                          style: TextStyle(
                            color: isSelected ? color : c.textSecondary,
                            fontWeight: isSelected
                                ? text.bodyBold.fontWeight
                                : text.body.fontWeight,
                            fontSize: 12.0,
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
