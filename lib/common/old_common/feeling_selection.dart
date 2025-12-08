// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\feeling_selection.dart
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('How are you feeling?'),
        Wrap(
          spacing: 8,
          children: DrugUseCatalog.primaryEmotions.map((f) {
            return ChoiceChip(
              label: Text(f['name']!.toUpperCase()),
              selected: feelings.contains(f['name']!),
              onSelected: (_) {
                final name = f['name']!;
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
            );
          }).toList(),
        ),
        if (feelings.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Secondary feelings? (Select multiple per primary)'),
          ...feelings.map((primary) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('For $primary:', style: const TextStyle(fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: (DrugUseCatalog.secondaryEmotions[primary] ?? []).map((sec) {
                    return ChoiceChip(
                      label: Text(sec),
                      selected: (secondaryFeelings[primary] ?? []).contains(sec),
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
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ],
    );
  }
}