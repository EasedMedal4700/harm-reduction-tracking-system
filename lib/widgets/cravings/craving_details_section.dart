import 'package:flutter/material.dart';
import '../../constants/craving_consatnts.dart';
import '../log_entry/craving_slider.dart';
import '../common/location_dropdown.dart';

class CravingDetailsSection extends StatelessWidget {
  final List<String> selectedCravings;
  final ValueChanged<List<String>> onCravingsChanged;
  final double intensity;
  final ValueChanged<double> onIntensityChanged;
  final String location;
  final ValueChanged<String?> onLocationChanged;
  final String? withWho;
  final ValueChanged<String?> onWithWhoChanged;

  const CravingDetailsSection({
    super.key,
    required this.selectedCravings,
    required this.onCravingsChanged,
    required this.intensity,
    required this.onIntensityChanged,
    required this.location,
    required this.onLocationChanged,
    required this.withWho,
    required this.onWithWhoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Craving Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Text('What were you craving?'),
        Wrap(
          spacing: 8.0,
          children: cravingCategories.entries.map((entry) {
            final isSelected = selectedCravings.contains(entry.value);
            return TextButton(
              onPressed: () => onCravingsChanged(
                isSelected
                  ? selectedCravings.where((c) => c != entry.value).toList()
                  : [...selectedCravings, entry.value],
              ),
              style: TextButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : null,
                foregroundColor: isSelected ? Colors.white : null,
              ),
              child: Text(entry.key),
            );
          }).toList(),
        ),
        if (selectedCravings.isNotEmpty) Text('Selected: ${selectedCravings.join(', ')}'),
        CravingSlider(value: intensity, onChanged: onIntensityChanged),
        LocationDropdown(location: location, onLocationChanged: onLocationChanged),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Who were you with?'),
          value: withWho,
          items: ['Alone', 'Friends', 'Family', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onWithWhoChanged,
        ),
      ],
    );
  }
}