import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class CatalogAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CatalogAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final accentColor = t.accent.primary;

    return AppBar(
      backgroundColor: t.colors.surface,
      elevation: t.sizes.elevationNone,
      // Automatic hamburger menu icon when drawer is present
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(t.spacing.xs),
            margin: EdgeInsets.only(right: t.spacing.sm),
            decoration: BoxDecoration(
              color: t.colors.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(t.shapes.radiusSm),
              border: Border.all(color: accentColor.withValues(alpha: t.opacities.slow)),
            ),
            child: Icon(Icons.science_outlined, color: accentColor),
          ),
          Text(
            'Substance Catalog',
            style: t.typography.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
