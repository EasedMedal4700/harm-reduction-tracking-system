// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Log entry form widget.
import 'package:flutter/material.dart';
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

  /// Pure UI parameter: if provided, certain form controls adopt this color.
  /// Derived by the page from the selected substance category.
  final Color? categoryAccent;

  /// Pure UI parameter: category icon for the selected substance.
  final IconData? categoryIcon;
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
    this.categoryAccent,
    this.categoryIcon,
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
  // Removed unused helper: color derivation happens at page-level.

  bool _showExtraDetails = false;

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    final th = context.theme;
    final targetAccent = widget.categoryAccent;
    final targetIcon = widget.categoryIcon;
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
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: context.accent.primary,
        end: targetAccent ?? context.accent.primary,
      ),
      duration: context.animations.normal,
      builder: (context, animatedAccent, _) {
        return Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
            children: [
              // Grouped form area (card) - contains all fields except the save button
              CommonCard(
                padding: EdgeInsets.all(sp.cardPadding),
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
                  children: [
                    // Substance
                    CommonSearchField<DrugSearchResult>(
                controller: widget.substanceCtrl,
                labelText: 'Substance',
                hintText: 'Start typing (e.g. dex...)',
                accentColor: targetAccent,
                prefixIcon: AnimatedSwitcher(
                  duration: context.animations.normal,
                  child: Icon(
                    targetIcon ?? Icons.science,
                    key: ValueKey<String>(
                      'substance_icon_${targetIcon ?? Icons.science}',
                    ),
                    color: (targetAccent != null
                        ? (targetAccent.computeLuminance() < 0.5
                            ? Colors.white
                            : Colors.black87)
                        : context.accent.primary),
                  ),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
                onChanged: (v) {
                  widget.onSubstanceChanged?.call(v);
                },
                optionsBuilder: (query) async {
                  // Includes canonical matches + aliases; aliases normalize to canonicalName.
                  return await optionsBuilder(query);
                },
                displayStringForOption: (r) => r.displayName,
                itemBuilder: (context, r) {
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
                      accentColor: targetAccent,
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
                      accentColor: targetAccent,
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
                accentColor: targetAccent,
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
                accentColor: targetAccent,
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
                // Extra Details accordion
                ExpansionTile(
                key: const ValueKey('extra_details_accordion'),
                initiallyExpanded: _showExtraDetails,
                onExpansionChanged: (v) =>
                  setState(() => _showExtraDetails = v),
                title: Text('Extra details', style: th.text.body),
                // Ensure header/text/icon contrast against the surface by
                // using the page-derived animatedAccent where available.
                collapsedIconColor: (animatedAccent ?? context.accent.primary),
                iconColor: (animatedAccent ?? context.accent.primary),
                textColor: (animatedAccent ?? context.accent.primary),
                collapsedTextColor: (animatedAccent ?? context.accent.primary),
                backgroundColor: targetAccent == null
                  ? th.c.surface
                  : Color.alphaBlend(
                    (animatedAccent ?? context.accent.primary)
                      .withValues(alpha: th.opacities.veryLow),
                    th.c.surface,
                    ),
                collapsedBackgroundColor: targetAccent == null
                  ? th.c.surface
                  : Color.alphaBlend(
                    (animatedAccent ?? context.accent.primary)
                      .withValues(alpha: th.opacities.veryLow),
                    th.c.surface,
                    ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: th.spacing.md,
                      vertical: th.spacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
                      children: [
                        // Intention
                        SizedBox(
                          width: double.infinity,
                          child: CommonDropdown<String>(
                            value: widget.intention ?? intentions.first,
                            items: intentions,
                            onChanged: (v) {
                              if (v != null && widget.onIntentionChanged != null) {
                                widget.onIntentionChanged!(v);
                              }
                            },
                            hintText: 'Intention',
                          ),
                        ),
                        CommonSpacer.vertical(sp.md),
                        // Craving Intensity
                        SizedBox(
                          width: double.infinity,
                          child: CommonCard(
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
                                  activeColor: targetAccent,
                                  onChanged: (v) =>
                                      widget.onCravingIntensityChanged?.call(v),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CommonSpacer.vertical(sp.md),
                        // Emotions
                        SizedBox(
                          width: double.infinity,
                          child: EmotionSelector(
                            selectedEmotions: widget.feelings ?? [],
                            availableEmotions: DrugUseCatalog.primaryEmotions
                                .map((e) => e['name']!)
                                .toList(),
                            accentColor: targetAccent,
                            onEmotionToggled: (emotion) {
                              if (widget.onFeelingsChanged != null) {
                                final current = List<String>.from(
                                  widget.feelings ?? [],
                                );
                                if (current.contains(emotion)) {
                                  current.remove(emotion);
                                } else {
                                  current.add(emotion);
                                }
                                widget.onFeelingsChanged!(current);
                              }
                            },
                          ),
                        ),
                        CommonSpacer.vertical(sp.md),
                        // Secondary Emotions
                        if (widget.feelings != null && widget.feelings!.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: _buildSecondaryEmotions(context),
                          ),
                        // Triggers
                        SizedBox(
                          width: double.infinity,
                          child: CommonChipGroup(
                            title: 'Triggers',
                            subtitle: 'What triggered this use?',
                            options: triggers,
                            selected: widget.selectedTriggers ?? [],
                            onChanged: (v) => widget.onTriggersChanged?.call(v),
                            selectedColor: targetAccent,
                            selectedBorderColor: targetAccent,
                          ),
                        ),
                        CommonSpacer.vertical(sp.md),
                        // Body Signals
                        SizedBox(
                          width: double.infinity,
                          child: CommonChipGroup(
                            title: 'Body Signals',
                            subtitle: 'Physical sensations',
                            options: physicalSensations,
                            selected: widget.selectedBodySignals ?? [],
                            onChanged: (v) => widget.onBodySignalsChanged?.call(v),
                            selectedColor: targetAccent,
                            selectedBorderColor: targetAccent,
                          ),
                        ),
                        CommonSpacer.vertical(sp.md),
                      ],
                    ),
                  ),
                ],
              ),
              // Notes
                            CommonSpacer.vertical(sp.lg),

              CommonTextarea(
                controller: widget.notesCtrl,
                labelText: 'Notes',
                maxLines: 3,
                accentColor: targetAccent,
              ),
                ],
              ),
              ),
              CommonSpacer.vertical(sp.md),

              if (widget.showSaveButton && widget.onSave != null)
                CommonPrimaryButton(
                  onPressed: widget.onSave!,
                  label: 'Save Entry',
                  backgroundColor: targetAccent,
                  icon: targetIcon,
                ),
            ],
          ),
        );
      },
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
