import 'package:flutter/material.dart';
import '../../constants/drug_categories.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> selectedCategories; // Changed to List for multiple selection
  final ValueChanged<List<String>> onCategoriesChanged;
  final bool showCommonOnly; // Add this
  final ValueChanged<bool> onShowCommonOnlyChanged; // Add this

  const CategoryFilter({
    super.key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
    required this.showCommonOnly, // Add this
    required this.onShowCommonOnlyChanged, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filter by Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: DrugCategories.categoryPriority.map((category) {
              final isSelected = selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  final newSelection = List<String>.from(selectedCategories);
                  if (selected) {
                    newSelection.add(category);
                  } else {
                    newSelection.remove(category);
                  }
                  onCategoriesChanged(newSelection);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Add the common only switch
          SwitchListTile(
            title: const Text('Show Common Only'),
            value: showCommonOnly,
            onChanged: onShowCommonOnlyChanged,
          ),
        ],
      ),
    );
  }
}