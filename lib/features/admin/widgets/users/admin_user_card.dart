
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-compliant. No hardcoded values.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';

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
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;
    final t = context.theme;

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

    // INVALID DATA FALLBACK
    if (authUserId.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: sp.sm),
        child: CommonCard(
          borderRadius: sh.radiusMd,
          showBorder: false,
          padding: EdgeInsets.zero,
          child: ListTile(
          leading: Icon(Icons.error_outline, color: c.error),
          title: Text(
            'Invalid user data',
            style: text.bodyBold.copyWith(color: c.error),
          ),
          subtitle: Text(
            'Email: $email',
            style: text.bodySmall.copyWith(color: c.textSecondary),
          ),
        ),
      ),
    );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.sm),
      child: CommonCard(
        borderRadius: sh.radiusMd,
        showBorder: false,
        padding: EdgeInsets.zero,
        child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(
          horizontal: sp.md,
          vertical: sp.sm,
        ),
        childrenPadding: EdgeInsets.only(bottom: sp.md),

        // USER AVATAR
        leading: CircleAvatar(
          backgroundColor: isAdmin
              ? t.accent.primary
              : t.accent.secondary.withValues(alpha: context.opacities.veryHigh),
          child: Text(
            username[0].toUpperCase(),
            style: text.bodyBold.copyWith(color: c.textInverse),
          ),
        ),

        // TITLE LINE
        title: Row(
          children: [
            Flexible(
              child: Text(
                username,
                style: text.bodyBold.copyWith(color: c.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (isAdmin) ...[
              SizedBox(width: sp.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sp.sm,
                  vertical: sp.xs,
                ),
                decoration: BoxDecoration(
                  color: t.accent.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                ),
                child: Text(
                  'ADMIN',
                  style: text.overline.copyWith(
                    color: t.accent.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),

        // SUBTITLE (email)
        subtitle: Text(
          email,
          style: text.bodySmall.copyWith(color: c.textSecondary),
        ),

        // EXPANDED DETAILS
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sp.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(context, 'Auth User ID',
                    '${authUserId.substring(0, 8)}...'),

                Divider(color: c.divider),

                _buildInfoRow(context, 'Entries', entryCount.toString()),
                _buildInfoRow(context, 'Cravings', cravingCount.toString()),
                _buildInfoRow(context, 'Reflections', reflectionCount.toString()),
                _buildInfoRow(
                  context,
                  'Total Activity',
                  (entryCount + cravingCount + reflectionCount).toString(),
                ),

                Divider(color: c.divider),

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

                SizedBox(height: sp.lg),

                /// ADMIN TOGGLE BUTTON
                Row(
                  children: [
                    Expanded(
                      child: CommonPrimaryButton(
                        onPressed: () => onToggleAdmin(authUserId, isAdmin),
                        icon: isAdmin ? Icons.remove_circle : Icons.add_circle,
                        label: isAdmin ? 'Remove Admin' : 'Make Admin',
                        backgroundColor: isAdmin ? c.error : c.success,
                        textColor: c.textInverse,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: text.caption.copyWith(color: c.textSecondary),
          ),
          Text(
            value,
            style: text.bodyBold.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}
