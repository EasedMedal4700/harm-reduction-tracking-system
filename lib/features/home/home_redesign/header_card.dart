// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use AppTheme. Replaced magic numbers with constants.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';



class HeaderCard extends StatelessWidget {
  final String userName;
  final String greeting;
  final VoidCallback onProfileTap;
  final String? profileImageUrl;
  const HeaderCard({
    required this.userName,
    required this.greeting,
    required this.onProfileTap,
    this.profileImageUrl,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final th = context.theme;
    final ac = context.accent;
    final sp = context.spacing;
    return Row(
      mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
      children: [
        Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            Text(
              greeting,
              style: th.typography.bodySmall.copyWith(
                color: c.textSecondary,
                fontWeight: tx.bodyMedium.fontWeight,
              ),
            ),
            CommonSpacer.vertical(sp.xs),
            Text(
              userName,
              style: th.typography.heading2.copyWith(
                color: c.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Semantics(
            label: 'Profile picture',
            button: true,
            child: Container(
              padding: EdgeInsets.all(sp.xs),
              decoration: BoxDecoration(
                shape: context.shapes.boxShapeCircle,
                border: Border.all(
                  color: ac.primary.withValues(alpha: context.opacities.medium),
                  width: context.borders.thin,
                ),
              ),
              child: CircleAvatar(
                radius: sp.lg, // Approx 22-24
                backgroundColor: ac.primary.withValues(
                  alpha: context.opacities.overlay,
                ),
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? Icon(Icons.person, color: ac.primary)
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
