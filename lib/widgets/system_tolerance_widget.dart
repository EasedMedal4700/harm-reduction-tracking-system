import 'package:flutter/material.dart';
import '../models/tolerance_model.dart';
import '../services/tolerance_engine_service.dart';
import '../services/user_service.dart';

/// Simple data holder for system tolerance display
class SystemToleranceData {
  final Map<String, double> percents;
  final Map<String, ToleranceSystemState> states;

  SystemToleranceData(this.percents, this.states);
}

/// Load system tolerance data for current user
Future<SystemToleranceData> loadSystemToleranceData() async {
  final userId = await UserService.getIntegerUserId();
  final report = await ToleranceEngineService.getToleranceReport(userId: userId);
  return SystemToleranceData(report.tolerances, report.states);
}

/// Minimal widget to display system-wide tolerance
Widget buildSystemToleranceSection(SystemToleranceData data) {
  return Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'System Tolerance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        ...kToleranceBuckets.map((bucket) {
          final percent = data.percents[bucket] ?? 0.0;
          final state = data.states[bucket] ?? ToleranceSystemState.recovered;
          return _buildBucketRow(bucket, percent, state);
        }),
        const SizedBox(height: 12),
      ],
    ),
  );
}

/// Build single bucket row
Widget _buildBucketRow(String bucket, double percent, ToleranceSystemState state) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatBucketName(bucket),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${percent.toStringAsFixed(1)}% — ${state.displayName}',
          style: TextStyle(
            fontSize: 13,
            color: _getStateColor(state),
          ),
        ),
      ],
    ),
  );
}

/// Format bucket name for display
String _formatBucketName(String bucket) {
  switch (bucket) {
    case 'gaba':
      return 'GABA';
    case 'stimulant':
      return 'Stimulant';
    case 'serotonin':
      return 'Serotonin';
    case 'opioid':
      return 'Opioid';
    case 'nmda':
      return 'NMDA';
    case 'cannabinoid':
      return 'Cannabinoid';
    default:
      return bucket.toUpperCase();
  }
}

/// Get color for system state
Color _getStateColor(ToleranceSystemState state) {
  switch (state) {
    case ToleranceSystemState.recovered:
      return Colors.grey;
    case ToleranceSystemState.lightStress:
      return Colors.blue;
    case ToleranceSystemState.moderateStrain:
      return Colors.orange;
    case ToleranceSystemState.highStrain:
      return Colors.red;
    case ToleranceSystemState.depleted:
      return Colors.red.shade900;
  }
}
