import 'package:flutter/material.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class CategoryFilterChips extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
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
            child: _buildFilterChip(context, category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String? category) {
    final t = context.theme;
    final isSelected = selectedCategory == category;
    final label = category ?? 'All';
    final icon = category != null
        ? DrugCategories.categoryIconMap[category]
        : Icons.apps;
    final accentColor = t.accent.primary;

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
                  : t.colors.textSecondary,
            ),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
      onSelected: (_) => onCategorySelected(category),
      selectedColor: accentColor.withValues(alpha: 0.2),
      backgroundColor: t.colors.surface,
      labelStyle: t.typography.body.copyWith(
        color: isSelected
            ? accentColor
            : t.colors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected
            ? accentColor
            : t.colors.border,
      ),
      padding: EdgeInsets.symmetric(horizontal: t.spacing.md, vertical: t.spacing.sm),
    );
  }
}
