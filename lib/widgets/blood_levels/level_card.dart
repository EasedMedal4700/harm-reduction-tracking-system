import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';

/// Simple card displaying drug level information
class LevelCard extends StatelessWidget {
  final DrugLevel level;
  
  const LevelCard({required this.level, super.key});
  
  @override
  Widget build(BuildContext context) {
    final percentage = level.percentage;
    final status = level.status;
    final color = _getColorForStatus(status);
    final timeAgo = DateTime.now().difference(level.lastUse);
    final remainingMg = level.totalRemaining;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  level.drugName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              color: color,
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  'Remaining',
                  '${remainingMg.toStringAsFixed(1)}mg',
                ),
                _buildInfoColumn(
                  'Last Dose',
                  '${level.lastDose.toStringAsFixed(1)}mg',
                ),
                _buildInfoColumn(
                  'Time',
                  _formatTimeAgo(timeAgo),
                ),
                _buildInfoColumn(
                  'Active Window',
                  '${level.activeWindow.toStringAsFixed(1)}h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Color _getColorForStatus(String status) {
    switch (status) {
      case 'HIGH':
        return Colors.red;
      case 'ACTIVE':
        return Colors.orange;
      case 'TRACE':
        return Colors.amber;
      default:
        return Colors.green;
    }
  }
  
  String _formatTimeAgo(Duration duration) {
    if (duration.inHours > 24) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else {
      return '${duration.inMinutes}m ago';
    }
  }
}
