// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/data/drug_categories.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';

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
    final tx = context.text;

    final th = context.theme;
    final isSelected = selectedCategory == category;
    final label = category ?? 'All';
    final icon = category != null
        ? DrugCategories.categoryIconMap[category]
        : Icons.apps;
    final accentColor = th.accent.primary;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: th.spacing.lg,
              color: isSelected ? accentColor : th.colors.textSecondary,
            ),
            const CommonSpacer.horizontal(6),
          ],
          Text(label),
        ],
      ),
      onSelected: (_) => onCategorySelected(category),
      selectedColor: accentColor.withValues(alpha: 0.2),
      backgroundColor: th.colors.surface,
      labelStyle: th.typography.body.copyWith(
        color: isSelected ? accentColor : th.colors.textSecondary,
        fontWeight: isSelected ? tx.bodyBold.fontWeight : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? accentColor : th.colors.border),
      padding: EdgeInsets.symmetric(
        horizontal: th.spacing.md,
        vertical: th.spacing.sm,
      ),
    );
  }
}
