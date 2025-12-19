// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../services/blood_levels_service.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

/// Expandable card displaying drug level information
class LevelCard extends StatefulWidget {
  final DrugLevel level;

  const LevelCard({
    required this.level,
    super.key,
  });

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    final percentage = widget.level.percentage;
    final status = widget.level.status;

    final categoryColor = _getColorForCategory();
    final timeAgo = DateTime.now().difference(widget.level.lastUse);
    final remainingMg = widget.level.totalRemaining;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
      child: CommonCard(
        onTap: () => setState(() => _expanded = !_expanded),
        backgroundColor: categoryColor.withValues(alpha: 0.07),
        borderColor: categoryColor.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(context, categoryColor, status),

            const CommonSpacer.vertical(16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(sh.radiusSm),
              child: LinearProgressIndicator(
                value: (percentage / 100).clamp(0.0, 1.0),
              backgroundColor: c.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
              minHeight: 8,
            ),
          ),

          const CommonSpacer.vertical(16),

          // Summary row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(context, 'Remaining', '${remainingMg.toStringAsFixed(1)}mg'),
              _buildInfoColumn(context, 'Last Dose', '${widget.level.lastDose.toStringAsFixed(1)}mg'),
              _buildInfoColumn(context, 'Time', _formatTimeAgo(timeAgo)),
              _buildInfoColumn(context, 'Window', '${widget.level.activeWindow.toStringAsFixed(1)}h'),
            ],
          ),

          if (_expanded) ...[
            const CommonSpacer.vertical(24),
            Divider(color: c.divider),
            const CommonSpacer.vertical(16),
            _buildExpandedContent(context),
          ],
        ],
      ),
    ));
  }

  // HEADER ROW
  Widget _buildHeaderRow(BuildContext context, Color categoryColor, String status) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left section: name + category
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.level.drugName.toUpperCase(),
                style: text.heading4.copyWith(color: categoryColor),
              ),
              if (widget.level.categories.isNotEmpty)
                Text(
                  widget.level.categories.first,
                  style: text.caption.copyWith(color: c.textSecondary),
                ),
            ],
          ),
        ),

        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: sp.sm,
                vertical: sp.xs,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(sh.radiusSm),
                border: Border.all(color: _getStatusColor(status)),
              ),
              child: Text(
                status,
                style: text.captionBold.copyWith(color: _getStatusColor(status)),
              ),
            ),
            SizedBox(width: sp.sm),
            Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: categoryColor,
            ),
          ],
        ),
      ],
    );
  }

  // EXPANDED CONTENT
  Widget _buildExpandedContent(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Individual Doses',
          style: text.bodyBold,
        ),
        SizedBox(height: sp.sm),

        ...widget.level.doses.map(
          (dose) => Padding(
            padding: EdgeInsets.symmetric(vertical: sp.xs),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _getColorForCategory(),
                    borderRadius: BorderRadius.circular(sh.radiusXs),
                  ),
                ),
                SizedBox(width: sp.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dose.dose.toStringAsFixed(1)}mg → '
                        '${dose.remaining.toStringAsFixed(1)}mg remaining',
                        style: text.body,
                      ),
                      Text(
                        '${_formatTimeAgo(DateTime.now().difference(dose.startTime))} '
                        '(${dose.percentRemaining.toStringAsFixed(0)}%)',
                        style: text.caption.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: sp.md),

        Row(
          children: [
            Expanded(
              child: _buildDetailItem(context, 'Half-life', '${widget.level.halfLife.toStringAsFixed(1)}h'),
            ),
            SizedBox(width: sp.sm),
            Expanded(
              child: _buildDetailItem(context, 'Duration', '${widget.level.maxDuration.toStringAsFixed(1)}h'),
            ),
          ],
        ),

        SizedBox(height: sp.sm),

        Row(
          children: [
            Expanded(
              child: _buildDetailItem(context, 'Total Dosed', '${widget.level.totalDose.toStringAsFixed(1)}mg'),
            ),
            SizedBox(width: sp.sm),
            Expanded(
              child: _buildDetailItem(context, '# Doses', '${widget.level.doses.length}'),
            ),
          ],
        ),
      ],
    );
  }

  // DETAIL BOX
  Widget _buildDetailItem(BuildContext context, String label, String value) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.sm),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(sh.radiusSm),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.caption.copyWith(color: c.textSecondary)),
          SizedBox(height: sp.xs),
          Text(value, style: text.bodyBold),
        ],
      ),
    );
  }

  // SUMMARY LABELS
  Widget _buildInfoColumn(BuildContext context, String label, String value) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.caption.copyWith(color: c.textSecondary)),
        SizedBox(height: sp.xs),
        Text(value, style: text.bodyBold),
      ],
    );
  }

  // CATEGORY COLOR
  Color _getColorForCategory() {
    if (widget.level.categories.isEmpty) {
      return DrugCategoryColors.defaultColor;
    }
    return DrugCategoryColors.colorFor(widget.level.categories.first);
  }

  // STATUS COLOR
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
    if (duration.inHours > 24) return '${duration.inDays}d ago';
    if (duration.inHours > 0) return '${duration.inHours}h ago';
    return '${duration.inMinutes}m ago';
  }
}
