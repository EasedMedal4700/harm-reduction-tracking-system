// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\substance_autocomplete.dart
import 'package:flutter/material.dart';
import '../../services/drug_profile_service.dart';
import '../../utils/entry_validation.dart';

class SubstanceAutocomplete extends StatefulWidget {
  final String substance;
  final ValueChanged<String> onSubstanceChanged;
  final TextEditingController? controller;

  const SubstanceAutocomplete({
    super.key,
    required this.substance,
    required this.onSubstanceChanged,
    this.controller,
  });

  @override
  State<SubstanceAutocomplete> createState() => _SubstanceAutocompleteState();
}

class _SubstanceAutocompleteState extends State<SubstanceAutocomplete> {
  final _drugProfileService = DrugProfileService();
  List<String>? _allDrugs;
  String? _normalizationMessage;
  String? _lastValidatedCanonicalName; // Track normalized canonical names

  @override
  void initState() {
    super.initState();
    _loadAllDrugs();
  }

  void _syncToExternal(String value) {
    if (widget.controller != null) {
      widget.controller!.text = value;
    }
  }

  Future<void> _loadAllDrugs() async {
    try {
      final drugs = await _drugProfileService.getAllDrugNames();
      if (mounted) {
        setState(() => _allDrugs = drugs);
      }
    } catch (e) {
      // Silently fail if Supabase is not initialized (e.g., in tests)
      if (mounted) {
        setState(() => _allDrugs = []);
      }
    }
  }

  void _showNormalizationMessage(String message) {
    setState(() => _normalizationMessage = message);
    // Clear message after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _normalizationMessage = null);
      }
    });
  }

  // Validator that checks against database substances
  String? _validateSubstanceFromDb(String? value) {
    final trimmed = value?.trim();
    
    // Check if empty
    if (trimmed == null || trimmed.isEmpty) {
      return ValidationUtils.emptySubstanceError;
    }
    
    // If this is a canonical name from a previous selection, accept it
    if (_lastValidatedCanonicalName != null && 
        trimmed.toLowerCase() == _lastValidatedCanonicalName!.toLowerCase()) {
      return null;
    }
    
    // If database hasn't loaded yet or is empty (e.g., in tests), accept any non-empty value
    if (_allDrugs == null || _allDrugs!.isEmpty) {
      return null;
    }
    
    // Check if substance exists in database (case-insensitive)
    final lowerValue = trimmed.toLowerCase();
    final exists = _allDrugs!.any((drug) => drug.toLowerCase() == lowerValue);
    
    if (!exists) {
      return ValidationUtils.unrecognizedSubstanceError;
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<DrugSearchResult>(
          initialValue: widget.controller != null 
              ? TextEditingValue(text: widget.controller!.text)
              : null,
          optionsBuilder: (TextEditingValue textEditingValue) async {
            try {
              if (textEditingValue.text.isEmpty) {
                // Return all drugs as simple results (not aliases)
                return _allDrugs?.map((name) => DrugSearchResult(
                  displayName: name,
                  canonicalName: name,
                  isAlias: false,
                )).toList() ?? [];
              }
              // Search database for matching drugs and aliases
              return await _drugProfileService.searchDrugNamesWithAliases(textEditingValue.text);
            } catch (e) {
              // Return empty list if Supabase is not initialized (e.g., in tests)
              return [];
            }
          },
          displayStringForOption: (option) => option.displayName,
          onSelected: (selection) {
            // Track the canonical name as validated
            setState(() {
              _lastValidatedCanonicalName = selection.canonicalName;
            });
            
            // Notify parent of the change
            widget.onSubstanceChanged(selection.canonicalName);
            
            // Sync to external controller if provided
            _syncToExternal(selection.canonicalName);
            
            // Show normalization message if it's an alias
            if (selection.isAlias) {
              _showNormalizationMessage(
                'Normalized "${selection.displayName.split(' (alias')[0]}" to "${selection.canonicalName}"'
              );
            }
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            // Sync the autocomplete's controller with our external controller
            if (widget.controller != null) {
              // Keep text in sync but preserve cursor position
              if (controller.text != widget.controller!.text) {
                controller.text = widget.controller!.text;
                // Restore cursor position at the end after sync
                controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length),
                );
              }
            }
            
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Substance',
                suffixIcon: Icon(Icons.search),
              ),
              validator: _validateSubstanceFromDb,
              onChanged: (value) {
                // Clear validated canonical name when user manually types
                if (_lastValidatedCanonicalName != null) {
                  setState(() {
                    _lastValidatedCanonicalName = null;
                  });
                }
                
                widget.onSubstanceChanged(value);
                // Sync to external controller without changing selection
                if (widget.controller != null) {
                  final selection = controller.selection;
                  widget.controller!.text = value;
                  widget.controller!.selection = selection;
                }
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        leading: Icon(
                          option.isAlias ? Icons.label : Icons.medication,
                          color: option.isAlias ? Colors.blue : null,
                        ),
                        title: Text(option.displayName),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        if (_normalizationMessage != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _normalizationMessage!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}