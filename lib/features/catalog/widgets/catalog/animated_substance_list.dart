import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
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
    final t = context.theme;

    return ListView.builder(
      padding: EdgeInsets.all(t.spacing.md),
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
