// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Initial migration header added. Not migrated yet.
import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import 'substance_card.dart';

class AnimatedSubstanceList extends StatelessWidget {
  final List<Map<String, dynamic>> substances;
  final bool isDark;
  final Function(Map<String, dynamic>) onSubstanceTap;
  final Function(String, String, Map<String, dynamic>) onAddStockpile;
  final Future<String?> Function(String) getMostActiveDay;

  const AnimatedSubstanceList({
    super.key,
    required this.substances,
    required this.isDark,
    required this.onSubstanceTap,
    required this.onAddStockpile,
    required this.getMostActiveDay,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ThemeConstants.homePagePadding),
      itemCount: substances.length,
      itemBuilder: (context, index) {
        final substance = substances[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 30)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: SubstanceCard(
                  substance: substance,
                  isDark: isDark,
                  onTap: () => onSubstanceTap(substance),
                  onAddStockpile: (substanceId, name, substance) =>
                      onAddStockpile(substanceId, name, substance),
                  getMostActiveDay: (name) => getMostActiveDay(name),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
