// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Log entry form widget.
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/data/drug_categories.dart';
import 'package:mobile_drug_use_app/constants/data/drug_use_catalog.dart';
import 'package:mobile_drug_use_app/constants/data/body_and_mind_catalog.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/inputs.dart';
import 'package:mobile_drug_use_app/common/inputs/search_field.dart';
import 'package:mobile_drug_use_app/common/buttons/buttons.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/text/common_section_header.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/features/catalog/services/drug_profile_service.dart';

class LogEntryForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final bool isSimpleMode;
  // Data
  final double? dose;
  final String? unit;
  final String? substance;
  final String? route;
  final List<String>? feelings;
  final Map<String, List<String>>? secondaryFeelings;
  final String? location;
  final DateTime? date;
  final int? hour;
  final int? minute;
  final bool? isMedicalPurpose;
  final double? cravingIntensity;
  final String? intention;
  final List<String>? selectedTriggers;
  final List<String>? selectedBodySignals;
  // Controllers
  final TextEditingController? notesCtrl;
  final TextEditingController? doseCtrl;
  final TextEditingController? substanceCtrl;
  // Callbacks
  final ValueChanged<double>? onDoseChanged;
  final ValueChanged<String>? onUnitChanged;
  final ValueChanged<String>? onSubstanceChanged;
  final ValueChanged<String>? onRouteChanged;
  final ValueChanged<List<String>>? onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>>? onSecondaryFeelingsChanged;
  final ValueChanged<String>? onLocationChanged;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<int>? onHourChanged;
  final ValueChanged<int>? onMinuteChanged;
  final ValueChanged<bool>? onMedicalPurposeChanged;
  final ValueChanged<double>? onCravingIntensityChanged;
  final ValueChanged<String>? onIntentionChanged;
  final ValueChanged<List<String>>? onTriggersChanged;
  final ValueChanged<List<String>>? onBodySignalsChanged;
  final VoidCallback? onSave;
  final bool showSaveButton;

  /// Optional injection point for DB-backed substance autocomplete.
  /// Defaults to [DrugProfileService.searchDrugNamesWithAliases].
  final Future<Iterable<DrugSearchResult>> Function(String)?
  substanceOptionsBuilder;
  const LogEntryForm({
    super.key,
    this.formKey,
    required this.isSimpleMode,
    this.dose,
    this.unit,
    this.substance,
    this.route,
    this.feelings,
    this.secondaryFeelings,
    this.location,
    this.date,
    this.hour,
    this.minute,
    this.isMedicalPurpose,
    this.cravingIntensity,
    this.intention,
    this.selectedTriggers,
    this.selectedBodySignals,
    this.notesCtrl,
    this.doseCtrl,
    this.substanceCtrl,
    this.onDoseChanged,
    this.onUnitChanged,
    this.onSubstanceChanged,
    this.onRouteChanged,
    this.onFeelingsChanged,
    this.onSecondaryFeelingsChanged,
    this.onLocationChanged,
    this.onDateChanged,
    this.onHourChanged,
    this.onMinuteChanged,
    this.onMedicalPurposeChanged,
    this.onCravingIntensityChanged,
    this.onIntentionChanged,
    this.onTriggersChanged,
    this.onBodySignalsChanged,
    this.onSave,
    this.showSaveButton = true,
    this.substanceOptionsBuilder,
  });

  @override
  State<LogEntryForm> createState() => _LogEntryFormState();
}

class _LogEntryFormState extends State<LogEntryForm> {
  Color? _substanceAccentColor;

  Color _accentColorForResult(DrugSearchResult result) {
    final primary = DrugCategories.primaryCategoryFromRaw(result.category);
    return DrugCategoryColors.colorFor(primary);
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    final Future<Iterable<DrugSearchResult>> Function(String) optionsBuilder =
        widget.substanceOptionsBuilder ??
        (query) async {
          // In production Supabase is initialized at startup.
          // In widget tests it often isn't, so we gracefully return no options
          // rather than crashing the whole widget tree.
          try {
            return await DrugProfileService().searchDrugNamesWithAliases(query);
          } catch (_) {
            return const <DrugSearchResult>[];
          }
        };
    final routeOptions = DrugUseCatalog.consumptionMethods
        .map((m) => m['name']!)
        .toList(growable: false);
    final normalizedRoute = () {
      final raw = widget.route;
      if (raw == null || raw.trim().isEmpty) return 'oral';
      final lower = raw.toLowerCase();
      return routeOptions.contains(lower) ? lower : 'oral';
    }();
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
        children: [
          // Substance
          CommonSearchField<DrugSearchResult>(
            controller: widget.substanceCtrl,
            labelText: 'Substance',
            hintText: 'Start typing (e.g. dex...)',
            accentColor: _substanceAccentColor,
            prefixIcon: Icon(
              Icons.science,
              color: _substanceAccentColor ?? context.accent.primary,
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            onChanged: (v) {
              widget.onSubstanceChanged?.call(v);
              if (v.trim().isEmpty && _substanceAccentColor != null) {
                setState(() {
                  _substanceAccentColor = null;
                });
              }
            },
            optionsBuilder: (query) async {
              // Includes canonical matches + aliases; aliases normalize to canonicalName.
              return await optionsBuilder(query);
            },
            displayStringForOption: (r) => r.displayName,
            itemBuilder: (context, r) {
              final th = context.theme;
              final category = DrugCategories.primaryCategoryFromRaw(
                r.category,
              );
              final categoryColor = DrugCategoryColors.colorFor(category);
              final categoryIcon =
                  DrugCategories.categoryIconMap[category] ?? Icons.science;

              return Row(
                children: [
                  Icon(categoryIcon, color: categoryColor, size: 18),
                  CommonSpacer.horizontal(th.spacing.sm),
                  Expanded(
                    child: Text(
                      r.displayName,
                      style: th.text.body.copyWith(color: categoryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
            onSelected: (r) {
              // Normalize aliases to canonical name in the form state.
              final nextAccent = _accentColorForResult(r);
              if (kDebugMode) {
                final parsedCategory = DrugCategories.primaryCategoryFromRaw(
                  r.category,
                );
                debugPrint(
                  '[SubstanceSelect] canonical="${r.canonicalName}" '
                  'display="${r.displayName}" '
                  'rawCategory="${r.category}" '
                  'parsedCategory="$parsedCategory" '
                  'color=0x${nextAccent.value.toRadixString(16).padLeft(8, '0')}',
                );
              }
              if (nextAccent != _substanceAccentColor) {
                setState(() {
                  _substanceAccentColor = nextAccent;
                });
              }

              widget.substanceCtrl?.text = r.canonicalName;
              widget.onSubstanceChanged?.call(r.canonicalName);
            },
          ),
          CommonSpacer.vertical(sp.md),
          // Dose & Unit
          Row(
            children: [
              Expanded(
                flex: AppLayout.flex2,
                child: CommonInputField(
                  controller: widget.doseCtrl,
                  labelText: 'Dose',
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    if (widget.onDoseChanged != null) {
                      final val = double.tryParse(v);
                      if (val != null) widget.onDoseChanged!(val);
                    }
                  },
                ),
              ),
              CommonSpacer.horizontal(sp.md),
              Expanded(
                flex: AppLayout.flex1,
                child: CommonDropdown<String>(
                  value: widget.unit ?? 'mg',
                  items: const ['mg', 'g', 'ml', 'oz', 'pills', 'tabs'],
                  onChanged: (v) => widget.onUnitChanged?.call(v ?? 'mg'),
                  hintText: 'Unit',
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.md),
          // Route
          CommonDropdown<String>(
            value: normalizedRoute,
            items: routeOptions,
            itemLabel: (v) =>
                v.isEmpty ? v : '${v[0].toUpperCase()}${v.substring(1)}',
            onChanged: (v) {
              if (v != null && widget.onRouteChanged != null) {
                widget.onRouteChanged!(v);
              }
            },
            hintText: 'Route of Administration',
          ),
          CommonSpacer.vertical(sp.md),
          // Time Selector
          _buildTimeSelector(context),
          CommonSpacer.vertical(sp.md),
          // Location
          CommonDropdown<String>(
            value: widget.location ?? DrugUseCatalog.locations.first,
            items: DrugUseCatalog.locations,
            onChanged: (v) {
              if (v != null && widget.onLocationChanged != null) {
                widget.onLocationChanged!(v);
              }
            },
            hintText: 'Location',
          ),
          CommonSpacer.vertical(sp.md),
          // Medical Purpose
          CommonSwitchTile(
            title: 'Medical Purpose',
            value: widget.isMedicalPurpose ?? false,
            onChanged: (v) => widget.onMedicalPurposeChanged?.call(v),
          ),
          CommonSpacer.vertical(sp.md),
          // Complex Mode Inputs
          if (!widget.isSimpleMode) ...[
            // Intention
            CommonDropdown<String>(
              value: widget.intention ?? intentions.first,
              items: intentions,
              onChanged: (v) {
                if (v != null && widget.onIntentionChanged != null) {
                  widget.onIntentionChanged!(v);
                }
              },
              hintText: 'Intention',
            ),
            CommonSpacer.vertical(sp.md),
            // Craving Intensity
            CommonCard(
              padding: EdgeInsets.all(sp.cardPadding),
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  CommonSectionHeader(
                    title: 'Craving Intensity',
                    subtitle: 'How strong was the urge?',
                  ),
                  CommonSpacer.vertical(sp.sm),
                  CommonSlider(
                    value: widget.cravingIntensity ?? 0.0,
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    onChanged: (v) => widget.onCravingIntensityChanged?.call(v),
                  ),
                ],
              ),
            ),
            CommonSpacer.vertical(sp.md),
            // Emotions
            EmotionSelector(
              selectedEmotions: widget.feelings ?? [],
              availableEmotions: DrugUseCatalog.primaryEmotions
                  .map((e) => e['name']!)
                  .toList(),
              onEmotionToggled: (emotion) {
                if (widget.onFeelingsChanged != null) {
                  final current = List<String>.from(widget.feelings ?? []);
                  if (current.contains(emotion)) {
                    current.remove(emotion);
                  } else {
                    current.add(emotion);
                  }
                  widget.onFeelingsChanged!(current);
                }
              },
            ),
            CommonSpacer.vertical(sp.md),
            // Secondary Emotions
            if (widget.feelings != null && widget.feelings!.isNotEmpty)
              _buildSecondaryEmotions(context),
            // Triggers
            CommonChipGroup(
              title: 'Triggers',
              subtitle: 'What triggered this use?',
              options: triggers,
              selected: widget.selectedTriggers ?? [],
              onChanged: (v) => widget.onTriggersChanged?.call(v),
            ),
            CommonSpacer.vertical(sp.md),
            // Body Signals
            CommonChipGroup(
              title: 'Body Signals',
              subtitle: 'Physical sensations',
              options: physicalSensations,
              selected: widget.selectedBodySignals ?? [],
              onChanged: (v) => widget.onBodySignalsChanged?.call(v),
            ),
            CommonSpacer.vertical(sp.md),
          ],
          // Notes
          CommonTextarea(
            controller: widget.notesCtrl,
            labelText: 'Notes',
            maxLines: 3,
          ),
          CommonSpacer.vertical(sp.lg),
          if (widget.showSaveButton && widget.onSave != null)
            CommonPrimaryButton(onPressed: widget.onSave!, label: 'Save Entry'),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    final th = context.theme;
    final time = TimeOfDay(
      hour: widget.hour ?? TimeOfDay.now().hour,
      minute: widget.minute ?? TimeOfDay.now().minute,
    );
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          widget.onHourChanged?.call(picked.hour);
          widget.onMinuteChanged?.call(picked.minute);
        }
      },
      borderRadius: BorderRadius.circular(th.shapes.radiusMd),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Time',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: th.spacing.md,
            vertical: th.spacing.sm,
          ),
        ),
        child: Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Text(time.format(context), style: th.text.body),
            Icon(Icons.access_time, color: th.colors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryEmotions(BuildContext context) {
    final th = context.theme;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: widget.feelings!.map((emotion) {
        final secondaryOptions = DrugUseCatalog.secondaryEmotions[emotion];
        if (secondaryOptions == null || secondaryOptions.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.only(bottom: th.spacing.md),
          child: CommonChipGroup(
            title: '$emotion Details',
            options: secondaryOptions,
            selected: widget.secondaryFeelings?[emotion] ?? [],
            onChanged: (selected) {
              if (widget.onSecondaryFeelingsChanged != null) {
                final current = Map<String, List<String>>.from(
                  widget.secondaryFeelings ?? {},
                );
                current[emotion] = selected;
                widget.onSecondaryFeelingsChanged!(current);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
