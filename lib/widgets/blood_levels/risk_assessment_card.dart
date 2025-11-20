import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';

/// Risk assessment card with gradient indicator
class RiskAssessmentCard extends StatelessWidget {
  final Map<String, DrugLevel> levels;

  const RiskAssessmentCard({required this.levels, super.key});

  @override
  Widget build(BuildContext context) {
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: riskColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: riskColor.withOpacity(0.1),
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
              const Text(
                'Risk Assessment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: riskColor.withOpacity(0.5)),
                ),
                child: Text(
                  riskLevel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: riskColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: riskColor.withOpacity(0.6),
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
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LOW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
              Text('HIGH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            warningMessage,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
