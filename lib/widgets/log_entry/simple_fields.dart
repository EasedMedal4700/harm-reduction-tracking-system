import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';
import '../../constants/data/drug_use_catalog.dart';
import 'dosage_input.dart';
import 'route_selection.dart';
import 'feeling_selection.dart';
import 'date_selector.dart';
import 'time_selector.dart';
import 'substance_autocomplete.dart';

// Refresh
class SimpleFields extends StatelessWidget {
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

  final bool isMedicalPurpose;
  final ValueChanged<bool> onMedicalPurposeChanged;

  final TextEditingController? substanceCtrl;
  final TextEditingController? doseCtrl;

  const SimpleFields({
    super.key,
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
    required this.isMedicalPurpose,
    required this.onMedicalPurposeChanged,
    this.substanceCtrl,
    this.doseCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final units = ['�g', 'mg', 'g', 'pills', 'ml'];

    Widget _buildCard({required String title, required Widget child}) {
      return Container(
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
              title,
              style: t.typography.titleMedium.copyWith(
                color: t.colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: t.spacing.m),
            child,
          ],
        ),
      );
    }

    return Column(
      children: [

        // -------------------------------
        // SUBSTANCE
        // -------------------------------
        _buildCard(
          title: "Substance",
          child: SubstanceAutocomplete(
            controller: substanceCtrl,
            onSubstanceChanged: onSubstanceChanged,
          ),
        ),
        SizedBox(height: t.spacing.l),

        // -------------------------------
        // DOSAGE
        // -------------------------------
        DosageInput(
          dose: dose,
          unit: unit,
          units: units,
          onDoseChanged: onDoseChanged,
          onUnitChanged: onUnitChanged,
        ),
        SizedBox(height: t.spacing.l),

        // -------------------------------
        // ROUTE
        // -------------------------------
        _buildCard(
          title: "Route of Administration",
          child: RouteSelection(
            route: route,
            onRouteChanged: onRouteChanged,
          ),
        ),
        SizedBox(height: t.spacing.l),

        // -------------------------------
        // MEDICAL PURPOSE
        // -------------------------------
        Container(
          decoration: BoxDecoration(
            color: t.colors.surface,
            borderRadius: BorderRadius.circular(t.shapes.radiusLg),
            border: Border.all(color: t.colors.outlineVariant),
          ),
          child: SwitchListTile(
            title: Text("Medical Purpose", style: t.typography.bodyLarge),
            value: isMedicalPurpose,
            onChanged: onMedicalPurposeChanged,
            activeColor: t.colors.primary,
          ),
        ),
        SizedBox(height: t.spacing.l),

        // -------------------------------
        // FEELINGS
        // -------------------------------
        _buildCard(
          title: "Feelings",
          child: FeelingSelection(
            feelings: feelings,
            secondaryFeelings: secondaryFeelings,
            onFeelingsChanged: onFeelingsChanged,
            onSecondaryFeelingsChanged: onSecondaryFeelingsChanged,
          ),
        ),
        SizedBox(height: t.spacing.l),

        // -------------------------------
        // DATE + TIME
        // -------------------------------
        DateSelector(
          date: date,
          onDateChanged: onDateChanged,
        ),
        SizedBox(height: t.spacing.m),
        TimeSelector(
          hour: hour,
          minute: minute,
          onHourChanged: onHourChanged,
          onMinuteChanged: onMinuteChanged,
        ),
        SizedBox(height: t.spacing.l),

        // -------------------------------
        // LOCATION
        // -------------------------------
        _buildCard(
          title: "Location",
          child: DropdownButtonFormField<String>(
            value: location.isEmpty || !DrugUseCatalog.locations.contains(location) 
                ? DrugUseCatalog.locations.first 
                : location,
            items: DrugUseCatalog.locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc, style: t.typography.bodyLarge))).toList(),
            onChanged: (v) => onLocationChanged(v!),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(t.shapes.radiusM)),
              contentPadding: EdgeInsets.symmetric(horizontal: t.spacing.m, vertical: t.spacing.s),
            ),
            dropdownColor: t.colors.surfaceContainer,
          ),
        ),
      ],
    );
  }
}
