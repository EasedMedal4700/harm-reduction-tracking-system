import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_use_catalog.dart';

/// Route of administration card with pill-shaped buttons
class RouteOfAdministrationCard extends StatelessWidget {
  final String route;
  final ValueChanged<String> onRouteChanged;
  final List<String> availableROAs; // Dynamic ROA list
  final bool Function(String)? isROAValidated; // Optional validation callback

  const RouteOfAdministrationCard({
    required this.route,
    required this.onRouteChanged,
    required this.availableROAs,
    this.isROAValidated,
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
          
          // ROA buttons - use dynamic availableROAs instead of static list
          Wrap(
            spacing: ThemeConstants.space8,
            runSpacing: ThemeConstants.space8,
            children: availableROAs.map((methodName) {
              final isSelected = route.toLowerCase() == methodName.toLowerCase();
              final isValidated = isROAValidated?.call(methodName) ?? true;
              final accentColor = isDark 
                  ? UIColors.darkNeonBlue
                  : UIColors.lightAccentBlue;
              
              // Find emoji from catalog, fallback to generic emoji
              final catalogEntry = DrugUseCatalog.consumptionMethods.firstWhere(
                (m) => m['name']!.toLowerCase() == methodName.toLowerCase(),
                orElse: () => {'name': methodName, 'emoji': '💊'},
              );
              final emoji = catalogEntry['emoji']!;
              
              return _buildROAButton(
                context,
                isDark,
                methodName,
                emoji,
                isSelected,
                isValidated,
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
    bool isValidated,
    Color accentColor,
  ) {
    // Use warning color if not validated
    final buttonColor = !isValidated
        ? (isDark ? UIColors.darkNeonOrange : Colors.orange)
        : accentColor;

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
              ? (isDark ? buttonColor.withOpacity(0.15) : buttonColor.withOpacity(0.1))
              : (isDark ? const Color(0x08FFFFFF) : UIColors.lightSurface),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
          border: Border.all(
            color: isSelected
                ? buttonColor
                : (isDark ? const Color(0x14FFFFFF) : UIColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? UIColors.createNeonGlow(buttonColor, intensity: 0.2)
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
            // Show warning icon if not validated
            if (!isValidated) ...[
              const SizedBox(width: ThemeConstants.space4),
              Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: buttonColor,
              ),
            ],
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
