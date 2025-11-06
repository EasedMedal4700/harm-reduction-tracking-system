import 'package:flutter/material.dart';
import '../../../constants/drug_categories.dart';

class CatalogFilters extends StatefulWidget {
  final List<String> selectedCategories;
  final bool showCommonOnly;
  final Function(List<String>) onCategoriesChanged;
  final Function(bool) onCommonOnlyChanged;
  final Function(String) onSearchChanged;

  const CatalogFilters({
    super.key,
    required this.selectedCategories,
    required this.showCommonOnly,
    required this.onCategoriesChanged,
    required this.onCommonOnlyChanged,
    required this.onSearchChanged,
  });

  @override
  State<CatalogFilters> createState() => _CatalogFiltersState();
}

class _CatalogFiltersState extends State<CatalogFilters> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search substances...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: widget.onSearchChanged,
          ),
        ),
        // Category filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8.0,
            children: DrugCategories.categoryPriority.map((category) {
              final isSelected = widget.selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  final newSelected = List<String>.from(widget.selectedCategories);
                  if (selected) {
                    newSelected.add(category);
                  } else {
                    newSelected.remove(category);
                  }
                  widget.onCategoriesChanged(newSelected);
                },
              );
            }).toList(),
          ),
        ),
        // Common only switch
        SwitchListTile(
          title: const Text('Common substances only'),
          value: widget.showCommonOnly,
          onChanged: widget.onCommonOnlyChanged,
        ),
      ],
    );
  }
}