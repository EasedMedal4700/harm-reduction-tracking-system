
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppTheme. Removed deprecated Material colors.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../common/widgets/common_spacer.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ProfileHeader({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final spacing = t.spacing;

    final isAdmin = userData?['is_admin'] ?? false;
    final displayName = userData?['display_name'] ?? 'Unknown User';
    final email = userData?['email'] ?? 'No email';

    return Column(
      children: [
        CommonSpacer.vertical(spacing.lg),

        // Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor:
              isAdmin ? t.accent.secondary : t.accent.primary, // neon admin vs primary
          child: Text(
            _getInitials(displayName),
            style: t.typography.heading1.copyWith(
              color: t.colors.textInverse,
            ),
          ),
        ),

        CommonSpacer.vertical(spacing.lg),

        // Name
        Text(
          displayName,
          style: t.typography.heading3,
        ),

        CommonSpacer.vertical(spacing.sm),

        // Email
        Text(
          email,
          style: t.typography.bodySmall,
        ),

        CommonSpacer.vertical(spacing.md),

        // Admin Badge
        if (isAdmin)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.sm,
            ),
            decoration: BoxDecoration(
              color: t.accent.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(t.shapes.radiusLg),
              border: Border.all(
                color: t.accent.secondary.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: AppLayout.mainAxisSizeMin,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: t.sizes.iconSm,
                  color: t.colors.textSecondary,
                ),
                CommonSpacer.horizontal(spacing.sm),
                Text(
                  'Administrator',
                  style: t.typography.bodyBold.copyWith(
                    color: t.accent.secondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
