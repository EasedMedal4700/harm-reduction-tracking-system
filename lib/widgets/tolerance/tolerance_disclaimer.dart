import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../services/onboarding_service.dart';

/// Disclaimer widget shown on tolerance-related pages.
/// 
/// CRITICAL: This disclaimer must be displayed prominently to users
/// to ensure they understand the limitations and risks.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(ThemeConstants.space16),
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: Colors.orange.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 24,
              ),
              SizedBox(width: ThemeConstants.space12),
              Expanded(
                child: Text(
                  'SAFETY DISCLAIMER',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontLarge,
                    fontWeight: ThemeConstants.fontBold,
                    color: Colors.orange,
                  ),
                ),
              ),
              if (onToggle != null)
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                  onPressed: onToggle,
                ),
            ],
          ),
          SizedBox(height: ThemeConstants.space12),
          Text(
            'Tolerance estimates are approximations based on general pharmacological principles.',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          if (isExpanded) ...[
            SizedBox(height: ThemeConstants.space12),
            Text(
              '• These calculations are NOT medically validated\n'
              '• They CANNOT predict safety, overdose risk, or health outcomes\n'
              '• Real-world risks vary widely based on:\n'
              '  - Individual physiology and genetics\n'
              '  - Drug purity and composition\n'
              '  - Drug interactions and combinations\n'
              '  - Environmental factors\n'
              '  - Mental and physical health conditions\n'
              '• TOLERANCE DOES NOT EQUAL SAFETY\n'
              '• Higher tolerance can lead to increased health risks\n'
              '• These estimates must NOT be used to determine "safe" doses',
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: ThemeConstants.space12),
            Container(
              padding: EdgeInsets.all(ThemeConstants.space12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'USE AT YOUR OWN RISK\n\n'
                'This feature is provided for informational purposes only. '
                'The developers assume no responsibility for any harm resulting '
                'from use of this feature. Always consult medical professionals '
                'and use harm reduction resources.',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  color: Colors.red,
                  fontWeight: ThemeConstants.fontMediumWeight,
                  height: 1.5,
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

/// Compact version of the disclaimer for headers with dismissible functionality.
class CompactToleranceDisclaimer extends StatefulWidget {
  const CompactToleranceDisclaimer({super.key});

  @override
  State<CompactToleranceDisclaimer> createState() => _CompactToleranceDisclaimerState();
}

class _CompactToleranceDisclaimerState extends State<CompactToleranceDisclaimer> {
  bool _isDismissed = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDismissedState();
  }

  Future<void> _loadDismissedState() async {
    final onboardingService = OnboardingService();
    final isDismissed = await onboardingService.isHarmNoticeDismissed(
      OnboardingService.toleranceHarmNoticeDismissedKey,
    );
    if (mounted) {
      setState(() {
        _isDismissed = isDismissed;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDismiss() async {
    final onboardingService = OnboardingService();
    await onboardingService.dismissHarmNotice(
      OnboardingService.toleranceHarmNoticeDismissedKey,
    );
    if (mounted) {
      setState(() {
        _isDismissed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show while loading or if dismissed
    if (_isLoading || _isDismissed) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(ThemeConstants.space12),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.amber.withOpacity(0.15) 
            : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark 
              ? Colors.amber.shade700 
              : Colors.amber.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: isDark ? Colors.amber.shade400 : Colors.amber.shade800,
            size: 24,
          ),
          SizedBox(width: ThemeConstants.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harm Reduction Notice',
                  style: TextStyle(
                    fontWeight: ThemeConstants.fontBold,
                    fontSize: ThemeConstants.fontMedium,
                    color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tolerance calculations are mathematical estimates only. '
                  'Individual responses vary based on genetics, health, substance purity, '
                  'and many other factors. Never use these numbers to make dosing decisions '
                  'or assume safety. Tolerance does NOT equal safety.',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontXSmall,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Dismiss button
          GestureDetector(
            onTap: _handleDismiss,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                Icons.close,
                size: 20,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
