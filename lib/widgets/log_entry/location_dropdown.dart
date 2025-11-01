// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\location_dropdown.dart
import 'package:flutter/material.dart';

class LocationDropdown extends StatelessWidget {
  final String location;
  final List<String> locations;
  final ValueChanged<String> onLocationChanged;

  const LocationDropdown({
    super.key,
    required this.location,
    required this.locations,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: location,
      items: locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
      onChanged: (v) => onLocationChanged(v!),
    );
  }
}