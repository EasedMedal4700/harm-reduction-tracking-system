// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: A multi-page onboarding experience for new users.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/common/logging/logger.dart';
import 'package:mobile_drug_use_app/features/setup_account/controllers/onboarding_controller.dart';
import 'package:mobile_drug_use_app/features/settings/providers/settings_providers.dart';
import 'package:mobile_drug_use_app/features/settings/models/app_settings_model.dart';
import '../../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/core/services/onboarding_service.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';

/// A multi-page onboarding experience for new users
/// Shows app introduction, privacy info, usage frequency selection, and theme picker
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    // Get current theme setting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings =
          ref.read(settingsControllerProvider).value ?? const AppSettings();
      ref
          .read(onboardingControllerProvider.notifier)
          .setDarkTheme(settings.darkMode);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final currentPage = ref.read(onboardingControllerProvider).currentPage;
    if (currentPage < 3) {
      _pageController.nextPage(
        duration: context.animations.normal,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    final currentPage = ref.read(onboardingControllerProvider).currentPage;
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: context.animations.normal,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final ok = await ref
        .read(onboardingControllerProvider.notifier)
        .completeOnboarding();

    if (!mounted) return;

    if (!ok) {
      final errorMessage = ref.read(onboardingControllerProvider).errorMessage;
      if (errorMessage == null) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    // Apply theme after onboarding data is saved.
    final state = ref.read(onboardingControllerProvider);
    await ref
        .read(settingsControllerProvider.notifier)
        .setDarkMode(state.isDarkTheme);
    if (!mounted) return;
    ref.read(navigationProvider).replace(AppRoutePaths.register);
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    final onboardingState = ref.watch(onboardingControllerProvider);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: EdgeInsets.all(sp.md),
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: sp.xs),
                      height: sp.xs,
                      decoration: BoxDecoration(
                        color: index <= onboardingState.currentPage
                            ? ac.primary
                            : c.border.withValues(
                                alpha: context.opacities.medium,
                              ),
                        borderRadius: BorderRadius.circular(sh.radiusSm),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  ref
                      .read(onboardingControllerProvider.notifier)
                      .setCurrentPage(page);
                },
                children: [
                  _buildWelcomePage(context),
                  _buildPrivacyInfoPage(context),
                  _buildPrivacyAcceptancePage(context),
                  _buildUsageFrequencyPage(context),
                ],
              ),
            ),
            // Navigation buttons
            Padding(
              padding: EdgeInsets.all(sp.xl),
              child: Row(
                children: [
                  if (onboardingState.currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: Icon(Icons.arrow_back, color: c.textSecondary),
                      label: Text(
                        'Back',
                        style: th.typography.labelLarge.copyWith(
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onboardingState.isCompleting
                        ? null
                        : (onboardingState.canProceedFromCurrentPage
                              ? _nextPage
                              : null),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ac.primary,
                      foregroundColor: c.textInverse,
                      padding: EdgeInsets.symmetric(
                        horizontal: sp.xl,
                        vertical: sp.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sh.radiusMd),
                      ),
                    ),
                    child: Text(
                      onboardingState.currentPage == 3
                          ? 'Get Started'
                          : 'Continue',
                      style: th.typography.labelLarge.copyWith(
                        color: c.textInverse,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.xl),
      child: Column(
        mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
        children: [
          CommonSpacer.vertical(sp.xl2),
          // App Icon
          Container(
            width: context.sizes.cardWidthSm,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ac.primary, ac.secondary],
                begin: sh.alignmentTopLeft,
                end: sh.alignmentBottomRight,
              ),
              borderRadius: BorderRadius.circular(sh.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: ac.primary.withValues(alpha: context.opacities.medium),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.science_outlined,
              size: context.sizes.icon2xl,
              color: c.textInverse,
            ),
          ),
          CommonSpacer.vertical(sp.xl),
          // App Name
          Text(
            'SubstanceCheck',
            style: th.typography.heading1.copyWith(
              fontWeight: tx.bodyBold.fontWeight,
              letterSpacing: -1,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.sm),
          // Tagline
          Text(
            'Realtime pharmacokinetic tracking\nfor informed substance use',
            textAlign: AppLayout.textAlignCenter,
            style: th.typography.heading4.copyWith(
              color: c.textSecondary,
              height: 1.4,
            ),
          ),
          CommonSpacer.vertical(sp.xl2),
          // Features
          _buildFeatureItem(
            context: context,
            icon: Icons.timeline,
            title: 'Track Metabolism & Blood Levels',
            description:
                'Real-time estimates of substance metabolism and clearance',
          ),
          CommonSpacer.vertical(sp.md),
          _buildFeatureItem(
            context: context,
            icon: Icons.trending_up,
            title: 'Monitor Tolerance',
            description: 'Understand how your body adapts over time',
          ),
          CommonSpacer.vertical(sp.md),
          _buildFeatureItem(
            context: context,
            icon: Icons.psychology,
            title: 'Track Cravings',
            description: 'Log and analyze your craving patterns',
          ),
          CommonSpacer.vertical(sp.md),
          _buildFeatureItem(
            context: context,
            icon: Icons.health_and_safety,
            title: 'Harm Reduction Insights',
            description: 'Make more informed decisions about your use',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Row(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Container(
          padding: EdgeInsets.all(sp.sm),
          decoration: BoxDecoration(
            color: ac.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(sh.radiusMd),
          ),
          child: Icon(icon, color: ac.primary, size: th.sizes.iconMd),
        ),
        CommonSpacer.horizontal(sp.md),
        Expanded(
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                title,
                style: th.typography.heading4.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
              ),
              CommonSpacer.vertical(sp.xs),
              Text(
                description,
                style: th.typography.body.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyInfoPage(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    final onboardingState = ref.watch(onboardingControllerProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.xl),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSpacer.vertical(sp.md),
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sp.sm),
                decoration: BoxDecoration(
                  color: c.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: c.success,
                  size: th.sizes.iconLg,
                ),
              ),
              CommonSpacer.horizontal(sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    Text(
                      'Privacy & Safety',
                      style: th.typography.heading3.copyWith(
                        fontWeight: tx.bodyBold.fontWeight,
                        color: c.textPrimary,
                      ),
                    ),
                    Text(
                      'Your data is protected',
                      style: th.typography.body.copyWith(
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.xl),
          // Encryption section
          _buildPrivacySection(
            context: context,
            icon: Icons.enhanced_encryption,
            title: 'End-to-End Encryption',
            content:
                'Your sensitive data is encrypted with a PIN that only you know. '
                'Even we cannot access your encrypted information. Your PIN never leaves your device.',
            color: c.info,
          ),
          CommonSpacer.vertical(sp.md),
          _buildPrivacySection(
            context: context,
            icon: Icons.cloud_off,
            title: 'Local-First Storage',
            content:
                'Your encryption keys are stored locally on your device. '
                'If you lose your PIN and recovery key, your data cannot be recovered by anyone.',
            color: ac.secondary,
          ),
          CommonSpacer.vertical(sp.md),
          _buildPrivacySection(
            context: context,
            icon: Icons.visibility_off,
            title: 'No Tracking or Ads',
            content:
                'We don\'t track your behavior, sell your data, or show ads. '
                'This app exists solely to help you make informed decisions.',
            color: c.warning,
          ),
          CommonSpacer.vertical(sp.md),
          _buildPrivacySection(
            context: context,
            icon: Icons.delete_forever,
            title: 'Delete Anytime',
            content:
                'You can download all your data and permanently delete your account '
                'at any time from the Settings menu.',
            color: c.error,
          ),
          CommonSpacer.vertical(sp.xl),
          // Theme selector
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(sh.radiusMd),
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  'Choose Your Theme',
                  style: th.typography.heading4.copyWith(
                    fontWeight: tx.bodyBold.fontWeight,
                    color: c.textPrimary,
                  ),
                ),
                CommonSpacer.vertical(sp.md),
                Row(
                  children: [
                    Expanded(
                      child: _buildThemeOption(
                        context: context,
                        title: 'Light',
                        icon: Icons.light_mode,
                        isSelected: !onboardingState.isDarkTheme,
                        onTap: () {
                          ref
                              .read(onboardingControllerProvider.notifier)
                              .setDarkTheme(false);
                          ref
                              .read(settingsControllerProvider.notifier)
                              .setDarkMode(false);
                        },
                      ),
                    ),
                    CommonSpacer.horizontal(sp.sm),
                    Expanded(
                      child: _buildThemeOption(
                        context: context,
                        title: 'Dark',
                        icon: Icons.dark_mode,
                        isSelected: onboardingState.isDarkTheme,
                        onTap: () {
                          ref
                              .read(onboardingControllerProvider.notifier)
                              .setDarkTheme(true);
                          ref
                              .read(settingsControllerProvider.notifier)
                              .setDarkMode(true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    final th = context.theme;
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(icon, color: color, size: th.sizes.iconMd),
          CommonSpacer.horizontal(sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  title,
                  style: th.typography.heading4.copyWith(
                    fontWeight: tx.bodyBold.fontWeight,
                    color: c.textPrimary,
                  ),
                ),
                CommonSpacer.vertical(sp.xs),
                Text(
                  content,
                  style: th.typography.body.copyWith(
                    height: 1.4,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sp.md),
        decoration: BoxDecoration(
          color: isSelected ? ac.primary.withValues(alpha: 0.1) : c.transparent,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(
            color: isSelected ? ac.primary : c.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: th.sizes.iconLg,
              color: isSelected ? ac.primary : c.textSecondary,
            ),
            CommonSpacer.vertical(sp.xs),
            Text(
              title,
              style: th.typography.body.copyWith(
                fontWeight: isSelected
                    ? tx.bodyBold.fontWeight
                    : FontWeight.normal,
                color: isSelected ? ac.primary : c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyAcceptancePage(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    final onboardingState = ref.watch(onboardingControllerProvider);
    final privacyAccepted = onboardingState.privacyAccepted;

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.xl),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSpacer.vertical(sp.md),
          // Header
          Text(
            'Privacy Policy',
            style: th.typography.heading3.copyWith(
              fontWeight: tx.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.xs),
          Text(
            'Please review and accept our privacy policy to continue.',
            style: th.typography.body.copyWith(color: c.textSecondary),
          ),
          CommonSpacer.vertical(sp.xl),
          // Privacy policy link
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              logger.debug('Onboarding: privacy policy link tapped');
              ref.read(navigationProvider).push(AppRoutePaths.privacyPolicy);
            },
            child: Container(
              padding: EdgeInsets.all(sp.lg),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(color: ac.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.policy,
                    color: ac.primary,
                    size: context.sizes.iconXl,
                  ),
                  CommonSpacer.horizontal(sp.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                      children: [
                        Text(
                          'Read Privacy Policy',
                          style: th.typography.heading4.copyWith(
                            fontWeight: tx.bodyBold.fontWeight,
                            color: c.textPrimary,
                          ),
                        ),
                        CommonSpacer.vertical(sp.xs),
                        Text(
                          'Opens in your browser',
                          style: th.typography.body.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.open_in_new,
                    color: ac.primary,
                    size: th.sizes.iconSm,
                  ),
                ],
              ),
            ),
          ),
          CommonSpacer.vertical(sp.xl),
          // Accept checkbox
          GestureDetector(
            onTap: () => ref
                .read(onboardingControllerProvider.notifier)
                .togglePrivacyAccepted(),
            child: Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: privacyAccepted
                    ? c.success.withValues(alpha: 0.15)
                    : c.transparent,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(
                  color: privacyAccepted ? c.success : c.border,
                  width: privacyAccepted ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: privacyAccepted ? c.success : c.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: privacyAccepted ? c.success : c.border,
                        width: context.sizes.borderRegular,
                      ),
                    ),
                    child: privacyAccepted
                        ? Icon(
                            Icons.check,
                            color: c.textInverse,
                            size: th.sizes.iconSm,
                          )
                        : null,
                  ),
                  CommonSpacer.horizontal(sp.md),
                  Expanded(
                    child: Text(
                      'I have read and accept the Privacy Policy',
                      style: th.typography.body.copyWith(
                        fontWeight: privacyAccepted
                            ? tx.bodyBold.fontWeight
                            : FontWeight.normal,
                        color: privacyAccepted ? c.success : c.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!privacyAccepted) ...[
            CommonSpacer.vertical(sp.md),
            Container(
              padding: EdgeInsets.all(sp.sm),
              decoration: BoxDecoration(
                color: c.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(sh.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: c.warning,
                    size: th.sizes.iconSm,
                  ),
                  CommonSpacer.horizontal(sp.sm),
                  Expanded(
                    child: Text(
                      'You must accept the privacy policy to continue',
                      style: th.typography.body.copyWith(color: c.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsageFrequencyPage(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    final onboardingState = ref.watch(onboardingControllerProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.xl),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSpacer.vertical(sp.md),
          // Header
          Text(
            'How often do you use?',
            style: th.typography.heading3.copyWith(
              fontWeight: tx.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.xs),
          Text(
            'This helps us personalize your experience. You can change this later in Settings.',
            style: th.typography.body.copyWith(color: c.textSecondary),
          ),
          CommonSpacer.vertical(sp.xl),
          // Frequency options
          ...OnboardingService.usageFrequencies.map((frequency) {
            final isSelected =
                onboardingState.selectedFrequency == frequency.id;
            return Padding(
              padding: EdgeInsets.only(bottom: sp.sm),
              child: GestureDetector(
                onTap: () => ref
                    .read(onboardingControllerProvider.notifier)
                    .selectFrequency(frequency.id),
                child: Container(
                  padding: EdgeInsets.all(sp.lg),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ac.primary.withValues(alpha: 0.1)
                        : c.surface,
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                    border: Border.all(
                      color: isSelected ? ac.primary : c.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        frequency.icon,
                        style: TextStyle(fontSize: tx.heading1.fontSize),
                      ),
                      CommonSpacer.horizontal(sp.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                          children: [
                            Text(
                              frequency.label,
                              style: th.typography.heading4.copyWith(
                                fontWeight: tx.bodyBold.fontWeight,
                                color: isSelected ? ac.primary : c.textPrimary,
                              ),
                            ),
                            CommonSpacer.vertical(sp.xs),
                            Text(
                              frequency.description,
                              style: th.typography.body.copyWith(
                                color: c.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: EdgeInsets.all(sp.xs),
                          decoration: BoxDecoration(
                            color: ac.primary,
                            shape: sh.boxShapeCircle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: c.textInverse,
                            size: context.sizes.iconSm,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (onboardingState.selectedFrequency == null) ...[
            CommonSpacer.vertical(sp.md),
            Container(
              padding: EdgeInsets.all(sp.sm),
              decoration: BoxDecoration(
                color: c.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(sh.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: c.warning,
                    size: th.sizes.iconSm,
                  ),
                  CommonSpacer.horizontal(sp.sm),
                  Expanded(
                    child: Text(
                      'Please select an option to continue',
                      style: th.typography.body.copyWith(color: c.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
