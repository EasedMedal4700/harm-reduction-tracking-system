import 'package:flutter/material.dart';
import '../../constants/time_period.dart';

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
  final TimePeriod? selectedPeriod;
  final ValueChanged<TimePeriod>? onPeriodChanged;


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
    this.selectedPeriod,
    this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
              // Time Period filter (if provided)
              if (selectedPeriod != null && onPeriodChanged != null) ...[
                Text(
                  'Time Period',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PeriodButton(
                        label: '7 Days',
                        isSelected: selectedPeriod == TimePeriod.last7Days,
                        onTap: () => onPeriodChanged!(TimePeriod.last7Days),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PeriodButton(
                        label: '30 Days',
                        isSelected: selectedPeriod == TimePeriod.last7Weeks,
                        onTap: () => onPeriodChanged!(TimePeriod.last7Weeks),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PeriodButton(
                        label: '90 Days',
                        isSelected: selectedPeriod == TimePeriod.last7Months,
                        onTap: () => onPeriodChanged!(TimePeriod.last7Months),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PeriodButton(
                        label: 'All Time',
                        isSelected: selectedPeriod == TimePeriod.all,
                        onTap: () => onPeriodChanged!(TimePeriod.all),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              // Type filter with buttons
              Text(
                'Filter by Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  return ToggleButtons(
                    isSelected: [selectedTypeIndex == 0, selectedTypeIndex == 1, selectedTypeIndex == 2],
                    onPressed: onTypeChanged,
                    borderRadius: BorderRadius.circular(10),
                    constraints: BoxConstraints(
                      minHeight: 40,
                      minWidth: (constraints.maxWidth - 20) / 3,
                    ),
                    children: const [
                      Text('All', style: TextStyle(fontSize: 13)),
                      Text('Medical', style: TextStyle(fontSize: 13)),
                      Text('Non-Medical', style: TextStyle(fontSize: 13)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              FilterButtons(
                label: 'Category',
                options: uniqueCategories,
                selectedValues: selectedCategories,
                onChanged: onCategoryChanged,
                allOptions: uniqueCategories,
              ),
              const SizedBox(height: 20),
              FilterButtons(
                label: 'Substance',
                options: uniqueSubstances,
                selectedValues: selectedSubstances,
                onChanged: onSubstanceChanged,
                allOptions: uniqueSubstances,
              ),
              const SizedBox(height: 20),
              FilterButtons(
                label: 'Location',
                options: uniquePlaces,
                selectedValues: selectedPlaces,
                onChanged: onPlaceChanged,
                allOptions: uniquePlaces,
              ),
              const SizedBox(height: 20),
              FilterButtons(
                label: 'Route',
                options: uniqueRoutes,
                selectedValues: selectedRoutes,
                onChanged: onRouteChanged,
                allOptions: uniqueRoutes,
              ),
              const SizedBox(height: 20),
              FilterButtons(
                label: 'Emotions',
                options: uniqueFeelings,
                selectedValues: selectedFeelings,
                onChanged: onFeelingChanged,
                allOptions: uniqueFeelings,
              ),
              const SizedBox(height: 20),
              // Craving slider
              Text(
                'Craving Intensity',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              RangeSlider(
                values: RangeValues(minCraving, maxCraving),
                min: 0,
                max: 10,
                divisions: 10,
                labels: RangeLabels(minCraving.toStringAsFixed(0), maxCraving.toStringAsFixed(0)),
                onChanged: (values) {
                  onMinCravingChanged(values.start);
                  onMaxCravingChanged(values.end);
                },
              ),
            ],
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
                : (isDark ? Colors.grey[800] : Colors.grey[200]),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDark ? Colors.grey[700]! : Colors.grey[400]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : (isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
            ),
          ),
        ),
      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            if (allOptions != null && onChanged != null) ...[
              const Spacer(),
              TextButton.icon(
                onPressed: () => onChanged!(allOptions!),
                icon: const Icon(Icons.select_all_rounded, size: 16),
                label: const Text('Select All', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ]
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: options.map((option) {
            final isSelected = isMulti
                ? selectedValues!.contains(option)
                : selectedValue == option;
            return FilterChip(
              label: Text(
                option,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
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
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              checkmarkColor: Theme.of(context).primaryColor,
              side: BorderSide(
                color: isSelected 
                    ? Theme.of(context).primaryColor 
                    : (isDark ? Colors.grey[700]! : Colors.grey[400]!),
                width: isSelected ? 1.5 : 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}