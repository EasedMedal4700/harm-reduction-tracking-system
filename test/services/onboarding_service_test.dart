import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/services/onboarding_service.dart';

void main() {
  group('OnboardingService', () {
    late OnboardingService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = OnboardingService();
    });

    group('isOnboardingComplete', () {
      test('returns false when onboarding not completed', () async {
        final result = await service.isOnboardingComplete();
        expect(result, false);
      });

      test('returns true after completeOnboarding is called', () async {
        await service.completeOnboarding();
        final result = await service.isOnboardingComplete();
        expect(result, true);
      });
    });

    group('completeOnboarding', () {
      test('marks onboarding as complete', () async {
        expect(await service.isOnboardingComplete(), false);
        await service.completeOnboarding();
        expect(await service.isOnboardingComplete(), true);
      });
    });

    group('resetOnboarding', () {
      test('resets onboarding completion status', () async {
        await service.completeOnboarding();
        expect(await service.isOnboardingComplete(), true);
        
        await service.resetOnboarding();
        expect(await service.isOnboardingComplete(), false);
      });

      test('resets privacy policy acceptance', () async {
        await service.acceptPrivacyPolicy();
        expect(await service.isPrivacyPolicyAccepted(), true);
        
        await service.resetOnboarding();
        expect(await service.isPrivacyPolicyAccepted(), false);
      });

      test('resets usage frequency', () async {
        await service.saveUsageFrequency('daily');
        expect(await service.getUsageFrequency(), 'daily');
        
        await service.resetOnboarding();
        expect(await service.getUsageFrequency(), null);
      });
    });

    group('Privacy Policy', () {
      test('isPrivacyPolicyAccepted returns false initially', () async {
        final result = await service.isPrivacyPolicyAccepted();
        expect(result, false);
      });

      test('isPrivacyPolicyAccepted returns true after acceptance', () async {
        await service.acceptPrivacyPolicy();
        final result = await service.isPrivacyPolicyAccepted();
        expect(result, true);
      });
    });

    group('Usage Frequency', () {
      test('getUsageFrequency returns null initially', () async {
        final result = await service.getUsageFrequency();
        expect(result, null);
      });

      test('saves and retrieves usage frequency correctly', () async {
        await service.saveUsageFrequency('weekly');
        final result = await service.getUsageFrequency();
        expect(result, 'weekly');
      });

      test('can update usage frequency', () async {
        await service.saveUsageFrequency('rarely');
        expect(await service.getUsageFrequency(), 'rarely');
        
        await service.saveUsageFrequency('daily');
        expect(await service.getUsageFrequency(), 'daily');
      });
    });

    group('Harm Reduction Notices', () {
      test('isHarmNoticeDismissed returns false initially', () async {
        final result = await service.isHarmNoticeDismissed('test_key');
        expect(result, false);
      });

      test('dismissHarmNotice sets notice as dismissed', () async {
        await service.dismissHarmNotice('test_key');
        final result = await service.isHarmNoticeDismissed('test_key');
        expect(result, true);
      });

      test('blood levels banner key works correctly', () async {
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.bloodLevelsHarmNoticeDismissedKey,
          ),
          false,
        );
        
        await service.dismissHarmNotice(
          OnboardingService.bloodLevelsHarmNoticeDismissedKey,
        );
        
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.bloodLevelsHarmNoticeDismissedKey,
          ),
          true,
        );
      });

      test('tolerance banner key works correctly', () async {
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.toleranceHarmNoticeDismissedKey,
          ),
          false,
        );
        
        await service.dismissHarmNotice(
          OnboardingService.toleranceHarmNoticeDismissedKey,
        );
        
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.toleranceHarmNoticeDismissedKey,
          ),
          true,
        );
      });

      test('different notice keys are independent', () async {
        await service.dismissHarmNotice(
          OnboardingService.bloodLevelsHarmNoticeDismissedKey,
        );
        
        // Blood levels should be dismissed
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.bloodLevelsHarmNoticeDismissedKey,
          ),
          true,
        );
        
        // Tolerance should still not be dismissed
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.toleranceHarmNoticeDismissedKey,
          ),
          false,
        );
      });

      test('resetHarmNotices clears all dismissed notices', () async {
        // Dismiss both notices
        await service.dismissHarmNotice(
          OnboardingService.bloodLevelsHarmNoticeDismissedKey,
        );
        await service.dismissHarmNotice(
          OnboardingService.toleranceHarmNoticeDismissedKey,
        );
        
        // Verify both are dismissed
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.bloodLevelsHarmNoticeDismissedKey,
          ),
          true,
        );
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.toleranceHarmNoticeDismissedKey,
          ),
          true,
        );
        
        // Reset
        await service.resetHarmNotices();
        
        // Both should be not dismissed again
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.bloodLevelsHarmNoticeDismissedKey,
          ),
          false,
        );
        expect(
          await service.isHarmNoticeDismissed(
            OnboardingService.toleranceHarmNoticeDismissedKey,
          ),
          false,
        );
      });
    });
  });

  group('UsageFrequency', () {
    test('usageFrequencies contains 4 options', () {
      expect(OnboardingService.usageFrequencies.length, 4);
    });

    test('usageFrequencies have correct ids', () {
      final ids = OnboardingService.usageFrequencies.map((f) => f.id).toList();
      expect(ids, contains('rarely'));
      expect(ids, contains('occasionally'));
      expect(ids, contains('weekly'));
      expect(ids, contains('daily'));
    });

    test('each frequency has label, description, and icon', () {
      for (final frequency in OnboardingService.usageFrequencies) {
        expect(frequency.label, isNotEmpty);
        expect(frequency.description, isNotEmpty);
        expect(frequency.icon, isNotEmpty);
      }
    });
  });

  group('Global singleton', () {
    test('onboardingService is accessible', () {
      expect(onboardingService, isA<OnboardingService>());
    });
  });
}
