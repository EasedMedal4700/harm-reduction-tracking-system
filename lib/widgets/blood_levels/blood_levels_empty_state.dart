import 'package:flutter/material.dart';

/// Empty state when no substances are active or visible after filtering
class BloodLevelsEmptyState extends StatelessWidget {
  final bool hasActiveFilters;

  const BloodLevelsEmptyState({
    super.key,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.science_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No active substances',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: 8),
            Text(
              'Try adjusting filters',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }
}
