// MIGRATION — Final theme-compliant version

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class ActivityDetailSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<DetailItem> details;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityDetailSheet({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.details,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;
    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sh.radiusLg),
        ),
        border: Border.all(color: c.border),
        boxShadow: t.cardShadow,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandleBar(context),
            SizedBox(height: sp.lg),
            _buildHeader(context),
            SizedBox(height: sp.xl),
            _buildDetailsList(context),
            SizedBox(height: sp.xl),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;

    return Container(
      margin: EdgeInsets.only(top: sp.sm),
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        color: c.border,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor,
                  accentColor.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(sh.radiusSm),
            ),
            child: Icon(icon, color: c.onAccent, size: 28),
          ),
          SizedBox(width: sp.lg),
          Expanded(
            child: Text(
              title,
              style: text.heading3.copyWith(color: c.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((detail) {
          final highlight = detail.highlight;

          return Padding(
            padding: EdgeInsets.only(bottom: sp.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.label,
                  style: text.label.copyWith(color: c.textSecondary),
                ),
                SizedBox(height: sp.xs),

                Container(
                  padding: highlight
                      ? EdgeInsets.symmetric(
                          horizontal: sp.sm,
                          vertical: sp.xs,
                        )
                      : null,
                  decoration: highlight
                      ? BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                          ),
                        )
                      : null,
                  child: Text(
                    detail.value,
                    style: text.bodyLarge.copyWith(
                      color: highlight ? accentColor : c.text,
                      fontWeight:
                          highlight ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.all(sp.lg),
      child: Row(
        children: [
          /// DELETE BUTTON
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              label: Text(
                'Delete',
                style: text.body.copyWith(
                  color: c.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: c.error),
                padding: EdgeInsets.symmetric(vertical: sp.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
                foregroundColor: c.error,
              ),
            ),
          ),

          SizedBox(width: sp.md),

          /// EDIT BUTTON
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: Text(
                'Edit Entry',
                style: text.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: c.onAccent,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: c.onAccent,
                shadowColor: c.overlayHeavy,
                padding: EdgeInsets.symmetric(vertical: sp.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail item (unchanged)
class DetailItem {
  final String label;
  final String value;
  final bool highlight;

  DetailItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });
}
