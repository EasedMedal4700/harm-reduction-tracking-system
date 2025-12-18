// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and existing common components. No logic or state changes.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    
    return Container(
      padding: EdgeInsets.all(t.spacing.md),
      color: t.colors.surface,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: t.typography.body,
        decoration: InputDecoration(
          hintText: 'Search by name or category',
          hintStyle: t.typography.body.copyWith(
            color: t.colors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: t.colors.textSecondary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: t.colors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.shapes.radiusMd),
            borderSide: BorderSide(
              color: t.colors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.shapes.radiusMd),
            borderSide: BorderSide(
              color: t.colors.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.shapes.radiusMd),
            borderSide: BorderSide(
              color: t.colors.success,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
