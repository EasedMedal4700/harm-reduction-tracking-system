import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/drug_use_catalog.dart';

/// Route of administration card with pill-shaped buttons
class RouteOfAdministrationCard extends StatelessWidget {
  final String route;
  final ValueChanged<String> onRouteChanged;

  const RouteOfAdministrationCard({
    required this.route,
    required this.onRouteChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Route of Administration',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // ROA buttons
          Wrap(
            spacing: ThemeConstants.space8,
            runSpacing: ThemeConstants.space8,
            children: DrugUseCatalog.consumptionMethods.map((method) {
              final methodName = method['name']!;
              final emoji = method['emoji']!;
              final isSelected = route.toLowerCase() == methodName.toLowerCase();
              final accentColor = isDark 
                  ? UIColors.darkNeonBlue
                  : UIColors.lightAccentBlue;
              
              return _buildROAButton(
                context,
                isDark,
                methodName,
                emoji,
                isSelected,
                accentColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildROAButton(
    BuildContext context,
    bool isDark,
    String methodName,
    String emoji,
    bool isSelected,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: () => onRouteChanged(methodName),
      child: AnimatedContainer(
        duration: ThemeConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space16,
          vertical: ThemeConstants.space12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? accentColor.withOpacity(0.15) : accentColor.withOpacity(0.1))
              : (isDark ? const Color(0x08FFFFFF) : UIColors.lightSurface),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
          border: Border.all(
            color: isSelected
                ? accentColor
                : (isDark ? const Color(0x14FFFFFF) : UIColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? UIColors.createNeonGlow(accentColor, intensity: 0.2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: ThemeConstants.space8),
            Text(
              _capitalizeFirst(methodName),
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: isSelected 
                    ? ThemeConstants.fontSemiBold
                    : ThemeConstants.fontRegular,
                color: isSelected
                    ? (isDark ? UIColors.darkText : UIColors.lightText)
                    : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  BoxDecoration _buildDecoration(bool isDark) {
    if (isDark) {
      return BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 1,
        ),
      );
    } else {
      return BoxDecoration(
        color: UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}
