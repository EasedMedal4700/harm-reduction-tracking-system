// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme/common usage, not fully migrated.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';


/// Example widget demonstrating theme usage patterns
/// Use this as a reference when building new themed widgets
class ThemeExampleWidget extends StatelessWidget {
  final AppTheme theme;

  const ThemeExampleWidget({required this.theme, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // EXAMPLE 1: Basic Card
          _buildBasicCard(),
          SizedBox(height: theme.spacing.xl),

          // EXAMPLE 2: Gradient Card
          _buildGradientCard(),
          SizedBox(height: theme.spacing.xl),

          // EXAMPLE 3: Neon Border Card (dark theme)
          _buildNeonCard(),
          SizedBox(height: theme.spacing.xl),

          // EXAMPLE 4: Icon with Background
          _buildIconExample(),
          SizedBox(height: theme.spacing.xl),

          // EXAMPLE 5: Typography Showcase
          _buildTypographyExample(),
          SizedBox(height: theme.spacing.xl),

          // EXAMPLE 6: Button Styles
          _buildButtonExample(),
        ],
      ),
    );
  }

  Widget _buildBasicCard() {
    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      decoration: theme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Card', style: theme.typography.heading3),
          SizedBox(height: theme.spacing.sm),
          Text(
            'Uses standard card decoration with theme-aware shadows and borders.',
            style: theme.typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientCard() {
    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      decoration: theme.gradientCardDecoration(useAccentGradient: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gradient Card',
            style: theme.typography.heading3.copyWith(
              color: theme.colors.textInverse,
            ),
          ),
          SizedBox(height: theme.spacing.sm),
          Text(
            'Uses accent gradient for hero sections.',
            style: theme.typography.body.copyWith(
              color: theme.colors.textInverse.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonCard() {
    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      decoration: theme.cardDecoration(neonBorder: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Neon Border Card', style: theme.typography.heading3),
          SizedBox(height: theme.spacing.sm),
          Text(
            'In dark mode, this card has a glowing neon border.',
            style: theme.typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildIconExample() {
    return Row(
      children: [
        // Icon with accent background
        Container(
          padding: EdgeInsets.all(theme.spacing.md),
          decoration: BoxDecoration(
            color: theme.accent.primary.withOpacity(theme.isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
            boxShadow: theme.isDark ? theme.getNeonGlow(intensity: 0.3) : null,
          ),
          child: Icon(
            Icons.star,
            size: AppThemeConstants.iconLg,
            color: theme.accent.primary,
          ),
        ),
        SizedBox(width: theme.spacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Icon with Background', style: theme.typography.heading4),
              SizedBox(height: theme.spacing.xs),
              Text(
                'Colored background with optional glow effect.',
                style: theme.typography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypographyExample() {
    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      decoration: theme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Heading 1', style: theme.typography.heading1),
          SizedBox(height: theme.spacing.sm),
          Text('Heading 2', style: theme.typography.heading2),
          SizedBox(height: theme.spacing.sm),
          Text('Heading 3', style: theme.typography.heading3),
          SizedBox(height: theme.spacing.sm),
          Text('Heading 4', style: theme.typography.heading4),
          SizedBox(height: theme.spacing.md),
          Text('Body Large', style: theme.typography.bodyLarge),
          Text('Body', style: theme.typography.body),
          Text('Body Bold', style: theme.typography.bodyBold),
          Text('Body Small', style: theme.typography.bodySmall),
          SizedBox(height: theme.spacing.md),
          Text('Caption', style: theme.typography.caption),
          Text('Caption Bold', style: theme.typography.captionBold),
          Text('OVERLINE', style: theme.typography.overline),
        ],
      ),
    );
  }

  Widget _buildButtonExample() {
    return Column(
      children: [
        // Primary button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.accent.primary,
            foregroundColor: theme.colors.textInverse,
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeConstants.buttonPaddingHorizontal,
              vertical: theme.spacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
            ),
          ),
          child: Text('Primary Button', style: theme.typography.button),
        ),
        SizedBox(height: theme.spacing.md),

        // Outlined button
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.accent.primary,
            side: BorderSide(color: theme.accent.primary),
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeConstants.buttonPaddingHorizontal,
              vertical: theme.spacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
            ),
          ),
          child: Text('Outlined Button', style: theme.typography.button),
        ),
        SizedBox(height: theme.spacing.md),

        // Text button
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: theme.accent.primary,
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeConstants.buttonPaddingHorizontal,
              vertical: theme.spacing.md,
            ),
          ),
          child: Text('Text Button', style: theme.typography.button),
        ),
      ],
    );
  }
}

