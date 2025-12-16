import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(
          color: t.colors.border,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        style: t.text.body.copyWith(
          color: t.colors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search substances...',
          hintStyle: t.text.body.copyWith(
            color: t.colors.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: t.colors.textSecondary,
          ),
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
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: t.spacing.md,
            vertical: t.spacing.sm,
          ),
        ),
      ),
    );
  }
}
