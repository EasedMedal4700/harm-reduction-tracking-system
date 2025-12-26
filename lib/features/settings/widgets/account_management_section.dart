// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and common components. No logic or state changes.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../services/account_data_service.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';
import 'account_dialogs.dart';
import 'account_confirmation_dialogs.dart';

/// Account management section for settings screen
/// Provides options for downloading data, deleting data, and deleting account
class AccountManagementSection extends StatelessWidget {
  const AccountManagementSection({super.key});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    return CommonCard(
      padding: EdgeInsets.all(sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Account Management',
            style: tx.heading3.copyWith(color: c.textPrimary),
          ),
          CommonSpacer.vertical(sp.xs),
          Text(
            'Manage your personal data and account',
            style: tx.bodySmall.copyWith(color: c.textSecondary),
          ),
          Divider(height: sp.xl, thickness: context.borders.thin),
          _buildDownloadDataTile(context),
          CommonSpacer.vertical(sp.sm),
          _buildDeleteDataTile(context),
          CommonSpacer.vertical(sp.sm),
          _buildDeleteAccountTile(context),
        ],
      ),
    );
  }

  Widget _buildDownloadDataTile(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;

    final sh = context.shapes;
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(sp.sm),
        decoration: BoxDecoration(
          color: c.info.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(sh.radiusSm),
        ),
        child: Icon(Icons.download, color: c.info, size: context.sizes.iconMd),
      ),
      title: const Text('Download My Data'),
      subtitle: const Text('Export all your personal information'),
      trailing: Icon(Icons.arrow_forward_ios, size: context.sizes.iconSm),
      onTap: () => _showDownloadDataDialog(context),
    );
  }

  Widget _buildDeleteDataTile(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(sp.sm),
        decoration: BoxDecoration(
          color: c.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(sh.radiusSm),
        ),
        child: Icon(
          Icons.delete_sweep,
          color: c.warning,
          size: context.sizes.iconMd,
        ),
      ),
      title: const Text('Delete My Data'),
      subtitle: const Text('Remove all your logs and entries'),
      trailing: Icon(Icons.arrow_forward_ios, size: context.sizes.iconSm),
      onTap: () => _showDeleteDataDialog(context),
    );
  }

  Widget _buildDeleteAccountTile(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: c.error, width: context.borders.medium),
        borderRadius: BorderRadius.circular(sh.radiusMd),
        color: c.error.withValues(alpha: 0.1),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(sp.sm),
          decoration: BoxDecoration(
            color: c.error.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(sh.radiusSm),
          ),
          child: Icon(
            Icons.warning,
            color: c.error,
            size: context.sizes.iconMd,
          ),
        ),
        title: Text(
          'Delete Account',
          style: tx.bodyBold.copyWith(color: c.error),
        ),
        subtitle: Text(
          'Permanently delete your account and all data',
          style: tx.bodySmall.copyWith(color: c.error.withValues(alpha: 0.8)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: context.sizes.iconSm,
          color: c.error,
        ),
        onTap: () => _showDeleteAccountDialog(context),
      ),
    );
  }

  void _showDownloadDataDialog(BuildContext context) {
    final c = context.colors;

    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Download My Data',
        description:
            'Enter your password to download all your personal information.',
        actionButtonText: 'Download',
        actionButtonColor: c.info,
        onVerified: (password) async {
          Navigator.pop(context);
          await _executeDownload(context);
        },
      ),
    );
  }

  Future<void> _executeDownload(BuildContext context) async {
    final c = context.colors;
    final messenger = ScaffoldMessenger.of(context);
    final service = AccountDataService();
    final result = await service.downloadUserData();
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: result.success ? c.success : c.error,
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    final c = context.colors;

    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Delete My Data',
        description:
            'Enter your password to delete all your logs and entries. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: c.warning,
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
      onDownloadFirst: () =>
          _showFinalDeleteDataWithDownload(context, password),
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
    final c = context.colors;
    final messenger = ScaffoldMessenger.of(context);
    final service = AccountDataService();
    final result = await service.deleteUserData();
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: result.success ? c.warning : c.error,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final c = context.colors;

    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Delete Account',
        description:
            'Enter your password to permanently delete your account. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: c.error,
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
    final service = AccountDataService();
    final result = await service.deleteAccount();
    if (!context.mounted) return;

    final c = context.colors;
    final messenger = ScaffoldMessenger.of(context);
    if (result.success) {
      context.go('/login_page');
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: c.error,
        duration: const Duration(seconds: 8),
      ),
    );
  }
}
