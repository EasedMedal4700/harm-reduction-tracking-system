
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and AppThemeExtension.
import 'package:flutter/material.dart';
import '../../../../models/daily_checkin_model.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

class CheckinCard extends StatelessWidget {
  final DailyCheckin checkin;

  const CheckinCard({super.key, required this.checkin});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CommonCard(
        padding: EdgeInsets.all(t.spacing.md),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and time of day
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getTimeIcon(checkin.timeOfDay),
                    size: 20,
                    color: t.colors.textSecondary,
                  ),
                  const CommonSpacer.horizontal(8),
                  Text(
                    _formatDate(checkin.checkinDate),
                    style: t.text.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: t.colors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: t.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(t.shapes.radiusSm),
                ),
                child: Text(
                  checkin.timeOfDay.toUpperCase(),
                  style: t.text.label.copyWith(
                    fontSize: 10,
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
                  fontWeight: FontWeight.w500,
                  color: t.colors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getMoodColor(checkin.mood).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getMoodColor(checkin.mood).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  checkin.mood,
                  style: t.text.label.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getMoodColor(checkin.mood), // Use the color for text too
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
                fontWeight: FontWeight.w500,
                color: t.colors.textSecondary,
              ),
            ),
            const CommonSpacer.vertical(4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: checkin.emotions.map((emotion) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.colors.surfaceVariant.withValues(alpha: 0.5),
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
                fontWeight: FontWeight.w500,
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

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Great':
        return Colors.green;
      case 'Good':
        return Colors.lightGreen;
      case 'Okay':
        return Colors.amber;
      case 'Struggling':
        return Colors.orange;
      case 'Poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
