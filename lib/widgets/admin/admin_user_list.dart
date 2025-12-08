import 'package:flutter/material.dart';
import 'admin_user_card.dart';
import '../../constants/theme/app_theme_extension.dart';

/// User list section for admin panel
class AdminUserList extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Function(String, bool) onToggleAdmin;
  final VoidCallback onRefresh;

  const AdminUserList({
    required this.users,
    required this.onToggleAdmin,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'User Management',
              style: t.typography.heading3.copyWith(
                color: t.colors.textPrimary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
              color: t.colors.textPrimary,
            ),
          ],
        ),

        SizedBox(height: t.spacing.lg),

        if (users.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(t.spacing.xl),
              child: Text(
                'No users found',
                style: t.typography.body.copyWith(
                  color: t.colors.textSecondary,
                ),
              ),
            ),
          )
        else
          ...users.map(
            (user) => AdminUserCard(
              user: user,
              onToggleAdmin: onToggleAdmin,
            ),
          ),
      ],
    );
  }
}
