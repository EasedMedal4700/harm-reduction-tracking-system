import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/substance_autocomplete.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/dosage_input.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/date_selector.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/time_selector.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/feeling_selection.dart';

class SimpleFields extends StatelessWidget {
  final TextEditingController substanceController;
  final TextEditingController dosageController;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String? selectedFeeling;
  final List<String> substanceOptions;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final ValueChanged<String> onFeelingSelected;

  const SimpleFields({
    super.key,
    required this.substanceController,
    required this.dosageController,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedFeeling,
    required this.substanceOptions,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onFeelingSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Substance Autocomplete
        SubstanceAutocomplete(
          controller: substanceController,
          options: substanceOptions,
        ),
        SizedBox(height: sp.md),

        // Dosage Input
        DosageInput(
          controller: dosageController,
          unit: 'mg', // TODO: Make dynamic based on substance
        ),
        SizedBox(height: sp.md),

        // Date and Time Row
        Row(
          children: [
            Expanded(
              child: DateSelector(
                selectedDate: selectedDate,
                onDateChanged: onDateChanged,
              ),
            ),
            SizedBox(width: sp.md),
            Expanded(
              child: TimeSelector(
                selectedTime: selectedTime,
                onTimeChanged: onTimeChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: sp.md),

        // Feeling Selection
        FeelingSelection(
          selectedFeeling: selectedFeeling,
          onFeelingSelected: onFeelingSelected,
        ),
      ],
    );
  }
}
