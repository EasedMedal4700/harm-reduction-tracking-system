// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/data/drug_use_catalog.dart';
import 'package:mobile_drug_use_app/constants/data/body_and_mind_catalog.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/input_field.dart';
import 'package:mobile_drug_use_app/common/inputs/textarea.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';
import 'package:mobile_drug_use_app/common/inputs/emotion_selector.dart';
import 'package:mobile_drug_use_app/common/inputs/slider.dart';
import 'package:mobile_drug_use_app/common/inputs/switch_tile.dart';
import 'package:mobile_drug_use_app/common/buttons/common_chip_group.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/text/common_section_header.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';

class LogEntryForm extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;

    final routeOptions = DrugUseCatalog.consumptionMethods
        .map((m) => m['name']!)
        .toList(growable: false);

    final normalizedRoute = () {
      final raw = route;
      if (raw == null || raw.trim().isEmpty) return 'oral';
      final lower = raw.toLowerCase();
      return routeOptions.contains(lower) ? lower : 'oral';
    }();
    
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
        children: [
          // Substance
          CommonInputField(
            controller: substanceCtrl,
            labelText: 'Substance',
            onChanged: onSubstanceChanged,
            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          ),
          CommonSpacer.vertical(sp.md),

          // Dose & Unit
          Row(
            children: [
              Expanded(
                flex: AppLayout.flex2,
                child: CommonInputField(
                  controller: doseCtrl,
                  labelText: 'Dose',
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    if (onDoseChanged != null) {
                      final val = double.tryParse(v);
                      if (val != null) onDoseChanged!(val);
                    }
                  },
                ),
              ),
              CommonSpacer.horizontal(sp.md),
              Expanded(
                flex: AppLayout.flex1,
                child: CommonDropdown<String>(
                  value: unit ?? 'mg',
                  items: const ['mg', 'g', 'ml', 'oz', 'pills', 'tabs'],
                  onChanged: (v) => onUnitChanged?.call(v ?? 'mg'),
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
            itemLabel: (v) => v.isEmpty ? v : '${v[0].toUpperCase()}${v.substring(1)}',
            onChanged: (v) {
              if (v != null && onRouteChanged != null) {
                onRouteChanged!(v);
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
            value: location ?? DrugUseCatalog.locations.first,
            items: DrugUseCatalog.locations,
            onChanged: (v) {
              if (v != null && onLocationChanged != null) {
                onLocationChanged!(v);
              }
            },
            hintText: 'Location',
          ),
          CommonSpacer.vertical(sp.md),

          // Medical Purpose
          CommonSwitchTile(
            title: 'Medical Purpose',
            value: isMedicalPurpose ?? false,
            onChanged: (v) => onMedicalPurposeChanged?.call(v),
          ),
          CommonSpacer.vertical(sp.md),

          // Complex Mode Inputs
          if (!isSimpleMode) ...[
            // Intention
            CommonDropdown<String>(
              value: intention ?? intentions.first,
              items: intentions,
              onChanged: (v) {
                if (v != null && onIntentionChanged != null) {
                  onIntentionChanged!(v);
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
                    value: cravingIntensity ?? 0.0,
                    min: 0.0,
                    max: 10.0,
                    divisions: 10,
                    onChanged: (v) => onCravingIntensityChanged?.call(v),
                  ),
                ],
              ),
            ),
            CommonSpacer.vertical(sp.md),

            // Emotions
            EmotionSelector(
              selectedEmotions: feelings ?? [],
              availableEmotions: DrugUseCatalog.primaryEmotions.map((e) => e['name']!).toList(),
              onEmotionToggled: (emotion) {
                if (onFeelingsChanged != null) {
                  final current = List<String>.from(feelings ?? []);
                  if (current.contains(emotion)) {
                    current.remove(emotion);
                  } else {
                    current.add(emotion);
                  }
                  onFeelingsChanged!(current);
                }
              },
            ),
            CommonSpacer.vertical(sp.md),

            // Secondary Emotions
            if (feelings != null && feelings!.isNotEmpty)
              _buildSecondaryEmotions(context),

            // Triggers
            CommonChipGroup(
              title: 'Triggers',
              subtitle: 'What triggered this use?',
              options: triggers,
              selected: selectedTriggers ?? [],
              onChanged: (v) => onTriggersChanged?.call(v),
            ),
            CommonSpacer.vertical(sp.md),

            // Body Signals
            CommonChipGroup(
              title: 'Body Signals',
              subtitle: 'Physical sensations',
              options: physicalSensations,
              selected: selectedBodySignals ?? [],
              onChanged: (v) => onBodySignalsChanged?.call(v),
            ),
            CommonSpacer.vertical(sp.md),
          ],

          // Notes
          CommonTextarea(
            controller: notesCtrl,
            labelText: 'Notes',
            maxLines: 3,
          ),
          CommonSpacer.vertical(sp.lg),

          if (showSaveButton && onSave != null)
            CommonPrimaryButton(
              onPressed: onSave!,
              label: 'Save Entry',
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    final t = context.theme;
    final text = context.text;
    final t = context.theme;
    final time = TimeOfDay(hour: hour ?? TimeOfDay.now().hour, minute: minute ?? TimeOfDay.now().minute);
    
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onHourChanged?.call(picked.hour);
          onMinuteChanged?.call(picked.minute);
        }
      },
      borderRadius: BorderRadius.circular(t.shapes.radiusMd),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Time',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: t.spacing.md, vertical: t.spacing.sm),
        ),
        child: Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Text(
              time.format(context),
              style: t.text.body,
            ),
            Icon(Icons.access_time, color: t.colors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryEmotions(BuildContext context) {
    final t = context.theme;
    final t = context.theme;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: feelings!.map((emotion) {
        final secondaryOptions = DrugUseCatalog.secondaryEmotions[emotion];
        if (secondaryOptions == null || secondaryOptions.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(bottom: t.spacing.md),
          child: CommonChipGroup(
            title: '$emotion Details',
            options: secondaryOptions,
            selected: secondaryFeelings?[emotion] ?? [],
            onChanged: (selected) {
              if (onSecondaryFeelingsChanged != null) {
                final current = Map<String, List<String>>.from(secondaryFeelings ?? {});
                current[emotion] = selected;
                onSecondaryFeelingsChanged!(current);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
