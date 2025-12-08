// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_typography.dart';

/// A modal bottom sheet that displays detailed information about an activity entry.
/// Fully migrated to AppTheme (no deprecated UI colors).
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
    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(t.spacing.lg),
        ),
        border: Border.all(color: t.colors.border),
        boxShadow: t.cardShadow,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandleBar(context),
            SizedBox(height: t.spacing.lg),
            _buildHeader(context),
            SizedBox(height: t.spacing.xl),
            _buildDetailsList(context),
            SizedBox(height: t.spacing.xl),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar(BuildContext context) {
    final t = context.theme;
    return Container(
      margin: EdgeInsets.only(top: t.spacing.sm),
      width: 44,
      height: 5,
      decoration: BoxDecoration(
        color: t.colors.border,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spacing.lg),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(t.spacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor,
                  accentColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(t.spacing.sm),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(width: t.spacing.lg),
          Expanded(
            child: Text(
              title,
              style: t.typography.heading3.copyWith(
                color: t.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context) {
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((detail) {
          final highlight = detail.highlight;

          return Padding(
            padding: EdgeInsets.only(bottom: t.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.label,
                  style: t.typography.heading3.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
                SizedBox(height: t.spacing.xs),
                Container(
                  padding: highlight
                      ? EdgeInsets.symmetric(
                          horizontal: t.spacing.sm,
                          vertical: t.spacing.xs,
                        )
                      : null,
                  decoration: highlight
                      ? BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(t.spacing.sm),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                          ),
                        )
                      : null,
                  child: Text(
                    detail.value,
                    style: t.typography.bodyLarge.copyWith(
                      color: highlight
                          ? accentColor
                          : t.colors.textPrimary,
                      fontWeight: highlight
                          ? FontWeight.w600
                          : FontWeight.normal,
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
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.all(t.spacing.lg),
      child: Row(
        children: [
          /// Delete button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: t.colors.error,
                side: BorderSide(color: t.colors.error),
                padding: EdgeInsets.symmetric(vertical: t.spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.spacing.md),
                ),
              ),
            ),
          ),
          SizedBox(width: t.spacing.md),

          /// Edit button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                shadowColor: t.colors.overlayHeavy,
                padding: EdgeInsets.symmetric(vertical: t.spacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.spacing.md),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A detail item used inside ActivityDetailSheet.
/// Also migrated (no deprecated values).
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
