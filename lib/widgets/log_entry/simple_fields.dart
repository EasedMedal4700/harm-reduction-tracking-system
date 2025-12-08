import 'package:flutter/material.dart';
import 'dosage_input.dart';
import 'route_selection.dart';
import '../../common/old_common/feeling_selection.dart';
import 'date_selector.dart';
import 'time_selector.dart';
import '../../common/old_common/location_dropdown.dart';
import 'substance_autocomplete.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../constants/theme/app_theme_constants.dart';

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
    final units = ['μg', 'mg', 'g', 'pills', 'ml'];

    return Column(
      children: [

        // -------------------------------
        // SUBSTANCE
        // -------------------------------
        CommonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSectionHeader(title: "Substance"),
              SizedBox(height: AppThemeConstants.spaceMd),
              SubstanceAutocomplete(
                controller: substanceCtrl,
                onSubstanceChanged: onSubstanceChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: AppThemeConstants.spaceLg),

        // -------------------------------
        // DOSAGE
        // -------------------------------
        CommonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSectionHeader(title: "Dosage"),
              SizedBox(height: AppThemeConstants.spaceMd),
              DosageInput(
                dose: dose,
                unit: unit,
                units: units,
                onDoseChanged: onDoseChanged,
                onUnitChanged: onUnitChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: AppThemeConstants.spaceLg),

        // -------------------------------
        // ROUTE
        // -------------------------------
        CommonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSectionHeader(title: "Route of Administration"),
              SizedBox(height: AppThemeConstants.spaceMd),
              RouteSelection(
                route: route,
                onRouteChanged: onRouteChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: AppThemeConstants.spaceLg),

        // -------------------------------
        // MEDICAL PURPOSE
        // -------------------------------
        CommonCard(
          child: SwitchListTile(
            title: const Text("Medical Purpose"),
            value: isMedicalPurpose,
            onChanged: onMedicalPurposeChanged,
          ),
        ),
        SizedBox(height: AppThemeConstants.spaceLg),

        // -------------------------------
        // FEELINGS
        // -------------------------------
        CommonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSectionHeader(title: "Feelings"),
              SizedBox(height: AppThemeConstants.spaceMd),
              FeelingSelection(
                feelings: feelings,
                secondaryFeelings: secondaryFeelings,
                onFeelingsChanged: onFeelingsChanged,
                onSecondaryFeelingsChanged: onSecondaryFeelingsChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: AppThemeConstants.spaceLg),

        // -------------------------------
        // DATE + TIME
        // -------------------------------
        CommonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSectionHeader(title: "Date & Time"),
              SizedBox(height: AppThemeConstants.spaceMd),
              DateSelector(
                date: date,
                onDateChanged: onDateChanged,
              ),
              SizedBox(height: AppThemeConstants.spaceMd),
              TimeSelector(
                hour: hour,
                minute: minute,
                onHourChanged: onHourChanged,
                onMinuteChanged: onMinuteChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: AppThemeConstants.spaceLg),

        // -------------------------------
        // LOCATION
        // -------------------------------
        CommonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonSectionHeader(title: "Location"),
              SizedBox(height: AppThemeConstants.spaceMd),
              LocationDropdown(
                location: location,
                onLocationChanged: onLocationChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
