import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Collapsible filter panel for drug inclusion/exclusion
class FilterPanel extends StatelessWidget {
  final List<String> availableDrugs;
  final Set<String> includedDrugs;
  final Set<String> excludedDrugs;
  final Function(String, bool) onIncludeChanged;
  final Function(String, bool) onExcludeChanged;
  final VoidCallback onClearAll;

  const FilterPanel({
    required this.availableDrugs,
    required this.includedDrugs,
    required this.excludedDrugs,
    required this.onIncludeChanged,
    required this.onExcludeChanged,
    required this.onClearAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentRed;
    
    return Container(
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: 0,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              border: Border(
                bottom: BorderSide(
                  color: UIColors.lightBorder,
                  width: ThemeConstants.borderThin,
                ),
              ),
            ),
      padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Filters',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              const Spacer(),
              if (includedDrugs.isNotEmpty || excludedDrugs.isNotEmpty)
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: accentColor),
                  ),
                ),
            ],
          ),
          SizedBox(height: ThemeConstants.space8),
          Text(
            'Include Only:',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: availableDrugs.map((drug) {
              final isSelected = includedDrugs.contains(drug);
              return FilterChip(
                label: Text(drug.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) => onIncludeChanged(drug, selected),
                backgroundColor: isDark
                    ? UIColors.darkSurface.withValues(alpha: 0.5)
                    : UIColors.lightSurface,
                selectedColor: accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
                checkmarkColor: accentColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? accentColor
                      : (isDark ? UIColors.darkText : UIColors.lightText),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: ThemeConstants.space12),
          Text(
            'Exclude:',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: availableDrugs.map((drug) {
              final isSelected = excludedDrugs.contains(drug);
              final excludeColor = isDark ? UIColors.darkNeonPink : Colors.red;
              return FilterChip(
                label: Text(drug.toUpperCase()),
                selected: isSelected,
                selectedColor: excludeColor.withValues(alpha: isDark ? 0.3 : 0.2),
                backgroundColor: isDark
                    ? UIColors.darkSurface.withValues(alpha: 0.5)
                    : UIColors.lightSurface,
                checkmarkColor: excludeColor,
                labelStyle: TextStyle(
                  color: isSelected
                      ? excludeColor
                      : (isDark ? UIColors.darkText : UIColors.lightText),
                ),
                onSelected: (selected) => onExcludeChanged(drug, selected),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
