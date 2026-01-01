// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-compliant. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/buttons/common_icon_button.dart';

import '../../models/admin_user.dart';
import 'admin_user_card.dart';

/// User list section for admin panel
class AdminUserList extends StatelessWidget {
  final List<AdminUser> users;
  final Future<void> Function(String, bool) onToggleAdmin;
  final VoidCallback onRefresh;
  const AdminUserList({
    required this.users,
    required this.onToggleAdmin,
    required this.onRefresh,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        // HEADER
        Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Text(
              'User Management',
              style: tx.heading3.copyWith(color: c.textPrimary),
            ),
            CommonIconButton(
              icon: Icons.refresh,
              color: c.textPrimary,
              onPressed: onRefresh,
            ),
          ],
        ),
        SizedBox(height: sp.lg),
        if (users.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(sp.xl),
              child: Text(
                'No users found',
                style: tx.body.copyWith(color: c.textSecondary),
              ),
            ),
          )
        else
          ...users.map(
            (user) => AdminUserCard(user: user, onToggleAdmin: onToggleAdmin),
          ),
      ],
    );
  }
}
