import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_use_catalog.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/buttons/common_chip.dart';
import '../../common/layout/common_spacer.dart';

class FeelingsCard extends StatelessWidget {
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;

  final ValueChanged<List<String>> onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryFeelingsChanged;

  const FeelingsCard({
    super.key,
    required this.feelings,
    required this.secondaryFeelings,
    required this.onFeelingsChanged,
    required this.onSecondaryFeelingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "How are you feeling?",
            subtitle: "Select primary feelings and optionally refine them",
          ),

          const CommonSpacer.vertical(ThemeConstants.space16),

          /// ⭐ PRIMARY FEELINGS
          _buildPrimaryFeelings(context, isDark),

          /// ⭐ SECONDARY FEELINGS
          if (feelings.isNotEmpty) ...[
            const CommonSpacer.vertical(ThemeConstants.space20),
            _buildSecondaryFeelings(context, isDark),
          ],
        ],
      ),
    );
  }

  // ----------------------------
  // PRIMARY FEELINGS
  // ----------------------------

  Widget _buildPrimaryFeelings(BuildContext context, bool isDark) {
    return Wrap(
      spacing: ThemeConstants.space12,
      runSpacing: ThemeConstants.space12,
      children: DrugUseCatalog.primaryEmotions.map((emotion) {
        final name = emotion['name']!;
        final emoji = emotion['emoji']!;
        final isSelected = feelings.contains(name);
        final accentColor = _getEmotionColor(name, isDark);

        return CommonChip(
          label: name,
          emoji: emoji,
          isSelected: isSelected,
          showGlow: true,
          selectedColor: accentColor,
          selectedBorderColor: accentColor,
          onTap: () => _togglePrimaryFeeling(name),
        );
      }).toList(),
    );
  }

  void _togglePrimaryFeeling(String feeling) {
    final updated = List<String>.from(feelings);

    if (updated.contains(feeling)) {
      updated.remove(feeling);

      // remove all secondary feelings belonging to this primary
      final newSecondary = Map<String, List<String>>.from(secondaryFeelings)
        ..remove(feeling);

      onSecondaryFeelingsChanged(newSecondary);
    } else {
      updated.add(feeling);
    }

    onFeelingsChanged(updated);
  }

  // ----------------------------
  // SECONDARY FEELINGS
  // ----------------------------

  Widget _buildSecondaryFeelings(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: feelings.map((primary) {
        final options = DrugUseCatalog.secondaryEmotions[primary] ?? [];
        if (options.isEmpty) return const SizedBox.shrink();

        final selected = secondaryFeelings[primary] ?? [];
        final accentColor = _getEmotionColor(primary, isDark);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "More specific ($primary):",
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),

            const CommonSpacer.vertical(ThemeConstants.space8),

            Wrap(
              spacing: ThemeConstants.space8,
              runSpacing: ThemeConstants.space8,
              children: options.map((sec) {
                final isSelected = selected.contains(sec);

                return CommonChip(
                  label: sec,
                  isSelected: isSelected,
                  showGlow: false,
                  selectedColor: accentColor,
                  selectedBorderColor: accentColor,
                  onTap: () => _toggleSecondary(primary, sec),
                );
              }).toList(),
            ),

            const CommonSpacer.vertical(ThemeConstants.space16),
          ],
        );
      }).toList(),
    );
  }

  void _toggleSecondary(String primary, String sec) {
    final updated = Map<String, List<String>>.from(secondaryFeelings);
    final list = List<String>.from(updated[primary] ?? []);

    if (list.contains(sec)) {
      list.remove(sec);
    } else {
      list.add(sec);
    }

    updated[primary] = list;
    onSecondaryFeelingsChanged(updated);
  }

  // ----------------------------
  // EMOTION -> ACCENT COLOR
  // ----------------------------

  Color _getEmotionColor(String emotion, bool isDark) {
    if (isDark) {
      switch (emotion) {
        case 'Happy': return Colors.greenAccent;
        case 'Calm': return Colors.cyanAccent;
        case 'Anxious': return Colors.orangeAccent;
        case 'Surprised': return Colors.purpleAccent;
        case 'Sad': return Colors.blueAccent;
        case 'Disgusted': return Colors.tealAccent;
        case 'Angry': return Colors.redAccent;
        case 'Excited': return Colors.pinkAccent;
        default: return Colors.blueAccent;
      }
    } else {
      switch (emotion) {
        case 'Happy': return Colors.green;
        case 'Calm': return Colors.teal;
        case 'Anxious': return Colors.orange;
        case 'Surprised': return Colors.purple;
        case 'Sad': return Colors.blue;
        case 'Disgusted': return Colors.teal;
        case 'Angry': return Colors.red;
        case 'Excited': return Colors.pink;
        default: return Colors.blue;
      }
    }
  }
}
