// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../services/account_data_service.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';
import 'account_dialogs.dart';
import 'account_confirmation_dialogs.dart';

/// Account management section for settings screen
/// Provides options for downloading data, deleting data, and deleting account
class AccountManagementSection extends StatelessWidget {
  const AccountManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;

    return CommonCard(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Account Management',
            style: typography.heading3.copyWith(
              color: colors.textPrimary,
            ),
          ),
          CommonSpacer.vertical(spacing.xs),
          Text(
            'Manage your personal data and account',
            style: typography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          Divider(height: spacing.xl, thickness: context.borders.thin),
          _buildDownloadDataTile(context),
          CommonSpacer.vertical(spacing.sm),
          _buildDeleteDataTile(context),
          CommonSpacer.vertical(spacing.sm),
          _buildDeleteAccountTile(context),
        ],
      ),
    );
  }

  Widget _buildDownloadDataTile(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.shapes;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          color: colors.info.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(radii.radiusSm),
        ),
        child: Icon(Icons.download, color: colors.info, size: context.sizes.iconMd),
      ),
      title: const Text('Download My Data'),
      subtitle: const Text('Export all your personal information'),
      trailing: Icon(Icons.arrow_forward_ios, size: context.sizes.iconSm),
      onTap: () => _showDownloadDataDialog(context),
    );
  }

  Widget _buildDeleteDataTile(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.shapes;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          color: colors.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(radii.radiusSm),
        ),
        child: Icon(Icons.delete_sweep, color: colors.warning, size: context.sizes.iconMd),
      ),
      title: const Text('Delete My Data'),
      subtitle: const Text('Remove all your logs and entries'),
      trailing: Icon(Icons.arrow_forward_ios, size: context.sizes.iconSm),
      onTap: () => _showDeleteDataDialog(context),
    );
  }

  Widget _buildDeleteAccountTile(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radii = context.shapes;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.error,
          width: context.borders.medium,
        ),
        borderRadius: BorderRadius.circular(radii.radiusMd),
        color: colors.error.withValues(alpha: 0.1),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(spacing.sm),
          decoration: BoxDecoration(
            color: colors.error.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(radii.radiusSm),
          ),
          child: Icon(
            Icons.warning,
            color: colors.error,
            size: context.sizes.iconMd,
          ),
        ),
        title: Text(
          'Delete Account',
          style: typography.bodyBold.copyWith(
            color: colors.error,
          ),
        ),
        subtitle: Text(
          'Permanently delete your account and all data',
          style: typography.bodySmall.copyWith(
            color: colors.error.withValues(alpha: 0.8),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: context.sizes.iconSm,
          color: colors.error,
        ),
        onTap: () => _showDeleteAccountDialog(context),
      ),
    );
  }

  void _showDownloadDataDialog(BuildContext context) {
    final colors = context.colors;
    
    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Download My Data',
        description:
            'Enter your password to download all your personal information.',
        actionButtonText: 'Download',
        actionButtonColor: colors.info,
        onVerified: (password) async {
          Navigator.pop(context);
          await _executeDownload(context);
        },
      ),
    );
  }

  Future<void> _executeDownload(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;
    final service = AccountDataService();
    final result = await service.downloadUserData();
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: result.success ? colors.success : colors.error,
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    final colors = context.colors;
    
    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Delete My Data',
        description:
            'Enter your password to delete all your logs and entries. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: colors.warning,
        requireConfirmation: true,
        onVerified: (password) async {
          Navigator.pop(context);
          _handleDeleteDataFlow(context, password);
        },
      ),
    );
  }

  void _handleDeleteDataFlow(BuildContext context, String password) {
    showDeleteDataConfirmation(
      context,
      password,
      onDownloadFirst: () => _showFinalDeleteDataWithDownload(context, password),
      onConfirmDelete: () async {
        await _executeDeleteData(context);
      },
    );
  }

  void _showFinalDeleteDataWithDownload(BuildContext context, String password) {
    showFinalDeleteDataConfirmation(
      context,
      password,
      onConfirmDelete: () async {
        await _executeDeleteData(context);
      },
    );
  }

  Future<void> _executeDeleteData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;
    final service = AccountDataService();
    final result = await service.deleteUserData();
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: result.success ? colors.warning : colors.error,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final colors = context.colors;
    
    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Delete Account',
        description:
            'Enter your password to permanently delete your account. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: colors.error,
        requireConfirmation: true,
        onVerified: (password) async {
          Navigator.pop(context);
          _handleDeleteAccountFlow(context, password);
        },
      ),
    );
  }

  void _handleDeleteAccountFlow(BuildContext context, String password) {
    showDeleteAccountConfirmation(
      context,
      password,
      onDownloadFirst: () => _showDownloadDataDialog(context),
      onContinue: () => _showFinalDeleteAccountFlow(context, password),
    );
  }

  void _showFinalDeleteAccountFlow(BuildContext context, String password) {
    showFinalDeleteAccountConfirmation(
      context,
      password,
      onConfirmDelete: () async {
        await _executeDeleteAccount(context);
      },
    );
  }

  Future<void> _executeDeleteAccount(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final colors = context.colors;
    final service = AccountDataService();
    final result = await service.deleteAccount();
    
    if (result.success) {
      navigator.pushNamedAndRemoveUntil('/login_page', (route) => false);
    }
    
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: colors.error,
        duration: const Duration(seconds: 8),
      ),
    );
  }
}
