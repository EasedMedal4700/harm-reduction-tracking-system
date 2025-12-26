// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and existing common components. No logic or state changes.
import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/inputs/input_field.dart';

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
    final th = context.theme;
    return Container(
      padding: EdgeInsets.all(th.spacing.md),
      color: th.colors.surface,
      child: CommonInputField(
        controller: controller,
        onChanged: onChanged,
        hintText: 'Search by name or category',
        prefixIcon: Icon(Icons.search, color: th.colors.textSecondary),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
            : null,
      ),
    );
  }
}
