import 'package:flutter/material.dart';

class ReflectionSelection extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final Set<String> selectedIds;
  final Function(String id, bool selected) onEntryChanged; // Change to function
  final VoidCallback onNext;

  const ReflectionSelection({
    super.key,
    required this.entries,
    required this.selectedIds,
    required this.onEntryChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Recent Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...entries.map((entry) => CheckboxListTile(
            key: ValueKey(entry['use_id']),
            title: Text('${entry['name']} - ${entry['dose']}'),
            subtitle: Text('${DateTime.parse(entry['start_time']).toLocal()} - ${entry['place']}'),
            value: selectedIds.contains(entry['use_id']?.toString()),
            onChanged: (selected) => onEntryChanged(entry['use_id']?.toString() ?? '', selected ?? false), // Pass id and selected
          )),
          if (selectedIds.isNotEmpty)
            ElevatedButton(
              onPressed: onNext,
              child: const Text('Next'),
            ),
        ],
      ),
    );
  }
}