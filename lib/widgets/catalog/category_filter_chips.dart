import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/drug_categories.dart';

class CategoryFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final bool isDark;
  final Color accentColor;
  final Function(String?) onCategorySelected;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.isDark,
    required this.accentColor,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = <String?>[
      null, // "All" option
      ...DrugCategories.categoryPriority,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildFilterChip(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(String? category) {
    final isSelected = selectedCategory == category;
    final label = category ?? 'All';
    final icon = category != null
        ? DrugCategories.categoryIconMap[category]
        : Icons.apps;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? accentColor
                  : (isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary),
            ),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
      onSelected: (_) => onCategorySelected(category),
      selectedColor: accentColor.withValues(alpha: 0.2),
      backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
      labelStyle: TextStyle(
        color: isSelected
            ? accentColor
            : (isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected
            ? accentColor
            : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
