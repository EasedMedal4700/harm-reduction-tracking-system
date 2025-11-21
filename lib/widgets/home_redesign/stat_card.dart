import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Modular Stat Card component
/// Professional medical dashboard style with centered content
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String? subtitle;
  final Color? customAccentColor;
  final double? progress; // 0.0 to 1.0 for progress bar

  const StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.subtitle,
    this.customAccentColor,
    this.progress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = customAccentColor ??
        (isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple);

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark, accentColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Value row
          Row(
            children: [
              // Icon
              Icon(
                icon,
                size: 28,
                color: accentColor,
              ),
              const Spacer(),
              
              // Value
              Text(
                value,
                style: TextStyle(
                  fontSize: ThemeConstants.font3XLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: ThemeConstants.space12),
          
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
          
          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: ThemeConstants.space4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: accentColor,
              ),
            ),
          ],
          
          // Progress bar
          if (progress != null) ...[
            const SizedBox(height: ThemeConstants.space12),
            ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: isDark
                    ? const Color(0x14FFFFFF)
                    : UIColors.lightDivider,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark, Color accentColor) {
    if (isDark) {
      // Dark theme: glassmorphism
      return BoxDecoration(
        color: const Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: const Color(0x14FFFFFF), // rgba(255,255,255,0.08)
          width: 1,
        ),
        boxShadow: UIColors.createNeonGlow(accentColor, intensity: 0.1),
      );
    } else {
      // Light theme: white card + soft shadow
      return BoxDecoration(
        color: UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}
