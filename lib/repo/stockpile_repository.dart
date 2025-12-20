import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stockpile_item.dart';

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
      print('Error parsing stockpile for $substanceId: $e');
      return null;
    }
  }

  /// Get stockpile percentage (0-100, returns 0 if doesn't exist)
  Future<double> getStockpilePercentage(String substanceId) async {
    final item = await getStockpile(substanceId);
    return item?.getPercentage() ?? 0.0;
  }

  /// Get all stockpile items
  Future<List<StockpileItem>> getAllStockpiles() async {
    final prefs = await SharedPreferences.getInstance();
    final itemIdsJson = prefs.getString(_allItemsKey);

    if (itemIdsJson == null) return [];

    try {
      final itemIds = (jsonDecode(itemIdsJson) as List<dynamic>)
          .map((e) => e as String)
          .toList();

      final items = <StockpileItem>[];
      for (final id in itemIds) {
        final item = await getStockpile(id);
        if (item != null) {
          items.add(item);
        }
      }

      return items;
    } catch (e) {
      print('Error loading all stockpiles: $e');
      return [];
    }
  }

  /// Delete stockpile for a substance
  Future<void> deleteStockpile(String substanceId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + substanceId;

    await prefs.remove(key);
    await _removeFromAllItemsList(substanceId);
  }

  /// Clear all stockpiles
  Future<void> clearAllStockpiles() async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getAllStockpiles();

    for (final item in items) {
      final key = _keyPrefix + item.substanceId;
      await prefs.remove(key);
    }

    await prefs.remove(_allItemsKey);
  }

  /// Update the list of all item IDs
  Future<void> _updateAllItemsList(String substanceId) async {
    final prefs = await SharedPreferences.getInstance();
    final itemIdsJson = prefs.getString(_allItemsKey);

    List<String> itemIds;
    if (itemIdsJson != null) {
      try {
        itemIds = (jsonDecode(itemIdsJson) as List<dynamic>)
            .map((e) => e as String)
            .toList();
      } catch (e) {
        itemIds = [];
      }
    } else {
      itemIds = [];
    }

    if (!itemIds.contains(substanceId)) {
      itemIds.add(substanceId);
      await prefs.setString(_allItemsKey, jsonEncode(itemIds));
    }
  }

  /// Remove from the list of all item IDs
  Future<void> _removeFromAllItemsList(String substanceId) async {
    final prefs = await SharedPreferences.getInstance();
    final itemIdsJson = prefs.getString(_allItemsKey);

    if (itemIdsJson == null) return;

    try {
      final itemIds = (jsonDecode(itemIdsJson) as List<dynamic>)
          .map((e) => e as String)
          .toList();

      itemIds.remove(substanceId);
      await prefs.setString(_allItemsKey, jsonEncode(itemIds));
    } catch (e) {
      print('Error removing from all items list: $e');
    }
  }

  /// Get total value of all stockpiles (in mg)
  Future<double> getTotalStockpileValue() async {
    final items = await getAllStockpiles();
    double total = 0.0;
    for (final item in items) {
      total += item.currentAmountMg;
    }
    return total;
  }

  /// Get count of substances with stockpile
  Future<int> getStockpileCount() async {
    final items = await getAllStockpiles();
    return items.where((item) => !item.isEmpty()).length;
  }
}
