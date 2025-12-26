import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated. Uses context-based AppTheme access only.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final sp = context.spacing;

    final th = context.theme;
    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: th.colors.surface,
        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
        boxShadow: th.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Basic Card', style: th.typography.heading3),
          SizedBox(height: sp.sm),
          Text(
            'Uses standard card decoration with theme-aware shadows and borders.',
            style: th.typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        gradient: th.accent.gradient,
        borderRadius: BorderRadius.circular(th.shapes.radiusLg),
        boxShadow: th.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Gradient Card',
            style: th.typography.heading3.copyWith(
              color: th.colors.textInverse,
            ),
          ),
          SizedBox(height: sp.sm),
          Text(
            'Uses accent gradient for hero sections.',
            style: th.typography.body.copyWith(
              color: th.colors.textInverse.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonCard(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: th.colors.surface,
        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
        boxShadow: th.cardShadow,
        border: th.isDark
            ? Border.all(color: th.accent.primary, width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Neon Border Card', style: th.typography.heading3),
          SizedBox(height: sp.sm),
          Text(
            'In dark mode, this card has a glowing neon border.',
            style: th.typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildIconExample(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;

    final sh = context.shapes;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(sp.md),
          decoration: BoxDecoration(
            color: th.accent.primary.withValues(alpha: th.isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(sh.radiusMd),
            boxShadow: th.isDark
                ? [
                    BoxShadow(
                      color: th.accent.primary.withValues(alpha: 0.3),
                      blurRadius: context.sizes.blurRadiusMd,
                      spreadRadius: context.sizes.spreadRadiusMd,
                    ),
                  ]
                : null,
          ),
          child: Icon(Icons.star, size: sp.lg, color: th.accent.primary),
        ),
        SizedBox(width: sp.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text('Icon with Background', style: th.typography.heading4),
              SizedBox(height: sp.xs),
              Text(
                'Colored background with optional glow effect.',
                style: th.typography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypographyExample(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: th.colors.surface,
        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
        boxShadow: th.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Heading 1', style: th.typography.heading1),
          SizedBox(height: sp.sm),
          Text('Heading 2', style: th.typography.heading2),
          SizedBox(height: sp.sm),
          Text('Heading 3', style: th.typography.heading3),
          SizedBox(height: sp.sm),
          Text('Heading 4', style: th.typography.heading4),
          SizedBox(height: sp.md),
          Text('Body Large', style: th.typography.bodyLarge),
          Text('Body', style: th.typography.body),
          Text('Body Bold', style: th.typography.bodyBold),
          Text('Body Small', style: th.typography.bodySmall),
          SizedBox(height: sp.md),
          Text('Caption', style: th.typography.caption),
          Text('Caption Bold', style: th.typography.captionBold),
          Text('OVERLINE', style: th.typography.overline),
        ],
      ),
    );
  }

  Widget _buildButtonExample(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: th.accent.primary,
            foregroundColor: th.colors.textInverse,
            padding: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
          ),
          child: Text('Primary Button', style: th.typography.button),
        ),
        SizedBox(height: sp.md),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: th.accent.primary,
            side: BorderSide(color: th.accent.primary),
            padding: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
          ),
          child: Text('Outlined Button', style: th.typography.button),
        ),
        SizedBox(height: sp.md),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: th.accent.primary,
            padding: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.md),
          ),
          child: Text('Text Button', style: th.typography.button),
        ),
      ],
    );
  }
}
