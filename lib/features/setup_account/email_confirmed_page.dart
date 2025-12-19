import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/buttons/common_primary_button.dart';

/// Success page shown after email confirmation via deep link.
///
/// Displays a success message and provides a button to navigate to login.
class EmailConfirmedPage extends StatelessWidget {
  const EmailConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(sp.xl),
          child: Column(
            mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
            children: [
              const Spacer(),
              // Success animation/icon
              Container(
                width: context.sizes.cardWidthSm,
                height: 120,
                decoration: BoxDecoration(
                  color: c.success.withValues(alpha: context.opacities.overlay),
                  shape: context.shapes.boxShapeCircle,
                ),
                child: Icon(
                  Icons.verified_rounded,
                  size: context.sizes.icon2xl,
                  color: c.success,
                ),
              ),
              CommonSpacer.vertical(sp.xl2),
              // Title
              Text(
                'Email Verified!',
                style: text.headlineMedium.copyWith(
                  color: c.textPrimary,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.lg),
              // Description
              Text(
                'Your email has been successfully verified. You can now log in to your account.',
                style: text.bodyMedium.copyWith(
                  color: c.textSecondary,
                  height: 1.5,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
              CommonSpacer.vertical(sp.lg),
              // Checkmark list
              Container(
                padding: EdgeInsets.all(sp.lg),
                decoration: BoxDecoration(
                  color: c.success.withValues(alpha: context.opacities.splash),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: c.success.withValues(alpha: context.opacities.selected),
                  ),
                ),
                child: Column(
                  children: [
                    _buildCheckItem(context, 'Email address confirmed'),
                    CommonSpacer.vertical(sp.md),
                    _buildCheckItem(context, 'Account activated'),
                    CommonSpacer.vertical(sp.md),
                    _buildCheckItem(context, 'Ready to log in'),
                  ],
                ),
              ),
              const Spacer(),
              // Login button
              CommonPrimaryButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login_page',
                    (route) => false,
                  );
                },
                icon: Icons.login_rounded,
                label: 'Go to Login',
                width: double.infinity,
              ),
              CommonSpacer.vertical(sp.xl2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String text) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;

    return Row(
      children: [
        Container(
          width: context.sizes.iconMd,
          height: context.sizes.iconMd,
          decoration: BoxDecoration(
            color: c.success,
            shape: context.shapes.boxShapeCircle,
          ),
          child: Icon(
            Icons.check,
            size: 16.0,
            color: c.textInverse,
          ),
        ),
        CommonSpacer.horizontal(sp.md),
        Expanded(
          child: Text(
            text,
            style: t.typography.body.copyWith(
              color: c.textPrimary,
              fontWeight: text.bodyMedium.fontWeight,
            ),
          ),
        ),
      ],
    );
  }
}




