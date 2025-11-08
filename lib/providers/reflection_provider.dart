// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\providers\reflection_provider.dart
import 'package:flutter/material.dart';
import '../models/reflection_model.dart';
import '../services/reflection_service.dart';

class ReflectionProvider with ChangeNotifier {
  Reflection _reflection = Reflection();
  Set<String> _selectedIds = {};
  bool _showForm = false;
  bool _isSaving = false;

  Reflection get reflection => _reflection;
  Set<String> get selectedIds => _selectedIds;
  bool get showForm => _showForm;
  bool get isSaving => _isSaving;

  void updateReflection(Reflection newReflection) {
    _reflection = newReflection;
    notifyListeners();
  }

  void toggleEntry(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void setShowForm(bool value) {
    _showForm = value;
    notifyListeners();
  }

  void setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  Future<void> save(BuildContext context, List<int> relatedEntries) async {
    setSaving(true);
    try {
      await ReflectionService().saveReflection(_reflection, relatedEntries);
      reset();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reflection saved!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      setSaving(false);
    }
  }

  void reset() {
    _reflection.reset();
    _selectedIds.clear();
    _showForm = false;
    notifyListeners();
  }
}