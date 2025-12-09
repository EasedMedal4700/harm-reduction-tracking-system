// MIGRATION
import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Risk assessment card with gradient indicator
class RiskAssessmentCard extends StatelessWidget {
  final Map<String, DrugLevel> levels;

  const RiskAssessmentCard({required this.levels, super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.theme;
    final text = context.text;
    
    final highRisk = levels.values.where((l) => l.percentage > 20).length;
    final moderateRisk = levels.values.where((l) => l.percentage > 10 && l.percentage <= 20).length;
    final totalDose = levels.values.fold<double>(0.0, (sum, l) => sum + l.totalRemaining);

    String riskLevel;
    Color riskColor;
    String warningMessage;
    double riskPosition;

    if (highRisk > 0) {
      riskLevel = 'HIGH';
      riskColor = c.error;
      warningMessage = 'Elevated risk detected. Avoid redosing and monitor for adverse interactions.';
      riskPosition = 0.8;
    } else if (moderateRisk > 0 || totalDose > 5.0) {
      riskLevel = 'MODERATE';
      riskColor = c.warning;
      warningMessage = 'Moderate risk detected. Monitor for interactions and avoid redosing.';
      riskPosition = 0.5;
    } else if (levels.isNotEmpty) {
      riskLevel = 'LOW';
      riskColor = c.success;
      warningMessage = 'Low risk level. Minimal residual effects expected.';
      riskPosition = 0.2;
    } else {
      riskLevel = 'CLEAR';
      riskColor = c.success;
      warningMessage = 'System clear. No active pharmacological substances detected.';
      riskPosition = 0.0;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: sp.lg),
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: riskColor.withValues(alpha: 0.3),
          width: 1,
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
                style: text.heading4,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sp.md,
                  vertical: sp.sm,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(color: riskColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  riskLevel,
                  style: text.bodyBold.copyWith(
                    color: riskColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: sp.lg),
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
                        color: c.surface,
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
          SizedBox(height: sp.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LOW', style: text.caption.copyWith(color: c.success, fontWeight: FontWeight.bold)),
              Text('HIGH', style: text.caption.copyWith(color: c.error, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: sp.md),
          Text(
            warningMessage,
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}
