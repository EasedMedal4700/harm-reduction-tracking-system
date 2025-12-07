import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class CatalogEmptyState extends StatelessWidget {
  final bool isDark;

  const CatalogEmptyState({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(ThemeConstants.space24),
            decoration: BoxDecoration(
              color: isDark
                  ? UIColors.darkSurfaceLight.withValues(alpha: 0.5)
                  : UIColors.lightDivider,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: ThemeConstants.space24),
          Text(
            'No substances found',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
