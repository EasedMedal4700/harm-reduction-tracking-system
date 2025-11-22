import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Risk assessment card with gradient indicator
class RiskAssessmentCard extends StatelessWidget {
  final Map<String, DrugLevel> levels;

  const RiskAssessmentCard({required this.levels, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final highRisk = levels.values.where((l) => l.percentage > 20).length;
    final moderateRisk = levels.values.where((l) => l.percentage > 10 && l.percentage <= 20).length;
    final totalDose = levels.values.fold<double>(0.0, (sum, l) => sum + l.totalRemaining);

    String riskLevel;
    Color riskColor;
    String warningMessage;
    double riskPosition;

    if (highRisk > 0) {
      riskLevel = 'HIGH';
      riskColor = Colors.red;
      warningMessage = 'Elevated risk detected. Avoid redosing and monitor for adverse interactions.';
      riskPosition = 0.8;
    } else if (moderateRisk > 0 || totalDose > 5.0) {
      riskLevel = 'MODERATE';
      riskColor = Colors.orange;
      warningMessage = 'Moderate risk detected. Monitor for interactions and avoid redosing.';
      riskPosition = 0.5;
    } else if (levels.isNotEmpty) {
      riskLevel = 'LOW';
      riskColor = Colors.green;
      warningMessage = 'Low risk level. Minimal residual effects expected.';
      riskPosition = 0.2;
    } else {
      riskLevel = 'CLEAR';
      riskColor = Colors.green;
      warningMessage = 'System clear. No active pharmacological substances detected.';
      riskPosition = 0.0;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ThemeConstants.space16),
      padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: riskColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: riskColor.withValues(alpha: 0.3),
                width: ThemeConstants.borderThin,
              ),
              boxShadow: [
                BoxShadow(
                  color: riskColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Risk Assessment',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space12,
                  vertical: ThemeConstants.space8,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: isDark ? 0.2 : 0.15),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  border: Border.all(color: riskColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    fontWeight: ThemeConstants.fontBold,
                    color: riskColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          Container(
            height: 12,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.orange, Colors.red],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.85 * riskPosition - 8,
                  top: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: riskColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? UIColors.darkBackground : UIColors.lightSurface,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: riskColor.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LOW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
              Text('HIGH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          SizedBox(height: ThemeConstants.space12),
          Text(
            warningMessage,
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
