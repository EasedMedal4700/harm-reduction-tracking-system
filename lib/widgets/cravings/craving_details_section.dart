// ignore_for_file: deprecated_member_use
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import '../../constants/data/craving_consatnts.dart';
import '../../constants/data/drug_use_catalog.dart';

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
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;
    
    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: a.primary),
              SizedBox(width: sp.sm),
              Text(
                'Craving Details',
                style: t.typography.heading4.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: sp.md),
          
          Text(
            'What were you craving?',
            style: t.typography.body.copyWith(color: c.textPrimary),
          ),
          SizedBox(height: sp.sm),
          Wrap(
            spacing: sp.xs,
            runSpacing: sp.xs,
            children: cravingCategories.entries.map((entry) {
              final isSelected = selectedCravings.contains(entry.key);
              return FilterChip(
                label: Text(entry.key),
                selected: isSelected,
                onSelected: (selected) => onCravingsChanged(
                  selected
                      ? [...selectedCravings, entry.key]
                      : selectedCravings.where((c) => c != entry.key).toList(),
                ),
                selectedColor: a.primary.withValues(alpha: 0.2),
                checkmarkColor: a.primary,
                labelStyle: t.typography.body.copyWith(
                  color: isSelected ? a.primary : c.textPrimary,
                ),
                backgroundColor: c.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : c.border,
                  ),
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: sp.lg),
          
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
          
          SizedBox(height: sp.md),
          
          DropdownButtonFormField<String>(
            value: location.isEmpty ? null : location,
            decoration: InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(sh.radiusMd)),
              contentPadding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
            ),
            items: DrugUseCatalog.locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
            onChanged: (v) {
              if (v != null) onLocationChanged(v);
            },
          ),
          
          SizedBox(height: sp.md),
          
          DropdownButtonFormField<String>(
            value: withWho?.isEmpty == true ? null : withWho,
            decoration: InputDecoration(
              labelText: 'Who were you with?',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(sh.radiusMd)),
              contentPadding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
            ),
            items: const ['Alone', 'Friends', 'Family', 'Other']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onWithWhoChanged,
          ),
        ],
      ),
    );
  }
}

