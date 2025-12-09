// MIGRATION — Clean, theme-compliant version

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import 'activity_card.dart';
import 'activity_empty_state.dart';

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
    final sp = context.spacing;

    if (cravings.isEmpty) {
      return const ActivityEmptyState(
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
        padding: EdgeInsets.all(sp.lg),
        itemCount: cravings.length,
        itemBuilder: (context, index) {
          final craving = cravings[index];

          final timestamp =
              _parseTimestamp(craving['time'] ?? craving['date']);

          final intensity = (craving['intensity'] ?? 5).toDouble();

          return ActivityCard(
            title: craving['substance'] ?? 'Unknown Substance',
            subtitle:
                'Intensity: ${intensity.toStringAsFixed(1)}/10 • ${craving['location'] ?? 'No location'}',
            timestamp: timestamp,
            icon: Icons.favorite,
            accentColor: _getIntensityColor(context, intensity),
            badge: craving['action'] == 'Resisted' ? 'Resisted' : null,
            onTap: () => onCravingTap(craving),
          );
        },
      ),
    );
  }

  /// Intensity → theme-aware accent colors
  Color _getIntensityColor(BuildContext context, double intensity) {
    final c = context.colors;

    if (intensity >= 8) return c.error;
    if (intensity >= 5) return c.warning;
    return c.info;
  }
}
