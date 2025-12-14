/**
 * Tolerance Disclaimer Widget
 * 
 * Created: 2024-03-15
 * Last Modified: 2025-01-23
 * 
 * Purpose:
 * Displays safety disclaimers and harm reduction warnings for the tolerance
 * feature. Provides both full-page expandable and compact dismissible versions
 * to inform users about the limitations and risks of tolerance estimates.
 * 
 * Features:
 * - Full-page disclaimer with expandable details section
 * - Compact dismissible notice for quick viewing
 * - Orange warning theme with high visibility
 * - Red warning box for critical safety information
 * - Persistent dismissal state (saved via OnboardingService)
 * - Key disclaimers about medical validation, safety risks, dosing decisions
 * - Dark/light theme adaptive colors
 */

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully modernized with granular theme API and ConsumerWidget.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/onboarding_service.dart';
import '../../constants/theme/app_theme_extension.dart';



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
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    // MAIN CONTAINER - Orange warning theme
    return Container(
      margin: EdgeInsets.all(spacing.lg),
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radii.radiusMd),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER - Warning icon and title with optional expand button
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: spacing.xl,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Text(
                  'SAFETY DISCLAIMER',
                  style: typography.heading3.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (onToggle != null)
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: colors.textSecondary,
                  ),
                  onPressed: onToggle,
                ),
            ],
          ),

          SizedBox(height: spacing.md),

          // MANDATORY LINE - Always visible short warning
          Text(
            'Tolerance estimates are approximations based on general pharmacological principles.',
            style: typography.bodyBold.copyWith(color: colors.textPrimary),
          ),

          // EXPANDABLE DETAILS - Full disclaimer text
          if (isExpanded) ...[
            SizedBox(height: spacing.md),

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
              style: typography.bodySmall.copyWith(
                height: 1.5,
                color: colors.textSecondary,
              ),
            ),

            SizedBox(height: spacing.md),

            // RED WARNING BOX - Critical liability and risk disclaimer
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(radii.radiusSm),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: Text(
                'USE AT YOUR OWN RISK\n\n'
                'This feature is informational only. The developers assume no liability for harm. '
                'Always consult medical professionals and follow harm reduction practices.',
                style: typography.bodySmall.copyWith(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
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
    // EARLY RETURN - Hide while loading or if dismissed
    if (_isLoading || _isDismissed) return const SizedBox.shrink();

    // THEME ACCESS
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;
    final isDark = context.theme.isDark;

    // ADAPTIVE COLORS - Different colors for dark/light mode
    final bg = isDark
        ? Colors.amber.withValues(alpha: 0.18)
        : Colors.amber.shade50;

    final borderColor = isDark
        ? Colors.amber.shade700
        : Colors.amber.shade300;

    final titleColor = isDark
        ? Colors.amber.shade300
        : Colors.amber.shade900;

    final bodyColor = isDark
        ? Colors.grey.shade300
        : Colors.grey.shade800;

    // COMPACT NOTICE CONTAINER
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radii.radiusMd),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: titleColor,
            size: spacing.xl,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harm Reduction Notice',
                  style: typography.bodyBold.copyWith(
                    color: titleColor,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  'Tolerance values are mathematical estimates. They do NOT indicate safety. '
                  'Individual responses vary based on genetics, health, substance purity, '
                  'and many more factors.',
                  style: typography.bodySmall.copyWith(
                    height: 1.4,
                    color: bodyColor,
                  ),
                ),
              ],
            ),
          ),
          // DISMISS BUTTON
          GestureDetector(
            onTap: _handleDismiss,
            child: Padding(
              padding: EdgeInsets.only(left: spacing.sm),
              child: Icon(
                Icons.close,
                size: spacing.md + 4,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

