import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import '../../constants/data/drug_use_catalog.dart';

class FeelingSelection extends StatelessWidget {
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final ValueChanged<List<String>> onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryFeelingsChanged;

  const FeelingSelection({
    super.key,
    required this.feelings,
    required this.secondaryFeelings,
    required this.onFeelingsChanged,
    required this.onSecondaryFeelingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style: t.typography.titleMedium.copyWith(
            color: t.colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: t.spacing.s),
        Wrap(
          spacing: t.spacing.s,
          runSpacing: t.spacing.s,
          children: DrugUseCatalog.primaryEmotions.map((f) {
            final name = f['name']!;
            final isSelected = feelings.contains(name);
            return FilterChip(
              label: Text(name.toUpperCase()),
              selected: isSelected,
              onSelected: (_) {
                final newFeelings = List<String>.from(feelings);
                final newSecondary = Map<String, List<String>>.from(secondaryFeelings);
                if (newFeelings.contains(name)) {
                  newFeelings.remove(name);
                  newSecondary.remove(name);
                } else {
                  newFeelings.add(name);
                }
                onFeelingsChanged(newFeelings);
                onSecondaryFeelingsChanged(newSecondary);
              },
              selectedColor: t.colors.primaryContainer,
              checkmarkColor: t.colors.onPrimaryContainer,
              labelStyle: t.typography.labelLarge.copyWith(
                color: isSelected ? t.colors.onPrimaryContainer : t.colors.onSurface,
                fontWeight: FontWeight.bold,
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
        if (feelings.isNotEmpty) ...[
          SizedBox(height: t.spacing.l),
          Text(
            'Secondary feelings? (Select multiple per primary)',
            style: t.typography.bodyMedium.copyWith(
              color: t.colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: t.spacing.m),
          ...feelings.map((primary) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'For $primary:',
                  style: t.typography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: t.colors.onSurface,
                  ),
                ),
                SizedBox(height: t.spacing.xs),
                Wrap(
                  spacing: t.spacing.s,
                  runSpacing: t.spacing.s,
                  children: (DrugUseCatalog.secondaryEmotions[primary] ?? []).map((sec) {
                    final isSelected = (secondaryFeelings[primary] ?? []).contains(sec);
                    return FilterChip(
                      label: Text(sec),
                      selected: isSelected,
                      onSelected: (_) {
                        final newSecondary = Map<String, List<String>>.from(secondaryFeelings);
                        newSecondary[primary] ??= [];
                        if (newSecondary[primary]!.contains(sec)) {
                          newSecondary[primary]!.remove(sec);
                        } else {
                          newSecondary[primary]!.add(sec);
                        }
                        onSecondaryFeelingsChanged(newSecondary);
                      },
                      selectedColor: t.colors.secondaryContainer,
                      checkmarkColor: t.colors.onSecondaryContainer,
                      labelStyle: t.typography.bodyMedium.copyWith(
                        color: isSelected ? t.colors.onSecondaryContainer : t.colors.onSurface,
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
                SizedBox(height: t.spacing.m),
              ],
            );
          }),
        ],
      ],
    );
  }
}

