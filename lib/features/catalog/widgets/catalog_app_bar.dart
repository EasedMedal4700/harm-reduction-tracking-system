import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';

class CatalogAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CatalogAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final accentColor = th.accent.primary;
    return AppBar(
      backgroundColor: th.colors.surface,
      elevation: th.sizes.elevationNone,
      // Automatic hamburger menu icon when drawer is present
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(th.spacing.xs),
            margin: EdgeInsets.only(right: th.spacing.sm),
            decoration: BoxDecoration(
              color: th.colors.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(th.shapes.radiusSm),
              border: Border.all(
                color: accentColor.withValues(alpha: th.opacities.slow),
              ),
            ),
            child: Icon(Icons.science_outlined, color: accentColor),
          ),
          Text(
            'Substance Catalog',
            style: th.typography.heading3.copyWith(
              color: th.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
