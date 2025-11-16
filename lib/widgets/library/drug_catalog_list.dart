import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/drug_catalog_entry.dart';

class DrugCatalogList extends StatelessWidget {
  final List<DrugCatalogEntry> entries;
  final Function(DrugCatalogEntry) onToggleFavorite;

  const DrugCatalogList({
    super.key,
    required this.entries,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text('No drugs found.'));
    }

    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final drug = entries[index];
        return DrugCatalogTile(
          drug: drug,
          onToggleFavorite: () => onToggleFavorite(drug),
        );
      },
    );
  }
}

class DrugCatalogTile extends StatelessWidget {
  final DrugCatalogEntry drug;
  final VoidCallback onToggleFavorite;

  const DrugCatalogTile({
    super.key,
    required this.drug,
    required this.onToggleFavorite,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(drug.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categories: ${drug.categories.join(', ')}'),
          Text('Total uses: ${drug.totalUses}'),
          Text('Average dose: ${drug.avgDose.toStringAsFixed(2)}'),
          Text('Last used: ${_formatDate(drug.lastUsed)}'),
          Text('Most active day: ${drug.weekdayUsage.mostActive}'),
          Text('Least active day: ${drug.weekdayUsage.leastActive}'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(drug.favorite ? Icons.star : Icons.star_border),
        onPressed: onToggleFavorite,
      ),
    );
  }
}
