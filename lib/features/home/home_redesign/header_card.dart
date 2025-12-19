import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use AppTheme. Replaced magic numbers with constants.
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
    final text = context.text;
    final t = context.theme;
    final acc = context.accent;
    final sp = context.spacing;

    return Row(
      mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
      children: [
        Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
            Text(
              greeting,
              style: t.typography.bodySmall.copyWith(
                color: c.textSecondary,
                fontWeight: text.bodyMedium.fontWeight,
              ),
            ),
            CommonSpacer.vertical(sp.xs),
            Text(
              userName,
              style: t.typography.heading2.copyWith(
                color: c.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            padding: EdgeInsets.all(sp.xs),
            decoration: BoxDecoration(
              shape: context.shapes.boxShapeCircle,
              border: Border.all(
                color: acc.primary.withValues(alpha: context.opacities.medium),
                width: context.borders.thin,
              ),
            ),
            child: CircleAvatar(
              radius: sp.lg, // Approx 22-24
              backgroundColor: acc.primary.withValues(alpha: context.opacities.overlay),
              backgroundImage: profileImageUrl != null 
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? Icon(Icons.person, color: acc.primary)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
