import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/daily_checkin_provider.dart';
import '../../daily_chekin/widgets/checkin_dialog.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use AppTheme.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
// Riverpod: TODO
// Notes: Migrated to use AppTheme.
class DailyCheckinBanner extends StatefulWidget {
  const DailyCheckinBanner({super.key});
  @override
  State<DailyCheckinBanner> createState() => _DailyCheckinBannerState();
}

class _DailyCheckinBannerState extends State<DailyCheckinBanner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<DailyCheckinProvider>();
      provider.initialize();
      provider.checkExistingCheckin();
    });
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

  void _showCheckinDialog(BuildContext context, DailyCheckinProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => ChangeNotifierProvider.value(
        value: provider,
        child: const DailyCheckinDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    return Consumer<DailyCheckinProvider>(
      builder: (context, provider, child) {
        final hasCheckedIn = provider.existingCheckin != null;
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
              // Header row with icon and title
              Row(
                children: [
                  Icon(
                    _getTimeIcon(provider.timeOfDay),
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
                          _getTimeOfDayGreeting(provider.timeOfDay),
                          style: tx.bodySmall.copyWith(color: c.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: sp.md),
              // Content based on check-in status
              if (hasCheckedIn)
                _buildCheckedInContent(context, provider, baseColor)
              else
                _buildPromptContent(context, provider, baseColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckedInContent(
    BuildContext context,
    DailyCheckinProvider provider,
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
                'You\'ve already checked in for ${provider.timeOfDay}. Great job tracking your wellness!',
                style: tx.bodyMedium.copyWith(color: c.textPrimary),
              ),
            ),
          ],
        ),
        SizedBox(height: sp.sm),
        Text(
          'Mood: ${provider.existingCheckin!.mood}',
          style: tx.labelMedium.copyWith(
            color: color,
            fontWeight: tx.bodyBold.fontWeight,
          ),
        ),
      ],
    );
  }

  Widget _buildPromptContent(
    BuildContext context,
    DailyCheckinProvider provider,
    Color color,
  ) {
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
            onPressed: () => _showCheckinDialog(context, provider),
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
