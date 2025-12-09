
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../constants/data/craving_consatnts.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../common/old_common/modern_form_card.dart';
import '../../common/old_common/craving_slider.dart';
import '../../common/old_common/location_dropdown.dart';

class CravingDetailsSection extends StatelessWidget {
  final List<String> selectedCravings;
  final ValueChanged<List<String>> onCravingsChanged;
  final double intensity;
  final ValueChanged<double> onIntensityChanged;
  final String location;
  final ValueChanged<String?> onLocationChanged;
  final String? withWho;
  final ValueChanged<String?> onWithWhoChanged;

  const CravingDetailsSection({
    super.key,
    required this.selectedCravings,
    required this.onCravingsChanged,
    required this.intensity,
    required this.onIntensityChanged,
    required this.location,
    required this.onLocationChanged,
    required this.withWho,
    required this.onWithWhoChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ModernFormCard(
      title: 'Craving Details',
      icon: Icons.psychology,
      accentColor: isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What were you craving?',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: cravingCategories.entries.map((entry) {
              final isSelected = selectedCravings.contains(entry.key);
              return FilterChip(
                label: Text(entry.key),
                selected: isSelected,
                onSelected: (selected) => onCravingsChanged(
                  selected
                      ? [...selectedCravings, entry.key]
                      : selectedCravings.where((c) => c != entry.key).toList(),
                ),
                selectedColor: (isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple).withValues(alpha: 0.3),
                checkmarkColor: isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple,
              );
            }).toList(),
          ),
          if (selectedCravings.isNotEmpty) ...[
            SizedBox(height: ThemeConstants.space12),
            Text(
              'Selected: ${selectedCravings.join('; ')}',
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
          ],
          SizedBox(height: ThemeConstants.space16),
          CravingSlider(value: intensity, onChanged: onIntensityChanged),
          SizedBox(height: ThemeConstants.space16),
          LocationDropdown(location: location, onLocationChanged: onLocationChanged),
          SizedBox(height: ThemeConstants.space16),
          ModernDropdownField<String>(
            label: 'Who were you with?',
            value: withWho?.isEmpty == true ? null : withWho,
            items: const ['Alone', 'Friends', 'Family', 'Other'],
            itemLabel: (item) => item,
            onChanged: onWithWhoChanged,
          ),
        ],
      ),
    );
  }
}