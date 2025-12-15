import 'package:flutter/material.dart';
import '../../common/cards/common_card.dart';
import '../../common/text/common_section_header.dart';
import '../../common/layout/common_spacer.dart';
import '../../common/buttons/common_chip.dart';
import '../../constants/data/drug_use_catalog.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonSectionHeader(
            title: "Route of Administration",
            subtitle: "How the substance was taken",
          ),

          CommonSpacer.vertical(t.spacing.md),

          Wrap(
            spacing: t.spacing.sm,
            runSpacing: t.spacing.sm,
            children: availableROAs.map((method) {
              final selected =
                  route.toLowerCase() == method.toLowerCase();
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
    final t = context.theme;
    if (!validated) {
      return t.colors.warning;
    }
    return t.accent.primary;
  }

  String _capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}
