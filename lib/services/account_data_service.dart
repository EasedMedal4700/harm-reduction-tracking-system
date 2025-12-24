import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'encryption_service_v2.dart';
import 'user_service.dart';
import '../common/logging/app_log.dart';

/// Result of account data operations
class AccountDataResult {
  final bool success;
  final String? message;
  final String? filePath;
  const AccountDataResult({required this.success, this.message, this.filePath});
}

/// Service for managing account data operations (download, delete)
class AccountDataService {
  AccountDataService({SupabaseClient? supabase, AuthService? authService})
    : _supabase = supabase ?? Supabase.instance.client,
      _authService =
          authService ??
          AuthService(
            client: supabase ?? Supabase.instance.client,
            encryption: EncryptionServiceV2(),
          );
  final SupabaseClient _supabase;
  final AuthService _authService;

  /// Download all user data to a JSON file and share it
  Future<AccountDataResult> downloadUserData() async {
    try {
      AppLog.i('\n=== DOWNLOAD USER DATA STARTED ===');
      final userId = UserService.getCurrentUserId();
      AppLog.i('[1/7] User ID: $userId');
      // Create data structure
      final userData = <String, dynamic>{
        'export_date': DateTime.now().toIso8601String(),
        'uuid_user_id': userId,
      };
      // Fetch drug use logs
      AppLog.i('[2/7] Fetching drug use logs...');
      final drugUseLogs = await _supabase
          .from('drug_use')
          .select()
          .eq('uuid_user_id', userId);
      userData['drug_use_logs'] = drugUseLogs;
      AppLog.i('[2/7] ✓ Found ${(drugUseLogs as List).length} entries');
      // Fetch reflections
      AppLog.i('[3/7] Fetching reflections...');
      try {
        final reflections = await _supabase
            .from('reflections')
            .select()
            .eq('uuid_user_id', userId);
        userData['reflections'] = reflections;
        AppLog.i('[3/7] ✓ Found ${(reflections as List).length} entries');
      } catch (e) {
        userData['reflections'] = [];
        AppLog.w('[3/7] ⚠ Warning: $e');
      }
      // Fetch cravings
      AppLog.i('[4/7] Fetching cravings...');
      try {
        final cravings = await _supabase
            .from('cravings')
            .select()
            .eq('uuid_user_id', userId);
        userData['cravings'] = cravings;
        AppLog.i('[4/7] ✓ Found ${(cravings as List).length} entries');
      } catch (e) {
        userData['cravings'] = [];
        AppLog.w('[4/7] ⚠ Warning: $e');
      }
      // Fetch stockpile
      AppLog.i('[5/7] Fetching stockpile...');
      try {
        final stockpile = await _supabase
            .from('stockpile')
            .select()
            .eq('uuid_user_id', userId);
        userData['stockpile'] = stockpile;
        AppLog.i('[5/7] ✓ Found ${(stockpile as List).length} entries');
      } catch (e) {
        userData['stockpile'] = [];
        AppLog.w('[5/7] ⚠ Warning: $e');
      }
      // Convert to JSON and save
      AppLog.i('[6/7] Saving file...');
      final jsonString = const JsonEncoder.withIndent('  ').convert(userData);
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/my_data_export_${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonString);
      AppLog.i('[6/7] ✓ File saved: ${file.path}');
      // Share the file
      AppLog.i('[7/7] Sharing file...');
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My Personal Data Export',
        text: 'Your personal data export from the app',
      );
      AppLog.i('[7/7] ✓ DOWNLOAD COMPLETE\n');
      return AccountDataResult(
        success: true,
        message: 'Data exported successfully!',
        filePath: file.path,
      );
    } catch (e) {
      AppLog.e('✗ DOWNLOAD FAILED: $e\n');
      return AccountDataResult(
        success: false,
        message: 'Error exporting data: $e',
      );
    }
  }

  /// Delete all user data (keeps account)
  Future<AccountDataResult> deleteUserData() async {
    try {
      AppLog.i('\n=== DELETE USER DATA STARTED ===');
      final userId = UserService.getCurrentUserId();
      AppLog.i('[1/5] User ID: $userId');
      // Delete drug_use
      AppLog.i('[2/5] Deleting drug_use...');
      await _supabase.from('drug_use').delete().eq('uuid_user_id', userId);
      AppLog.i('[2/5] ✓ Complete');
      // Delete reflections
      AppLog.i('[3/5] Deleting reflections...');
      try {
        await _supabase.from('reflections').delete().eq('uuid_user_id', userId);
        AppLog.i('[3/5] ✓ Complete');
      } catch (e) {
        AppLog.w('[3/5] ⚠ Warning: $e');
      }
      // Delete cravings
      AppLog.i('[4/5] Deleting cravings...');
      try {
        await _supabase.from('cravings').delete().eq('uuid_user_id', userId);
        AppLog.i('[4/5] ✓ Complete');
      } catch (e) {
        AppLog.w('[4/5] ⚠ Warning: $e');
      }
      // Delete stockpile
      AppLog.i('[5/5] Deleting stockpile...');
      try {
        await _supabase.from('stockpile').delete().eq('uuid_user_id', userId);
        AppLog.i('[5/5] ✓ Complete');
      } catch (e) {
        AppLog.w('[5/5] ⚠ Warning: $e');
      }
      AppLog.i('✓ DELETE DATA COMPLETE\n');
      return const AccountDataResult(
        success: true,
        message: 'All your data has been deleted.',
      );
    } catch (e) {
      AppLog.e('✗ DELETE DATA FAILED: $e\n');
      return AccountDataResult(
        success: false,
        message: 'Error deleting data: $e',
      );
    }
  }

  /// Delete user account and all data
  Future<AccountDataResult> deleteAccount() async {
    try {
      AppLog.i('\n=== DELETE ACCOUNT STARTED ===');
      final userId = UserService.getCurrentUserId();
      AppLog.i('[1/7] User ID: $userId');
      // Delete all data first
      AppLog.i('[2/7] Deleting all user data...');
      await deleteUserData();
      // Delete user record
      AppLog.i('[6/7] Deleting user record...');
      try {
        await _supabase.from('users').delete().eq('auth_user_id', userId);
        AppLog.i('[6/7] ✓ Complete');
      } catch (e) {
        AppLog.e('[6/7] ✗ Failed: $e');
      }
      // Sign out
      AppLog.i('[7/7] Signing out...');
      await _authService.logout();
      AppLog.i('[7/7] ✓ ACCOUNT DELETION COMPLETE\n');
      return const AccountDataResult(
        success: true,
        message:
            'Your account has been deleted. Login credentials remain - '
            'contact support for complete removal.',
      );
    } catch (e) {
      AppLog.e('✗ DELETE ACCOUNT FAILED: $e\n');
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
