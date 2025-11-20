import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';

/// System overview card showing key metrics
class SystemOverviewCard extends StatelessWidget {
  final Map<String, DrugLevel> levels;
  final Map<String, DrugLevel> allLevels;

  const SystemOverviewCard({
    required this.levels,
    required this.allLevels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final activeCount = levels.length;
    final strongEffects = levels.values.where((l) => l.percentage > 20).length;
    final totalDose = levels.values.fold<double>(0.0, (sum, l) => sum + l.totalRemaining);
    
    // Get recent doses (24h) from full dataset
    final now = DateTime.now();
    final recentCount = allLevels.values.fold<int>(0, (sum, level) {
      return sum + level.doses.where((dose) => 
        now.difference(dose.startTime).inHours < 24
      ).length;
    });

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, size: 20),
              SizedBox(width: 8),
              Text(
                'System Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Active\nSubstances', '$activeCount', Colors.cyan, Icons.science),
              _buildStatCard('Strong\nEffects', '$strongEffects', Colors.amber, Icons.warning_amber),
              _buildStatCard('Recent\nDoses', '$recentCount', Colors.purple, Icons.schedule),
              _buildStatCard('Total\nDose', '${totalDose.toStringAsFixed(1)}u', Colors.red, Icons.scale),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
