import 'package:flutter/material.dart';
import '../constants/ui_colors.dart';
import '../constants/theme_constants.dart';

/// Success page shown after email confirmation via deep link.
///
/// Displays a success message and provides a button to navigate to login.
class EmailConfirmedPage extends StatelessWidget {
  const EmailConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? UIColors.darkBackground : UIColors.lightBackground;
    final primaryColor =
        isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final textSecondaryColor =
        isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary;
    final successColor = isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ThemeConstants.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success animation/icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_rounded,
                  size: 60,
                  color: successColor,
                ),
              ),
              SizedBox(height: ThemeConstants.space32),
              // Title
              Text(
                'Email Verified!',
                style: TextStyle(
                  fontSize: ThemeConstants.font3XLarge,
                  fontWeight: ThemeConstants.fontBold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ThemeConstants.space16),
              // Description
              Text(
                'Your email has been successfully verified. You can now log in to your account.',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  color: textSecondaryColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ThemeConstants.space16),
              // Checkmark list
              Container(
                padding: EdgeInsets.all(ThemeConstants.space16),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
                  border: Border.all(
                    color: successColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildCheckItem('Email address confirmed', successColor, textColor),
                    SizedBox(height: ThemeConstants.space12),
                    _buildCheckItem('Account activated', successColor, textColor),
                    SizedBox(height: ThemeConstants.space12),
                    _buildCheckItem('Ready to log in', successColor, textColor),
                  ],
                ),
              ),
              const Spacer(),
              // Login button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login_page',
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.login_rounded),
                  label: const Text(
                    'Go to Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeConstants.buttonRadius),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ThemeConstants.space32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String text, Color checkColor, Color textColor) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: checkColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(width: ThemeConstants.space12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: textColor,
              fontWeight: ThemeConstants.fontMediumWeight,
            ),
          ),
        ),
      ],
    );
  }
}
