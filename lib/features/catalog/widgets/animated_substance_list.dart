// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Animated list of substances.
import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import 'substance_card.dart';

class AnimatedSubstanceList extends StatelessWidget {
  final List<Map<String, dynamic>> substances;
  final Function(Map<String, dynamic>) onSubstanceTap;
  final Function(String, String, Map<String, dynamic>) onAddStockpile;
  final Future<String?> Function(String) getMostActiveDay;
  const AnimatedSubstanceList({
    super.key,
    required this.substances,
    required this.onSubstanceTap,
    required this.onAddStockpile,
    required this.getMostActiveDay,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return ListView.builder(
      itemCount: substances.length,
      itemBuilder: (context, i) {
        final s = substances[i];
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: th.sp.xs,
          ),
          child: SubstanceCard(
            substance: s,
            onTap: () => onSubstanceTap(s),
            onAddStockpile: (substanceId, name, substance) =>
                onAddStockpile(substanceId, name, substance),
            getMostActiveDay: (name) => getMostActiveDay(name),
          ),
        );
      },
    );
  }
}
