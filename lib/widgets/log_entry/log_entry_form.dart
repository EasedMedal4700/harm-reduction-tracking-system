import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/data/drug_use_catalog.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/input_field.dart';
import 'package:mobile_drug_use_app/common/inputs/textarea.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';

class LogEntryForm extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final bool isSimpleMode;
  
  // Data
  final double? dose;
  final String? unit;
  final String? substance;
  final String? route;
  final List<String>? feelings;
  final Map<String, List<String>>? secondaryFeelings;
  final String? location;
  final DateTime? date;
  final int? hour;
  final int? minute;
  final bool? isMedicalPurpose;
  final double? cravingIntensity;
  final String? intention;
  final List<String>? selectedTriggers;
  final List<String>? selectedBodySignals;

  // Controllers
  final TextEditingController? notesCtrl;
  final TextEditingController? doseCtrl;
  final TextEditingController? substanceCtrl;

  // Callbacks
  final ValueChanged<double>? onDoseChanged;
  final ValueChanged<String>? onUnitChanged;
  final ValueChanged<String>? onSubstanceChanged;
  final ValueChanged<String>? onRouteChanged;
  final ValueChanged<List<String>>? onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>>? onSecondaryFeelingsChanged;
  final ValueChanged<String>? onLocationChanged;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<int>? onHourChanged;
  final ValueChanged<int>? onMinuteChanged;
  final ValueChanged<bool>? onMedicalPurposeChanged;
  final ValueChanged<double>? onCravingIntensityChanged;
  final ValueChanged<String>? onIntentionChanged;
  final ValueChanged<List<String>>? onTriggersChanged;
  final ValueChanged<List<String>>? onBodySignalsChanged;
  final VoidCallback? onSave;
  
  final bool showSaveButton;

  const LogEntryForm({
    super.key,
    this.formKey,
    required this.isSimpleMode,
    this.dose,
    this.unit,
    this.substance,
    this.route,
    this.feelings,
    this.secondaryFeelings,
    this.location,
    this.date,
    this.hour,
    this.minute,
    this.isMedicalPurpose,
    this.cravingIntensity,
    this.intention,
    this.selectedTriggers,
    this.selectedBodySignals,
    this.notesCtrl,
    this.doseCtrl,
    this.substanceCtrl,
    this.onDoseChanged,
    this.onUnitChanged,
    this.onSubstanceChanged,
    this.onRouteChanged,
    this.onFeelingsChanged,
    this.onSecondaryFeelingsChanged,
    this.onLocationChanged,
    this.onDateChanged,
    this.onHourChanged,
    this.onMinuteChanged,
    this.onMedicalPurposeChanged,
    this.onCravingIntensityChanged,
    this.onIntentionChanged,
    this.onTriggersChanged,
    this.onBodySignalsChanged,
    this.onSave,
    this.showSaveButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;

    final routeOptions = DrugUseCatalog.consumptionMethods
        .map((m) => m['name']!)
        .toList(growable: false);

    final normalizedRoute = () {
      final raw = route;
      if (raw == null || raw.trim().isEmpty) return 'oral';
      final lower = raw.toLowerCase();
      return routeOptions.contains(lower) ? lower : 'oral';
    }();
    
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Substance
          CommonInputField(
            controller: substanceCtrl,
            labelText: 'Substance',
            onChanged: onSubstanceChanged,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          SizedBox(height: sp.md),

          // Dose & Unit
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CommonInputField(
                  controller: doseCtrl,
                  labelText: 'Dose',
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    if (onDoseChanged != null) {
                      final val = double.tryParse(v);
                      if (val != null) onDoseChanged!(val);
                    }
                  },
                ),
              ),
              SizedBox(width: sp.md),
              Expanded(
                flex: 1,
                child: CommonDropdown<String>(
                  value: unit ?? 'mg',
                  items: const ['mg', 'g', 'ml', 'oz', 'pills', 'tabs'],
                  onChanged: (v) => onUnitChanged?.call(v ?? 'mg'),
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),

          // Route
          CommonDropdown<String>(
            value: normalizedRoute,
            items: routeOptions,
            itemLabel: (v) => v.isEmpty ? v : '${v[0].toUpperCase()}${v.substring(1)}',
            onChanged: (v) {
              if (v != null && onRouteChanged != null) {
                onRouteChanged!(v);
              }
            },
            hintText: 'Route of Administration',
          ),
          SizedBox(height: sp.md),

          // Notes
          CommonTextarea(
            controller: notesCtrl,
            labelText: 'Notes',
            maxLines: 3,
          ),
          SizedBox(height: sp.lg),

          if (showSaveButton && onSave != null)
            CommonPrimaryButton(
              onPressed: onSave!,
              label: 'Save Entry',
            ),
        ],
      ),
    );
  }
}
