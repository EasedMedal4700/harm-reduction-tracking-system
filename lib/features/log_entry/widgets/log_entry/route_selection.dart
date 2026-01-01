// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Route selection widget.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/data/drug_use_catalog.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';

class RouteSelection extends StatelessWidget {
  final String route;
  final ValueChanged<String> onRouteChanged;
  const RouteSelection({
    super.key,
    required this.route,
    required this.onRouteChanged,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(title: "Route of Administration"),
          SizedBox(height: th.sp.md),
          Wrap(
            spacing: th.sp.sm,
            runSpacing: th.sp.sm,
            children: DrugUseCatalog.consumptionMethods.map((method) {
              final String name = method['name']!;
              final String emoji = method['emoji']!;
              final bool selected = route == name;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: AppLayout.mainAxisSizeMin,
                  children: [
                    Text(emoji, style: TextStyle(fontSize: th.sizes.iconLg)),
                    SizedBox(width: th.sp.xs),
                    Text(
                      name.toUpperCase(),
                      style: th.text.bodyBold.copyWith(
                        color: selected
                            ? th.colors.textInverse
                            : th.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                selected: selected,
                selectedColor: th.accent.primary,
                backgroundColor: th.colors.surfaceVariant,
                onSelected: (_) => onRouteChanged(name),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                  side: BorderSide(
                    color: selected ? th.accent.primary : th.colors.border,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
