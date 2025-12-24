// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonChipGroup.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../common/buttons/common_chip_group.dart';
import '../../../../common/cards/common_card.dart';

class EmotionSelector extends StatelessWidget {
  final List<String> selectedEmotions;
  final List<String> availableEmotions;
  final Function(String) onEmotionToggled;
  const EmotionSelector({
    super.key,
    required this.selectedEmotions,
    required this.availableEmotions,
    required this.onEmotionToggled,
  });
  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonChipGroup(
            title: 'Emotions',
            subtitle: 'Select up to a few that match how you feel',
            options: availableEmotions,
            selected: selectedEmotions,
            onChanged: (newList) {
              // Calculate difference to maintain API compatibility
              final oldSet = selectedEmotions.toSet();
              final newSet = newList.toSet();
              final added = newSet.difference(oldSet);
              final removed = oldSet.difference(newSet);
              if (added.isNotEmpty) {
                onEmotionToggled(added.first);
              } else if (removed.isNotEmpty) {
                onEmotionToggled(removed.first);
              }
            },
            allowMultiple: true,
          ),
        ],
      ),
    );
  }
}
