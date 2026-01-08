// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Sheet for displaying substance details.
import 'dart:convert';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import '../../../constants/data/drug_categories.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../constants/theme/app_typography.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/buttons/common_chip_group.dart';
import 'dosage_guide_card.dart';
import 'timing_info_card.dart';

class SubstanceDetailsSheet extends ConsumerStatefulWidget {
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
  ConsumerState<SubstanceDetailsSheet> createState() =>
      _SubstanceDetailsSheetState();
}

class _SubstanceDetailsSheetState extends ConsumerState<SubstanceDetailsSheet> {
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
    final th = context.theme;
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
      initialChildSize: th.sizes.sheetInitialChildSize,
      minChildSize: th.sizes.sheetMinChildSize,
      maxChildSize: th.sizes.sheetMaxChildSize,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: th.colors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(th.shapes.radiusLg),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: th.sp.sm),
                  width: th.sizes.iconXl,
                  height: th.sp.xs,
                  decoration: BoxDecoration(
                    color: th.colors.divider,
                    borderRadius: BorderRadius.circular(th.shapes.radiusXs),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(th.sp.md),
                  children: [
                    // Header
                    _buildHeader(context, name, categories, accentColor),
                    CommonSpacer.vertical(th.sp.xl),
                    // Aliases
                    _buildAliases(context),
                    CommonSpacer.vertical(th.sp.xl),
                    // Method Selector
                    if (_availableMethods.length > 1) ...[
                      _buildMethodSelector(context, accentColor),
                      CommonSpacer.vertical(th.sp.lg),
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
                    SizedBox(height: th.sp.xl),
                    // Timing
                    TimingInfoCard(
                      onset: _parsedOnset[_selectedMethod],
                      duration: _parsedDuration[_selectedMethod],
                      afterEffects: _parsedAfterEffects[_selectedMethod],
                      accentColor: accentColor,
                    ),
                    SizedBox(height: th.sp.xl),
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
    final th = context.theme;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(th.sp.sm),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: th.opacities.selected),
                borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              ),
              child: Icon(
                DrugCategories.categoryIconMap[categories.firstOrNull] ??
                    Icons.science,
                color: accentColor,
                size: th.sizes.iconLg,
              ),
            ),
            SizedBox(width: th.sp.md),
            Expanded(
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  Text(
                    name,
                    style: th.tx.heading2.copyWith(
                      color: th.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: th.sp.xs),
                  Wrap(
                    spacing: th.sp.sm,
                    runSpacing: th.sp.xs,
                    children: categories
                        .map(
                          (cat) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: th.sp.sm,
                              vertical: th.sizes.borderRegular,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: accentColor.withValues(
                                  alpha: th.opacities.slow,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(
                                th.shapes.radiusSm,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: th.tx.label.copyWith(color: accentColor),
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
                padding: EdgeInsets.all(th.sp.sm),
                decoration: BoxDecoration(
                  color: th.colors.surface,
                  shape: context.shapes.boxShapeCircle,
                ),
                child: const Icon(Icons.close),
              ),
              onPressed: () => ref.read(navigationProvider).pop(),
            ),
          ],
        ),
        SizedBox(height: th.sp.md),
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
                    ref.read(navigationProvider).pop();
                    widget.onAddStockpile!(substanceId, name, widget.substance);
                  }
                : null,
            icon: Icon(Icons.add, size: th.sizes.iconSm),
            label: const Text('Add to Stockpile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: th.colors.textInverse,
              padding: EdgeInsets.symmetric(
                horizontal: th.sp.md,
                vertical: th.sp.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              ),
              elevation: th.sizes.elevationSm,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAliases(BuildContext context) {
    final th = context.theme;

    final aliases = (widget.substance['aliases'] as List?)
        ?.map((e) => e.toString())
        .toList();
    if (aliases == null || aliases.isEmpty) return const SizedBox.shrink();
    return CommonCard(
      padding: EdgeInsets.all(th.sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(
                Icons.alternate_email,
                size: th.sizes.iconSm,
                color: th.colors.textSecondary,
              ),
              CommonSpacer.horizontal(th.sp.sm),
              Text(
                'Also Known As',
                style: th.tx.bodyBold.copyWith(color: th.colors.textPrimary),
              ),
            ],
          ),
          CommonSpacer.vertical(th.sp.sm),
          Text(
            aliases.join(', '),
            style: th.tx.body.copyWith(
              color: th.colors.textSecondary,
              height: AppTypographyConstants.lineHeightAliases,
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
    final th = context.theme;

    final summary = widget.substance['properties']?['summary'];
    final warning = widget.substance['properties']?['warning'];
    final testKits = widget.substance['properties']?['test-kits'];
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        if (warning != null) ...[
          _buildWarningCard(context, warning.toString()),
          CommonSpacer.vertical(th.sp.lg),
        ],
        if (summary != null) ...[
          Text(
            'Summary',
            style: th.tx.heading3.copyWith(color: th.colors.textPrimary),
          ),
          CommonSpacer.vertical(th.sp.sm),
          Text(
            summary.toString(),
            style: th.tx.body.copyWith(
              height: AppTypographyConstants.lineHeightRelaxed,
              color: th.colors.textSecondary,
            ),
          ),
          CommonSpacer.vertical(th.sp.xl),
        ],
        if (testKits != null) ...[
          Text(
            'Reagent Testing',
            style: th.tx.heading3.copyWith(color: th.colors.textPrimary),
          ),
          CommonSpacer.vertical(th.sp.sm),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(th.sp.lg),
            decoration: BoxDecoration(
              color: th.colors.surface,
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              border: Border.all(color: th.colors.border),
            ),
            child: Text(
              testKits.toString(),
              style: th.tx.body.copyWith(
                fontFamily: AppTypographyConstants.fontFamilyMonospace,
                color: th.colors.textPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWarningCard(BuildContext context, String message) {
    final th = context.theme;

    return CommonCard(
      padding: EdgeInsets.all(th.sp.lg),
      backgroundColor: th.colors.warning.withValues(
        alpha: th.opacities.overlay,
      ),
      borderColor: th.colors.warning.withValues(alpha: th.opacities.slow),
      child: Row(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(Icons.warning_amber_rounded, color: th.colors.warning),
          CommonSpacer.horizontal(th.sp.md),
          Expanded(
            child: Text(
              message,
              style: th.tx.body.copyWith(
                color: th.colors.warning,
                height: AppTypographyConstants.lineHeightNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
