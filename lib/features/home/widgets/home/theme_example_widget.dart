import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated. Uses context-based AppTheme access only.

/// Example widget demonstrating theme usage patterns
/// Use this as a reference when building new themed widgets
class ThemeExampleWidget extends StatelessWidget {
  const ThemeExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
        children: [
          _buildBasicCard(context),
          CommonSpacer(height: sp.xl),

          _buildGradientCard(context),
          CommonSpacer(height: sp.xl),

          _buildNeonCard(context),
          CommonSpacer(height: sp.xl),

          _buildIconExample(context),
          CommonSpacer(height: sp.xl),

          _buildTypographyExample(context),
          CommonSpacer(height: sp.xl),

          _buildButtonExample(context),
        ],
      ),
    );
  }

  Widget _buildBasicCard(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Basic Card', style: t.typography.heading3),
          SizedBox(height: sp.sm),
          Text(
            'Uses standard card decoration with theme-aware shadows and borders.',
            style: t.typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        gradient: t.accent.gradient,
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Gradient Card',
            style: t.typography.heading3.copyWith(color: t.colors.textInverse),
          ),
          SizedBox(height: sp.sm),
          Text(
            'Uses accent gradient for hero sections.',
            style: t.typography.body.copyWith(
              color: t.colors.textInverse.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonCard(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        boxShadow: t.cardShadow,
        border: t.isDark ? Border.all(color: t.accent.primary, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Neon Border Card', style: t.typography.heading3),
          SizedBox(height: sp.sm),
          Text(
            'In dark mode, this card has a glowing neon border.',
            style: t.typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildIconExample(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;
    final sh = context.shapes;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(sp.md),
          decoration: BoxDecoration(
            color: t.accent.primary.withValues(alpha: t.isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(sh.radiusMd),
            boxShadow: t.isDark
                ? [
                    BoxShadow(
                      color: t.accent.primary.withValues(alpha: 0.3),
                      blurRadius: context.sizes.blurRadiusMd,
                      spreadRadius: context.sizes.spreadRadiusMd,
                    ),
                  ]
                : null,
          ),
          child: Icon(Icons.star, size: sp.lg, color: t.accent.primary),
        ),
        SizedBox(width: sp.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text('Icon with Background', style: t.typography.heading4),
              SizedBox(height: sp.xs),
              Text(
                'Colored background with optional glow effect.',
                style: t.typography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypographyExample(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Heading 1', style: t.typography.heading1),
          SizedBox(height: sp.sm),
          Text('Heading 2', style: t.typography.heading2),
          SizedBox(height: sp.sm),
          Text('Heading 3', style: t.typography.heading3),
          SizedBox(height: sp.sm),
          Text('Heading 4', style: t.typography.heading4),
          SizedBox(height: sp.md),
          Text('Body Large', style: t.typography.bodyLarge),
          Text('Body', style: t.typography.body),
          Text('Body Bold', style: t.typography.bodyBold),
          Text('Body Small', style: t.typography.bodySmall),
          SizedBox(height: sp.md),
          Text('Caption', style: t.typography.caption),
          Text('Caption Bold', style: t.typography.captionBold),
          Text('OVERLINE', style: t.typography.overline),
        ],
      ),
    );
  }

  Widget _buildButtonExample(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: t.accent.primary,
            foregroundColor: t.colors.textInverse,
            padding: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
          ),
          child: Text('Primary Button', style: t.typography.button),
        ),
        SizedBox(height: sp.md),

        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: t.accent.primary,
            side: BorderSide(color: t.accent.primary),
            padding: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
          ),
          child: Text('Outlined Button', style: t.typography.button),
        ),
        SizedBox(height: sp.md),

        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: t.accent.primary,
            padding: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.md),
          ),
          child: Text('Text Button', style: t.typography.button),
        ),
      ],
    );
  }
}
