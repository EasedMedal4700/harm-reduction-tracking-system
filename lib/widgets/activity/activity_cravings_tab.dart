// MIGRATION

import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';
import '../../constants/theme/app_theme.dart';


class ActivityCravingsTab extends StatelessWidget {
  final List cravings;
  final Function(Map<String, dynamic>) onCravingTap;
  final Future<void> Function() onRefresh;

  const ActivityCravingsTab({
    super.key,
    required this.cravings,
    required this.onCravingTap,
    required this.onRefresh,
  });

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is DateTime) return timestamp;

    try {
      return DateTime.parse(timestamp.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    if (cravings.isEmpty) {
      return ActivityEmptyState(
        icon: Icons.favorite_border,
        title: 'No Cravings Logged',
        subtitle: 'Your craving records will appear here',
      );
    }

    return RefreshIndicator(
      color: t.accent.primary,
      backgroundColor: t.colors.surface,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(t.spacing.lg),
        itemCount: cravings.length,
        itemBuilder: (context, index) {
          final craving = cravings[index];
          final timestamp = _parseTimestamp(craving['time'] ?? craving['date']);
          final intensity = (craving['intensity'] ?? 5).toDouble();

          return ActivityCard(
            title: craving['substance'] ?? 'Unknown Substance',
            subtitle:
                'Intensity: ${intensity.toStringAsFixed(1)}/10 • ${craving['location'] ?? 'No location'}',
            timestamp: timestamp,
            icon: Icons.favorite,
            accentColor: _getIntensityColor(intensity, t),
            badge: craving['action'] == 'Resisted' ? 'Resisted' : null,
            onTap: () => onCravingTap(craving),
          );
        },
      ),
    );
  }

  /// Intensity → theme-aware accent colors
  Color _getIntensityColor(double intensity, AppTheme t) {
    if (intensity >= 8) return t.colors.error;
    if (intensity >= 5) return t.colors.warning;
    return t.colors.info;
  }
}
