import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Modular Daily Check-in Card component
/// Professional medical dashboard style
class DailyCheckinCard extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;
  final String? completedMessage;

  const DailyCheckinCard({
    required this.isCompleted,
    required this.onTap,
    this.completedMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? UIColors.darkNeonBlue
        : UIColors.lightAccentBlue;

    return InkWell(
      onTap: isCompleted ? null : onTap,
      borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
        decoration: _buildDecoration(isDark, accentColor),
        child: Row(
          children: [
            // Icon - centered vertically
            Icon(
              isCompleted ? Icons.check_circle : Icons.event_note,
              size: 32,
              color: accentColor,
            ),
            
            const SizedBox(width: ThemeConstants.space16),
            
            // Text content - centered vertically
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isCompleted
                        ? 'Daily Check-in Complete'
                        : 'Daily Check-in',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontLarge,
                      fontWeight: ThemeConstants.fontSemiBold,
                      color: isDark
                          ? UIColors.darkText
                          : UIColors.lightText,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.space4),
                  Text(
                    isCompleted
                        ? (completedMessage ?? 'Great job today!')
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
            
            // Arrow or checkmark
            if (!isCompleted)
              Icon(
                Icons.arrow_forward_ios,
                size: ThemeConstants.iconSmall,
                color: isDark
                    ? UIColors.darkTextSecondary
                    : UIColors.lightTextSecondary,
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark, Color accentColor) {
    if (isDark) {
      // Dark theme: glassmorphism with subtle accent
      return BoxDecoration(
        color: const Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isCompleted
              ? accentColor.withValues(alpha: 0.3)
              : const Color(0x14FFFFFF), // rgba(255,255,255,0.08)
          width: 1,
        ),
        boxShadow: isCompleted
            ? UIColors.createNeonGlow(accentColor, intensity: 0.2)
            : null,
      );
    } else {
      // Light theme: clean white card
      return BoxDecoration(
        color: isCompleted
            ? accentColor.withValues(alpha: 0.05)
            : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: isCompleted
            ? Border.all(
                color: accentColor.withValues(alpha: 0.2),
                width: ThemeConstants.borderThin,
              )
            : null,
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}
