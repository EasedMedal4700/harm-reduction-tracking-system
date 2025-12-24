import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stockpile_item.dart';
import '../common/logging/app_log.dart';

/// Repository for managing local stockpile data using SharedPreferences
class StockpileRepository {
  static const String _keyPrefix = 'stockpile_';
  static const String _allItemsKey = 'stockpile_all_items';

  /// Add amount to stockpile (creates if doesn't exist)
  Future<void> addToStockpile(
    String substanceId,
    double amountMg, {
    double? unitMg,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + substanceId;

    StockpileItem item;
    final existing = await getStockpile(substanceId);

    if (existing != null) {
      // Update existing stockpile
      final newCurrent = existing.currentAmountMg + amountMg;
      final newTotal = existing.totalAddedMg + amountMg;

      item = existing.copyWith(
        currentAmountMg: newCurrent,
        totalAddedMg: newTotal,
        unitMg: unitMg ?? existing.unitMg,
        updatedAt: DateTime.now(),
      );
    } else {
      // Create new stockpile
      item = StockpileItem(
        substanceId: substanceId,
        totalAddedMg: amountMg,
        currentAmountMg: amountMg,
        unitMg: unitMg,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    // Save to SharedPreferences
    await prefs.setString(key, jsonEncode(item.toJson()));

    // Update all items list
    await _updateAllItemsList(substanceId);
  }

  /// Subtract amount from stockpile (clamps to 0 if result is negative)
  Future<void> subtractFromStockpile(
    String substanceId,
    double amountMg,
  ) async {
    final existing = await getStockpile(substanceId);
    if (existing == null) return; // No stockpile to subtract from

    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + substanceId;

    // Clamp to 0 if result would be negative
    final newCurrent = (existing.currentAmountMg - amountMg).clamp(
      0.0,
      double.infinity,
    );

    final updated = existing.copyWith(
      currentAmountMg: newCurrent,
      updatedAt: DateTime.now(),
    );

    await prefs.setString(key, jsonEncode(updated.toJson()));
  }

  /// Get stockpile for a substance (returns null if doesn't exist)
  Future<StockpileItem?> getStockpile(String substanceId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + substanceId;

    final jsonString = prefs.getString(key);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return StockpileItem.fromJson(json);
    } catch (e) {
      AppLog.e('Error parsing stockpile for $substanceId: $e');
      return null;
    }
  }

  /// Get stockpile percentage (0-100, returns 0 if doesn't exist)
  Future<double> getStockpilePercentage(String substanceId) async {
    final item = await getStockpile(substanceId);
    return item?.getPercentage() ?? 0.0;
  }

  /// Get all stockpile items
  Future<List<StockpileItem>> getAllStockpileItems() async {
    final prefs = await SharedPreferences.getInstance();
    final allItems = prefs.getStringList(_allItemsKey) ?? [];

    final items = <StockpileItem>[];
    for (final id in allItems) {
      final item = await getStockpile(id);
      if (item != null) {
        items.add(item);
      }
    }
    return items;
  }

  /// Alias for getAllStockpileItems to match test expectations
  Future<List<StockpileItem>> getAllStockpiles() => getAllStockpileItems();

  /// Delete a stockpile item
  Future<void> deleteStockpile(String substanceId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + substanceId;

    await prefs.remove(key);

    // Remove from all items list
    final allItems = prefs.getStringList(_allItemsKey) ?? [];
    if (allItems.contains(substanceId)) {
      allItems.remove(substanceId);
      await prefs.setStringList(_allItemsKey, allItems);
    }
  }

  /// Clear all stockpile items
  Future<void> clearAllStockpiles() async {
    final prefs = await SharedPreferences.getInstance();
    final allItems = prefs.getStringList(_allItemsKey) ?? [];

    for (final id in allItems) {
      await prefs.remove(_keyPrefix + id);
    }

    await prefs.remove(_allItemsKey);
  }

  /// Get total value of all stockpiles (sum of current amounts)
  Future<double> getTotalStockpileValue() async {
    final items = await getAllStockpileItems();
    return items.fold<double>(0.0, (sum, item) => sum + item.currentAmountMg);
  }

  /// Helper to update the list of all tracked substance IDs
  Future<void> _updateAllItemsList(String substanceId) async {
    final prefs = await SharedPreferences.getInstance();
    final allItems = prefs.getStringList(_allItemsKey) ?? [];

    if (!allItems.contains(substanceId)) {
      allItems.add(substanceId);
      await prefs.setStringList(_allItemsKey, allItems);
    }
  }
}
