import 'package:flutter/material.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Review for theme/context migration if needed.

class SubstanceList extends StatelessWidget {
  final List<Map<String, dynamic>> substances;
  final Function(String) onSubstanceSelected;

  const SubstanceList({
    super.key,
    required this.substances,
    required this.onSubstanceSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (substances.isEmpty) {
      return const Center(
        child: Text('No substances found.'),
      );
    }

    return ListView.builder(
      itemCount: substances.length,
      itemBuilder: (context, index) {
        final substance = substances[index];
        final name = substance['pretty_name'] ?? substance['name'] ?? '';
        final categories = substance['categories'] as List<dynamic>? ?? [];
        final description = substance['description'] ?? '';

        return ListTile(
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categories.isNotEmpty)
                Wrap(
                  spacing: 4.0,
                  children: categories.map<Widget>((category) {
                    return Chip(
                      label: Text(category.toString()),
                      labelStyle: const TextStyle(fontSize: 12.0),


                    );
                  }).toList(),
                ),
              if (description.isNotEmpty)
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          onTap: () => onSubstanceSelected(name),
        );
      },
    );
  }
}