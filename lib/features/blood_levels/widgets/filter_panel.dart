// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer. Kept Container as it's a panel.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';

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
    final tx = context.text;
    final ac = context.accent;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          bottom: BorderSide(color: c.border, width: context.borders.thin),
        ),
      ),
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          Row(
            children: [
              Text('Filters', style: tx.heading4),
              const Spacer(),
              if (includedDrugs.isNotEmpty || excludedDrugs.isNotEmpty)
                TextButton(
                  onPressed: onClearAll,
                  child: Text('Clear All', style: TextStyle(color: ac.primary)),
                ),
            ],
          ),
          CommonSpacer.vertical(sp.sm),
          Text('Include Only:', style: tx.bodyBold),
          CommonSpacer.vertical(sp.xs),
          Wrap(
            spacing: sp.sm,
            runSpacing: sp.xs,
            children: availableDrugs.map((drug) {
              final isSelected = includedDrugs.contains(drug);
              return FilterChip(
                label: Text(drug.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) => onIncludeChanged(drug, selected),
                backgroundColor: c.surfaceVariant,
                selectedColor: ac.primary.withValues(
                  alpha: context.opacities.selected,
                ),
                checkmarkColor: ac.primary,
                labelStyle: TextStyle(
                  color: isSelected ? ac.primary : c.textPrimary,
                ),
              );
            }).toList(),
          ),
          CommonSpacer.vertical(sp.lg),
          Text('Exclude:', style: tx.bodyBold),
          CommonSpacer.vertical(sp.xs),
          Wrap(
            spacing: sp.sm,
            runSpacing: sp.xs,
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
