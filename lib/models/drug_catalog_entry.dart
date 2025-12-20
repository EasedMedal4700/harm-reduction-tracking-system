class DrugCatalogEntry {
  const DrugCatalogEntry({
    required this.name,
    required this.categories,
    required this.totalUses,
    required this.avgDose,
    required this.lastUsed,
    required this.weekdayUsage,
    required this.favorite,
    required this.archived,
    required this.notes,
    required this.quantity,
  });

  final String name;
  final List<String> categories;
  final int totalUses;
  final double avgDose;
  final DateTime? lastUsed;
  final WeekdayUsage weekdayUsage;
  final bool favorite;
  final bool archived;
  final String notes;
  final num quantity;

  DrugCatalogEntry copyWith({bool? favorite, bool? archived}) {
    return DrugCatalogEntry(
      name: name,
      categories: categories,
      totalUses: totalUses,
      avgDose: avgDose,
      lastUsed: lastUsed,
      weekdayUsage: weekdayUsage,
      favorite: favorite ?? this.favorite,
      archived: archived ?? this.archived,
      notes: notes,
      quantity: quantity,
    );
  }
}

class WeekdayUsage {
  const WeekdayUsage({
    required this.counts,
    required this.mostActive,
    required this.leastActive,
  });

  final List<int> counts;
  final int mostActive;
  final int leastActive;
}

class LocalPrefs {
  const LocalPrefs({
    required this.favorite,
    required this.archived,
    required this.notes,
    required this.quantity,
  });

  final bool favorite;
  final bool archived;
  final String notes;
  final num quantity;
}
