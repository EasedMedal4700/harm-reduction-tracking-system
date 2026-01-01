// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Route of administration card.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/buttons/common_chip.dart';
import '../../../../constants/data/drug_use_catalog.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class RouteOfAdministrationCard extends StatelessWidget {
  final String route;
  final ValueChanged<String> onRouteChanged;
  final List<String> availableROAs;
  final bool Function(String)? isROAValidated;
  const RouteOfAdministrationCard({
    super.key,
    required this.route,
    required this.onRouteChanged,
    required this.availableROAs,
    this.isROAValidated,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(
            title: "Route of Administration",
            subtitle: "How the substance was taken",
          ),
          CommonSpacer.vertical(th.sp.md),
          Wrap(
            spacing: th.sp.sm,
            runSpacing: th.sp.sm,
            children: availableROAs.map((method) {
              final selected = route.toLowerCase() == method.toLowerCase();
              final validated = isROAValidated?.call(method) ?? true;
              final emoji = _emojiForROA(method);
              final accent = _accentColorForROA(context, validated);
              return CommonChip(
                label: _capitalize(method),
                emoji: emoji,
                isSelected: selected,
                showGlow: selected,
                selectedColor: accent,
                selectedBorderColor: accent,
                onTap: () => onRouteChanged(method),
                icon: validated ? null : Icons.warning_amber_rounded,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------
  String _emojiForROA(String name) {
    final entry = DrugUseCatalog.consumptionMethods.firstWhere(
      (m) => m['name']!.toLowerCase() == name.toLowerCase(),
      orElse: () => {'emoji': '', 'name': name},
    );
    return entry['emoji']!;
  }

  Color _accentColorForROA(BuildContext context, bool validated) {
    final c = context.colors;
    final ac = context.accent;
    if (!validated) {
      return c.warning;
    }
    return ac.primary;
  }

  String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}
