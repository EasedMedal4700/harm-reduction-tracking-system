
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/inputs/input_field.dart';
import '../../common/inputs/dropdown.dart';
import '../../common/layout/common_spacer.dart';

class DosageCard extends StatelessWidget {
  final double dose;
  final String unit;
  final List<String> units;
  final ValueChanged<double> onDoseChanged;
  final ValueChanged<String> onUnitChanged;
  final TextEditingController? doseCtrl;

  const DosageCard({
    super.key,
    required this.dose,
    required this.unit,
    required this.units,
    required this.onDoseChanged,
    required this.onUnitChanged,
    this.doseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: 'Dosage',
            subtitle: 'How much did you take?',
          ),

          const CommonSpacer.vertical(ThemeConstants.space12),

          Row(
            children: [
              /// Dose input
              Expanded(
                flex: 2,
                child: CommonInputField(
                  controller: doseCtrl,
                  hintText: '0.0',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    final sanitized = value.replaceAll(',', '.').trim();
                    final parsed = double.tryParse(sanitized);
                    if (parsed != null) {
                      onDoseChanged(parsed);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    final sanitized = value.replaceAll(',', '.').trim();
                    if (double.tryParse(sanitized) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),

              const CommonSpacer.horizontal(ThemeConstants.space12),

              /// Unit dropdown
              Expanded(
                flex: 1,
                child: CommonDropdown<String>(
                  value: unit,
                  items: units,
                  onChanged: (value) {
                    if (value != null) {
                      onUnitChanged(value);
                    }
                  },
                ),
              ),
            ],
          ),

          const CommonSpacer.vertical(ThemeConstants.space4),
        ],
      ),
    );
  }
}
