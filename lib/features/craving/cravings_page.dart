// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Page for logging cravings. Uses CommonPrimaryButton. No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../common/layout/common_drawer.dart';
import '../../constants/data/body_and_mind_catalog.dart';
import '../../constants/data/drug_use_catalog.dart';
import 'widgets/craving_details_section.dart';
import 'widgets/emotional_state_section.dart';
import 'widgets/body_mind_signals_section.dart';
import 'widgets/outcome_section.dart';
import '../../models/craving_model.dart';
import 'services/craving_service.dart';
import '../../services/timezone_service.dart';
import '../../services/user_service.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../common/buttons/common_primary_button.dart';

class CravingsPage extends StatefulWidget {
  final CravingService? cravingService;
  const CravingsPage({super.key, this.cravingService});
  @override
  State<CravingsPage> createState() => _CravingsPageState();
}

class _CravingsPageState extends State<CravingsPage> {
  List<String> selectedCravings = [];
  double intensity = 0.0;
  String location = 'Select a location';
  String? withWho;
  List<String> primaryEmotions = [];
  Map<String, List<String>> secondaryEmotions = {};
  String? thoughts;
  List<String> selectedSensations = [];
  String? whatDidYouDo;
  bool actedOnCraving = false;
  late final CravingService _cravingService;
  final TimezoneService _timezoneService = TimezoneService();
  bool _isSaving = false;
  final List<String> sensations = physicalSensations;
  final List<String> emotions = DrugUseCatalog.primaryEmotions
      .map((e) => e['name']!)
      .toList();
  @override
  void initState() {
    super.initState();
    _cravingService = widget.cravingService ?? CravingService();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final now = DateTime.now();
    final allSecondary = secondaryEmotions.values
        .expand((list) => list)
        .toList();
    final craving = Craving(
      userId: UserService.getCurrentUserId(),
      substance: selectedCravings.isNotEmpty ? selectedCravings.join('; ') : '',
      intensity: intensity,
      date: now,
      time:
          '${now.toIso8601String().split('T')[0]} ${now.toUtc().toIso8601String().split('T')[1].split('.')[0]}+00',
      location: location,
      people: withWho ?? '',
      activity: whatDidYouDo ?? '',
      thoughts: thoughts ?? '',
      triggers: [],
      bodySensations: selectedSensations,
      primaryEmotion: primaryEmotions.isNotEmpty
          ? primaryEmotions.join(', ')
          : '',
      secondaryEmotion: allSecondary.isNotEmpty
          ? allSecondary.join(', ')
          : null,
      action: actedOnCraving ? 'Acted' : 'Resisted',
      timezone: _timezoneService.getTimezoneOffset(),
    );
    try {
      await _cravingService.saveCraving(craving);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Craving saved!'),
          backgroundColor: th.colors.success,
          duration: context.animations.toast,
        ),
      );
      _resetForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
          backgroundColor: th.colors.error,
          duration: context.animations.toast,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _resetForm() {
    setState(() {
      selectedCravings = [];
      intensity = 5.0;
      location = 'Select a location';
      withWho = null;
      primaryEmotions = [];
      secondaryEmotions = {};
      thoughts = null;
      selectedSensations = [];
      whatDidYouDo = null;
      actedOnCraving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text('Log Craving', style: th.typography.heading3),
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: th.sizes.elevationNone,
        actions: [
          Semantics(
            button: true,
            enabled: !_isSaving,
            label: _isSaving ? 'Saving craving' : 'Save craving',
            child: TextButton.icon(
              onPressed: () {
                if (!_isSaving) _save();
              },
              icon: _isSaving
                  ? SizedBox(
                      width: th.spacing.lg,
                      height: th.spacing.lg,
                      child: CircularProgressIndicator(
                        strokeWidth: th.borders.medium,
                        color: ac.primary,
                      ),
                    )
                  : Icon(Icons.check, color: ac.primary),
              label: Text(
                _isSaving ? 'Saving...' : 'Save',
                style: th.typography.labelLarge.copyWith(color: ac.primary),
              ),
            ),
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      body: RefreshIndicator(
        color: ac.primary,
        backgroundColor: c.surface,
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.lg),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text('Craving Reflection', style: th.typography.heading2),
              SizedBox(height: sp.sm),
              Text(
                'Log your recent craving experience',
                style: th.typography.body.copyWith(color: c.textSecondary),
              ),
              Divider(color: c.border),
              CravingDetailsSection(
                selectedCravings: selectedCravings,
                onCravingsChanged: (cravings) =>
                    setState(() => selectedCravings = cravings),
                intensity: intensity,
                onIntensityChanged: (value) =>
                    setState(() => intensity = value),
                location: location,
                onLocationChanged: (value) =>
                    setState(() => location = value ?? 'Home'),
                withWho: withWho,
                onWithWhoChanged: (value) => setState(() => withWho = value),
              ),
              Divider(color: c.border),
              EmotionalStateSection(
                selectedEmotions: primaryEmotions,
                secondaryEmotions: secondaryEmotions,
                onEmotionsChanged: (emotions) =>
                    setState(() => primaryEmotions = emotions),
                onSecondaryEmotionsChanged: (secondary) =>
                    setState(() => secondaryEmotions = secondary),
                thoughts: thoughts,
                onThoughtsChanged: (value) => setState(() => thoughts = value),
              ),
              Divider(color: c.border),
              BodyMindSignalsSection(
                sensations: sensations,
                selectedSensations: selectedSensations,
                onSensationsChanged: (sensations) =>
                    setState(() => selectedSensations = sensations),
              ),
              Divider(color: c.border),
              OutcomeSection(
                whatDidYouDo: whatDidYouDo,
                onWhatDidYouDoChanged: (value) =>
                    setState(() => whatDidYouDo = value),
                actedOnCraving: actedOnCraving,
                onActedOnCravingChanged: (value) =>
                    setState(() => actedOnCraving = value),
              ),
              SizedBox(height: sp.lg),
              CommonPrimaryButton(
                label: 'Save Entry',
                onPressed: () {
                  _save();
                },
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
