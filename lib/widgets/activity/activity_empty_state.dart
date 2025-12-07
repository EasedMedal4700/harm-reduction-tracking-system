import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';

class ActivityEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const ActivityEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isDark 
                  ? UIColors.darkTextSecondary.withOpacity(0.5)
                  : UIColors.lightTextSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
