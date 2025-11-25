import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';

class ActivityCravingsTab extends StatelessWidget {
  final List cravings;
  final bool isDark;
  final Function(Map<String, dynamic>) onCravingTap;
  final Future<void> Function() onRefresh;

  const ActivityCravingsTab({
    super.key,
    required this.cravings,
    required this.isDark,
    required this.onCravingTap,
    required this.onRefresh,
  });

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is DateTime) return timestamp;
    try {
      return DateTime.parse(timestamp.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cravings.isEmpty) {
      return ActivityEmptyState(
        icon: Icons.favorite_border,
        title: 'No Cravings Logged',
        subtitle: 'Your craving records will appear here',
        isDark: isDark,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(ThemeConstants.space16),
        itemCount: cravings.length,
        itemBuilder: (context, index) {
          final craving = cravings[index];
          final timestamp = _parseTimestamp(craving['time'] ?? craving['date']);
          final intensity = (craving['intensity'] ?? 5).toDouble();
          
          return ActivityCard(
            title: craving['substance'] ?? 'Unknown Substance',
            subtitle: 'Intensity: ${intensity.toStringAsFixed(1)}/10 • ${craving['location'] ?? 'No location'}',
            timestamp: timestamp,
            icon: Icons.favorite,
            accentColor: _getIntensityColor(intensity),
            badge: craving['action'] == 'Resisted' ? 'Resisted' : null,
            onTap: () => onCravingTap(craving),
          );
        },
      ),
    );
  }

  Color _getIntensityColor(double intensity) {
    if (intensity >= 8) return Colors.red;
    if (intensity >= 5) return Colors.orange;
    return Colors.yellow;
  }
}
