// MIGRATION

import 'package:flutter/material.dart';
import '../../services/onboarding_service.dart';
import '../../constants/theme/app_theme_extension.dart';



/// Full-page tolerance disclaimer widget
class ToleranceDisclaimerWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onToggle;

  const ToleranceDisclaimerWidget({
    super.key,
    this.isExpanded = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;

    return Container(
      margin: EdgeInsets.all(t.spacing.lg),
      padding: EdgeInsets.all(t.spacing.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(
          color: Colors.orange.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: t.spacing.xl,
              ),
              SizedBox(width: t.spacing.md),
              Expanded(
                child: Text(
                  'SAFETY DISCLAIMER',
                  style: t.typography.heading3.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
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

          SizedBox(height: t.spacing.md),

          /// Short mandatory line
          Text(
            'Tolerance estimates are approximations based on general pharmacological principles.',
            style: t.typography.bodyBold.copyWith(color: c.textPrimary),
          ),

          if (isExpanded) ...[
            SizedBox(height: t.spacing.md),

            /// Long explanation
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
              style: t.typography.bodySmall.copyWith(
                height: 1.5,
                color: c.textSecondary,
              ),
            ),

            SizedBox(height: t.spacing.md),

            /// Red warning box
            Container(
              padding: EdgeInsets.all(t.spacing.md),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(t.shapes.radiusSm),
                border: Border.all(
                  color: Colors.red.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Text(
                'USE AT YOUR OWN RISK\n\n'
                'This feature is informational only. The developers assume no liability for harm. '
                'Always consult medical professionals and follow harm reduction practices.',
                style: t.typography.bodySmall.copyWith(
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
    // Don't show while loading or if dismissed
    if (_isLoading || _isDismissed) return const SizedBox.shrink();

    final t = context.theme;
    final c = context.colors;
    final isDark = t.isDark; // <-- use AppTheme's isDark flag

    final bg = isDark
        ? Colors.amber.withOpacity(0.18)
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

    return Container(
      padding: EdgeInsets.all(t.spacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: titleColor,
            size: t.spacing.xl,
          ),
          SizedBox(width: t.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harm Reduction Notice',
                  style: t.typography.bodyBold.copyWith(
                    color: titleColor,
                  ),
                ),
                SizedBox(height: t.spacing.xs),
                Text(
                  'Tolerance values are mathematical estimates. They do NOT indicate safety. '
                  'Individual responses vary based on genetics, health, substance purity, '
                  'and many more factors.',
                  style: t.typography.bodySmall.copyWith(
                    height: 1.4,
                    color: bodyColor,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _handleDismiss,
            child: Padding(
              padding: EdgeInsets.only(left: t.spacing.sm),
              child: Icon(
                Icons.close,
                size: t.spacing.md + 4,
                color: c.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

