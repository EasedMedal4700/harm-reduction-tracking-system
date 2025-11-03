import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final List<String> uniqueCategories;
  final List<String> uniqueSubstances;
  final List<String> selectedCategories;
  final ValueChanged<List<String>> onCategoryChanged;
  final List<String> selectedSubstances; // Changed to list for multi-select
  final ValueChanged<List<String>> onSubstanceChanged; // Changed to list
  final int selectedTypeIndex;
  final ValueChanged<int> onTypeChanged;
  final List<String> uniquePlaces;
  final List<String> selectedPlaces;
  final ValueChanged<List<String>> onPlaceChanged;
  final List<String> uniqueRoutes;
  final List<String> selectedRoutes;
  final ValueChanged<List<String>> onRouteChanged;
  final List<String> uniqueFeelings;
  final List<String> selectedFeelings;
  final ValueChanged<List<String>> onFeelingChanged;
  final double minCraving;
  final double maxCraving;
  final ValueChanged<double> onMinCravingChanged;
  final ValueChanged<double> onMaxCravingChanged;


  const FilterWidget({
    super.key,
    required this.uniqueCategories,
    required this.uniqueSubstances,
    required this.selectedCategories,
    required this.onCategoryChanged,
    required this.selectedSubstances, // Updated
    required this.onSubstanceChanged, // Updated
    required this.selectedTypeIndex,
    required this.onTypeChanged,
    required this.uniquePlaces,
    required this.selectedPlaces,
    required this.onPlaceChanged,
    required this.uniqueRoutes,
    required this.selectedRoutes,
    required this.onRouteChanged,
    required this.uniqueFeelings,
    required this.selectedFeelings,
    required this.onFeelingChanged,
    required this.minCraving,
    required this.maxCraving,
    required this.onMinCravingChanged,
    required this.onMaxCravingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type filter with buttons
              const Text('Filter by Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ToggleButtons(
                isSelected: [selectedTypeIndex == 0, selectedTypeIndex == 1, selectedTypeIndex == 2],
                onPressed: onTypeChanged,
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('All')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Medical')),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Non-Medical')),
                ],
              ),
              const SizedBox(height: 16),
              FilterButtons(
                label: 'Category',
                options: uniqueCategories,
                selectedValues: selectedCategories,
                onChanged: onCategoryChanged,
                allOptions: uniqueCategories,
              ),
              const SizedBox(height: 16),
              FilterButtons(
                label: 'Substance',
                options: uniqueSubstances,
                selectedValues: selectedSubstances,
                onChanged: onSubstanceChanged,
                allOptions: uniqueSubstances,
              ),
              const SizedBox(height: 16),
              FilterButtons(
                label: 'Location',
                options: uniquePlaces,
                selectedValues: selectedPlaces,
                onChanged: onPlaceChanged,
                allOptions: uniquePlaces,
              ),
              const SizedBox(height: 16),
              FilterButtons(
                label: 'Route',
                options: uniqueRoutes,
                selectedValues: selectedRoutes,
                onChanged: onRouteChanged,
                allOptions: uniqueRoutes,
              ),
              const SizedBox(height: 16),
              FilterButtons(
                label: 'Emotions',
                options: uniqueFeelings,
                selectedValues: selectedFeelings,
                onChanged: onFeelingChanged,
                allOptions: uniqueFeelings,
              ),
              const SizedBox(height: 16),
              // Craving slider
              const Text('Craving Intensity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              RangeSlider(
                values: RangeValues(minCraving, maxCraving),
                min: 0,
                max: 10,
                divisions: 10,
                labels: RangeLabels(minCraving.toString(), maxCraving.toString()),
                onChanged: (values) {
                  onMinCravingChanged(values.start);
                  onMaxCravingChanged(values.end);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FilterButtons extends StatelessWidget {
  final String label;
  final List<String> options;
  final List<String>? selectedValues; // For multi-select
  final String? selectedValue; // For single-select
  final ValueChanged<List<String>>? onChanged; // For multi
  final ValueChanged<String?>? onSingleChanged; // For single
  final List<String>? allOptions; // For Select All

  const FilterButtons({
    super.key,
    required this.label,
    required this.options,
    this.selectedValues,
    this.selectedValue,
    this.onChanged,
    this.onSingleChanged,
    this.allOptions,
  });

  @override
  Widget build(BuildContext context) {
    final isMulti = selectedValues != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            if (allOptions != null && onChanged != null) ...[
              const Spacer(),
              ElevatedButton(
                onPressed: () => onChanged!(allOptions!),
                child: const Text('Select All'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: options.map((option) {
            final isSelected = isMulti
                ? selectedValues!.contains(option)
                : selectedValue == option;
            return ElevatedButton(
              onPressed: () {
                if (isMulti && onChanged != null) {
                  final newSelected = List<String>.from(selectedValues!);
                  if (newSelected.contains(option)) {
                    newSelected.remove(option);
                  } else {
                    newSelected.add(option);
                  }
                  onChanged!(newSelected);
                } else if (onSingleChanged != null) {
                  onSingleChanged!(option == 'All' ? null : option);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
                foregroundColor: isSelected ? Colors.white : Colors.black,
              ),
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}