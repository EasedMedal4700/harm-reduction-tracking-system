// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\location_dropdown.dart
import 'package:flutter/material.dart';
import '../../constants/drug_use_catalog.dart';

class LocationDropdown extends StatelessWidget {
  final String location;
  final ValueChanged<String> onLocationChanged;

  const LocationDropdown({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: location,
      items: DrugUseCatalog.locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
      onChanged: (v) => onLocationChanged(v!),
    );
  }
}