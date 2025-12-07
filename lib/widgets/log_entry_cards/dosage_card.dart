import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Dosage input card
class DosageCard extends StatelessWidget {
  final double dose;
  final String unit;
  final List<String> units;
  final ValueChanged<double> onDoseChanged;
  final ValueChanged<String> onUnitChanged;
  final TextEditingController? doseCtrl;

  const DosageCard({
    required this.dose,
    required this.unit,
    required this.units,
    required this.onDoseChanged,
    required this.onUnitChanged,
    this.doseCtrl,
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
            'Dosage',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Dose and unit row
          Row(
            children: [
              // Dose input
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: doseCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      color: isDark 
                          ? UIColors.darkTextSecondary.withOpacity(0.5)
                          : UIColors.lightTextSecondary.withOpacity(0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                    fontSize: ThemeConstants.fontLarge,
                  ),
                  onChanged: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      onDoseChanged(parsed);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: ThemeConstants.space12),
              
              // Unit dropdown
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  value: unit,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    ),
                  ),
                  style: TextStyle(
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                    fontSize: ThemeConstants.fontMedium,
                  ),
                  dropdownColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
                  items: units.map((u) {
                    return DropdownMenuItem(
                      value: u,
                      child: Text(u),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onUnitChanged(value);
                    }
                  },
                ),
              ),
            ],
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
