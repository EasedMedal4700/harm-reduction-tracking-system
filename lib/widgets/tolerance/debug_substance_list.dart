import 'package:flutter/material.dart';

/// Debug widget showing per-substance tolerance percentages
class DebugSubstanceList extends StatelessWidget {
  final Map<String, double> perSubstanceTolerances;
  final bool isLoading;

  const DebugSubstanceList({
    required this.perSubstanceTolerances,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DEBUG: Per-substance tolerance',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (perSubstanceTolerances.isEmpty)
              const Text('No data')
            else
              ...perSubstanceTolerances.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key, style: const TextStyle(fontSize: 14)),
                      Text(
                        '${e.value.toStringAsFixed(1)} %',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
