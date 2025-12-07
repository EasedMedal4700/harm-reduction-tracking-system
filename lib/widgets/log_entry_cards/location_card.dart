import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_use_catalog.dart';

/// Location selection card
class LocationCard extends StatelessWidget {
  final String location;
  final ValueChanged<String> onLocationChanged;

  const LocationCard({
    required this.location,
    required this.onLocationChanged,
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
            'Location',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Location dropdown
          DropdownButtonFormField<String>(
            value: location.isEmpty || location == 'Select a location' ? null : location,
            decoration: InputDecoration(
              hintText: 'Select location',
              hintStyle: TextStyle(
                color: isDark 
                    ? UIColors.darkTextSecondary.withOpacity(0.5)
                    : UIColors.lightTextSecondary.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
                  width: 2,
                ),
              ),
            ),
            style: TextStyle(
              color: isDark ? UIColors.darkText : UIColors.lightText,
              fontSize: ThemeConstants.fontMedium,
            ),
            dropdownColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
            items: DrugUseCatalog.locations
                .where((loc) => loc != 'Select a location')
                .map((loc) {
              return DropdownMenuItem(
                value: loc,
                child: Text(loc),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onLocationChanged(value);
              }
            },
          ),
        ],
      ),
    );
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
