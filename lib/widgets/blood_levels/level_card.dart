import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/data/drug_categories.dart';

/// Expandable card displaying drug level information
class LevelCard extends StatefulWidget {
  final DrugLevel level;

  const LevelCard({required this.level, super.key});

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final percentage = widget.level.percentage;
    final status = widget.level.status;
    final color = _getColorForCategory();
    final timeAgo = DateTime.now().difference(widget.level.lastUse);
    final remainingMg = widget.level.totalRemaining;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.level.drugName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        if (widget.level.categories.isNotEmpty)
                          Text(
                            widget.level.categories.first,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _getStatusColor(status)),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _expanded ? Icons.expand_less : Icons.expand_more,
                        color: color,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              LinearProgressIndicator(
                value: (percentage / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey[300],
                color: color,
                minHeight: 8,
              ),
              const SizedBox(height: 12),

              // Summary info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn(
                    'Remaining',
                    '${remainingMg.toStringAsFixed(1)}mg',
                  ),
                  _buildInfoColumn(
                    'Last Dose',
                    '${widget.level.lastDose.toStringAsFixed(1)}mg',
                  ),
                  _buildInfoColumn('Time', _formatTimeAgo(timeAgo)),
                  _buildInfoColumn(
                    'Window',
                    '${widget.level.activeWindow.toStringAsFixed(1)}h',
                  ),
                ],
              ),

              // Expanded details
              if (_expanded) ...[
                const Divider(height: 24),
                _buildExpandedContent(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Individual Doses',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.level.doses.map(
          (dose) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getColorForCategory(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dose.dose.toStringAsFixed(1)}mg → ${dose.remaining.toStringAsFixed(1)}mg remaining',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        '${_formatTimeAgo(DateTime.now().difference(dose.startTime))} (${dose.percentRemaining.toStringAsFixed(0)}%)',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                'Half-life',
                '${widget.level.halfLife.toStringAsFixed(1)}h',
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                'Duration',
                '${widget.level.maxDuration.toStringAsFixed(1)}h',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                'Total Dosed',
                '${widget.level.totalDose.toStringAsFixed(1)}mg',
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                '# Doses',
                '${widget.level.doses.length}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: isDark ? Border.all(color: UIColors.darkBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? UIColors.darkTextSecondary : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? UIColors.darkText : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? UIColors.darkTextSecondary : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? UIColors.darkText : Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getColorForCategory() {
    if (widget.level.categories.isEmpty) {
      return DrugCategoryColors.defaultColor;
    }
    return DrugCategoryColors.colorFor(widget.level.categories.first);
  }

  Color _getStatusColor(String status) {
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
