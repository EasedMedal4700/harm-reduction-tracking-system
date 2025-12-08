import 'dart:convert';
import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_categories.dart';
import 'dosage_guide_card.dart';
import 'timing_info_card.dart';

class SubstanceDetailsSheet extends StatefulWidget {
  final Map<String, dynamic> substance;
  final Function(
    String substanceId,
    String name,
    Map<String, dynamic> substance,
  )?
  onAddStockpile;

  const SubstanceDetailsSheet({
    super.key,
    required this.substance,
    this.onAddStockpile,
  });

  @override
  State<SubstanceDetailsSheet> createState() => _SubstanceDetailsSheetState();
}

class _SubstanceDetailsSheetState extends State<SubstanceDetailsSheet> {
  String _selectedMethod = 'Oral';
  List<String> _availableMethods = ['Oral'];
  Map<String, dynamic> _parsedDosage = {};
  Map<String, dynamic> _parsedDuration = {};
  Map<String, dynamic> _parsedOnset = {};
  Map<String, dynamic> _parsedAfterEffects = {};

  @override
  void initState() {
    super.initState();
    _parseData();
  }

  void _parseData() {
    print('DEBUG: Parsing data for ${widget.substance['name']}');

    var rawDose = widget.substance['formatted_dose'];
    print('DEBUG: rawDose type: ${rawDose.runtimeType}');
    print('DEBUG: rawDose value: $rawDose');

    // Handle String JSON
    if (rawDose is String) {
      try {
        rawDose = jsonDecode(rawDose);
        print('DEBUG: Decoded rawDose: $rawDose');
      } catch (e) {
        print('DEBUG: Error decoding rawDose: $e');
      }
    }

    if (rawDose != null) {
      if (rawDose is Map) {
        // Check if keys look like methods (capitalized, not starting with _)
        final keys = rawDose.keys
            .where((k) => k.toString() != '_unit')
            .toList();
        // If keys are "Light", "Common" etc, it's a single method (assume Oral/Generic)
        if (keys.any((k) => ['Light', 'Common', 'Strong'].contains(k))) {
          _availableMethods = ['Oral'];
          _parsedDosage = {'Oral': rawDose};
        } else {
          _availableMethods = keys.map((e) => e.toString()).toList();
          _parsedDosage = Map<String, dynamic>.from(rawDose);
        }
      }
    }

    print('DEBUG: _availableMethods: $_availableMethods');
    print('DEBUG: _parsedDosage keys: ${_parsedDosage.keys}');

    // Ensure Oral is first if present
    if (_availableMethods.contains('Oral')) {
      _availableMethods.remove('Oral');
      _availableMethods.insert(0, 'Oral');
    }

    // Default to first available method
    if (_availableMethods.isNotEmpty) {
      _selectedMethod = _availableMethods.first;
    }

    // Parse Timing Data
    _parsedDuration = _normalizeTiming(widget.substance['formatted_duration']);
    _parsedOnset = _normalizeTiming(widget.substance['formatted_onset']);
    _parsedAfterEffects = _normalizeTiming(
      widget.substance['formatted_aftereffects'],
    );

    print('DEBUG: _parsedDuration: $_parsedDuration');
  }

  Map<String, dynamic> _normalizeTiming(dynamic raw) {
    if (raw == null) return {};

    // Handle String JSON
    if (raw is String) {
      try {
        raw = jsonDecode(raw);
      } catch (e) {
        print('DEBUG: Error decoding timing: $e');
        return {};
      }
    }

    if (raw is! Map) return {};

    // If it has "value", it's generic for all methods
    if (raw.containsKey('value')) {
      final unit = raw['_unit'] ?? '';
      final value = raw['value'];
      return {for (var m in _availableMethods) m: '$value $unit'};
    }

    // Otherwise, it might be keyed by method (with variants like Oral_IR, Oral_ER)
    final result = <String, dynamic>{};
    final unit = raw['_unit'] ?? '';

    for (var method in _availableMethods) {
      // Try exact match first
      if (raw.containsKey(method)) {
        result[method] = '${raw[method]} $unit';
        continue;
      }

      // Try to find keys that start with the method name (e.g., "Oral_IR", "Oral_ER" for "Oral")
      final matchingKeys = raw.keys
          .where(
            (key) => key.toString().toLowerCase().startsWith(
              method.toLowerCase() + '_',
            ),
          )
          .toList();

      if (matchingKeys.isNotEmpty) {
        // Combine all variants into a single string
        final values = matchingKeys.map((key) => '${raw[key]}').toList();
        result[method] = '${values.join(' / ')} $unit';
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = widget.substance['pretty_name'] ?? widget.substance['name'];
    final categories =
        (widget.substance['categories'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final primaryCategory = categories.isNotEmpty
        ? categories.first
        : 'Unknown';
    final accentColor = DrugCategoryColors.colorFor(primaryCategory);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? UIColors.darkBackground : UIColors.lightBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(ThemeConstants.radiusLarge),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: ThemeConstants.space12,
                  ),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? UIColors.darkDivider
                        : UIColors.lightDivider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
                  children: [
                    // Header
                    _buildHeader(name, categories, isDark, accentColor),
                    const SizedBox(height: ThemeConstants.space24),

                    // Aliases
                    _buildAliases(isDark),
                    const SizedBox(height: ThemeConstants.space24),

                    // Method Selector
                    if (_availableMethods.length > 1) ...[
                      _buildMethodSelector(isDark, accentColor),
                      const SizedBox(height: ThemeConstants.space16),
                    ],

                    // Dosage Guide
                    DosageGuideCard(
                      doseData: _parsedDosage[_selectedMethod] != null
                          ? Map<String, dynamic>.from(
                              _parsedDosage[_selectedMethod] as Map,
                            )
                          : null,
                      selectedMethod: _selectedMethod,
                      isDark: isDark,
                      accentColor: accentColor,
                    ),
                    const SizedBox(height: ThemeConstants.space24),

                    // Timing
                    TimingInfoCard(
                      onset: _parsedOnset[_selectedMethod],
                      duration: _parsedDuration[_selectedMethod],
                      afterEffects: _parsedAfterEffects[_selectedMethod],
                      isDark: isDark,
                      accentColor: accentColor,
                    ),
                    const SizedBox(height: ThemeConstants.space24),

                    // Properties / Summary
                    _buildProperties(isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    String name,
    List<String> categories,
    bool isDark,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  ThemeConstants.radiusMedium,
                ),
              ),
              child: Icon(
                DrugCategories.categoryIconMap[categories.firstOrNull] ??
                    Icons.science,
                color: accentColor,
                size: 32,
              ),
            ),
            const SizedBox(width: ThemeConstants.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: ThemeConstants.font2XLarge,
                      fontWeight: ThemeConstants.fontBold,
                      color: isDark ? UIColors.darkText : UIColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: categories
                        .map(
                          (cat) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: accentColor.withValues(alpha: 0.5),
                              ),
                              borderRadius: BorderRadius.circular(
                                ThemeConstants.radiusSmall,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: ThemeConstants.fontXSmall,
                                color: accentColor,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SizedBox(height: ThemeConstants.space16),
        // Add to Stockpile button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.onAddStockpile != null
                ? () {
                    final substanceId = widget.substance['name'] ?? 'unknown';
                    final name =
                        widget.substance['pretty_name'] ??
                        widget.substance['name'] ??
                        'Unknown';
                    Navigator.pop(context);
                    widget.onAddStockpile!(substanceId, name, widget.substance);
                  }
                : null,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add to Stockpile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space16,
                vertical: ThemeConstants.space12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ThemeConstants.radiusMedium,
                ),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAliases(bool isDark) {
    final aliases = (widget.substance['aliases'] as List?)
        ?.map((e) => e.toString())
        .toList();
    if (aliases == null || aliases.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.alternate_email,
                size: 16,
                color: isDark
                    ? UIColors.darkTextSecondary
                    : UIColors.lightTextSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Also Known As',
                style: TextStyle(
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            aliases.join(', '),
            style: TextStyle(
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelector(bool isDark, Color accentColor) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _availableMethods.map((method) {
          final isSelected = method == _selectedMethod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedMethod = method);
              },
              selectedColor: accentColor.withValues(alpha: 0.2),
              backgroundColor: isDark
                  ? UIColors.darkSurface
                  : UIColors.lightSurface,
              labelStyle: TextStyle(
                color: isSelected
                    ? accentColor
                    : (isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? accentColor : Colors.transparent,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProperties(bool isDark) {
    final summary = widget.substance['properties']?['summary'];
    final warning = widget.substance['properties']?['warning'];
    final testKits = widget.substance['properties']?['test-kits'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (warning != null) ...[
          _buildWarningCard(warning.toString(), isDark),
          const SizedBox(height: 16),
        ],
        if (summary != null) ...[
          Text(
            'Summary',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary.toString(),
            style: TextStyle(
              height: 1.6,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (testKits != null) ...[
          Text(
            'Reagent Testing',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              border: Border.all(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            child: Text(
              testKits.toString(),
              style: TextStyle(
                fontFamily: 'Monospace',
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWarningCard(String message, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? Colors.amber[200] : Colors.amber[900],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
