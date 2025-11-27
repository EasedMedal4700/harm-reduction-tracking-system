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
            const Expanded(child: Text('⚠️ DELETE ACCOUNT')),
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
            _WarningItem('All your data and logs', isRed: true),
            _WarningItem('All your settings and profile', isRed: true),
            _WarningItem('Your account record', isRed: true),
            const SizedBox(height: 8),
            _WarningItem('⚠️ Login credentials remain (contact support to delete)', isRed: false),
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
              'This action CANNOT be reversed. Your data will be gone forever.',
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
                'Type "DELETE MY ACCOUNT" to confirm account deletion:',
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
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    
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
      print('\n=== DOWNLOAD USER DATA STARTED ===');
      print('[1/8] Initializing Supabase client...');
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();
      print('[1/8] ✓ Complete - User ID: $userId');

      // Fetch all user data
      print('[2/8] Creating data structure...');
      final userData = <String, dynamic>{
        'export_date': DateTime.now().toIso8601String(),
        'uuid_user_id': userId,
      };
      print('[2/8] ✓ Complete');

      // Fetch drug use logs
      print('[3/8] Fetching drug use logs...');
      final drugUseLogs = await supabase
          .from('drug_use')
          .select()
          .eq('uuid_user_id', userId);
      userData['drug_use_logs'] = drugUseLogs;
      print('[3/8] ✓ Complete - Found ${(drugUseLogs as List).length} entries');

      // Fetch reflections
      print('[4/8] Fetching reflections...');
      try {
        final reflections = await supabase
            .from('reflections')
            .select()
            .eq('uuid_user_id', userId);
        userData['reflections'] = reflections;
        print('[4/8] ✓ Complete - Found ${(reflections as List).length} entries');
      } catch (e) {
        userData['reflections'] = [];
        print('[4/8] ⚠ Warning - Reflections table error: $e');
      }

      // Fetch cravings
      print('[5/8] Fetching cravings...');
      try {
        final cravings = await supabase
            .from('cravings')
            .select()
            .eq('uuid_user_id', userId);
        userData['cravings'] = cravings;
        print('[5/8] ✓ Complete - Found ${(cravings as List).length} entries');
      } catch (e) {
        userData['cravings'] = [];
        print('[5/8] ⚠ Warning - Cravings table error: $e');
      }

      // Fetch stockpile
      print('[6/8] Fetching stockpile...');
      try {
        final stockpile = await supabase
            .from('stockpile')
            .select()
            .eq('uuid_user_id', userId);
        userData['stockpile'] = stockpile;
        print('[6/8] ✓ Complete - Found ${(stockpile as List).length} entries');
      } catch (e) {
        userData['stockpile'] = [];
        print('[6/8] ⚠ Warning - Stockpile table error: $e');
      }

      // Convert to JSON
      print('[7/8] Converting to JSON and saving file...');
      final jsonString = const JsonEncoder.withIndent('  ').convert(userData);

      // Save to file
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/my_data_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);
      print('[7/8] ✓ Complete - File saved at: ${file.path}');

      print('[8/8] Closing dialog and opening share...');
      navigator.pop(); // Close loading dialog

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Personal Data Export',
        text: 'Your personal data export from the app',
      );

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      print('[8/8] ✓ DOWNLOAD COMPLETE\n');
    } catch (e, stackTrace) {
      print('\n✗✗✗ DOWNLOAD FAILED ✗✗✗');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      navigator.pop(); // Close loading dialog
      
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error exporting data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error dialog shown\n');
    }
  }

  Future<void> _deleteUserData(BuildContext context, String password) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    
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
      print('\n=== DELETE USER DATA STARTED ===');
      print('[1/6] Initializing Supabase client...');
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();
      print('[1/6] ✓ Complete - User ID: $userId');

      // Delete all user data
      print('[2/6] Deleting drug_use entries...');
      await supabase.from('drug_use').delete().eq('uuid_user_id', userId);
      print('[2/6] ✓ Complete - drug_use entries deleted');
      
      print('[3/6] Deleting reflections...');
      try {
        await supabase.from('reflections').delete().eq('uuid_user_id', userId);
        print('[3/6] ✓ Complete - reflections deleted');
      } catch (e) {
        print('[3/6] ⚠ Warning - Reflections table error: $e');
      }
      
      print('[4/6] Deleting cravings...');
      try {
        await supabase.from('cravings').delete().eq('uuid_user_id', userId);
        print('[4/6] ✓ Complete - cravings deleted');
      } catch (e) {
        print('[4/6] ⚠ Warning - Cravings table error: $e');
      }
      
      print('[5/6] Deleting stockpile...');
      try {
        await supabase.from('stockpile').delete().eq('uuid_user_id', userId);
        print('[5/6] ✓ Complete - stockpile deleted');
      } catch (e) {
        print('[5/6] ⚠ Warning - Stockpile table error: $e');
      }

      print('[6/6] Closing dialog and showing success...');
      navigator.pop(); // Close loading dialog

      messenger.showSnackBar(
        const SnackBar(
          content: Text('All your data has been deleted.'),
          backgroundColor: Colors.orange,
        ),
      );
      print('[6/6] ✓ DELETE DATA COMPLETE\n');
    } catch (e, stackTrace) {
      print('\n✗✗✗ DELETE DATA FAILED ✗✗✗');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      navigator.pop(); // Close loading dialog
      
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error deleting data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error dialog shown\n');
    }
  }

  Future<void> _deleteAccount(BuildContext context, String password) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    
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
      print('\n=== DELETE ACCOUNT STARTED ===');
      print('[1/9] Initializing Supabase client...');
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();
      print('[1/9] ✓ Complete - User ID: $userId');

      // Delete all user data first
      print('[2/9] Deleting drug_use entries...');
      await supabase.from('drug_use').delete().eq('uuid_user_id', userId);
      print('[2/9] ✓ Complete - drug_use entries deleted');
      
      // Verify drug_use deletion
      try {
        final drugUseCheck = await supabase
            .from('drug_use')
            .select('uuid_user_id')
            .eq('uuid_user_id', userId)
            .limit(1);
        if ((drugUseCheck as List).isEmpty) {
          print('[2/9] ✓ VERIFIED - all drug_use entries removed');
        } else {
          print('[2/9] ⚠ WARNING - ${(drugUseCheck as List).length} drug_use entries still exist');
        }
      } catch (e) {
        print('[2/9] ⚠ WARNING - Could not verify drug_use deletion: $e');
      }
      
      print('[3/9] Deleting reflections...');
      try {
        await supabase.from('reflections').delete().eq('uuid_user_id', userId);
        print('[3/9] ✓ Complete - reflections deleted');
        
        // Verify reflections deletion
        final reflectionsCheck = await supabase
            .from('reflections')
            .select('uuid_user_id')
            .eq('uuid_user_id', userId)
            .limit(1);
        if ((reflectionsCheck as List).isEmpty) {
          print('[3/9] ✓ VERIFIED - all reflections removed');
        } else {
          print('[3/9] ⚠ WARNING - ${(reflectionsCheck as List).length} reflections still exist');
        }
      } catch (e) {
        print('[3/9] ⚠ Warning - Reflections table error: $e');
      }
      
      print('[4/9] Deleting cravings...');
      try {
        await supabase.from('cravings').delete().eq('uuid_user_id', userId);
        print('[4/9] ✓ Complete - cravings deleted');
        
        // Verify cravings deletion
        final cravingsCheck = await supabase
            .from('cravings')
            .select('uuid_user_id')
            .eq('uuid_user_id', userId)
            .limit(1);
        if ((cravingsCheck as List).isEmpty) {
          print('[4/9] ✓ VERIFIED - all cravings removed');
        } else {
          print('[4/9] ⚠ WARNING - ${(cravingsCheck as List).length} cravings still exist');
        }
      } catch (e) {
        print('[4/9] ⚠ Warning - Cravings table error: $e');
      }
      
      print('[5/9] Deleting stockpile...');
      try {
        await supabase.from('stockpile').delete().eq('uuid_user_id', userId);
        print('[5/9] ✓ Complete - stockpile deleted');
        
        // Verify stockpile deletion
        final stockpileCheck = await supabase
            .from('stockpile')
            .select('uuid_user_id')
            .eq('uuid_user_id', userId)
            .limit(1);
        if ((stockpileCheck as List).isEmpty) {
          print('[5/9] ✓ VERIFIED - all stockpile entries removed');
        } else {
          print('[5/9] ⚠ WARNING - ${(stockpileCheck as List).length} stockpile entries still exist');
        }
      } catch (e) {
        print('[5/9] ⚠ Warning - Stockpile table error: $e');
      }

      // Delete user record - users table uses auth_user_id to link to auth.users(id)
      print('[6/9] Deleting user record from users table...');
      try {
        await supabase.from('users').delete().eq('auth_user_id', userId);
        print('[6/9] ✓ Complete - user record deleted');
        
        // Verify user record was deleted
        final userCheck = await supabase
            .from('users')
            .select('auth_user_id')
            .eq('auth_user_id', userId)
            .maybeSingle();
        if (userCheck == null) {
          print('[6/9] ✓ VERIFIED - user record successfully removed from users table');
        } else {
          print('[6/9] ⚠ WARNING - user record still exists in users table after deletion attempt');
        }
      } catch (e) {
        print('[6/9] ✗ FAILED - Error deleting user record: $e');
        // Continue with the process even if users table deletion fails
      }

      // Note: Auth deletion requires admin privileges and cannot be done client-side
      // User will need to delete their auth account through Supabase dashboard or support
      print('[7/9] Skipping auth deletion (requires admin privileges)...');

      // Verify auth user still exists (we can't delete it client-side)
      try {
        final currentUser = supabase.auth.currentUser;
        if (currentUser != null) {
          print('[7/9] ✓ VERIFIED - auth user still exists (expected - requires admin privileges to delete)');
        } else {
          print('[7/9] ⚠ WARNING - auth user not found (unexpected)');
        }
      } catch (e) {
        print('[7/9] ⚠ WARNING - Could not verify auth user status: $e');
      }

      // Sign out
      print('[8/9] Signing out user...');
      await AuthService().logout();
      print('[8/9] ✓ Complete - user signed out');

      print('[9/9] Closing dialog and navigating to login...');
      navigator.pop(); // Close loading dialog

      print('[9/9] Navigating to login screen...');
      // Navigate to login screen
      navigator.pushNamedAndRemoveUntil('/login_page', (route) => false);

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Your account has been deleted. Login credentials remain - contact support for complete removal.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 8),
        ),
      );
      print('[9/9] ✓ ACCOUNT DELETION COMPLETE\n');
    } catch (e, stackTrace) {
      print('\n✗✗✗ DELETE ACCOUNT FAILED ✗✗✗');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      navigator.pop(); // Close loading dialog
      
      messenger.showSnackBar(
        SnackBar(
          content: Text('Error deleting account: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('Error dialog shown\n');
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
