import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../constants/theme/app_theme_extension.dart';
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
    var rawDose = widget.substance['formatted_dose'];

    // Handle String JSON
    if (rawDose is String) {
      try {
        rawDose = jsonDecode(rawDose);
      } catch (e) {
        // Ignore
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
  }

  Map<String, dynamic> _normalizeTiming(dynamic raw) {
    if (raw == null) return {};

    // Handle String JSON
    if (raw is String) {
      try {
        raw = jsonDecode(raw);
      } catch (e) {
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
              '${method.toLowerCase()}_',
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
    final t = context.theme;
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
            color: t.colors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(t.shapes.radiusLg),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: t.spacing.sm,
                  ),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: t.colors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(t.spacing.md),
                  children: [
                    // Header
                    _buildHeader(context, name, categories, accentColor),
                    SizedBox(height: t.spacing.xl),

                    // Aliases
                    _buildAliases(context),
                    SizedBox(height: t.spacing.xl),

                    // Method Selector
                    if (_availableMethods.length > 1) ...[
                      _buildMethodSelector(context, accentColor),
                      SizedBox(height: t.spacing.md),
                    ],

                    // Dosage Guide
                    DosageGuideCard(
                      doseData: _parsedDosage[_selectedMethod] != null
                          ? Map<String, dynamic>.from(
                              _parsedDosage[_selectedMethod] as Map,
                            )
                          : null,
                      selectedMethod: _selectedMethod,
                      accentColor: accentColor,
                    ),
                    SizedBox(height: t.spacing.xl),

                    // Timing
                    TimingInfoCard(
                      onset: _parsedOnset[_selectedMethod],
                      duration: _parsedDuration[_selectedMethod],
                      afterEffects: _parsedAfterEffects[_selectedMethod],
                      accentColor: accentColor,
                    ),
                    SizedBox(height: t.spacing.xl),

                    // Properties / Summary
                    _buildProperties(context),
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
    BuildContext context,
    String name,
    List<String> categories,
    Color accentColor,
  ) {
    final t = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(t.spacing.sm),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(
                  t.shapes.radiusMd,
                ),
              ),
              child: Icon(
                DrugCategories.categoryIconMap[categories.firstOrNull] ??
                    Icons.science,
                color: accentColor,
                size: 32,
              ),
            ),
            SizedBox(width: t.spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: t.text.heading2.copyWith(
                      color: t.colors.textPrimary,
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
                                t.shapes.radiusSm,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: t.text.label.copyWith(
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
                  color: t.colors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        SizedBox(height: t.spacing.md),
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
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.md,
                vertical: t.spacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  t.shapes.radiusMd,
                ),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAliases(BuildContext context) {
    final t = context.theme;
    final aliases = (widget.substance['aliases'] as List?)
        ?.map((e) => e.toString())
        .toList();
    if (aliases == null || aliases.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(t.spacing.md),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.alternate_email,
                size: 16,
                color: t.colors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Also Known As',
                style: t.text.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            aliases.join(', '),
            style: t.text.body.copyWith(
              color: t.colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelector(BuildContext context, Color accentColor) {
    final t = context.theme;
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
              backgroundColor: t.colors.surface,
              labelStyle: t.typography.body.copyWith(
                color: isSelected
                    ? accentColor
                    : t.colors.textSecondary,
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

  Widget _buildProperties(BuildContext context) {
    final t = context.theme;
    final summary = widget.substance['properties']?['summary'];
    final warning = widget.substance['properties']?['warning'];
    final testKits = widget.substance['properties']?['test-kits'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (warning != null) ...[
          _buildWarningCard(context, warning.toString()),
          const SizedBox(height: 16),
        ],
        if (summary != null) ...[
          Text(
            'Summary',
            style: t.text.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary.toString(),
            style: t.text.body.copyWith(
              height: 1.6,
              color: t.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (testKits != null) ...[
          Text(
            'Reagent Testing',
            style: t.text.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: t.colors.surface,
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              border: Border.all(
                color: t.colors.border,
              ),
            ),
            child: Text(
              testKits.toString(),
              style: t.text.body.copyWith(
                fontFamily: 'Monospace',
                color: t.colors.textPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWarningCard(BuildContext context, String message) {
    final t = context.theme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.colors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(color: t.colors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: t.colors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: t.text.body.copyWith(
                color: t.colors.warning,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
