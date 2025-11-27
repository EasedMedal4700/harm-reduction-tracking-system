import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class AccountManagementSection extends StatelessWidget {
  const AccountManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
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
                    color: Colors.grey[600],
                  ),
            ),
            const Divider(height: 24),
            
            // Download Data Button
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.download, color: Colors.blue),
              ),
              title: const Text('Download My Data'),
              subtitle: const Text('Export all your personal information'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showDownloadDataDialog(context),
            ),
            
            const SizedBox(height: 8),
            
            // Delete Data Button
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_sweep, color: Colors.orange),
              ),
              title: const Text('Delete My Data'),
              subtitle: const Text('Remove all your logs and entries'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showDeleteDataDialog(context),
            ),
            
            const SizedBox(height: 8),
            
            // Delete Account Button - Scary Red
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red.shade300, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.withOpacity(0.05),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.warning, color: Colors.red),
                ),
                title: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Permanently delete your account and all data',
                  style: TextStyle(color: Colors.red),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red.shade700),
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDownloadDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _PasswordVerificationDialog(
        title: 'Download My Data',
        description: 'Enter your password to download all your personal information.',
        actionButtonText: 'Download',
        actionButtonColor: Colors.blue,
        onVerified: (password) async {
          Navigator.pop(context);
          await _downloadUserData(context, password);
        },
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _PasswordVerificationDialog(
        title: 'Delete My Data',
        description: 'Enter your password to delete all your logs and entries. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: Colors.orange,
        requireConfirmation: true,
        onVerified: (password) async {
          Navigator.pop(context);
          _showDeleteDataConfirmation(context, password);
        },
      ),
    );
  }

  void _showDeleteDataConfirmation(BuildContext context, String password) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange.shade700, size: 32),
            const SizedBox(width: 12),
            const Expanded(child: Text('Are You Sure?')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This will permanently delete:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _WarningItem('All your drug use logs'),
            _WarningItem('All your reflections'),
            _WarningItem('All your cravings data'),
            _WarningItem('All your tolerance data'),
            _WarningItem('All your stockpile entries'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Consider downloading your data first!',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your account will remain active, but all your data will be gone forever.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteDataConfirmation(context, password);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: const Text('Download Data First'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteUserData(context, password);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Delete My Data'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteDataConfirmation(BuildContext context, String password) {
    bool userConfirmed = false;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Final Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Type "DELETE MY DATA" to confirm:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'DELETE MY DATA',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    userConfirmed = value.trim() == 'DELETE MY DATA';
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: userConfirmed
                  ? () async {
                      Navigator.pop(context);
                      await _deleteUserData(context, password);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete Data'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _PasswordVerificationDialog(
        title: 'Delete Account',
        description: 'Enter your password to permanently delete your account. This action cannot be undone.',
        actionButtonText: 'Continue',
        actionButtonColor: Colors.red,
        requireConfirmation: true,
        onVerified: (password) async {
          Navigator.pop(context);
          _showDeleteAccountConfirmation(context, password);
        },
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context, String password) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.shade50,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 32),
            const SizedBox(width: 12),
            const Expanded(child: Text('⚠️ PERMANENT DELETION')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will PERMANENTLY delete:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 12),
            _WarningItem('Your entire account', isRed: true),
            _WarningItem('All your data and logs', isRed: true),
            _WarningItem('All your settings', isRed: true),
            _WarningItem('Your login credentials', isRed: true),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade700, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.download, color: Colors.amber.shade900),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Download your data first so you can always come back!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action CANNOT be reversed. Your account will be gone forever.',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDownloadDataDialog(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            child: const Text('Download Data First'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteAccountConfirmation(context, password);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('I Understand, Continue'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteAccountConfirmation(BuildContext context, String password) {
    bool userConfirmed = false;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.red.shade50,
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red.shade900, size: 32),
              const SizedBox(width: 8),
              const Expanded(child: Text('FINAL CONFIRMATION')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Type "DELETE MY ACCOUNT" to confirm permanent deletion:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'DELETE MY ACCOUNT',
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                  ),
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
                onChanged: (value) {
                  setState(() {
                    userConfirmed = value.trim() == 'DELETE MY ACCOUNT';
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                '⚠️ This is your last chance to cancel!',
                style: TextStyle(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: userConfirmed
                  ? () async {
                      Navigator.pop(context);
                      await _deleteAccount(context, password);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: const Text('DELETE MY ACCOUNT FOREVER'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadUserData(BuildContext context, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Collecting your data...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final supabase = Supabase.instance.client;
      final userId = await UserService.getIntegerUserId();

      // Fetch all user data
      final userData = <String, dynamic>{
        'export_date': DateTime.now().toIso8601String(),
        'user_id': userId,
      };

      // Fetch drug use logs
      final drugUseLogs = await supabase
          .from('drug_use')
          .select()
          .eq('user_id', userId);
      userData['drug_use_logs'] = drugUseLogs;

      // Fetch reflections
      try {
        final reflections = await supabase
            .from('reflections')
            .select()
            .eq('user_id', userId);
        userData['reflections'] = reflections;
      } catch (e) {
        userData['reflections'] = [];
      }

      // Fetch cravings
      try {
        final cravings = await supabase
            .from('cravings')
            .select()
            .eq('user_id', userId);
        userData['cravings'] = cravings;
      } catch (e) {
        userData['cravings'] = [];
      }

      // Fetch stockpile
      try {
        final stockpile = await supabase
            .from('stockpile')
            .select()
            .eq('user_id', userId);
        userData['stockpile'] = stockpile;
      } catch (e) {
        userData['stockpile'] = [];
      }

      // Convert to JSON
      final jsonString = const JsonEncoder.withIndent('  ').convert(userData);

      // Save to file
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/my_data_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      Navigator.pop(context); // Close loading dialog

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Personal Data Export',
        text: 'Your personal data export from the app',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteUserData(BuildContext context, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting your data...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final supabase = Supabase.instance.client;
      final userId = await UserService.getIntegerUserId();

      // Delete all user data
      await supabase.from('drug_use').delete().eq('user_id', userId);
      
      try {
        await supabase.from('reflections').delete().eq('user_id', userId);
      } catch (e) {
        // Table might not exist
      }
      
      try {
        await supabase.from('cravings').delete().eq('user_id', userId);
      } catch (e) {
        // Table might not exist
      }
      
      try {
        await supabase.from('stockpile').delete().eq('user_id', userId);
      } catch (e) {
        // Table might not exist
      }

      Navigator.pop(context); // Close loading dialog

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All your data has been deleted.'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting your account...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final supabase = Supabase.instance.client;
      final userId = await UserService.getIntegerUserId();

      // Delete all user data first
      await supabase.from('drug_use').delete().eq('user_id', userId);
      
      try {
        await supabase.from('reflections').delete().eq('user_id', userId);
      } catch (e) {}
      
      try {
        await supabase.from('cravings').delete().eq('user_id', userId);
      } catch (e) {}
      
      try {
        await supabase.from('stockpile').delete().eq('user_id', userId);
      } catch (e) {}

      // Delete user record
      await supabase.from('users').delete().eq('user_id', userId);

      // Sign out
      await AuthService().logout();

      Navigator.pop(context); // Close loading dialog

      // Navigate to login screen
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your account has been permanently deleted.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _WarningItem extends StatelessWidget {
  final String text;
  final bool isRed;

  const _WarningItem(this.text, {this.isRed = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.close,
            color: isRed ? Colors.red.shade700 : Colors.orange.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isRed ? Colors.red.shade900 : Colors.orange.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordVerificationDialog extends StatefulWidget {
  final String title;
  final String description;
  final String actionButtonText;
  final Color actionButtonColor;
  final bool requireConfirmation;
  final Function(String password) onVerified;

  const _PasswordVerificationDialog({
    required this.title,
    required this.description,
    required this.actionButtonText,
    required this.actionButtonColor,
    this.requireConfirmation = false,
    required this.onVerified,
  });

  @override
  State<_PasswordVerificationDialog> createState() => _PasswordVerificationDialogState();
}

class _PasswordVerificationDialogState extends State<_PasswordVerificationDialog> {
  final _passwordController = TextEditingController();
  bool _isVerifying = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final password = _passwordController.text.trim();
    
    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your password';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;
      final email = supabase.auth.currentUser?.email;

      if (email == null) {
        throw Exception('User not authenticated');
      }

      // Verify password by attempting to sign in
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        widget.onVerified(password);
      } else {
        setState(() {
          _errorMessage = 'Invalid password';
          _isVerifying = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid password. Please try again.';
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.description),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              errorText: _errorMessage,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            enabled: !_isVerifying,
            onSubmitted: (_) => _verify(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isVerifying ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isVerifying ? null : _verify,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.actionButtonColor,
            foregroundColor: Colors.white,
          ),
          child: _isVerifying
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(widget.actionButtonText),
        ),
      ],
    );
  }
}
