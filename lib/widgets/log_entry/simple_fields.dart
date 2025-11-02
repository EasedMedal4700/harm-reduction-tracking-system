import 'package:flutter/material.dart';
import 'dosage_input.dart';
import 'substance_autocomplete.dart';
import 'route_selection.dart';
import 'feeling_selection.dart';
import 'date_selector.dart';
import 'time_selector.dart';
import 'location_dropdown.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final units = ['μg', 'mg', 'g', 'pills', 'ml'];
    final locations = ['Home', 'Work', 'School', 'Public', 'Vehicle', 'Gym', 'Other'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DosageInput(
          dose: dose,
          unit: unit,
          units: units,
          onDoseChanged: onDoseChanged,
          onUnitChanged: onUnitChanged,
        ),
        const SizedBox(height: 16),

        SubstanceAutocomplete(
          substance: substance,
          onSubstanceChanged: onSubstanceChanged,
        ),
        const SizedBox(height: 16),

        const Text('Route of Administration'),
        RouteSelection(
          route: route,
          onRouteChanged: onRouteChanged,
        ),
        const SizedBox(height: 16),

        FeelingSelection(
          feelings: feelings,
          secondaryFeelings: secondaryFeelings,
          onFeelingsChanged: onFeelingsChanged,
          onSecondaryFeelingsChanged: onSecondaryFeelingsChanged,
        ),
        const SizedBox(height: 16),

        DateSelector(
          date: date,
          onDateChanged: onDateChanged,
        ),
        const SizedBox(height: 16),

        TimeSelector(
          hour: hour,
          minute: minute,
          onHourChanged: onHourChanged,
          onMinuteChanged: onMinuteChanged,
        ),
        const SizedBox(height: 16),

        const Text('Location'),
        LocationDropdown(
          location: location,
          locations: locations,
          onLocationChanged: onLocationChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}