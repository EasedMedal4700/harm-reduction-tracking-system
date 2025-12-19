// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonInputField.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/inputs/input_field.dart';

class CatalogSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const CatalogSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return CommonInputField(
      controller: controller,
      hintText: 'Search substances...',
      prefixIcon: Icon(
        Icons.search,
        color: t.colors.textSecondary,
      ),
      onChanged: (_) => onChanged(),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: Icon(
                Icons.clear,
                color: t.colors.textSecondary,
              ),
              onPressed: () {
                controller.clear();
                onChanged();
              },
            )
          : null,
    );
  }
}
