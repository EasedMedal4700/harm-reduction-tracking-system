import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'user_service.dart';

/// Result of account data operations
class AccountDataResult {
  final bool success;
  final String? message;
  final String? filePath;

  const AccountDataResult({
    required this.success,
    this.message,
    this.filePath,
  });
}

/// Service for managing account data operations (download, delete)
class AccountDataService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Download all user data to a JSON file and share it
  Future<AccountDataResult> downloadUserData() async {
    try {
      print('\n=== DOWNLOAD USER DATA STARTED ===');
      final userId = UserService.getCurrentUserId();
      print('[1/7] User ID: $userId');

      // Create data structure
      final userData = <String, dynamic>{
        'export_date': DateTime.now().toIso8601String(),
        'uuid_user_id': userId,
      };

      // Fetch drug use logs
      print('[2/7] Fetching drug use logs...');
      final drugUseLogs = await _supabase
          .from('drug_use')
          .select()
          .eq('uuid_user_id', userId);
      userData['drug_use_logs'] = drugUseLogs;
      print('[2/7] ✓ Found ${(drugUseLogs as List).length} entries');

      // Fetch reflections
      print('[3/7] Fetching reflections...');
      try {
        final reflections = await _supabase
            .from('reflections')
            .select()
            .eq('uuid_user_id', userId);
        userData['reflections'] = reflections;
        print('[3/7] ✓ Found ${(reflections as List).length} entries');
      } catch (e) {
        userData['reflections'] = [];
        print('[3/7] ⚠ Warning: $e');
      }

      // Fetch cravings
      print('[4/7] Fetching cravings...');
      try {
        final cravings = await _supabase
            .from('cravings')
            .select()
            .eq('uuid_user_id', userId);
        userData['cravings'] = cravings;
        print('[4/7] ✓ Found ${(cravings as List).length} entries');
      } catch (e) {
        userData['cravings'] = [];
        print('[4/7] ⚠ Warning: $e');
      }

      // Fetch stockpile
      print('[5/7] Fetching stockpile...');
      try {
        final stockpile = await _supabase
            .from('stockpile')
            .select()
            .eq('uuid_user_id', userId);
        userData['stockpile'] = stockpile;
        print('[5/7] ✓ Found ${(stockpile as List).length} entries');
      } catch (e) {
        userData['stockpile'] = [];
        print('[5/7] ⚠ Warning: $e');
      }

      // Convert to JSON and save
      print('[6/7] Saving file...');
      final jsonString = const JsonEncoder.withIndent('  ').convert(userData);
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/my_data_export_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonString);
      print('[6/7] ✓ File saved: ${file.path}');

      // Share the file
      print('[7/7] Sharing file...');
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Personal Data Export',
        text: 'Your personal data export from the app',
      );
      print('[7/7] ✓ DOWNLOAD COMPLETE\n');

      return AccountDataResult(
        success: true,
        message: 'Data exported successfully!',
        filePath: file.path,
      );
    } catch (e) {
      print('✗ DOWNLOAD FAILED: $e\n');
      return AccountDataResult(
        success: false,
        message: 'Error exporting data: $e',
      );
    }
  }

  /// Delete all user data (keeps account)
  Future<AccountDataResult> deleteUserData() async {
    try {
      print('\n=== DELETE USER DATA STARTED ===');
      final userId = UserService.getCurrentUserId();
      print('[1/5] User ID: $userId');

      // Delete drug_use
      print('[2/5] Deleting drug_use...');
      await _supabase.from('drug_use').delete().eq('uuid_user_id', userId);
      print('[2/5] ✓ Complete');

      // Delete reflections
      print('[3/5] Deleting reflections...');
      try {
        await _supabase.from('reflections').delete().eq('uuid_user_id', userId);
        print('[3/5] ✓ Complete');
      } catch (e) {
        print('[3/5] ⚠ Warning: $e');
      }

      // Delete cravings
      print('[4/5] Deleting cravings...');
      try {
        await _supabase.from('cravings').delete().eq('uuid_user_id', userId);
        print('[4/5] ✓ Complete');
      } catch (e) {
        print('[4/5] ⚠ Warning: $e');
      }

      // Delete stockpile
      print('[5/5] Deleting stockpile...');
      try {
        await _supabase.from('stockpile').delete().eq('uuid_user_id', userId);
        print('[5/5] ✓ Complete');
      } catch (e) {
        print('[5/5] ⚠ Warning: $e');
      }

      print('✓ DELETE DATA COMPLETE\n');
      return const AccountDataResult(
        success: true,
        message: 'All your data has been deleted.',
      );
    } catch (e) {
      print('✗ DELETE DATA FAILED: $e\n');
      return AccountDataResult(
        success: false,
        message: 'Error deleting data: $e',
      );
    }
  }

  /// Delete user account and all data
  Future<AccountDataResult> deleteAccount() async {
    try {
      print('\n=== DELETE ACCOUNT STARTED ===');
      final userId = UserService.getCurrentUserId();
      print('[1/7] User ID: $userId');

      // Delete all data first
      print('[2/7] Deleting all user data...');
      await deleteUserData();

      // Delete user record
      print('[6/7] Deleting user record...');
      try {
        await _supabase.from('users').delete().eq('auth_user_id', userId);
        print('[6/7] ✓ Complete');
      } catch (e) {
        print('[6/7] ✗ Failed: $e');
      }

      // Sign out
      print('[7/7] Signing out...');
      await AuthService().logout();
      print('[7/7] ✓ ACCOUNT DELETION COMPLETE\n');

      return const AccountDataResult(
        success: true,
        message: 'Your account has been deleted. Login credentials remain - '
            'contact support for complete removal.',
      );
    } catch (e) {
      print('✗ DELETE ACCOUNT FAILED: $e\n');
      return AccountDataResult(
        success: false,
        message: 'Error deleting account: $e',
      );
    }
  }

  /// Verify user password
  Future<bool> verifyPassword(String password) async {
    try {
      final email = _supabase.auth.currentUser?.email;
      if (email == null) return false;

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      return false;
    }
  }
}
