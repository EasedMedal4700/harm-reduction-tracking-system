import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/theme/app_theme_extension.dart';

/// User card widget for admin panel
class AdminUserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final Function(String, bool) onToggleAdmin;

  const AdminUserCard({
    required this.user,
    required this.onToggleAdmin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    // Use auth_user_id as the primary identifier now
    final authUserId = user['auth_user_id'] as String? ?? '';
    final username = user['username'] as String? ??
        user['display_name'] as String? ??
        'Unknown';
    final email = user['email'] as String? ?? 'No email';
    final isAdmin = user['is_admin'] as bool? ?? false;
    final createdAt = user['created_at'];
    final lastActive =
        user['last_activity'] ?? user['last_active'] ?? user['updated_at'];
    final entryCount = user['entry_count'] as int? ?? 0;
    final cravingCount = user['craving_count'] as int? ?? 0;
    final reflectionCount = user['reflection_count'] as int? ?? 0;

    // If authUserId is empty, the data is invalid
    if (authUserId.isEmpty) {
      return Container(
        decoration: t.cardDecoration(),
        margin: EdgeInsets.symmetric(vertical: t.spacing.sm),
        child: ListTile(
          leading: Icon(Icons.error_outline, color: t.colors.error),
          title: Text(
            'Invalid user data',
            style: t.typography.bodyBold.copyWith(color: t.colors.error),
          ),
          subtitle: Text(
            'Email: $email',
            style: t.typography.bodySmall.copyWith(color: t.colors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      decoration: t.cardDecoration(),
      margin: EdgeInsets.symmetric(vertical: t.spacing.sm),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(
          horizontal: t.spacing.md,
          vertical: t.spacing.sm,
        ),
        childrenPadding: EdgeInsets.only(bottom: t.spacing.md),
        leading: CircleAvatar(
          backgroundColor:
              isAdmin ? t.accent.primary : t.accent.secondary.withOpacity(0.8),
          child: Text(
            username[0].toUpperCase(),
            style: t.typography.bodyBold.copyWith(
              color: t.colors.textInverse,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              username,
              style: t.typography.bodyBold.copyWith(
                color: t.colors.textPrimary,
              ),
            ),
            if (isAdmin) ...[
              SizedBox(width: t.spacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: t.spacing.sm,
                  vertical: t.spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: t.accent.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(t.spacing.sm),
                ),
                child: Text(
                  'ADMIN',
                  style: t.typography.overline.copyWith(
                    color: t.accent.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          email,
          style: t.typography.bodySmall.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, 'Auth User ID',
                    '${authUserId.substring(0, 8)}...'),
                Divider(color: t.colors.divider),
                _buildInfoRow(context, 'Entries', entryCount.toString()),
                _buildInfoRow(context, 'Cravings', cravingCount.toString()),
                _buildInfoRow(
                    context, 'Reflections', reflectionCount.toString()),
                _buildInfoRow(
                  context,
                  'Total Activity',
                  (entryCount + cravingCount + reflectionCount).toString(),
                ),
                Divider(color: t.colors.divider),
                if (createdAt != null)
                  _buildInfoRow(
                    context,
                    'Joined',
                    DateFormat('MMM d, yyyy')
                        .format(DateTime.parse(createdAt)),
                  ),
                if (lastActive != null)
                  _buildInfoRow(
                    context,
                    'Last Active',
                    DateFormat('MMM d, yyyy HH:mm')
                        .format(DateTime.parse(lastActive)),
                  ),
                SizedBox(height: t.spacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            onToggleAdmin(authUserId, isAdmin),
                        icon: Icon(
                          isAdmin
                              ? Icons.remove_circle
                              : Icons.add_circle,
                        ),
                        label: Text(
                          isAdmin ? 'Remove Admin' : 'Make Admin',
                          style: t.typography.button.copyWith(
                            color: t.colors.textInverse,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAdmin
                              ? t.colors.error
                              : t.colors.success,
                          foregroundColor: t.colors.textInverse,
                          padding: EdgeInsets.symmetric(
                            vertical: t.spacing.sm,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(t.spacing.sm),
                          ),
                          shadowColor: t.colors.overlayHeavy,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final t = context.theme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: t.typography.caption.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          Text(
            value,
            style: t.typography.bodyBold.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
