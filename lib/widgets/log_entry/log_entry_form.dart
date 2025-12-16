import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'simple_fields.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/complex_fields.dart';

class LogEntryForm extends StatelessWidget {
  final bool isSimpleMode;

  final double dose;
  final String unit;
  final String substance;
  final String route;
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final String location;
  final DateTime date;
  final int hour;
  final int minute;

  final bool isMedicalPurpose;
  final double cravingIntensity;
  final String? intention;
  final List<String> selectedTriggers;
  final List<String> selectedBodySignals;

  final TextEditingController notesCtrl;
  final TextEditingController? doseCtrl;
  final TextEditingController? substanceCtrl;

  final ValueChanged<double> onDoseChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<String> onSubstanceChanged;
  final ValueChanged<String> onRouteChanged;
  final ValueChanged<List<String>> onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryFeelingsChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<bool> onMedicalPurposeChanged;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<String?> onIntentionChanged;
  final ValueChanged<List<String>> onTriggersChanged;
  final ValueChanged<List<String>> onBodySignalsChanged;

  final VoidCallback onSave;
  final GlobalKey<FormState> formKey;
  final bool showSaveButton;

  const LogEntryForm({
    super.key,
    required this.isSimpleMode,
    required this.dose,
    required this.unit,
    required this.substance,
    required this.route,
    required this.feelings,
    required this.secondaryFeelings,
    required this.location,
    required this.date,
    required this.hour,
    required this.minute,
    required this.isMedicalPurpose,
    required this.cravingIntensity,
    required this.intention,
    required this.selectedTriggers,
    required this.selectedBodySignals,
    required this.notesCtrl,
    required this.formKey,
    required this.onDoseChanged,
    required this.onUnitChanged,
    required this.onSubstanceChanged,
    required this.onRouteChanged,
    required this.onFeelingsChanged,
    required this.onSecondaryFeelingsChanged,
    required this.onLocationChanged,
    required this.onDateChanged,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onMedicalPurposeChanged,
    required this.onCravingIntensityChanged,
    required this.onIntentionChanged,
    required this.onTriggersChanged,
    required this.onBodySignalsChanged,
    required this.onSave,
    this.showSaveButton = true,
    this.substanceCtrl,
    this.doseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);

    return Form(
      key: formKey,
      child: Column(
        children: [
          SimpleFields(
            dose: dose,
            unit: unit,
            substance: substance,
            route: route,
            feelings: feelings,
            secondaryFeelings: secondaryFeelings,
            location: location,
            date: date,
            hour: hour,
            minute: minute,
            onDoseChanged: onDoseChanged,
            onUnitChanged: onUnitChanged,
            onSubstanceChanged: onSubstanceChanged,
            onRouteChanged: onRouteChanged,
            onFeelingsChanged: onFeelingsChanged,
            onSecondaryFeelingsChanged: onSecondaryFeelingsChanged,
            onLocationChanged: onLocationChanged,
            onDateChanged: onDateChanged,
            onHourChanged: onHourChanged,
            onMinuteChanged: onMinuteChanged,
            isMedicalPurpose: isMedicalPurpose,
            onMedicalPurposeChanged: onMedicalPurposeChanged,
            substanceCtrl: substanceCtrl,
            doseCtrl: doseCtrl,
          ),
          
          if (!isSimpleMode) ...[
            SizedBox(height: t.spacing.l),
            ComplexFields(
              cravingIntensity: cravingIntensity,
              intention: intention,
              selectedTriggers: selectedTriggers,
              selectedBodySignals: selectedBodySignals,
              onCravingIntensityChanged: onCravingIntensityChanged,
              onIntentionChanged: onIntentionChanged,
              onTriggersChanged: onTriggersChanged,
              onBodySignalsChanged: onBodySignalsChanged,
            ),
          ],

          SizedBox(height: t.spacing.l),

          // Notes
          Container(
            padding: EdgeInsets.all(t.spacing.m),
            decoration: BoxDecoration(
              color: t.colors.surface,
              borderRadius: BorderRadius.circular(t.shapes.radiusLg),
              border: Border.all(color: t.colors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notes",
                  style: t.typography.titleMedium.copyWith(
                    color: t.colors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: t.spacing.m),
                TextFormField(
                  controller: notesCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Add any additional notes here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(t.shapes.radiusM),
                    ),
                  ),
                  style: t.typography.bodyLarge,
                ),
              ],
            ),
          ),

          if (showSaveButton) ...[
            SizedBox(height: t.spacing.xl),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSave,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: t.spacing.m),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(t.shapes.radiusM),
                  ),
                ),
                child: Text(
                  "Save Entry",
                  style: t.typography.titleMedium.copyWith(
                    color: t.colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          
          SizedBox(height: t.spacing.xxl),
        ],
      ),
    );
  }
}

