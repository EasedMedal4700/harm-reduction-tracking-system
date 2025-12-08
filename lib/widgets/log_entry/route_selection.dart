// filepath: lib/widgets/log_entry/route_selection.dart

import 'package:flutter/material.dart';
import '../../constants/data/drug_use_catalog.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';

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
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(title: "Route of Administration"),
          const SizedBox(height: AppThemeConstants.spaceMd),

          Wrap(
            spacing: AppThemeConstants.spaceSm,
            runSpacing: AppThemeConstants.spaceSm,
            children: DrugUseCatalog.consumptionMethods.map((method) {
              final String name = method['name']!;
              final String emoji = method['emoji']!;

              final bool selected = route == name;

              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: AppThemeConstants.spaceXs),
                    Text(
                      name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                selected: selected,
                selectedColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                onSelected: (_) => onRouteChanged(name),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
