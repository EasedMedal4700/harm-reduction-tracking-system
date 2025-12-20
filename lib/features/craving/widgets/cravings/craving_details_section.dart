// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonChipGroup.

// ignore_for_file: deprecated_member_use
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';

import '../../../../constants/data/craving_consatnts.dart';
import '../../../../constants/data/drug_use_catalog.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/buttons/common_chip_group.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/inputs/dropdown.dart';

class CravingDetailsSection extends StatelessWidget {
  final List<String> selectedCravings;
  final ValueChanged<List<String>> onCravingsChanged;
  final double intensity;
  final ValueChanged<double> onIntensityChanged;
  final String location;
  final ValueChanged<String?> onLocationChanged;
  final String? withWho;
  final ValueChanged<String?> onWithWhoChanged;

  const CravingDetailsSection({
    super.key,
    required this.selectedCravings,
    required this.onCravingsChanged,
    required this.intensity,
    required this.onIntensityChanged,
    required this.location,
    required this.onLocationChanged,
    required this.withWho,
    required this.onWithWhoChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final text = context.text;
    final a = context.accent;
    final sp = context.spacing;

    return CommonCard(
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: a.primary, size: t.sizes.iconMd),
              CommonSpacer.horizontal(sp.sm),
              Text(
                'Craving Details',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: text.bodyBold.fontWeight,
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),

          CommonChipGroup(
            title: 'What were you craving?',
            options: cravingCategories.keys.toList(),
            selected: selectedCravings,
            onChanged: onCravingsChanged,
            allowMultiple: true,
          ),

          CommonSpacer.vertical(sp.lg),

          Text(
            'Intensity: ${intensity.round()}/10',
            style: t.typography.body.copyWith(color: c.textPrimary),
          ),
          Slider(
            value: intensity,
            min: 0,
            max: 10,
            divisions: 10,
            label: intensity.round().toString(),
            onChanged: onIntensityChanged,
            activeColor: a.primary,
            inactiveColor: c.border,
          ),

          CommonSpacer.vertical(sp.md),

          CommonDropdown<String>(
            value: location.isEmpty ? null : location,
            hintText: 'Location',
            items: DrugUseCatalog.locations,
            onChanged: (v) {
              if (v != null) onLocationChanged(v);
            },
          ),

          const CommonSpacer.vertical(16),

          CommonDropdown<String>(
            value: withWho?.isEmpty == true ? null : withWho,
            hintText: 'Who were you with?',
            items: const ['Alone', 'Friends', 'Family', 'Other'],
            onChanged: onWithWhoChanged,
          ),
        ],
      ),
    );
  }
}
