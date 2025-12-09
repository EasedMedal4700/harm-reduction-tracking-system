// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Initial migration header added. Not migrated yet.
import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class CatalogSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final Color accentColor;
  final VoidCallback onChanged;

  const CatalogSearchBar({
    super.key,
    required this.controller,
    required this.isDark,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        style: TextStyle(
          color: isDark ? UIColors.darkText : UIColors.lightText,
        ),
        decoration: InputDecoration(
          hintText: 'Search substances...',
          hintStyle: TextStyle(
            color: isDark
                ? UIColors.darkTextSecondary
                : UIColors.lightTextSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark
                ? UIColors.darkTextSecondary
                : UIColors.lightTextSecondary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space16,
            vertical: ThemeConstants.space12,
          ),
        ),
      ),
    );
  }
}
