import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

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

/// Compact version of the disclaimer for headers.
class CompactToleranceDisclaimer extends StatelessWidget {
  const CompactToleranceDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space12,
        vertical: ThemeConstants.space8,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 16,
          ),
          SizedBox(width: ThemeConstants.space8),
          Flexible(
            child: Text(
              'Approximations only - NOT medical advice',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
