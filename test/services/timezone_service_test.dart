import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/timezone_service.dart';

void main() {
  group('TimezoneService', () {
    late TimezoneService service;

    setUp(() {
      service = TimezoneService();
    });

    test('getTimezoneOffset returns valid number', () {
      final offset = service.getTimezoneOffset();
      expect(offset, isA<double>());
      expect(offset, greaterThanOrEqualTo(-12));
      expect(offset, lessThanOrEqualTo(14));
    });

    test('getTimezoneOffsetString returns formatted string', () {
      final offsetString = service.getTimezoneOffsetString();
      expect(offsetString, isA<String>());
      expect(offsetString, matches(r'^[+-]\d{2}:\d{2}$'));
    });

    test('getTimezoneOffsetString has correct format', () {
      final offsetString = service.getTimezoneOffsetString();
      
      // Should be +XX:XX or -XX:XX
      expect(offsetString.length, 6);
      expect(offsetString[0], matches(r'[+-]'));
      expect(offsetString[3], ':');
    });

    test('getTimezoneOffset converts minutes to hours correctly', () {
      final offset = service.getTimezoneOffset();
      
      // Verify it's a valid timezone offset (multiple of 0.25 usually)
      // Most timezones are whole hours or half hours (some are 45 minutes)
      final multipliedBy4 = (offset * 4).round();
      expect(multipliedBy4 / 4, offset);
    });

    test('positive offset has + sign', () {
      final now = DateTime.now();
      if (now.timeZoneOffset.inMinutes > 0) {
        final offsetString = service.getTimezoneOffsetString();
        expect(offsetString[0], '+');
      }
    });

    test('negative offset has - sign', () {
      final now = DateTime.now();
      if (now.timeZoneOffset.inMinutes < 0) {
        final offsetString = service.getTimezoneOffsetString();
        expect(offsetString[0], '-');
      }
    });

    test('offset calculation matches DateTime.now()', () {
      final systemOffset = DateTime.now().timeZoneOffset.inMinutes / 60.0;
      final serviceOffset = service.getTimezoneOffset();
      expect(serviceOffset, systemOffset);
    });

    test('offset string parsing', () {
      final offsetString = service.getTimezoneOffsetString();
      final parts = offsetString.substring(1).split(':');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      
      expect(hours, greaterThanOrEqualTo(0));
      expect(hours, lessThanOrEqualTo(14));
      expect(minutes, greaterThanOrEqualTo(0));
      expect(minutes, lessThanOrEqualTo(59));
    });
  });
}
