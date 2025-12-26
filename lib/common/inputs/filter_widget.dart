// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/enums/time_period.dart';
import '../../constants/theme/app_theme_extension.dart';
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Replaces old_common/filter.dart. Fully aligned with AppThemeExtension.
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
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Period filter (if provided)
        if (selectedPeriod != null && onPeriodChanged != null) ...[
          Text(
            'Time Period',
            style: th.text.heading4.copyWith(
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
          SizedBox(height: sp.sm),
          Row(
            children: [
              Expanded(
                child: _PeriodButton(
                  label: '7 Days',
                  isSelected: selectedPeriod == TimePeriod.last7Days,
                  onTap: () => onPeriodChanged!(TimePeriod.last7Days),
                ),
              ),
              SizedBox(width: sp.xs),
              Expanded(
                child: _PeriodButton(
                  label: '30 Days',
                  isSelected: selectedPeriod == TimePeriod.last7Weeks,
                  onTap: () => onPeriodChanged!(TimePeriod.last7Weeks),
                ),
              ),
              SizedBox(width: sp.xs),
              Expanded(
                child: _PeriodButton(
                  label: '90 Days',
                  isSelected: selectedPeriod == TimePeriod.last7Months,
                  onTap: () => onPeriodChanged!(TimePeriod.last7Months),
                ),
              ),
              SizedBox(width: sp.xs),
              Expanded(
                child: _PeriodButton(
                  label: 'All Time',
                  isSelected: selectedPeriod == TimePeriod.all,
                  onTap: () => onPeriodChanged!(TimePeriod.all),
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),
        ],
        // Type filter with buttons
        Text(
          'Filter by Type',
          style: th.text.heading4.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: sp.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            return ToggleButtons(
              isSelected: [
                selectedTypeIndex == 0,
                selectedTypeIndex == 1,
                selectedTypeIndex == 2,
              ],
              onPressed: onTypeChanged,
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              constraints: BoxConstraints(
                minHeight: 40,
                minWidth: (constraints.maxWidth - 20) / 3,
              ),
              color: c.textSecondary,
              selectedColor: c.textPrimary,
              fillColor: th.accent.primary.withValues(alpha: 0.2),
              borderColor: c.border,
              selectedBorderColor: th.accent.primary,
              children: const [
                Text('All', style: TextStyle(fontSize: 13)),
                Text('Medical', style: TextStyle(fontSize: 13)),
                Text('Non-Medical', style: TextStyle(fontSize: 13)),
              ],
            );
          },
        ),
        SizedBox(height: sp.md),
        FilterButtons(
          label: 'Category',
          options: uniqueCategories,
          selectedValues: selectedCategories,
          onChanged: onCategoryChanged,
          allOptions: uniqueCategories,
        ),
        SizedBox(height: sp.md),
        FilterButtons(
          label: 'Substance',
          options: uniqueSubstances,
          selectedValues: selectedSubstances,
          onChanged: onSubstanceChanged,
          allOptions: uniqueSubstances,
        ),
        SizedBox(height: sp.md),
        FilterButtons(
          label: 'Location',
          options: uniquePlaces,
          selectedValues: selectedPlaces,
          onChanged: onPlaceChanged,
          allOptions: uniquePlaces,
        ),
        SizedBox(height: sp.md),
        FilterButtons(
          label: 'Route',
          options: uniqueRoutes,
          selectedValues: selectedRoutes,
          onChanged: onRouteChanged,
          allOptions: uniqueRoutes,
        ),
        SizedBox(height: sp.md),
        FilterButtons(
          label: 'Emotions',
          options: uniqueFeelings,
          selectedValues: selectedFeelings,
          onChanged: onFeelingChanged,
          allOptions: uniqueFeelings,
        ),
        SizedBox(height: sp.md),
        // Craving slider
        Text(
          'Craving Intensity',
          style: th.text.heading4.copyWith(
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: sp.sm),
        RangeSlider(
          values: RangeValues(minCraving, maxCraving),
          min: 0,
          max: 10,
          divisions: 10,
          labels: RangeLabels(
            minCraving.toStringAsFixed(0),
            maxCraving.toStringAsFixed(0),
          ),
          activeColor: th.accent.primary,
          inactiveColor: c.border,
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
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;

    final sh = context.shapes;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: sp.sm, horizontal: sp.xs),
          decoration: BoxDecoration(
            color: isSelected
                ? th.accent.primary.withValues(alpha: 0.15)
                : c.surface,
            borderRadius: BorderRadius.circular(sh.radiusMd),
            border: Border.all(
              color: isSelected ? th.accent.primary : c.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: th.text.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? th.accent.primary : c.textSecondary,
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
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    final isMulti = selectedValues != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: th.text.heading4.copyWith(
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            if (allOptions != null && onChanged != null) ...[
              const Spacer(),
              TextButton.icon(
                onPressed: () => onChanged!(allOptions!),
                icon: Icon(
                  Icons.select_all_rounded,
                  size: 16,
                  color: th.accent.primary,
                ),
                label: Text(
                  'Select All',
                  style: TextStyle(fontSize: 12, color: th.accent.primary),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: sp.sm,
                    vertical: sp.xs,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: sp.sm),
        Wrap(
          spacing: sp.sm,
          runSpacing: sp.sm,
          children: options.map((option) {
            final isSelected = isMulti
                ? selectedValues!.contains(option)
                : selectedValue == option;
            return FilterChip(
              label: Text(
                option,
                style: th.text.bodySmall.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? th.accent.primary : c.textPrimary,
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
              backgroundColor: c.surface,
              selectedColor: th.accent.primary.withValues(alpha: 0.2),
              checkmarkColor: th.accent.primary,
              side: BorderSide(
                color: isSelected ? th.accent.primary : c.border,
                width: isSelected ? 1.5 : 1,
              ),
              padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(sh.radiusLg),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
