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
    final t = AppTheme.of(context);
    
    return Container(
      padding: EdgeInsets.all(t.spacing.m),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
        border: Border.all(color: t.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: t.colors.primary),
              SizedBox(width: t.spacing.s),
              Text(
                'Craving Details',
                style: t.typography.titleMedium.copyWith(
                  color: t.colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.m),
          
          Text(
            'What were you craving?',
            style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          ),
          SizedBox(height: t.spacing.s),
          Wrap(
            spacing: t.spacing.xs,
            runSpacing: t.spacing.xs,
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
                selectedColor: t.colors.primaryContainer,
                checkmarkColor: t.colors.onPrimaryContainer,
                labelStyle: t.typography.bodyMedium.copyWith(
                  color: isSelected ? t.colors.onPrimaryContainer : t.colors.onSurface,
                ),
                backgroundColor: t.colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusS),
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : t.colors.outline,
                  ),
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: t.spacing.l),
          
          Text(
            'Intensity: /10',
            style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          ),
          Slider(
            value: intensity,
            min: 0,
            max: 10,
            divisions: 10,
            label: intensity.round().toString(),
            onChanged: onIntensityChanged,
            activeColor: t.colors.primary,
            inactiveColor: t.colors.surfaceContainerHighest,
          ),
          
          SizedBox(height: t.spacing.m),
          
          DropdownButtonFormField<String>(
            value: location.isEmpty ? null : location,
            decoration: InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(t.shapes.radiusM)),
              contentPadding: EdgeInsets.symmetric(horizontal: t.spacing.m, vertical: t.spacing.s),
            ),
            items: DrugUseCatalog.locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
            onChanged: (v) {
              if (v != null) onLocationChanged(v);
            },
          ),
          
          SizedBox(height: t.spacing.m),
          
          DropdownButtonFormField<String>(
            value: withWho?.isEmpty == true ? null : withWho,
            decoration: InputDecoration(
              labelText: 'Who were you with?',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(t.shapes.radiusM)),
              contentPadding: EdgeInsets.symmetric(horizontal: t.spacing.m, vertical: t.spacing.s),
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

