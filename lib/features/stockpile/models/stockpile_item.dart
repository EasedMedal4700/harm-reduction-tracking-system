// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
// Represents a stockpile item for a substance (local-only storage)
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stockpile_item.freezed.dart';

DateTime _dateTimeFromAny(Object? v) {
  if (v is DateTime) return v;
  if (v is String && v.isNotEmpty) {
    return DateTime.tryParse(v) ?? DateTime.now();
  }
  return DateTime.now();
}

String _dateTimeToIsoString(DateTime v) => v.toIso8601String();

@freezed
abstract class StockpileItem with _$StockpileItem {
  const factory StockpileItem({
    required String substanceId,
    required double totalAddedMg,
    required double currentAmountMg,
    double? unitMg,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StockpileItem;

  const StockpileItem._();

  factory StockpileItem.fromJson(Map<String, dynamic> json) {
    return StockpileItem(
      substanceId:
          json['substanceId']?.toString() ??
          json['substance_id']?.toString() ??
          '',
      totalAddedMg:
          (json['totalAddedMg'] as num?)?.toDouble() ??
          (json['total_added_mg'] as num?)?.toDouble() ??
          0.0,
      currentAmountMg:
          (json['currentAmountMg'] as num?)?.toDouble() ??
          (json['current_amount_mg'] as num?)?.toDouble() ??
          0.0,
      unitMg:
          (json['unitMg'] as num?)?.toDouble() ??
          (json['unit_mg'] as num?)?.toDouble(),
      createdAt: _dateTimeFromAny(json['createdAt'] ?? json['created_at']),
      updatedAt: _dateTimeFromAny(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'substanceId': substanceId,
    'totalAddedMg': totalAddedMg,
    'currentAmountMg': currentAmountMg,
    'unitMg': unitMg,
    'createdAt': _dateTimeToIsoString(createdAt),
    'updatedAt': _dateTimeToIsoString(updatedAt),
  };

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
