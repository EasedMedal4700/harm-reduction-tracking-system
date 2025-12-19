// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer. Kept Container as it's a panel.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

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
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;
    final acc = context.accent;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          bottom: BorderSide(
            color: c.border,
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('Filters', style: text.heading4),
              const Spacer(),
              if (includedDrugs.isNotEmpty || excludedDrugs.isNotEmpty)
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'Clear All',
                    style: TextStyle(color: acc.primary),
                  ),
                ),
            ],
          ),

          const CommonSpacer.vertical(8),

          Text('Include Only:', style: text.bodyBold),
          const CommonSpacer.vertical(4),

          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: availableDrugs.map((drug) {
              final isSelected = includedDrugs.contains(drug);
              return FilterChip(
                label: Text(drug.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) => onIncludeChanged(drug, selected),
                backgroundColor: c.surfaceVariant,
                selectedColor: acc.primary.withValues(alpha: 0.2),
                checkmarkColor: acc.primary,
                labelStyle: TextStyle(
                  color: isSelected ? acc.primary : c.textPrimary,
                ),
              );
            }).toList(),
          ),

          const CommonSpacer.vertical(16),

          Text('Exclude:', style: text.bodyBold),
          const CommonSpacer.vertical(4),

          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: availableDrugs.map((drug) {
              final isSelected = excludedDrugs.contains(drug);
              final excludeColor = c.error;
              return FilterChip(
                label: Text(drug.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) => onExcludeChanged(drug, selected),
                backgroundColor: c.surfaceVariant,
                selectedColor: excludeColor.withValues(alpha: 0.2),
                checkmarkColor: excludeColor,
                labelStyle: TextStyle(
                  color: isSelected ? excludeColor : c.textPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
