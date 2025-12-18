import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use AppTheme. Replaced magic numbers with constants.
class DailyCheckinCard extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;
  final String? completedMessage;
  final String? completedTimeSlot; // 'morning', 'afternoon', or 'evening'

  const DailyCheckinCard({
    required this.isCompleted,
    required this.onTap,
    this.completedMessage,
    this.completedTimeSlot,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final acc = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.text;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final accentColor = acc.primary;
    final completedColor = c.success;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: _buildDecoration(context, isDark, accentColor, completedColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and title
          Row(
            children: [
              // Icon with status color
              Container(
                padding: EdgeInsets.all(context.spacing.sm),
                decoration: BoxDecoration(
                  color: (isCompleted ? completedColor : accentColor).withValues(alpha: context.opacities.low),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.event_note,
                  size: context.sizes.iconLg, // Icon size
                  color: isCompleted ? completedColor : accentColor,
                ),
              ),
              
              SizedBox(width: sp.md),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Daily Check-in',
                      style: t.heading4.copyWith(
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: sp.xs),
                    Text(
                      isCompleted
                          ? _getCompletedMessage()
                          : 'Track your mood and wellness',
                      style: t.bodySmall.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: sp.md),
          
          // Action button with status indicator
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCompleted ? null : onTap,
              icon: Icon(
                isCompleted ? Icons.check_circle_outline : Icons.add_circle_outline,
                size: context.sizes.iconSm,
              ),
              label: Text(
                _getButtonText(),
                style: t.button.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? (isDark ? c.surface : c.surface) // Simplified for theme
                    : accentColor,
                foregroundColor: isCompleted
                    ? c.textSecondary
                    : c.textInverse,
                elevation: isCompleted ? 0 : 2,
                padding: EdgeInsets.symmetric(vertical: sp.md, horizontal: sp.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
                disabledBackgroundColor: c.surface,
                disabledForegroundColor: c.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCompletedMessage() {
    if (completedTimeSlot != null) {
      String timeDisplay = '';
      switch (completedTimeSlot) {
        case 'morning':
          timeDisplay = 'Morning';
          break;
        case 'afternoon':
          timeDisplay = 'Afternoon';
          break;
        case 'evening':
          timeDisplay = 'Evening';
          break;
        default:
          timeDisplay = completedTimeSlot!;
      }
      return 'Completed for $timeDisplay';
    }
    return completedMessage ?? 'Great job today!';
  }

  String _getButtonText() {
    if (isCompleted && completedTimeSlot != null) {
      String timeDisplay = '';
      switch (completedTimeSlot) {
        case 'morning':
          timeDisplay = 'Morning';
          break;
        case 'afternoon':
          timeDisplay = 'Afternoon';
          break;
        case 'evening':
          timeDisplay = 'Evening';
          break;
        default:
          timeDisplay = completedTimeSlot!;
      }
      return '$timeDisplay ';
    }
    return isCompleted ? 'Completed ' : 'Check-In Now';
  }

  BoxDecoration _buildDecoration(BuildContext context, bool isDark, Color accentColor, Color completedColor) {
    final c = context.colors;
    final sh = context.shapes;
    
    if (isDark) {
      // Dark theme: glassmorphism with subtle accent
      return BoxDecoration(
        color: c.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(
          color: isCompleted
              ? completedColor.withValues(alpha: 0.3)
              : c.border.withValues(alpha: 0.5),
          width: isCompleted ? 1.5 : 1,
        ),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                  color: completedColor.withValues(alpha: 0.15),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : null,
      );
    } else {
      // Light theme: clean white card
      return BoxDecoration(
        color: isCompleted
            ? completedColor.withValues(alpha: 0.05)
            : c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: isCompleted
            ? Border.all(
                color: completedColor.withValues(alpha: 0.3),
                width: 1.0,
              )
            : null,
        boxShadow: context.cardShadow,
      );
    }
  }
}
