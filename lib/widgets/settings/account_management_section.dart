import 'package:flutter/material.dart';
import '../../services/account_data_service.dart';
import 'account_dialogs.dart';
import 'account_confirmation_dialogs.dart';

/// Account management section for settings screen
/// Provides options for downloading data, deleting data, and deleting account
class AccountManagementSection extends StatelessWidget {
  const AccountManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Card(
      margin: const EdgeInsets.all(16),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your personal data and account',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: subtitleColor,
                  ),
            ),
            const Divider(height: 24),
            _buildDownloadDataTile(context, isDark),
            const SizedBox(height: 8),
            _buildDeleteDataTile(context, isDark),
            const SizedBox(height: 8),
            _buildDeleteAccountTile(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadDataTile(BuildContext context, bool isDark) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.blue.withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.download, color: Colors.blue),
      ),
      title: const Text('Download My Data'),
      subtitle: const Text('Export all your personal information'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showDownloadDataDialog(context),
    );
  }

  Widget _buildDeleteDataTile(BuildContext context, bool isDark) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.orange.withOpacity(0.2)
              : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete_sweep, color: Colors.orange),
      ),
      title: const Text('Delete My Data'),
      subtitle: const Text('Remove all your logs and entries'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showDeleteDataDialog(context),
    );
  }

  Widget _buildDeleteAccountTile(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.red.shade400 : Colors.red.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isDark
            ? Colors.red.withOpacity(0.15)
            : Colors.red.withOpacity(0.05),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.red.withOpacity(0.3)
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.warning,
            color: isDark ? Colors.red.shade300 : Colors.red,
          ),
        ),
        title: Text(
          'Delete Account',
          style: TextStyle(
            color: isDark ? Colors.red.shade300 : Colors.red.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Permanently delete your account and all data',
          style: TextStyle(
            color: isDark ? Colors.red.shade200 : Colors.red,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? Colors.red.shade300 : Colors.red.shade700,
        ),
        onTap: () => _showDeleteAccountDialog(context),
      ),
    );
  }

  void _showDownloadDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Download My Data',
        description:
            'Enter your password to download all your personal information.',
        actionButtonText: 'Download',
        actionButtonColor: Colors.blue,
        onVerified: (password) async {
          Navigator.pop(context);
          await _executeDownload(context);
        },
      ),
    );
  }

  Future<void> _executeDownload(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final service = AccountDataService();
    final result = await service.downloadUserData();
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: result.success ? Colors.green : Colors.red,
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Delete My Data',
        description:
            'Enter your password to delete all your logs and entries. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: Colors.orange,
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
    final service = AccountDataService();
    final result = await service.deleteUserData();
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: result.success ? Colors.orange : Colors.red,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PasswordVerificationDialog(
        title: 'Delete Account',
        description:
            'Enter your password to permanently delete your account. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: Colors.red,
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
    final service = AccountDataService();
    final result = await service.deleteAccount();
    
    if (result.success) {
      navigator.pushNamedAndRemoveUntil('/login_page', (route) => false);
    }
    
    messenger.showSnackBar(
      SnackBar(
        content: Text(result.message ?? 'Operation completed'),
        backgroundColor: result.success ? Colors.red : Colors.red.shade900,
        duration: const Duration(seconds: 8),
      ),
    );
  }
}
