import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/inputs/common_input_field.dart';
import '../../common/inputs/common_dropdown.dart';
import '../../common/layout/common_spacer.dart';

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
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const CommonSectionHeader(
            title: 'Dosage',
          ),
          
          CommonSpacer.vertical(ThemeConstants.space12),
          
          // Dose and unit row
          Row(
            children: [
              // Dose input
              Expanded(
                flex: 2,
                child: CommonInputField(
                  controller: doseCtrl,
                  hintText: '0.0',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              
              CommonSpacer.horizontal(ThemeConstants.space12),
              
              // Unit dropdown
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
        ],
      ),
    );
  }
}
