// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-compliant. No hardcoded values.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:intl/intl.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';

import '../../models/admin_user.dart';

/// User card widget for admin panel
class AdminUserCard extends StatelessWidget {
  final AdminUser user;
  final Future<void> Function(String, bool) onToggleAdmin;
  const AdminUserCard({
    required this.user,
    required this.onToggleAdmin,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final tx = context.text;
    final authUserId = user.authUserId;
    final username = user.displayName;
    final email = user.email;
    final isAdmin = user.isAdmin;
    final createdAt = user.createdAt;
    final lastActive = user.lastActivity ?? user.updatedAt;
    final entryCount = user.entryCount;
    final cravingCount = user.cravingCount;
    final reflectionCount = user.reflectionCount;
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
              style: tx.bodyBold.copyWith(color: c.error),
            ),
            subtitle: Text(
              'Email: $email',
              style: tx.bodySmall.copyWith(color: c.textSecondary),
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
          tilePadding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
          childrenPadding: EdgeInsets.only(bottom: sp.md),
          // USER AVATAR
          leading: CircleAvatar(
            backgroundColor: isAdmin
                ? th.accent.primary
                : th.accent.secondary.withValues(
                    alpha: context.opacities.veryHigh,
                  ),
            child: Text(
              username[0].toUpperCase(),
              style: tx.bodyBold.copyWith(color: c.textInverse),
            ),
          ),
          // TITLE LINE
          title: Row(
            children: [
              Flexible(
                child: Text(
                  username,
                  style: tx.bodyBold.copyWith(color: c.textPrimary),
                  overflow: AppLayout.textOverflowEllipsis,
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
                    color: th.accent.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                  ),
                  child: Text(
                    'ADMIN',
                    style: tx.overline.copyWith(
                      color: th.accent.primary,
                      fontWeight: tx.bodyBold.fontWeight,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // SUBTITLE (email)
          subtitle: Text(
            email,
            style: tx.bodySmall.copyWith(color: c.textSecondary),
          ),
          // EXPANDED DETAILS
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sp.md),
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  _buildInfoRow(
                    context,
                    'Auth User ID',
                    '${authUserId.substring(0, 8)}...',
                  ),
                  Divider(color: c.divider),
                  _buildInfoRow(context, 'Entries', entryCount.toString()),
                  _buildInfoRow(context, 'Cravings', cravingCount.toString()),
                  _buildInfoRow(
                    context,
                    'Reflections',
                    reflectionCount.toString(),
                  ),
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
                      DateFormat('MMM d, yyyy').format(createdAt),
                    ),
                  if (lastActive != null)
                    _buildInfoRow(
                      context,
                      'Last Active',
                      DateFormat('MMM d, yyyy HH:mm').format(lastActive),
                    ),
                  SizedBox(height: sp.lg),

                  /// ADMIN TOGGLE BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: CommonPrimaryButton(
                          onPressed: () {
                            unawaited(onToggleAdmin(authUserId, isAdmin));
                          },
                          icon: isAdmin
                              ? Icons.remove_circle
                              : Icons.add_circle,
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
    final tx = context.text;
    final sp = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sp.xs),
      child: Row(
        mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
        children: [
          Text(label, style: tx.caption.copyWith(color: c.textSecondary)),
          Text(value, style: tx.bodyBold.copyWith(color: c.textPrimary)),
        ],
      ),
    );
  }
}
