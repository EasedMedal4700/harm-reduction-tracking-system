import 'package:flutter/material.dart';
import '../repo/substance_repository.dart';
import '../widgets/common/category_filter.dart'; // Add this import

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final SubstanceRepository _repository = SubstanceRepository();
  List<Map<String, dynamic>> _allSubstances = [];
  List<Map<String, dynamic>> _filteredSubstances = [];
  String _searchQuery = '';
  bool _showCommonOnly = false; // Keep this
  List<String> _selectedCategories = []; // Add this for category filter
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCatalog();
  }

  Future<void> _fetchCatalog() async {
    try {
      final substances = await _repository.fetchSubstancesCatalog();
      // Sort alphabetically by pretty_name or name
      substances.sort((a, b) {
        final nameA = (a['pretty_name'] ?? a['name']).toLowerCase();
        final nameB = (b['pretty_name'] ?? b['name']).toLowerCase();
        return nameA.compareTo(nameB);
      });
      setState(() {
        _allSubstances = substances;
        _filteredSubstances = substances;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading catalog: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Substance Catalog')),
      body: Column(
        children: [
          // Update CategoryFilter with switch
          CategoryFilter(
            selectedCategories: _selectedCategories,
            onCategoriesChanged: (categories) {
              setState(() => _selectedCategories = categories);
              _applyFilters();
            },
            showCommonOnly: _showCommonOnly, // Add this
            onShowCommonOnlyChanged: (value) {
              setState(() => _showCommonOnly = value);
              _applyFilters(); // Re-apply filters when switch changes
            },
          ),
          const SizedBox(height: 8),
          // Search Bar (searches by pretty_name)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Substances',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                _searchQuery = query;
                _applyFilters(); // Re-apply filters when search changes
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: _filteredSubstances.map((sub) {
                final prettyName = sub['pretty_name'] ?? sub['name'];
                final description = sub['description'];
                final categories = (sub['categories'] as List<dynamic>).join(', ');
                return ListTile(
                  title: Text(prettyName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (description.isNotEmpty) Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text('Categories: $categories'),
                    ],
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: $prettyName')),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Update _applyFilters to check for lowercase "common"
  void _applyFilters() {
    setState(() {
      _filteredSubstances = _allSubstances.where((sub) {
        final matchesSearch = (sub['pretty_name'] ?? sub['name']).toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.any((selected) => (sub['categories'] as List<dynamic>).contains(selected));
        final matchesCommon = !_showCommonOnly || (sub['categories'] as List<dynamic>).contains('common'); // Changed to lowercase
        return matchesSearch && matchesCategory && matchesCommon;
      }).toList();
    });
  }
}