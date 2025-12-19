import 'dart:convert';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/buttons/common_chip_group.dart';
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
                  height: t.spacing.xs,
                  decoration: BoxDecoration(
                    color: t.colors.divider,
                    borderRadius: BorderRadius.circular(t.shapes.radiusXs),
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
                    const CommonSpacer.vertical(24),

                    // Aliases
                    _buildAliases(context),
                    const CommonSpacer.vertical(24),

                    // Method Selector
                    if (_availableMethods.length > 1) ...[
                      _buildMethodSelector(context, accentColor),
                      const CommonSpacer.vertical(16),
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
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
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
                size: t.sizes.iconLg,
              ),
            ),
            SizedBox(width: t.spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  Text(
                    name,
                    style: t.text.heading2.copyWith(
                      color: t.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: t.spacing.xs),
                  Wrap(
                    spacing: t.spacing.sm,
                    runSpacing: t.spacing.xs,
                    children: categories
                        .map(
                          (cat) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: t.spacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: accentColor.withValues(alpha: t.opacities.slow),
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
                padding: EdgeInsets.all(t.spacing.sm),
                decoration: BoxDecoration(
                  color: t.colors.surface,
                  shape: context.shapes.boxShapeCircle,
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
            icon: Icon(Icons.add, size: t.sizes.iconSm),
            label: const Text('Add to Stockpile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: t.colors.textInverse,
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.md,
                vertical: t.spacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  t.shapes.radiusMd,
                ),
              ),
              elevation: context.sizes.elevationSm,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAliases(BuildContext context) {
    final t = context.theme;
    final text = context.text;
    final t = context.theme;
    final aliases = (widget.substance['aliases'] as List?)
        ?.map((e) => e.toString())
        .toList();
    if (aliases == null || aliases.isEmpty) return const SizedBox.shrink();

    return CommonCard(
      padding: EdgeInsets.all(t.spacing.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(
                Icons.alternate_email,
                size: t.spacing.lg,
                color: t.colors.textSecondary,
              ),
              CommonSpacer.horizontal(t.spacing.sm),
              Text(
                'Also Known As',
                style: t.text.body.copyWith(
                  fontWeight: text.bodyBold.fontWeight,
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(t.spacing.sm),
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
    return CommonChipGroup(
      title: 'Administration Method',
      showHeader: false,
      options: _availableMethods,
      selected: [_selectedMethod],
      onChanged: (selectedList) {
        if (selectedList.isNotEmpty) {
          setState(() => _selectedMethod = selectedList.first);
        }
      },
      allowMultiple: false,
      selectedColor: accentColor,
    );
  }

  Widget _buildProperties(BuildContext context) {
    final t = context.theme;
    final text = context.text;
    final t = context.theme;
    final summary = widget.substance['properties']?['summary'];
    final warning = widget.substance['properties']?['warning'];
    final testKits = widget.substance['properties']?['test-kits'];

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        if (warning != null) ...[
          _buildWarningCard(context, warning.toString()),
          CommonSpacer.vertical(t.spacing.lg),
        ],
        if (summary != null) ...[
          Text(
            'Summary',
            style: t.text.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          CommonSpacer.vertical(t.spacing.sm),
          Text(
            summary.toString(),
            style: t.text.body.copyWith(
              height: 1.6,
              color: t.colors.textSecondary,
            ),
          ),
          CommonSpacer.vertical(t.spacing.xl),
        ],
        if (testKits != null) ...[
          Text(
            'Reagent Testing',
            style: t.text.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          CommonSpacer.vertical(t.spacing.sm),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(t.spacing.lg),
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
    return CommonCard(
      padding: EdgeInsets.all(t.spacing.lg),
      backgroundColor: t.colors.warning.withValues(alpha: 0.1),
      borderColor: t.colors.warning.withValues(alpha: t.opacities.slow),
      child: Row(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(Icons.warning_amber_rounded, color: t.colors.warning),
          CommonSpacer.horizontal(t.spacing.md),
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
