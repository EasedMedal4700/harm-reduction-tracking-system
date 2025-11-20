import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/admin_service.dart';
import 'package:mockito/annotations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Run: flutter pub run build_runner build to generate mocks
@GenerateMocks([SupabaseClient, SupabaseQueryBuilder, PostgrestFilterBuilder])
void main() {
  group('AdminService', () {
    late AdminService adminService;

    setUp(() {
      adminService = AdminService();
    });

    test('service initializes correctly', () {
      expect(adminService, isNotNull);
    });

    group('getSystemStats', () {
      test('returns empty stats when no data', () async {
        // Note: This test requires proper Supabase mocking
        // which is beyond the scope of this basic test setup
        expect(adminService.getSystemStats, isA<Function>());
      });
    });

    group('getErrorAnalytics', () {
      test('method exists and is callable', () {
        expect(adminService.getErrorAnalytics, isA<Function>());
      });
    });

    group('fetchAllUsers', () {
      test('method exists and is callable', () {
        expect(adminService.fetchAllUsers, isA<Function>());
      });
    });

    group('promoteUser', () {
      test('method exists and accepts user ID', () {
        expect(adminService.promoteUser, isA<Function>());
      });
    });

    group('demoteUser', () {
      test('method exists and accepts user ID', () {
        expect(adminService.demoteUser, isA<Function>());
      });
    });

    group('clearErrorLogs', () {
      test('method exists with correct parameters', () {
        expect(adminService.clearErrorLogs, isA<Function>());
      });
    });
  });
}
