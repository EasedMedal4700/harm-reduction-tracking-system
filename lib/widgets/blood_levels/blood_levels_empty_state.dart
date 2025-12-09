// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Empty state when no substances are active or visible after filtering
class BloodLevelsEmptyState extends StatelessWidget {
  final bool hasActiveFilters;

  const BloodLevelsEmptyState({
    super.key,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.science_outlined, size: 64, color: c.textTertiary),
          SizedBox(height: sp.lg),
          Text(
            'No active substances',
            style: text.heading4.copyWith(color: c.textSecondary),
          ),
          if (hasActiveFilters) ...[
            SizedBox(height: sp.sm),
            Text(
              'Try adjusting filters',
              style: text.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
