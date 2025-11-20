import 'package:flutter/material.dart';

/// Collapsible filter panel for drug inclusion/exclusion
class FilterPanel extends StatelessWidget {
  final List<String> availableDrugs;
  final Set<String> includedDrugs;
  final Set<String> excludedDrugs;
  final Function(String, bool) onIncludeChanged;
  final Function(String, bool) onExcludeChanged;
  final VoidCallback onClearAll;

  const FilterPanel({
    required this.availableDrugs,
    required this.includedDrugs,
    required this.excludedDrugs,
    required this.onIncludeChanged,
    required this.onExcludeChanged,
    required this.onClearAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (includedDrugs.isNotEmpty || excludedDrugs.isNotEmpty)
                TextButton(
                  onPressed: onClearAll,
                  child: const Text('Clear All'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Include Only:', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: availableDrugs.map((drug) {
              final isSelected = includedDrugs.contains(drug);
              return FilterChip(
                label: Text(drug.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) => onIncludeChanged(drug, selected),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Exclude:', style: TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: availableDrugs.map((drug) {
              final isSelected = excludedDrugs.contains(drug);
              return FilterChip(
                label: Text(drug.toUpperCase()),
                selected: isSelected,
                selectedColor: Colors.red[300],
                onSelected: (selected) => onExcludeChanged(drug, selected),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
