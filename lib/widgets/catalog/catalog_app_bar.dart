// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Initial migration header added. Not migrated yet.
import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class CatalogAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final Color accentColor;

  const CatalogAppBar({
    super.key,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
      elevation: 0,
      // Automatic hamburger menu icon when drawer is present
      title: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: ThemeConstants.space8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              boxShadow: isDark
                  ? UIColors.createNeonGlow(accentColor, intensity: 0.2)
                  : null,
            ),
            child: Icon(Icons.science_outlined, color: accentColor),
          ),
          Text(
            'Substance Catalog',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}
