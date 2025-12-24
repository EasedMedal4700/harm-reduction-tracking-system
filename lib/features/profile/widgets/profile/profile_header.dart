// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppTheme. Removed deprecated Material colors.
import 'package:flutter/material.dart';
import '../../../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const ProfileHeader({super.key, required this.userData});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final spacing = th.spacing;
    final isAdmin = userData?['is_admin'] ?? false;
    final displayName = userData?['display_name'] ?? 'Unknown User';
    final email = userData?['email'] ?? 'No email';
    return Column(
      children: [
        CommonSpacer.vertical(spacing.lg),
        // Avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: isAdmin
              ? th.accent.secondary
              : th.accent.primary, // neon admin vs primary
          child: Text(
            _getInitials(displayName),
            style: th.typography.heading1.copyWith(
              color: th.colors.textInverse,
            ),
          ),
        ),
        CommonSpacer.vertical(spacing.lg),
        // Name
        Text(displayName, style: th.typography.heading3),
        CommonSpacer.vertical(spacing.sm),
        // Email
        Text(email, style: th.typography.bodySmall),
        CommonSpacer.vertical(spacing.md),
        // Admin Badge
        if (isAdmin)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.sm,
            ),
            decoration: BoxDecoration(
              color: th.accent.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(th.shapes.radiusLg),
              border: Border.all(
                color: th.accent.secondary.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: AppLayout.mainAxisSizeMin,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: th.sizes.iconSm,
                  color: th.colors.textSecondary,
                ),
                CommonSpacer.horizontal(spacing.sm),
                Text(
                  'Administrator',
                  style: th.typography.bodyBold.copyWith(
                    color: th.accent.secondary,
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
