// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
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
    final t = context.theme;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(title: "Route of Administration"),
          SizedBox(height: t.spacing.md),

          Wrap(
            spacing: t.spacing.sm,
            runSpacing: t.spacing.sm,
            children: DrugUseCatalog.consumptionMethods.map((method) {
              final String name = method['name']!;
              final String emoji = method['emoji']!;

              final bool selected = route == name;

              return ChoiceChip(
                label: Row(
                  mainAxisSize: AppLayout.mainAxisSizeMin,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 20.0)),
                    SizedBox(width: t.spacing.xs),
                    Text(
                      name.toUpperCase(),
                      style: t.typography.label.copyWith(
                        fontWeight: t.text.bodyBold.fontWeight,
                        color: selected
                            ? t.colors.textInverse
                            : t.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                selected: selected,
                selectedColor: t.accent.primary,
                backgroundColor: t.colors.surfaceVariant,
                onSelected: (_) => onRouteChanged(name),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                  side: BorderSide(
                    color: selected ? t.accent.primary : t.colors.border,
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
