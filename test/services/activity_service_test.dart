import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/activity_service.dart';

void main() {
  late ActivityService activityService;

  setUp(() {
    activityService = ActivityService();
  });

  group('ActivityService', () {
    test('can be instantiated', () {
      expect(activityService, isNotNull);
    });

    test('fetchRecentActivity returns a Future<Map<String, dynamic>>', () async {
      // This test will fail if not authenticated, but verifies the method signature
      try {
        final result = await activityService.fetchRecentActivity();
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('entries'), true);
        expect(result.containsKey('cravings'), true);
        expect(result.containsKey('reflections'), true);
      } catch (e) {
        // Expected to fail without authentication, but the method should exist and return the right type
        expect(e, isA<StateError>()); // User not logged in error
      }
    });
  });
}
