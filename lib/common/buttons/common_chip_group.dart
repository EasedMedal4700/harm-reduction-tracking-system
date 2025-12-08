import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../cards/common_card.dart';
import '../text/common_section_header.dart';
import '../layout/common_spacer.dart';
import 'common_chip.dart';

/// A reusable chip group for multi- or single-select lists.
/// Optional header (title + subtitle).
/// If [showHeader] is false, NO header and NO header spacing is rendered.
class CommonChipGroup extends StatelessWidget {
  final String title;
  final String? subtitle;

  final List<String> options;
  final List<String> selected;

  final ValueChanged<List<String>> onChanged;

  final bool allowMultiple;
  final bool showGlow;

  /// NEW: Control header rendering
  final bool showHeader;

  /// Optional chip-level overrides
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;

  const CommonChipGroup({
    super.key,
    required this.title,
    this.subtitle,

    required this.options,
    required this.selected,
    required this.onChanged,

    this.allowMultiple = true,
    this.showGlow = true,

    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,

    this.showHeader = true, // Default: show header like normal cards
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Only render header when enabled
          if (showHeader) ...[
            CommonSectionHeader(
              title: title,
              subtitle: subtitle,
            ),
            const CommonSpacer.vertical(ThemeConstants.space12),
          ],

          Wrap(
            spacing: ThemeConstants.space8,
            runSpacing: ThemeConstants.space8,
            children: options.map((value) {
              final isSelected = selected.contains(value);

              return CommonChip(
                label: value,
                isSelected: isSelected,
                onTap: () {
                  List<String> updated = List.from(selected);

                  if (allowMultiple) {
                    isSelected ? updated.remove(value) : updated.add(value);
                  } else {
                    updated = [value];
                  }

                  onChanged(updated);
                },
                emoji: null,
                icon: null,
                showGlow: showGlow,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                selectedBorderColor: selectedBorderColor,
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
