import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Modular Daily Check-in Card component
/// Professional medical dashboard style
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isCompleted ? completedColor : accentColor).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.event_note,
                  size: 28,
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: sp.xs),
                    Text(
                      isCompleted
                          ? _getCompletedMessage()
                          : 'Track your mood and wellness',
                      style: TextStyle(
                        fontSize: 12,
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
                size: 20,
              ),
              label: Text(
                _getButtonText(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? (isDark ? Colors.grey.shade800 : Colors.grey.shade300)
                    : accentColor,
                foregroundColor: isCompleted
                    ? (isDark ? c.textSecondary : Colors.grey.shade600)
                    : Colors.white,
                elevation: isCompleted ? 0 : 2,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
                disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                disabledForegroundColor: isDark ? c.textSecondary : Colors.grey.shade600,
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
        color: const Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(
          color: isCompleted
              ? completedColor.withValues(alpha: 0.3)
              : const Color(0x14FFFFFF), // rgba(255,255,255,0.08)
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }
  }
}
