// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Uses Riverpod dailyCheckinForNowProvider for completion state.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/providers/daily_checkin_providers.dart';
import 'package:mobile_drug_use_app/features/daily_chekin/models/daily_checkin_model.dart';
import '../../daily_chekin/widgets/checkin_dialog.dart';

class DailyCheckinBanner extends ConsumerWidget {
  const DailyCheckinBanner({super.key});

  String _timeOfDay() {
    final hour = TimeOfDay.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  String _getTimeOfDayGreeting(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return 'Good Morning';
      case 'afternoon':
        return 'Good Afternoon';
      case 'evening':
        return 'Good Evening';
      default:
        return 'Hello';
    }
  }

  IconData _getTimeIcon(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return Icons.wb_sunny;
      case 'afternoon':
        return Icons.wb_cloudy;
      case 'evening':
        return Icons.nightlight_round;
      default:
        return Icons.mood;
    }
  }

  Future<void> _showCheckinDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const DailyCheckinDialog(),
    );
    ref.invalidate(dailyCheckinForNowProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;

    final timeOfDay = _timeOfDay();
    final checkin = ref.watch(dailyCheckinForNowProvider);
    final hasCheckedIn = checkin.value != null;
    final baseColor = hasCheckedIn ? c.success : ac.primary;
    final backgroundColor = baseColor.withValues(alpha: 0.1);

    return Container(
      margin: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: baseColor.withValues(alpha: 0.3)),
        boxShadow: context.cardShadow,
      ),
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(
                _getTimeIcon(timeOfDay),
                size: context.sizes.iconLg,
                color: baseColor,
              ),
              SizedBox(width: sp.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    Text(
                      'Daily Check-In',
                      style: tx.titleMedium.copyWith(
                        color: c.textPrimary,
                        fontWeight: tx.bodyBold.fontWeight,
                      ),
                    ),
                    Text(
                      _getTimeOfDayGreeting(timeOfDay),
                      style: tx.bodySmall.copyWith(color: c.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),
          if (hasCheckedIn)
            _buildCheckedInContent(context, timeOfDay, checkin.value, baseColor)
          else
            _buildPromptContent(context, ref, baseColor),
        ],
      ),
    );
  }

  Widget _buildCheckedInContent(
    BuildContext context,
    String timeOfDay,
    DailyCheckin? checkin,
    Color color,
  ) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: color, size: context.sizes.iconMd),
            SizedBox(width: sp.xs),
            Expanded(
              child: Text(
                'You\'ve already checked in for $timeOfDay. Great job tracking your wellness!',
                style: tx.bodyMedium.copyWith(color: c.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: sp.sm),
        Text(
          'Mood: ${checkin?.mood ?? ''}',
          style: tx.labelMedium.copyWith(
            color: color,
            fontWeight: tx.bodyBold.fontWeight,
          ),
        ),
      ],
    );
  }

  Widget _buildPromptContent(BuildContext context, WidgetRef ref, Color color) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          'How are you feeling today?',
          style: tx.titleSmall.copyWith(fontWeight: tx.bodyBold.fontWeight),
        ),
        SizedBox(height: sp.xs),
        Text(
          'Track your wellness throughout the day.',
          style: tx.bodySmall.copyWith(color: c.textSecondary),
        ),
        SizedBox(height: sp.md),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showCheckinDialog(context, ref),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Check-In Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: c.textInverse,
              padding: EdgeInsets.symmetric(vertical: sp.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(sh.radiusSm),
              ),
              elevation: context.sizes.elevationNone,
            ),
          ),
        ),
      ],
    );
  }
}
