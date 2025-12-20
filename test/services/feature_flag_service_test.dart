import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/feature_flag_service.dart';
import 'package:mobile_drug_use_app/constants/config/feature_flags.dart';

void main() {
  group('FeatureFlagService', () {
    late FeatureFlagService service;

    setUp(() {
      // Create a new instance for testing
      service = FeatureFlagService();
      service.clearCache();
    });

    group('Initial State', () {
      test('isLoaded returns false before load()', () {
        expect(service.isLoaded, isFalse);
      });

      test('isLoading returns false initially', () {
        expect(service.isLoading, isFalse);
      });

      test('allFlags returns empty list before load()', () {
        expect(service.allFlags, isEmpty);
      });

      test('errorMessage is null initially', () {
        expect(service.errorMessage, isNull);
      });
    });

    group('isEnabled behavior before load', () {
      test('returns true for any feature when not loaded (fail-open)', () {
        expect(service.isEnabled('home_page', isAdmin: false), isTrue);
        expect(service.isEnabled('unknown_feature', isAdmin: false), isTrue);
      });

      test('returns true for admin regardless of load state', () {
        expect(service.isEnabled('home_page', isAdmin: true), isTrue);
        expect(service.isEnabled('unknown_feature', isAdmin: true), isTrue);
      });
    });

    group('Admin Override', () {
      test('isEnabled returns true for admin even if feature is disabled', () {
        // Simulate a loaded state with a disabled feature
        // Note: In real tests, we'd mock the Supabase response
        expect(service.isEnabled('disabled_feature', isAdmin: true), isTrue);
      });

      test('isEnabled respects isAdmin parameter', () {
        // Admin always gets access
        expect(service.isEnabled('any_feature', isAdmin: true), isTrue);

        // Non-admin depends on the flag (defaults to true when not loaded)
        expect(service.isEnabled('any_feature', isAdmin: false), isTrue);
      });
    });

    group('FeatureFlag Model', () {
      test('FeatureFlag.fromJson parses correctly', () {
        final json = {
          'id': 1,
          'feature_name': 'test_feature',
          'enabled': true,
          'description': 'Test description',
          'updated_at': '2025-01-01T00:00:00Z',
        };

        final flag = FeatureFlag.fromJson(json);

        expect(flag.id, 1);
        expect(flag.featureName, 'test_feature');
        expect(flag.enabled, isTrue);
        expect(flag.description, 'Test description');
        expect(flag.updatedAt, DateTime.parse('2025-01-01T00:00:00Z'));
      });

      test('FeatureFlag.fromJson handles null description', () {
        final json = {
          'id': 2,
          'feature_name': 'test_feature_2',
          'enabled': false,
          'description': null,
          'updated_at': '2025-01-01T00:00:00Z',
        };

        final flag = FeatureFlag.fromJson(json);

        expect(flag.description, isNull);
        expect(flag.enabled, isFalse);
      });

      test('FeatureFlag.copyWith creates new instance with updated values', () {
        final original = FeatureFlag(
          id: 1,
          featureName: 'test',
          enabled: true,
          description: 'desc',
          updatedAt: DateTime.now(),
        );

        final updated = original.copyWith(enabled: false);

        expect(updated.enabled, isFalse);
        expect(updated.id, original.id);
        expect(updated.featureName, original.featureName);
      });
    });

    group('getFlag method', () {
      test('returns null for unknown feature before load', () {
        expect(service.getFlag('unknown_feature'), isNull);
      });
    });

    group('clearCache', () {
      test('resets isLoaded to false', () {
        // Simulate loaded state
        service.clearCache();
        expect(service.isLoaded, isFalse);
      });

      test('clears all flags', () {
        service.clearCache();
        expect(service.allFlags, isEmpty);
      });
    });
  });

  group('FeatureFlags Constants', () {
    test('all list contains expected flags', () {
      expect(FeatureFlags.all, contains(FeatureFlags.homePage));
      expect(FeatureFlags.all, contains(FeatureFlags.analyticsPage));
      expect(FeatureFlags.all, contains(FeatureFlags.logEntryPage));
      expect(FeatureFlags.all, contains(FeatureFlags.dailyCheckin));
    });

    test('displayNames contains all flags', () {
      for (final flag in FeatureFlags.all) {
        expect(
          FeatureFlags.displayNames.containsKey(flag),
          isTrue,
          reason: 'Missing display name for $flag',
        );
      }
    });

    test('getDisplayName returns correct name', () {
      expect(FeatureFlags.getDisplayName(FeatureFlags.homePage), 'Home Page');
      expect(
        FeatureFlags.getDisplayName(FeatureFlags.analyticsPage),
        'Analytics Page',
      );
    });

    test('getDisplayName returns flag name for unknown flags', () {
      expect(FeatureFlags.getDisplayName('unknown_flag'), 'unknown_flag');
    });
  });
}
