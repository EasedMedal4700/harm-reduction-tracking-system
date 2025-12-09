// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class LibrarySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const LibrarySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space12),
      color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: isDark ? UIColors.darkText : UIColors.lightText,
        ),
        decoration: InputDecoration(
          hintText: 'Search by name or category',
          hintStyle: TextStyle(
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: isDark
              ? UIColors.darkBackground
              : UIColors.lightBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            borderSide: BorderSide(
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            borderSide: BorderSide(
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            borderSide: BorderSide(
              color: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
