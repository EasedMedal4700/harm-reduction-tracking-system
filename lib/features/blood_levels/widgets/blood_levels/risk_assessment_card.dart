// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.

import 'package:flutter/material.dart';
import '../../../../services/blood_levels_service.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';

/// Risk assessment card with gradient indicator
class RiskAssessmentCard extends StatelessWidget {
  final Map<String, DrugLevel> levels;

  const RiskAssessmentCard({
    super.key,
    required this.levels,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    // ----------------------------
    // RISK EVALUATION LOGIC
    // ----------------------------
    final highRisk = levels.values.where((l) => l.percentage > 20).length;
    final moderateRisk =
        levels.values.where((l) => l.percentage > 10 && l.percentage <= 20).length;

    final totalDose =
        levels.values.fold<double>(0.0, (sum, l) => sum + l.totalRemaining);

    String riskLevel;
    Color riskColor;
    String warningMessage;
    double riskPosition;

    if (highRisk > 0) {
      riskLevel = 'HIGH';
      riskColor = c.error;
      warningMessage = 'Elevated risk detected. Avoid redosing and monitor carefully.';
      riskPosition = 0.8;
    } else if (moderateRisk > 0 || totalDose > 5.0) {
      riskLevel = 'MODERATE';
      riskColor = c.warning;
      warningMessage =
          'Moderate risk detected. Monitor interactions and avoid redosing.';
      riskPosition = 0.5;
    } else if (levels.isNotEmpty) {
      riskLevel = 'LOW';
      riskColor = c.success;
      warningMessage = 'Low risk level. Minimal residual effects expected.';
      riskPosition = 0.2;
    } else {
      riskLevel = 'CLEAR';
      riskColor = c.success;
      warningMessage = 'System clear. No active substances detected.';
      riskPosition = 0.0;
    }

    // ----------------------------
    // UI
    // ----------------------------
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: CommonCard(
        padding: EdgeInsets.all(sp.lg),
        borderColor: riskColor.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Text('Risk Assessment', style: text.heading4),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: sp.md,
                  vertical: sp.sm - 2,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: riskColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  riskLevel,
                  style: text.bodyBold.copyWith(
                    color: riskColor,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: sp.lg),

          // RISK GRADIENT BAR
          Container(
            height: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              gradient: LinearGradient(
                colors: [
                  c.success,
                  c.warning,
                  c.error,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left:
                      (MediaQuery.of(context).size.width * 0.80 * riskPosition),
                  top: -3,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: riskColor,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: c.surface),
                      boxShadow: [
                        BoxShadow(
                          color: riskColor.withValues(alpha: 0.6),
                          blurRadius: 10,
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
              Text('LOW',
                  style: text.captionBold.copyWith(color: c.success)),
              Text('HIGH',
                  style: text.captionBold.copyWith(color: c.error)),
            ],
          ),

          SizedBox(height: sp.md),

          // WARNING MESSAGE
          Text(
            warningMessage,
            style: text.bodySmall.copyWith(
              color: c.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    ));
  }
}
