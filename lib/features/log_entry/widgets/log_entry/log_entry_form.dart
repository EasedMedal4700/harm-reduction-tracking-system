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
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/date_selector.dart';
import 'package:mobile_drug_use_app/features/log_entry/utils/roa_normalization.dart';

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

  /// Optional DB-driven ROA options (already normalized for UI display).
  /// If provided, ROA selection is rendered as a button grid.
  final List<String>? availableROAs;

  /// Optional DB-driven ROA validation (already normalized for UI display).
  final bool Function(String roa)? isROAValidated;
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
    this.availableROAs,
    this.isROAValidated,
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
  void initState() {
    super.initState();
    // In complex mode, show all fields by default.
    _showExtraDetails = !widget.isSimpleMode;
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final fieldGap = widget.isSimpleMode ? th.sp.md : th.sp.sm;
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
    final availableROAs =
        widget.availableROAs ?? RoaNormalization.primaryDisplayROAs;
    final selectedRoute = () {
      final raw = widget.route;
      if (raw == null || raw.trim().isEmpty) return 'oral';
      final lower = raw.toLowerCase();
      return availableROAs.contains(lower) ? lower : 'oral';
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scrollableContent = SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
                  children: [
                    // Grouped form area (card) - contains all fields except the save button
                    CommonCard(
                      padding: EdgeInsets.all(th.sp.cardPadding),
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
                                          ? th.colors.textInverse
                                          : th.colors.textPrimary)
                                    : context.accent.primary),
                              ),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Required'
                                : null,
                            onChanged: (v) {
                              widget.onSubstanceChanged?.call(v);
                            },
                            optionsBuilder: (query) async {
                              // Includes canonical matches + aliases; aliases normalize to canonicalName.
                              return await optionsBuilder(query);
                            },
                            displayStringForOption: (r) => r.displayName,
                            itemBuilder: (context, r) {
                              final category =
                                  DrugCategories.primaryCategoryFromRaw(
                                    r.category,
                                  );
                              final categoryColor = DrugCategoryColors.colorFor(
                                category,
                              );
                              final categoryIcon =
                                  DrugCategories.categoryIconMap[category] ??
                                  Icons.science;

                              return Row(
                                children: [
                                  Icon(
                                    categoryIcon,
                                    color: categoryColor,
                                    size: 18,
                                  ),
                                  CommonSpacer.horizontal(th.sp.sm),
                                  Expanded(
                                    child: Text(
                                      r.displayName,
                                      style: th.text.body.copyWith(
                                        color: categoryColor,
                                      ),
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
                          CommonSpacer.vertical(fieldGap),
                          // Dose & Unit
                          Row(
                            children: [
                              Expanded(
                                flex: AppLayout.flex2,
                                child: CommonInputField(
                                  controller: widget.doseCtrl,
                                  labelText: 'Dose',
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  accentColor: targetAccent,
                                  onChanged: (v) {
                                    if (widget.onDoseChanged != null) {
                                      final val = double.tryParse(v);
                                      if (val != null) {
                                        widget.onDoseChanged!(val);
                                      }
                                    }
                                  },
                                ),
                              ),
                              CommonSpacer.horizontal(th.sp.md),
                              Expanded(
                                flex: AppLayout.flex1,
                                child: CommonDropdown<String>(
                                  value: widget.unit ?? 'mg',
                                  items: const [
                                    'mg',
                                    'g',
                                    'ml',
                                    'oz',
                                    'pills',
                                    'tabs',
                                  ],
                                  accentColor: targetAccent,
                                  onChanged: (v) =>
                                      widget.onUnitChanged?.call(v ?? 'mg'),
                                  hintText: 'Unit',
                                ),
                              ),
                            ],
                          ),
                          CommonSpacer.vertical(fieldGap),
                          // Route
                          _buildROASelector(
                            context,
                            availableROAs: availableROAs,
                            selectedRoute: selectedRoute,
                            accentColor: targetAccent,
                          ),
                          CommonSpacer.vertical(fieldGap),
                          // Date & Time
                          Row(
                            children: [
                              Expanded(
                                child: DateSelector(
                                  selectedDate: DateTime(
                                    (widget.date ?? DateTime.now()).year,
                                    (widget.date ?? DateTime.now()).month,
                                    (widget.date ?? DateTime.now()).day,
                                    widget.hour ?? TimeOfDay.now().hour,
                                    widget.minute ?? TimeOfDay.now().minute,
                                  ),
                                  onDateChanged: (value) {
                                    widget.onDateChanged?.call(
                                      DateTime(
                                        value.year,
                                        value.month,
                                        value.day,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: th.sp.md),
                              Expanded(child: _buildTimeSelector(context)),
                            ],
                          ),
                          CommonSpacer.vertical(fieldGap),
                          // Location
                          CommonDropdown<String>(
                            value:
                                widget.location ??
                                DrugUseCatalog.locations.first,
                            items: DrugUseCatalog.locations,
                            accentColor: targetAccent,
                            onChanged: (v) {
                              if (v != null &&
                                  widget.onLocationChanged != null) {
                                widget.onLocationChanged!(v);
                              }
                            },
                            hintText: 'Location',
                          ),
                          CommonSpacer.vertical(fieldGap),
                          // Medical Purpose
                          CommonSwitchTile(
                            title: 'Medical Purpose',
                            value: widget.isMedicalPurpose ?? false,
                            onChanged: (v) =>
                                widget.onMedicalPurposeChanged?.call(v),
                          ),
                          CommonSpacer.vertical(fieldGap),
                          // Extra Details accordion
                          ExpansionTile(
                            key: const ValueKey('extra_details_accordion'),
                            initiallyExpanded: _showExtraDetails,
                            onExpansionChanged: (v) =>
                                setState(() => _showExtraDetails = v),
                            title: Text('Extra details', style: th.text.body),
                            // Ensure header/text/icon contrast against the surface by
                            // using the page-derived animatedAccent where available.
                            collapsedIconColor:
                                (animatedAccent ?? context.accent.primary),
                            iconColor:
                                (animatedAccent ?? context.accent.primary),
                            textColor:
                                (animatedAccent ?? context.accent.primary),
                            collapsedTextColor:
                                (animatedAccent ?? context.accent.primary),
                            backgroundColor: targetAccent == null
                                ? th.c.surface
                                : Color.alphaBlend(
                                    (animatedAccent ?? context.accent.primary)
                                        .withValues(
                                          alpha: th.opacities.veryLow,
                                        ),
                                    th.c.surface,
                                  ),
                            collapsedBackgroundColor: targetAccent == null
                                ? th.c.surface
                                : Color.alphaBlend(
                                    (animatedAccent ?? context.accent.primary)
                                        .withValues(
                                          alpha: th.opacities.veryLow,
                                        ),
                                    th.c.surface,
                                  ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: th.sp.md,
                                  vertical: th.sp.sm,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      AppLayout.crossAxisAlignmentStretch,
                                  children: [
                                    // Intention
                                    SizedBox(
                                      width: double.infinity,
                                      child: CommonDropdown<String>(
                                        value:
                                            widget.intention ??
                                            intentions.first,
                                        items: intentions,
                                        onChanged: (v) {
                                          if (v != null &&
                                              widget.onIntentionChanged !=
                                                  null) {
                                            widget.onIntentionChanged!(v);
                                          }
                                        },
                                        hintText: 'Intention',
                                      ),
                                    ),
                                    CommonSpacer.vertical(th.sp.md),
                                    // Craving Intensity
                                    SizedBox(
                                      width: double.infinity,
                                      child: CommonCard(
                                        padding: EdgeInsets.all(
                                          th.sp.cardPadding,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              AppLayout.crossAxisAlignmentStart,
                                          children: [
                                            CommonSectionHeader(
                                              title: 'Craving Intensity',
                                              subtitle:
                                                  'How strong was the urge?',
                                            ),
                                            CommonSpacer.vertical(th.sp.sm),
                                            CommonSlider(
                                              value:
                                                  widget.cravingIntensity ??
                                                  0.0,
                                              min: 0.0,
                                              max: 10.0,
                                              divisions: 10,
                                              activeColor: targetAccent,
                                              onChanged: (v) => widget
                                                  .onCravingIntensityChanged
                                                  ?.call(v),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CommonSpacer.vertical(th.sp.md),
                                    // Emotions
                                    SizedBox(
                                      width: double.infinity,
                                      child: _buildPrimaryEmotionsGrid(
                                        context,
                                        accentColor: targetAccent,
                                      ),
                                    ),
                                    CommonSpacer.vertical(th.sp.md),
                                    // Secondary Emotions
                                    if (widget.feelings != null &&
                                        widget.feelings!.isNotEmpty)
                                      SizedBox(
                                        width: double.infinity,
                                        child: _buildSecondaryEmotions(context),
                                      ),
                                    // Triggers
                                    SizedBox(
                                      width: double.infinity,
                                      child: _buildMultiSelectGridCard(
                                        context,
                                        title: 'Triggers',
                                        subtitle: 'What triggered this use?',
                                        options: triggers,
                                        selected:
                                            widget.selectedTriggers ?? const [],
                                        onChanged: widget.onTriggersChanged,
                                        columnsWide: 4,
                                        columnsNarrow: 2,
                                        selectedColor: targetAccent,
                                      ),
                                    ),
                                    CommonSpacer.vertical(th.sp.md),
                                    // Body Signals
                                    SizedBox(
                                      width: double.infinity,
                                      child: _buildMultiSelectGridCard(
                                        context,
                                        title: 'Body Signals',
                                        subtitle: 'Physical sensations',
                                        options: physicalSensations,
                                        selected:
                                            widget.selectedBodySignals ??
                                            const [],
                                        onChanged: widget.onBodySignalsChanged,
                                        columnsWide: 4,
                                        columnsNarrow: 2,
                                        selectedColor: targetAccent,
                                      ),
                                    ),
                                    CommonSpacer.vertical(th.sp.md),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Notes
                          CommonSpacer.vertical(th.sp.lg),

                          CommonTextarea(
                            controller: widget.notesCtrl,
                            labelText: 'Notes',
                            maxLines: 3,
                            accentColor: targetAccent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              final contentWidget = constraints.hasBoundedHeight
                  ? Expanded(child: scrollableContent)
                  : scrollableContent;

              return Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
                children: [
                  contentWidget,
                  CommonSpacer.vertical(th.sp.md),
                  if (widget.showSaveButton && widget.onSave != null)
                    CommonPrimaryButton(
                      onPressed: widget.onSave!,
                      label: 'Save Entry',
                      backgroundColor: targetAccent,
                      icon: targetIcon,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildROASelector(
    BuildContext context, {
    required List<String> availableROAs,
    required String selectedRoute,
    required Color? accentColor,
  }) {
    final th = context.theme;

    final normalizedAvailable = availableROAs
        .map((r) => r.trim().toLowerCase())
        .where((r) => r.isNotEmpty)
        .toSet()
        .toList(growable: false);

    final extras = normalizedAvailable
        .where((r) => !RoaNormalization.primaryDisplayROAs.contains(r))
        .toList(growable: false);

    final display = <String>[...RoaNormalization.primaryDisplayROAs, ...extras];

    final chips = display
        .map((roa) {
          final isSelected = selectedRoute.toLowerCase() == roa.toLowerCase();
          final validated = widget.isROAValidated?.call(roa) ?? true;

          final emoji = RoaNormalization.primaryEmoji[roa];
          final label = roa.isEmpty
              ? roa
              : '${roa[0].toUpperCase()}${roa.substring(1)}';

          final chipAccent = validated ? accentColor : th.c.warning;

          return CommonChip(
            key: ValueKey('roa_$roa'),
            label: label,
            emoji: emoji,
            icon: validated ? null : Icons.warning_amber_rounded,
            isSelected: isSelected,
            showGlow: isSelected,
            selectedColor: chipAccent,
            selectedBorderColor: chipAccent,
            onTap: () => widget.onRouteChanged?.call(roa),
          );
        })
        .toList(growable: false);

    return _buildFixedWidthGrid(
      context,
      children: chips,
      columnsWide: 3,
      columnsNarrow: 2,
      narrowBreakpoint: 360,
      spacing: th.sp.sm,
    );
  }

  Widget _buildPrimaryEmotionsGrid(
    BuildContext context, {
    required Color? accentColor,
  }) {
    final th = context.theme;
    final selected = widget.feelings ?? const <String>[];

    final chips = DrugUseCatalog.primaryEmotions
        .map((e) {
          final name = e['name']!;
          final emoji = e['emoji'];
          final isSelected = selected.contains(name);

          return CommonChip(
            key: ValueKey('primary_emotion_$name'),
            label: name,
            emoji: emoji,
            isSelected: isSelected,
            showGlow: isSelected,
            selectedColor: accentColor,
            selectedBorderColor: accentColor,
            onTap: () {
              if (widget.onFeelingsChanged == null) return;
              final current = List<String>.from(selected);
              isSelected ? current.remove(name) : current.add(name);
              widget.onFeelingsChanged!(current);
            },
          );
        })
        .toList(growable: false);

    return CommonCard(
      padding: EdgeInsets.all(th.sp.cardPadding),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          const CommonSectionHeader(
            title: 'Emotions',
            subtitle: 'How did you feel?',
          ),
          CommonSpacer.vertical(th.sp.md),
          // 8 emotions -> 2 columns -> 4 rows.
          _buildFixedWidthGrid(
            context,
            children: chips,
            columnsWide: 2,
            columnsNarrow: 2,
            narrowBreakpoint: 0,
            spacing: th.sp.sm,
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectGridCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required List<String> options,
    required List<String> selected,
    required ValueChanged<List<String>>? onChanged,
    required int columnsWide,
    required int columnsNarrow,
    required Color? selectedColor,
  }) {
    final th = context.theme;

    final children = options
        .map((opt) {
          final isSelected = selected.contains(opt);
          return CommonChip(
            key: ValueKey('${title}_$opt'),
            label: opt,
            isSelected: isSelected,
            showGlow: isSelected,
            selectedColor: selectedColor,
            selectedBorderColor: selectedColor,
            onTap: () {
              if (onChanged == null) return;
              final updated = List<String>.from(selected);
              isSelected ? updated.remove(opt) : updated.add(opt);
              onChanged(updated);
            },
          );
        })
        .toList(growable: false);

    return CommonCard(
      padding: EdgeInsets.all(th.sp.cardPadding),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSectionHeader(title: title, subtitle: subtitle),
          CommonSpacer.vertical(th.sp.md),
          _buildFixedWidthGrid(
            context,
            children: children,
            columnsWide: columnsWide,
            columnsNarrow: columnsNarrow,
            narrowBreakpoint: 360,
            spacing: th.sp.sm,
          ),
        ],
      ),
    );
  }

  Widget _buildFixedWidthGrid(
    BuildContext context, {
    required List<Widget> children,
    required int columnsWide,
    required int columnsNarrow,
    required double narrowBreakpoint,
    required double spacing,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = (narrowBreakpoint > 0 && maxWidth < narrowBreakpoint)
            ? columnsNarrow
            : columnsWide;

        final safeColumns = columns <= 0 ? 1 : columns;
        final totalGaps = spacing * (safeColumns - 1);
        final itemWidth = (maxWidth - totalGaps) / safeColumns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(growable: false),
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
    final timeLabel = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(time, alwaysUse24HourFormat: true);
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(alwaysUse24HourFormat: true),
              child: child ?? const SizedBox.shrink(),
            );
          },
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
            horizontal: th.sp.md,
            vertical: th.sp.sm,
          ),
        ),
        child: Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Expanded(
              child: Text(
                timeLabel,
                style: th.text.body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
      children: widget.feelings!
          .map((emotion) {
            final secondaryOptions = DrugUseCatalog.secondaryEmotions[emotion];
            if (secondaryOptions == null || secondaryOptions.isEmpty) {
              return const SizedBox.shrink();
            }

            final selected =
                widget.secondaryFeelings?[emotion] ?? const <String>[];

            final chips = secondaryOptions
                .map((opt) {
                  final isSelected = selected.contains(opt);
                  return CommonChip(
                    key: ValueKey('secondary_${emotion}_$opt'),
                    label: opt,
                    isSelected: isSelected,
                    showGlow: isSelected,
                    onTap: () {
                      if (widget.onSecondaryFeelingsChanged == null) return;
                      final updated = List<String>.from(selected);
                      isSelected ? updated.remove(opt) : updated.add(opt);
                      final current = Map<String, List<String>>.from(
                        widget.secondaryFeelings ?? {},
                      );
                      current[emotion] = updated;
                      widget.onSecondaryFeelingsChanged!(current);
                    },
                  );
                })
                .toList(growable: false);

            return Padding(
              padding: EdgeInsets.only(bottom: th.sp.md),
              child: CommonCard(
                padding: EdgeInsets.all(th.sp.cardPadding),
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    CommonSectionHeader(title: '$emotion Details'),
                    CommonSpacer.vertical(th.sp.md),
                    // 4 per row when possible (25% each).
                    _buildFixedWidthGrid(
                      context,
                      children: chips,
                      columnsWide: 4,
                      columnsNarrow: 4,
                      narrowBreakpoint: 0,
                      spacing: th.sp.sm,
                    ),
                  ],
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
