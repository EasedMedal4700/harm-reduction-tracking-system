// Tolerance Disclaimer Widget
//
// Created: 2024-03-15
// Last Modified: 2025-01-23
//
// Purpose:
// Displays safety disclaimers and harm reduction warnings for the tolerance
// feature. Provides both full-page expandable and compact dismissible versions
// to inform users about the limitations and risks of tolerance estimates.
//
// Features:
// - Full-page disclaimer with expandable details section
// - Compact dismissible notice for quick viewing
// - Orange warning theme with high visibility
// - Red warning box for critical safety information
// - Persistent dismissal state (saved via OnboardingService)
// - Key disclaimers about medical validation, safety risks, dosing decisions
// - Dark/light theme adaptive colors
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully modernized with granular theme API and ConsumerWidget.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/onboarding_service.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Full-page tolerance disclaimer widget.
///
/// Displays a prominent safety warning with expandable details about the
/// limitations of tolerance estimates. Used on tolerance-related pages to
/// ensure users understand risks before viewing tolerance data.
class ToleranceDisclaimerWidget extends ConsumerWidget {
  final bool isExpanded;
  final VoidCallback? onToggle;
  const ToleranceDisclaimerWidget({
    super.key,
    this.isExpanded = false,
    this.onToggle,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // THEME ACCESS
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    // MAIN CONTAINER - Orange warning theme
    return Container(
      margin: EdgeInsets.all(sp.lg),
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.warning.withValues(alpha: 0.5),
          width: context.sizes.borderRegular,
        ),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // HEADER - Warning icon and title with optional expand button
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: c.warning, size: sp.xl),
              SizedBox(width: sp.md),
              Expanded(
                child: Text(
                  'SAFETY DISCLAIMER',
                  style: tx.heading3.copyWith(
                    color: c.warning,
                    fontWeight: tx.bodyBold.fontWeight,
                  ),
                ),
              ),
              if (onToggle != null)
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: c.textSecondary,
                  ),
                  onPressed: onToggle,
                ),
            ],
          ),
          SizedBox(height: sp.md),
          // MANDATORY LINE - Always visible short warning
          Text(
            'Tolerance estimates are approximations based on general pharmacological principles.',
            style: tx.bodyBold.copyWith(color: c.textPrimary),
          ),
          // EXPANDABLE DETAILS - Full disclaimer text
          if (isExpanded) ...[
            SizedBox(height: sp.md),
            // Detailed bullet points about limitations and risks
            Text(
              '• These calculations are NOT medically validated\n'
              '• They CANNOT predict safety, overdose risk, or health outcomes\n'
              '• Real-world risks vary widely based on:\n'
              '  - Physiology, genetics, health\n'
              '  - Substance purity variations\n'
              '  - Polydrug interactions\n'
              '  - Environment & mental state\n'
              '• TOLERANCE DOES NOT EQUAL SAFETY\n'
              '• High tolerance can increase harm risk\n'
              '• NEVER use these numbers for dosing decisions',
              style: tx.bodySmall.copyWith(height: 1.5, color: c.textSecondary),
            ),
            SizedBox(height: sp.md),
            // RED WARNING BOX - Critical liability and risk disclaimer
            Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: c.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(sh.radiusSm),
                border: Border.all(
                  color: c.error.withValues(alpha: 0.35),
                  width: context.sizes.borderThin,
                ),
              ),
              child: Text(
                'USE AT YOUR OWN RISK\n\n'
                'This feature is informational only. The developers assume no liability for harm. '
                'Always consult medical professionals and follow harm reduction practices.',
                style: tx.bodySmall.copyWith(
                  color: c.error,
                  fontWeight: tx.bodyBold.fontWeight,
                  height: 1.4,
                ),
                textAlign: AppLayout.textAlignCenter,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact dismissible version for top-of-page notices
class CompactToleranceDisclaimer extends StatefulWidget {
  const CompactToleranceDisclaimer({super.key});
  @override
  State<CompactToleranceDisclaimer> createState() =>
      _CompactToleranceDisclaimerState();
}

class _CompactToleranceDisclaimerState
    extends State<CompactToleranceDisclaimer> {
  bool _isDismissed = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadDismissedState();
  }

  Future<void> _loadDismissedState() async {
    final onboardingService = OnboardingService();
    final dismissed = await onboardingService.isHarmNoticeDismissed(
      OnboardingService.toleranceHarmNoticeDismissedKey,
    );
    if (!mounted) return;
    setState(() {
      _isDismissed = dismissed;
      _isLoading = false;
    });
  }

  Future<void> _handleDismiss() async {
    final onboardingService = OnboardingService();
    await onboardingService.dismissHarmNotice(
      OnboardingService.toleranceHarmNoticeDismissedKey,
    );
    if (!mounted) return;
    setState(() => _isDismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    // EARLY RETURN - Hide while loading or if dismissed
    if (_isLoading || _isDismissed) return const SizedBox.shrink();
    // THEME ACCESS
    final isDark = context.theme.isDark;
    // ADAPTIVE COLORS - Different colors for dark/light mode
    final bg = isDark
        ? c.warning.withValues(alpha: 0.18)
        : c.warning.withValues(alpha: 0.1);
    final borderColor = isDark ? c.warning : c.warning.withValues(alpha: 0.5);
    final titleColor = isDark ? c.warning : c.warning;
    final bodyColor = isDark ? c.textSecondary : c.textSecondary;
    // COMPACT NOTICE CONTAINER
    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: borderColor,
          width: context.sizes.borderRegular,
        ),
      ),
      child: Row(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(Icons.warning_amber_rounded, color: titleColor, size: sp.xl),
          SizedBox(width: sp.md),
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  'Harm Reduction Notice',
                  style: tx.bodyBold.copyWith(color: titleColor),
                ),
                SizedBox(height: sp.xs),
                Text(
                  'Tolerance values are mathematical estimates. They do NOT indicate safety. '
                  'Individual responses vary based on genetics, health, substance purity, '
                  'and many more factors.',
                  style: tx.bodySmall.copyWith(height: 1.4, color: bodyColor),
                ),
              ],
            ),
          ),
          // DISMISS BUTTON
          GestureDetector(
            onTap: _handleDismiss,
            child: Padding(
              padding: EdgeInsets.only(left: sp.sm),
              child: Icon(Icons.close, size: sp.md + 4, color: c.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
