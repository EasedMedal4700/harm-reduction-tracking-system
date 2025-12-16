import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';




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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? UIColors.darkNeonBlue
        : UIColors.lightAccentBlue;
    final completedColor = isDark
        ? UIColors.darkNeonGreen
        : Colors.green.shade600;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark, accentColor, completedColor),
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
              
              const SizedBox(width: ThemeConstants.space16),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Daily Check-in',
                      style: TextStyle(
                        fontSize: ThemeConstants.fontLarge,
                        fontWeight: ThemeConstants.fontBold,
                        color: isDark
                            ? UIColors.darkText
                            : UIColors.lightText,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.space4),
                    Text(
                      isCompleted
                          ? _getCompletedMessage()
                          : 'Track your mood and wellness',
                      style: TextStyle(
                        fontSize: ThemeConstants.fontSmall,
                        color: isDark
                            ? UIColors.darkTextSecondary
                            : UIColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: ThemeConstants.space16),
          
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
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontSemiBold,
                  height: 1.2,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? (isDark ? Colors.grey.shade800 : Colors.grey.shade300)
                    : (isDark ? accentColor : accentColor),
                foregroundColor: isCompleted
                    ? (isDark ? UIColors.darkTextSecondary : Colors.grey.shade600)
                    : Colors.white,
                elevation: isCompleted ? 0 : 2,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                ),
                disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                disabledForegroundColor: isDark ? UIColors.darkTextSecondary : Colors.grey.shade600,
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
      return '$timeDisplay ✓';
    }
    return isCompleted ? 'Completed ✓' : 'Check-In Now';
  }

  BoxDecoration _buildDecoration(bool isDark, Color accentColor, Color completedColor) {
    if (isDark) {
      // Dark theme: glassmorphism with subtle accent
      return BoxDecoration(
        color: const Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isCompleted
              ? completedColor.withValues(alpha: 0.3)
              : const Color(0x14FFFFFF), // rgba(255,255,255,0.08)
          width: isCompleted ? 1.5 : 1,
        ),
        boxShadow: isCompleted
            ? UIColors.createNeonGlow(completedColor, intensity: 0.15)
            : null,
      );
    } else {
      // Light theme: clean white card
      return BoxDecoration(
        color: isCompleted
            ? completedColor.withValues(alpha: 0.05)
            : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: isCompleted
            ? Border.all(
                color: completedColor.withValues(alpha: 0.3),
                width: ThemeConstants.borderThin,
              )
            : null,
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}


