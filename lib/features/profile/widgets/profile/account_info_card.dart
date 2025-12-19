// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppTheme system. No deprecated constants remain.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:intl/intl.dart';

import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'info_row.dart';

class AccountInfoCard extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const AccountInfoCard({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final spacing = t.spacing;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(
            title: "Account Information",
          ),

          CommonSpacer.vertical(spacing.lg),

          InfoRow(
            icon: Icons.badge,
            label: "User ID",
            value: userData?['user_id']?.toString() ?? "N/A",
          ),
          Divider(color: t.colors.divider),

          InfoRow(
            icon: Icons.email,
            label: "Email",
            value: userData?['email'] ?? "N/A",
          ),
          Divider(color: t.colors.divider),

          InfoRow(
            icon: Icons.person,
            label: "Display Name",
            value: userData?['display_name'] ?? "N/A",
          ),
          Divider(color: t.colors.divider),

          InfoRow(
            icon: Icons.calendar_today,
            label: "Member Since",
            value: _formatDate(userData?['created_at']),
          ),
          Divider(color: t.colors.divider),

          InfoRow(
            icon: Icons.update,
            label: "Last Updated",
            value: _formatDateTime(userData?['updated_at']),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic isoString) {
    if (isoString == null) return "N/A";
    final dt = DateTime.tryParse(isoString.toString());
    if (dt == null) return "N/A";
    return DateFormat("MMMM dd, yyyy").format(dt);
  }

  String _formatDateTime(dynamic isoString) {
    if (isoString == null) return "N/A";
    final dt = DateTime.tryParse(isoString.toString());
    if (dt == null) return "N/A";
    return DateFormat("MMM dd, yyyy HH:mm").format(dt);
  }
}
