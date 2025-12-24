/// Represents a stockpile item for a substance (local-only storage)
class StockpileItem {
  final String substanceId;
  final double totalAddedMg; // Total ever added (historical max)
  final double currentAmountMg; // Current remaining amount
  final double? unitMg; // mg per pill/capsule (optional)
  final DateTime createdAt;
  final DateTime updatedAt;
  StockpileItem({
    required this.substanceId,
    required this.totalAddedMg,
    required this.currentAmountMg,
    this.unitMg,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a StockpileItem from JSON data
  factory StockpileItem.fromJson(Map<String, dynamic> json) {
    return StockpileItem(
      substanceId: json['substanceId'] as String,
      totalAddedMg: (json['totalAddedMg'] as num).toDouble(),
      currentAmountMg: (json['currentAmountMg'] as num).toDouble(),
      unitMg: json['unitMg'] != null
          ? (json['unitMg'] as num).toDouble()
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Converts this StockpileItem to JSON data
  Map<String, dynamic> toJson() {
    return {
      'substanceId': substanceId,
      'totalAddedMg': totalAddedMg,
      'currentAmountMg': currentAmountMg,
      'unitMg': unitMg,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Creates a copy with updated fields
  StockpileItem copyWith({
    String? substanceId,
    double? totalAddedMg,
    double? currentAmountMg,
    double? unitMg,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockpileItem(
      substanceId: substanceId ?? this.substanceId,
      totalAddedMg: totalAddedMg ?? this.totalAddedMg,
      currentAmountMg: currentAmountMg ?? this.currentAmountMg,
      unitMg: unitMg ?? this.unitMg,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get stockpile percentage (0-100)
  double getPercentage() {
    if (totalAddedMg <= 0) return 0.0;
    return (currentAmountMg / totalAddedMg) * 100;
  }

  /// Check if stockpile is low (< 20%)
  bool isLow() {
    return getPercentage() < 20;
  }

  /// Check if stockpile is empty
  bool isEmpty() {
    return currentAmountMg <= 0;
  }

  @override
  String toString() {
    return 'StockpileItem(substance: $substanceId, current: ${currentAmountMg}mg, total: ${totalAddedMg}mg, ${getPercentage().toStringAsFixed(1)}%)';
  }
}
