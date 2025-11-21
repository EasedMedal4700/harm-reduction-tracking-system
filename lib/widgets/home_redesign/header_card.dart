import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Modular Header Card component with greeting
/// Professional medical dashboard style
class HeaderCard extends StatelessWidget {
  final String? userName;

  const HeaderCard({this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greeting = _getGreeting();

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting - calm professional typography
          Text(
            greeting,
            style: TextStyle(
              fontSize: ThemeConstants.font2XLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          
          if (userName != null) ...[
            const SizedBox(height: ThemeConstants.space8),
            Text(
              userName!,
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                color: isDark
                    ? UIColors.darkTextSecondary
                    : UIColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  BoxDecoration _buildDecoration(bool isDark) {
    if (isDark) {
      // Dark theme: glassmorphism
      return BoxDecoration(
        color: const Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: const Color(0x14FFFFFF), // rgba(255,255,255,0.08)
          width: 1,
        ),
      );
    } else {
      // Light theme: clean white card
      return BoxDecoration(
        color: UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}
