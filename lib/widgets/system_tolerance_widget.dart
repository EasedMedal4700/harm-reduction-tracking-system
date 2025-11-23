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
  final report = await ToleranceEngineService.getToleranceReport(
    userId: userId,
  );
  return SystemToleranceData(report.tolerances, report.states);
}

/// Minimal widget to display system-wide tolerance
Widget buildSystemToleranceSection(SystemToleranceData data) {
  // We can't easily access context here since it's a function,
  // but we can infer dark mode if needed or just use neutral colors.
  // Ideally this should be a StatelessWidget to access Theme.
  // For now, we'll use a generic card style.

  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.black.withOpacity(0.05)),
    ),
    color: Colors.white,
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Tolerance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...kToleranceBuckets.map((bucket) {
            final percent = data.percents[bucket] ?? 0.0;
            final state = data.states[bucket] ?? ToleranceSystemState.recovered;
            return _buildBucketRow(bucket, percent, state);
          }),
        ],
      ),
    ),
  );
}

/// Build single bucket row
Widget _buildBucketRow(
  String bucket,
  double percent,
  ToleranceSystemState state,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatBucketName(bucket),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            Text(
              '${percent.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getStateColor(state),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '— ${state.displayName}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
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
