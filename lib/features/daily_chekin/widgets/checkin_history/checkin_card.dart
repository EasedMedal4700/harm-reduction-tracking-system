// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and AppThemeExtension.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../models/daily_checkin_model.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

class CheckinCard extends StatelessWidget {
  final DailyCheckin checkin;
  const CheckinCard({super.key, required this.checkin});
  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final th = context.theme;
    return Padding(
      padding: EdgeInsets.only(bottom: th.spacing.md),
      child: CommonCard(
        padding: EdgeInsets.all(th.spacing.md),
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            // Header with date and time of day
            Row(
              mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getTimeIcon(checkin.timeOfDay),
                      size: th.sizes.iconSm,
                      color: th.colors.textSecondary,
                    ),
                    CommonSpacer.horizontal(th.spacing.sm),
                    Text(
                      _formatDate(checkin.checkinDate),
                      style: th.tx.body.copyWith(
                        fontWeight: tx.bodyBold.fontWeight,
                        color: th.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: th.spacing.sm,
                    vertical: th.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: th.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(th.shapes.radiusSm),
                  ),
                  child: Text(
                    checkin.timeOfDay.toUpperCase(),
                    style: th.tx.label.copyWith(
                      fontSize: tx.caption.fontSize,
                      color: th.colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const CommonSpacer.vertical(12),
            // Mood
            Row(
              children: [
                Text(
                  'Mood: ',
                  style: th.tx.body.copyWith(
                    fontWeight: tx.body.fontWeight,
                    color: th.colors.textSecondary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: th.spacing.md,
                    vertical: th.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getMoodColor(
                      checkin.mood,
                      context,
                    ).withValues(alpha: th.opacities.selected),
                    borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                    border: Border.all(
                      color: _getMoodColor(
                        checkin.mood,
                        context,
                      ).withValues(alpha: th.opacities.slow),
                    ),
                  ),
                  child: Text(
                    checkin.mood,
                    style: th.tx.label.copyWith(
                      fontWeight: tx.bodyBold.fontWeight,
                      color: _getMoodColor(
                        checkin.mood,
                        context,
                      ), // Use the color for text too
                    ),
                  ),
                ),
              ],
            ),
            const CommonSpacer.vertical(8),
            // Emotions
            if (checkin.emotions.isNotEmpty) ...[
              Text(
                'Emotions:',
                style: th.tx.body.copyWith(
                  fontWeight: tx.body.fontWeight,
                  color: th.colors.textSecondary,
                ),
              ),
              const CommonSpacer.vertical(4),
              Wrap(
                spacing: th.spacing.sm,
                runSpacing: th.spacing.sm,
                children: checkin.emotions.map((emotion) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: th.spacing.sm,
                      vertical: th.spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: th.colors.surfaceVariant.withValues(
                        alpha: th.opacities.slow,
                      ),
                      borderRadius: BorderRadius.circular(th.shapes.radiusSm),
                      border: Border.all(color: th.colors.border),
                    ),
                    child: Text(
                      emotion,
                      style: th.tx.label.copyWith(color: th.colors.textPrimary),
                    ),
                  );
                }).toList(),
              ),
              const CommonSpacer.vertical(8),
            ],
            // Notes
            if (checkin.notes != null && checkin.notes!.isNotEmpty) ...[
              Text(
                'Notes:',
                style: th.tx.body.copyWith(
                  fontWeight: tx.body.fontWeight,
                  color: th.colors.textSecondary,
                ),
              ),
              const CommonSpacer.vertical(4),
              Text(
                checkin.notes!,
                style: th.tx.body.copyWith(color: th.colors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkinDate = DateTime(date.year, date.month, date.day);
    if (checkinDate == today) {
      return 'Today';
    } else if (checkinDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  IconData _getTimeIcon(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return Icons.wb_sunny_rounded;
      case 'afternoon':
        return Icons.wb_cloudy_rounded;
      case 'evening':
        return Icons.nightlight_round_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  Color _getMoodColor(String mood, BuildContext context) {
    final th = context.theme;

    switch (mood) {
      case 'Great':
        return th.colors.success;
      case 'Good':
        return th.colors.success.withValues(alpha: 0.7);
      case 'Okay':
        return th.colors.warning;
      case 'Struggling':
        return th.colors.warning.withValues(alpha: 0.7);
      case 'Poor':
        return th.colors.error;
      default:
        return th.colors.textSecondary;
    }
  }
}
