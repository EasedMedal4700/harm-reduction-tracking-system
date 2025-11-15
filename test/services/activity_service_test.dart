import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/activity_service.dart';

void main() {
  group('ActivityService', () {
    late ActivityService service;

    setUp(() {
      service = ActivityService();
    });

    test('ActivityService can be instantiated', () {
      expect(service, isNotNull);
      expect(service, isA<ActivityService>());
    });

    test('fetchRecentActivity method exists and has correct signature', () {
      expect(
        service.fetchRecentActivity,
        isA<Function>(),
      );
    });
  });
}
