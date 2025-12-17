import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';

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
    final acc = context.accent;
    final sp = context.spacing;
    final t = context.text;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: t.bodySmall.copyWith(
                color: c.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: sp.xs),
            Text(
              userName,
              style: t.heading2.copyWith(
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
              shape: BoxShape.circle,
              border: Border.all(
                color: acc.primary.withValues(alpha: AppThemeConstants.opacityMedium),
                width: AppThemeConstants.borderThin,
              ),
            ),
            child: CircleAvatar(
              radius: sp.lg, // Approx 22-24
              backgroundColor: acc.primary.withValues(alpha: AppThemeConstants.opacityOverlay),
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
