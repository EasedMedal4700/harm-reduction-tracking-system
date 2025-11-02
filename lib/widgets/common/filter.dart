import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  final List<String> uniqueCategories;
  final List<String> uniqueSubstances;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final String? selectedSubstance;
  final ValueChanged<String?> onSubstanceChanged;
  final int selectedTypeIndex; // 0: All, 1: Medical, 2: Non-Medical
  final ValueChanged<int> onTypeChanged;

  const FilterWidget({
    super.key,
    required this.uniqueCategories,
    required this.uniqueSubstances,
    this.selectedCategory,
    required this.onCategoryChanged,
    this.selectedSubstance,
    required this.onSubstanceChanged,
    required this.selectedTypeIndex,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                options: ['All', ...uniqueCategories],
                selectedValue: selectedCategory ?? 'All',
                onChanged: onCategoryChanged,
              ),
              const SizedBox(height: 16),
              FilterButtons(
                label: 'Substance',
                options: ['All', ...uniqueSubstances],
                selectedValue: selectedSubstance ?? 'All',
                onChanged: onSubstanceChanged,
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
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const FilterButtons({
    super.key,
    required this.label,
    required this.options,
    this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return ElevatedButton(
              onPressed: () => onChanged(option == 'All' ? null : option),
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