import 'package:flutter/material.dart';
import '../models/drug_catalog_entry.dart';
import '../services/personal_library_service.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/library/drug_catalog_list.dart';

class PersonalLibraryPage extends StatefulWidget {
  const PersonalLibraryPage({super.key});

  @override
  State<PersonalLibraryPage> createState() => _PersonalLibraryPageState();
}

class _PersonalLibraryPageState extends State<PersonalLibraryPage> {
  final _service = PersonalLibraryService();
  final TextEditingController _searchController = TextEditingController();

  List<DrugCatalogEntry> _catalog = [];
  List<DrugCatalogEntry> _filtered = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final catalog = await _service.fetchCatalog();
      setState(() {
        _catalog = catalog;
        _filtered = _service.applySearch(_searchController.text, _catalog);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load catalog: $e';
        _loading = false;
      });
    }
  }

  Future<void> _toggleFavorite(DrugCatalogEntry entry) async {
    final updatedFavorite = await _service.toggleFavorite(entry);
    if (!mounted) return;
    setState(() {
      final index = _catalog.indexWhere((item) => item.name == entry.name);
      if (index != -1) {
        _catalog[index] = _catalog[index].copyWith(favorite: updatedFavorite);
      }
      _filtered = _service.applySearch(_searchController.text, _catalog);
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filtered = _service.applySearch(value, _catalog);
    });
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadCatalog, child: const Text('Retry')),
          ],
        ),
      );
    }
    return DrugCatalogList(
      entries: _filtered,
      onToggleFavorite: _toggleFavorite,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Catalog')),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search by name or category',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
