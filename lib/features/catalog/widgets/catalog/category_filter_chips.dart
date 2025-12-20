// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

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
    final text = context.text;
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
    final text = context.text;
    final isSelected = selectedCategory == category;
    final label = category ?? 'All';
    final icon = category != null
        ? DrugCategories.categoryIconMap[category]
        : Icons.apps;
    final accentColor = t.accent.primary;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: t.spacing.lg,
              color: isSelected ? accentColor : t.colors.textSecondary,
            ),
            const CommonSpacer.horizontal(6),
          ],
          Text(label),
        ],
      ),
      onSelected: (_) => onCategorySelected(category),
      selectedColor: accentColor.withValues(alpha: 0.2),
      backgroundColor: t.colors.surface,
      labelStyle: t.typography.body.copyWith(
        color: isSelected ? accentColor : t.colors.textSecondary,
        fontWeight: isSelected
            ? context.text.bodyBold.fontWeight
            : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? accentColor : t.colors.border),
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.md,
        vertical: t.spacing.sm,
      ),
    );
  }
}
