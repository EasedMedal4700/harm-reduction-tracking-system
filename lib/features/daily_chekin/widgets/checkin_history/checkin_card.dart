
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and AppThemeExtension.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../models/daily_checkin_model.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

class CheckinCard extends StatelessWidget {
  final DailyCheckin checkin;

  const CheckinCard({super.key, required this.checkin});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.md),
      child: CommonCard(
        padding: EdgeInsets.all(t.spacing.md),
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
                    size: t.sizes.iconSm,
                    color: t.colors.textSecondary,
                  ),
                  CommonSpacer.horizontal(t.spacing.sm),
                  Text(
                    _formatDate(checkin.checkinDate),
                    style: t.text.body.copyWith(
                      fontWeight: text.bodyBold.fontWeight,
                      color: t.colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: t.spacing.sm, vertical: t.spacing.xs),
                decoration: BoxDecoration(
                  color: t.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(t.shapes.radiusSm),
                ),
                child: Text(
                  checkin.timeOfDay.toUpperCase(),
                  style: t.text.label.copyWith(
                    fontSize: context.text.caption.fontSize,
                    color: t.colors.textSecondary,
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
                style: t.text.body.copyWith(
                  fontWeight: text.body.fontWeight,
                  color: t.colors.textSecondary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: t.spacing.md, vertical: t.spacing.xs),
                decoration: BoxDecoration(
                  color: _getMoodColor(checkin.mood, context).withValues(alpha: t.opacities.selected),
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                  border: Border.all(
                    color: _getMoodColor(checkin.mood, context).withValues(alpha: t.opacities.slow),
                  ),
                ),
                child: Text(
                  checkin.mood,
                  style: t.text.label.copyWith(
                    fontWeight: text.bodyBold.fontWeight,
                    color: _getMoodColor(checkin.mood, context), // Use the color for text too
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
              style: t.text.body.copyWith(
                fontWeight: text.body.fontWeight,
                color: t.colors.textSecondary,
              ),
            ),
            const CommonSpacer.vertical(4),
            Wrap(
              spacing: t.spacing.sm,
              runSpacing: t.spacing.sm,
              children: checkin.emotions.map((emotion) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: t.spacing.sm, vertical: t.spacing.xs),
                  decoration: BoxDecoration(
                    color: t.colors.surfaceVariant.withValues(alpha: t.opacities.slow),
                    borderRadius: BorderRadius.circular(t.shapes.radiusSm),
                    border: Border.all(color: t.colors.border),
                  ),
                  child: Text(
                    emotion,
                    style: t.text.label.copyWith(
                      color: t.colors.textPrimary,
                    ),
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
              style: t.text.body.copyWith(
                fontWeight: text.body.fontWeight,
                color: t.colors.textSecondary,
              ),
            ),
            const CommonSpacer.vertical(4),
            Text(
              checkin.notes!,
              style: t.text.body.copyWith(
                color: t.colors.textSecondary,
              ),
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
    final t = context.theme;
    switch (mood) {
      case 'Great':
        return t.colors.success;
      case 'Good':
        return t.colors.success.withValues(alpha: 0.7);
      case 'Okay':
        return t.colors.warning;
      case 'Struggling':
        return t.colors.warning.withValues(alpha: 0.7);
      case 'Poor':
        return t.colors.error;
      default:
        return t.colors.textSecondary;
    }
  }
}
