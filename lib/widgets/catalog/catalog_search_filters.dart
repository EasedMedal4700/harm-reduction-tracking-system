import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import 'catalog_search_bar.dart';
import 'category_filter_chips.dart';
import 'common_filter_toggle.dart';

class CatalogSearchFilters extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final List<String> selectedCategories;
  final bool showCommonOnly;
  final bool isDark;
  final Color accentColor;
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
    required this.isDark,
    required this.accentColor,
    required this.onSearchClear,
    required this.onSearchChanged,
    required this.onCategoryToggled,
    required this.onCommonOnlyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.homePagePadding),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            width: ThemeConstants.borderThin,
          ),
        ),
      ),
      child: Column(
        children: [
          CatalogSearchBar(
            controller: searchController,
            isDark: isDark,
            accentColor: accentColor,
            onChanged: () {
              onSearchChanged(searchController.text);
            },
          ),
          SizedBox(height: ThemeConstants.space16),
          CategoryFilterChips(
            selectedCategory: selectedCategories.isNotEmpty ? selectedCategories.first : null,
            isDark: isDark,
            accentColor: accentColor,
            onCategorySelected: (category) {
              if (category != null) {
                onCategoryToggled(category);
              }
            },
          ),
          SizedBox(height: ThemeConstants.space16),
          CommonFilterToggle(
            showCommonOnly: showCommonOnly,
            isDark: isDark,
            accentColor: accentColor,
            onChanged: onCommonOnlyChanged,
          ),
        ],
      ),
    );
  }
}
