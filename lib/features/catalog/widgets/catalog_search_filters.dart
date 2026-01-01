// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer.
import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import 'catalog_search_bar.dart';
import 'category_filter_chips.dart';
import 'common_filter_toggle.dart';

class CatalogSearchFilters extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final List<String> selectedCategories;
  final bool showCommonOnly;
  final VoidCallback onSearchClear;
  final ValueChanged<String> onSearchChanged;
  final Function(String?) onCategoryToggled;
  final ValueChanged<bool> onCommonOnlyChanged;
  const CatalogSearchFilters({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.selectedCategories,
    required this.showCommonOnly,
    required this.onSearchClear,
    required this.onSearchChanged,
    required this.onCategoryToggled,
    required this.onCommonOnlyChanged,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return Container(
      padding: EdgeInsets.all(th.sp.md),
      decoration: BoxDecoration(
        color: th.colors.surface,
        border: Border(
          bottom: BorderSide(color: th.colors.border, width: th.borders.thin),
        ),
      ),
      child: Column(
        children: [
          CatalogSearchBar(
            controller: searchController,
            onChanged: () {
              onSearchChanged(searchController.text);
            },
          ),
          CommonSpacer.vertical(th.sp.lg),
          CategoryFilterChips(
            selectedCategory: selectedCategories.isNotEmpty
                ? selectedCategories.first
                : null,
            onCategorySelected: (category) {
              if (category != null) {
                onCategoryToggled(category);
              }
            },
          ),
          CommonSpacer.vertical(th.sp.lg),
          CommonFilterToggle(
            showCommonOnly: showCommonOnly,
            onChanged: onCommonOnlyChanged,
          ),
        ],
      ),
    );
  }
}
