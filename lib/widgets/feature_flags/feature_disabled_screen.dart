
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';



/// A screen displayed when a feature is currently disabled.
/// Shows a friendly message and provides navigation options.
class FeatureDisabledScreen extends StatelessWidget {
  /// The name of the disabled feature (e.g., 'craving_log')
  final String featureName;

  /// Optional custom message to display
  final String? customMessage;

  const FeatureDisabledScreen({
    super.key,
    required this.featureName,
    this.customMessage,
  });

  /// Formats a feature name for display (e.g., 'craving_log' -> 'Craving Log')
  String _formatFeatureName(String name) {
    return name
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final formattedName = _formatFeatureName(featureName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use theme-appropriate colors
    final backgroundColor =
        isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final primaryColor =
        isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final textSecondaryColor =
        isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary;
    final infoColor = isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          formattedName,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ThemeConstants.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ThemeConstants.space48),
                // Construction icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.construction_rounded,
                    size: 60,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: ThemeConstants.space32),
                // Title
                Text(
                  'Feature Temporarily Unavailable',
                  style: TextStyle(
                    fontSize: ThemeConstants.font2XLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeConstants.space16),
                // Description
                Text(
                  customMessage ??
                      'The $formattedName feature is currently undergoing maintenance. '
                          'Please check back later.',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    color: textSecondaryColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ThemeConstants.space48),
                // Home button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('Go to Home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: ThemeConstants.space16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.buttonRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ThemeConstants.space16),
                // Back button (if can pop)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Go Back'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      padding: EdgeInsets.symmetric(
                        vertical: ThemeConstants.space16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ThemeConstants.buttonRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ThemeConstants.space32),
                // Info card
                Container(
                  padding: EdgeInsets.all(ThemeConstants.space16),
                  decoration: BoxDecoration(
                    color: infoColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      ThemeConstants.cardRadius,
                    ),
                    border: Border.all(
                      color: infoColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: infoColor,
                        size: ThemeConstants.iconMedium,
                      ),
                      SizedBox(width: ThemeConstants.space12),
                      Expanded(
                        child: Text(
                          'This feature will be available again soon. '
                          'Thank you for your patience.',
                          style: TextStyle(
                            fontSize: ThemeConstants.fontSmall,
                            color: infoColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
