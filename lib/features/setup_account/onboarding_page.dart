import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/onboarding_service.dart';
import '../../providers/settings_provider.dart';
import '../../common/layout/common_spacer.dart';

/// A multi-page onboarding experience for new users
/// Shows app introduction, privacy info, usage frequency selection, and theme picker
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // User selections
  String? _selectedFrequency;
  bool _privacyAccepted = false;
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    // Get current theme setting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsProvider>().settings;
      setState(() {
        _isDarkTheme = settings.darkMode;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: context.animations.normal,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: context.animations.normal,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    // Save preferences
    if (_selectedFrequency != null) {
      await onboardingService.saveUsageFrequency(_selectedFrequency!);
    }
    if (_privacyAccepted) {
      await onboardingService.acceptPrivacyPolicy();
    }
    
    // Apply theme
    if (mounted) {
      context.read<SettingsProvider>().setDarkMode(_isDarkTheme);
    }
    
    // Mark onboarding complete
    await onboardingService.completeOnboarding();
    
    // Navigate to register
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/register');
    }
  }

  bool get _canProceedFromCurrentPage {
    switch (_currentPage) {
      case 0:
        return true; // Welcome page
      case 1:
        return true; // Privacy info page
      case 2:
        return _privacyAccepted; // Privacy policy acceptance
      case 3:
        return _selectedFrequency != null; // Usage frequency selection
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    
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
                      height: context.spacing.xs,
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? a.primary
                            : c.border.withValues(alpha: context.opacities.medium),
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
                  setState(() => _currentPage = page);
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
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: _previousPage,
                      icon: Icon(Icons.arrow_back, color: c.textSecondary),
                      label: Text('Back', style: t.typography.labelLarge.copyWith(color: c.textSecondary)),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _canProceedFromCurrentPage ? _nextPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: a.primary,
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
                      _currentPage == 3 ? 'Get Started' : 'Continue',
                      style: t.typography.labelLarge.copyWith(color: c.textInverse),
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
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
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
                colors: [
                  a.primary,
                  a.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(sh.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: a.primary.withValues(alpha: context.opacities.medium),
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
            style: t.typography.heading1.copyWith(
              fontWeight: text.bodyBold.fontWeight,
              letterSpacing: -1,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.sm),
          
          // Tagline
          Text(
            'Realtime pharmacokinetic tracking\nfor informed substance use',
            textAlign: AppLayout.textAlignCenter,
            style: t.typography.heading4.copyWith(
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
            description: 'Real-time estimates of substance metabolism and clearance',
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
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return Row(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Container(
          padding: EdgeInsets.all(sp.sm),
          decoration: BoxDecoration(
            color: a.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(sh.radiusMd),
          ),
          child: Icon(
            icon,
            color: a.primary,
            size: t.sizes.iconMd,
          ),
        ),
        CommonSpacer.horizontal(sp.md),
        Expanded(
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                title,
                style: t.typography.heading4.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                  color: c.textPrimary,
                ),
              ),
              CommonSpacer.vertical(sp.xs),
              Text(
                description,
                style: t.typography.body.copyWith(
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyInfoPage(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

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
                  size: t.sizes.iconLg,
                ),
              ),
              CommonSpacer.horizontal(sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    Text(
                      'Privacy & Safety',
                      style: t.typography.heading3.copyWith(
                        fontWeight: text.bodyBold.fontWeight,
                        color: c.textPrimary,
                      ),
                    ),
                    Text(
                      'Your data is protected',
                      style: t.typography.body.copyWith(
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
            content: 'Your sensitive data is encrypted with a PIN that only you know. '
                'Even we cannot access your encrypted information. Your PIN never leaves your device.',
            color: Colors.blue,
          ),
          CommonSpacer.vertical(sp.md),
          
          _buildPrivacySection(
            context: context,
            icon: Icons.cloud_off,
            title: 'Local-First Storage',
            content: 'Your encryption keys are stored locally on your device. '
                'If you lose your PIN and recovery key, your data cannot be recovered by anyone.',
            color: Colors.purple,
          ),
          CommonSpacer.vertical(sp.md),
          
          _buildPrivacySection(
            context: context,
            icon: Icons.visibility_off,
            title: 'No Tracking or Ads',
            content: 'We don\'t track your behavior, sell your data, or show ads. '
                'This app exists solely to help you make informed decisions.',
            color: Colors.orange,
          ),
          CommonSpacer.vertical(sp.md),
          
          _buildPrivacySection(
            context: context,
            icon: Icons.delete_forever,
            title: 'Delete Anytime',
            content: 'You can download all your data and permanently delete your account '
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
              border: Border.all(
                color: c.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  'Choose Your Theme',
                  style: t.typography.heading4.copyWith(
                    fontWeight: text.bodyBold.fontWeight,
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
                        isSelected: !_isDarkTheme,
                        onTap: () {
                          setState(() => _isDarkTheme = false);
                          context.read<SettingsProvider>().setDarkMode(false);
                        },
                      ),
                    ),
                    CommonSpacer.horizontal(sp.sm),
                    Expanded(
                      child: _buildThemeOption(
                        context: context,
                        title: 'Dark',
                        icon: Icons.dark_mode,
                        isSelected: _isDarkTheme,
                        onTap: () {
                          setState(() => _isDarkTheme = true);
                          context.read<SettingsProvider>().setDarkMode(true);
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
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(icon, color: color, size: t.sizes.iconMd),
          CommonSpacer.horizontal(sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  title,
                  style: t.typography.heading4.copyWith(
                    fontWeight: text.bodyBold.fontWeight,
                    color: c.textPrimary,
                  ),
                ),
                CommonSpacer.vertical(sp.xs),
                Text(
                  content,
                  style: t.typography.body.copyWith(
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
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(sp.md),
        decoration: BoxDecoration(
          color: isSelected
              ? a.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(
            color: isSelected
                ? a.primary
                : c.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: t.sizes.iconLg,
              color: isSelected
                  ? a.primary
                  : c.textSecondary,
            ),
            CommonSpacer.vertical(sp.xs),
            Text(
              title,
              style: t.typography.body.copyWith(
                fontWeight: isSelected ? text.bodyBold.fontWeight : text.bodyRegular.fontWeight,
                color: isSelected
                    ? a.primary
                    : c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyAcceptancePage(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.xl),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSpacer.vertical(sp.md),
          // Header
          Text(
            'Privacy Policy',
            style: t.typography.heading3.copyWith(
              fontWeight: text.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.xs),
          Text(
            'Please review and accept our privacy policy to continue.',
            style: t.typography.body.copyWith(
              color: c.textSecondary,
            ),
          ),
          CommonSpacer.vertical(sp.xl),
          
          // Privacy policy link
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              debugPrint("🔥 PRIVACY LINK TAPPED");
              Navigator.of(context).pushNamed('/privacy-policy');
            },
            child: Container(
              padding: EdgeInsets.all(sp.lg),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(
                  color: a.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.policy,
                    color: a.primary,
                    size: context.sizes.iconXl,
                  ),
                  CommonSpacer.horizontal(sp.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                      children: [
                        Text(
                          'Read Privacy Policy',
                          style: t.typography.heading4.copyWith(
                            fontWeight: text.bodyBold.fontWeight,
                            color: c.textPrimary,
                          ),
                        ),
                        CommonSpacer.vertical(sp.xs),
                        Text(
                          'Opens in your browser',
                          style: t.typography.body.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.open_in_new,
                    color: a.primary,
                    size: t.sizes.iconSm,
                  ),
                ],
              ),
            ),
          ),
          CommonSpacer.vertical(sp.xl),
          
          // Accept checkbox
          GestureDetector(
            onTap: () => setState(() => _privacyAccepted = !_privacyAccepted),
            child: Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: _privacyAccepted
                    ? c.success.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                border: Border.all(
                  color: _privacyAccepted
                      ? c.success
                      : c.border,
                  width: _privacyAccepted ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _privacyAccepted
                          ? c.success
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _privacyAccepted
                            ? c.success
                            : c.border,
                        width: 2,
                      ),
                    ),
                    child: _privacyAccepted
                        ? Icon(Icons.check, color: c.textInverse, size: t.sizes.iconSm)
                        : null,
                  ),
                  CommonSpacer.horizontal(sp.md),
                  Expanded(
                    child: Text(
                      'I have read and accept the Privacy Policy',
                      style: t.typography.body.copyWith(
                        fontWeight: _privacyAccepted ? text.bodyBold.fontWeight : text.bodyRegular.fontWeight,
                        color: _privacyAccepted
                            ? c.success
                            : c.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (!_privacyAccepted) ...[
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
                    size: t.sizes.iconSm,
                  ),
                  CommonSpacer.horizontal(sp.sm),
                  Expanded(
                    child: Text(
                      'You must accept the privacy policy to continue',
                      style: t.typography.body.copyWith(
                        color: c.warning,
                      ),
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
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.xl),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSpacer.vertical(sp.md),
          // Header
          Text(
            'How often do you use?',
            style: t.typography.heading3.copyWith(
              fontWeight: text.bodyBold.fontWeight,
              color: c.textPrimary,
            ),
          ),
          CommonSpacer.vertical(sp.xs),
          Text(
            'This helps us personalize your experience. You can change this later in Settings.',
            style: t.typography.body.copyWith(
              color: c.textSecondary,
            ),
          ),
          CommonSpacer.vertical(sp.xl),
          
          // Frequency options
          ...OnboardingService.usageFrequencies.map((frequency) {
            final isSelected = _selectedFrequency == frequency.id;
            return Padding(
              padding: EdgeInsets.only(bottom: sp.sm),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFrequency = frequency.id),
                child: Container(
                  padding: EdgeInsets.all(sp.lg),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? a.primary.withValues(alpha: 0.1)
                        : c.surface,
                    borderRadius: BorderRadius.circular(sh.radiusMd),
                    border: Border.all(
                      color: isSelected
                          ? a.primary
                          : c.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        frequency.icon,
                        style: const TextStyle(fontSize: context.text.heading1.fontSize),
                      ),
                      CommonSpacer.horizontal(sp.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                          children: [
                            Text(
                              frequency.label,
                              style: t.typography.heading4.copyWith(
                                fontWeight: text.bodyBold.fontWeight,
                                color: isSelected
                                    ? a.primary
                                    : c.textPrimary,
                              ),
                            ),
                            CommonSpacer.vertical(sp.xs),
                            Text(
                              frequency.description,
                              style: t.typography.body.copyWith(
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
                            color: a.primary,
                            shape: BoxShape.circle,
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
          
          if (_selectedFrequency == null) ...[
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
                    size: t.sizes.iconSm,
                  ),
                  CommonSpacer.horizontal(sp.sm),
                  Expanded(
                    child: Text(
                      'Please select an option to continue',
                      style: t.typography.body.copyWith(
                        color: c.warning,
                      ),
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
