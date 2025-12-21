// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Page for editing cravings. No hardcoded values.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import '../../common/layout/common_spacer.dart';
import '../craving/widgets/cravings/craving_details_section.dart';
import '../craving/widgets/cravings/emotional_state_section.dart';
import '../craving/widgets/cravings/body_mind_signals_section.dart';
import '../craving/widgets/cravings/outcome_section.dart';
import 'widgets/edit_craving/craving_app_bar.dart';
import '../../services/craving_service.dart';
import '../../utils/error_handler.dart';
import '../../constants/data/body_and_mind_catalog.dart';
import '../../constants/data/drug_use_catalog.dart';
import '../../constants/data/craving_consatnts.dart';

class EditCravingPage extends StatefulWidget {
  final Map<String, dynamic> entry;
  final CravingService? cravingService;
  const EditCravingPage({super.key, required this.entry, this.cravingService});

  @override
  State<EditCravingPage> createState() => _EditCravingPageState();
}

class _EditCravingPageState extends State<EditCravingPage> {
  late final CravingService _cravingService;

  // Form fields
  List<String> selectedCravings = [];
  double intensity = 5.0;
  String location = 'Select a location';
  String withWho = '';
  List<String> primaryEmotions = [];
  Map<String, List<String>> secondaryEmotions = {};
  String thoughts = '';
  List<String> selectedSensations = [];
  String whatDidYouDo = '';
  bool actedOnCraving = false;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _cravingId;

  final List<String> sensations = physicalSensations;
  final List<String> emotions = DrugUseCatalog.primaryEmotions
      .map((e) => e['name']!)
      .toList();

  @override
  void initState() {
    super.initState();
    _cravingService = widget.cravingService ?? CravingService();
    _loadCravingData();
  }

  Future<void> _loadCravingData() async {
    setState(() => _isLoading = true);

    try {
      _cravingId = widget.entry['craving_id']?.toString();

      if (_cravingId == null || _cravingId!.isEmpty) {
        throw Exception('Missing craving ID');
      }

      ErrorHandler.logDebug(
        'EditCravingPage',
        'Loading craving with ID: $_cravingId',
      );

      final data = await _cravingService.fetchCravingById(_cravingId!);

      if (data == null) {
        throw Exception('Craving not found');
      }

      // Parse and populate form fields
      setState(() {
        // Parse substance(s) - DB uses semicolon-separated with full emoji names
        final substanceStr = data['substance']?.toString() ?? '';
        if (substanceStr.isEmpty) {
          selectedCravings = [];
        } else {
          // Split by semicolon (DB format) and trim whitespace
          final parsedList = substanceStr
              .split(';')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty);

          // Map DB values (singular) to UI keys (plural + emoji)
          selectedCravings = parsedList.map((s) {
            for (var entry in cravingCategories.entries) {
              if (entry.value == s) return entry.key;
            }
            return s;
          }).toList();

          ErrorHandler.logDebug(
            'EditCravingPage',
            'Parsed substances from DB: $selectedCravings',
          );
        }

        intensity =
            double.tryParse(data['intensity']?.toString() ?? '5.0') ?? 5.0;

        // Validate location against allowed values
        final dbLocation = data['location']?.toString() ?? 'Select a location';
        if (DrugUseCatalog.locations.contains(dbLocation)) {
          location = dbLocation;
        } else {
          // If DB has invalid/custom location, default to 'Other' or first valid option
          ErrorHandler.logWarning(
            'EditCravingPage',
            'Invalid location in DB: $dbLocation, defaulting to "Other"',
          );
          location = 'Other';
        }

        // Validate "who were you with" against allowed values
        final dbWithWho = data['people']?.toString() ?? '';
        const validWithWhoOptions = ['Alone', 'Friends', 'Family', 'Other'];
        if (dbWithWho.isEmpty || !validWithWhoOptions.contains(dbWithWho)) {
          // If DB has invalid/custom value, default to empty or 'Other'
          ErrorHandler.logWarning(
            'EditCravingPage',
            'Invalid withWho in DB: $dbWithWho, defaulting to empty',
          );
          withWho = ''; // Will show as placeholder in dropdown
        } else {
          withWho = dbWithWho;
        }

        thoughts = data['thoughts']?.toString() ?? '';
        whatDidYouDo = data['activity']?.toString() ?? '';

        // Parse body sensations
        final sensationsStr = data['body_sensations']?.toString() ?? '';
        selectedSensations = sensationsStr.isEmpty
            ? []
            : sensationsStr
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();

        // Parse emotions
        final primaryStr = data['primary_emotion']?.toString() ?? '';
        primaryEmotions = primaryStr.isEmpty
            ? []
            : primaryStr
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();

        // Parse secondary emotions
        // Note: DB stores secondary emotions as flat comma-separated list,
        // but UI expects map structure. For now, initialize empty map.
        // Secondary emotions can be re-selected in the UI.
        secondaryEmotions = {};

        // Parse action
        final actionStr = data['action']?.toString() ?? '';
        actedOnCraving = actionStr.toLowerCase() == 'acted';
      });

      ErrorHandler.logDebug(
        'EditCravingPage',
        'Craving loaded - substance: $selectedCravings, intensity: $intensity',
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError('EditCravingPage._loadCravingData', e, stackTrace);
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          title: 'Failed to Load Craving',
          message: 'Could not load craving data.',
          details: e.toString(),
          onRetry: _loadCravingData,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      ErrorHandler.logDebug(
        'EditCravingPage',
        'Saving changes for craving: $_cravingId',
      );

      // Map UI keys back to DB values
      final substancesToSave = selectedCravings.map((s) {
        return cravingCategories[s] ?? s;
      }).toList();

      // Flatten secondary emotions
      final allSecondary = secondaryEmotions.values
          .expand((list) => list)
          .toList();

      final updateData = {
        'substance': substancesToSave.isNotEmpty
            ? substancesToSave.join('; ')
            : '', // Use semicolon like DB
        'intensity': intensity.toInt(),
        'location': location,
        'people': withWho,
        'activity': whatDidYouDo,
        'thoughts': thoughts,
        'body_sensations': selectedSensations.join(','),
        'primary_emotion': primaryEmotions.isNotEmpty
            ? primaryEmotions.join(', ')
            : '',
        'secondary_emotion': allSecondary.isNotEmpty
            ? allSecondary.join(', ')
            : null,
        'action': actedOnCraving ? 'Acted' : 'Resisted',
      };

      await _cravingService.updateCraving(_cravingId!, updateData);

      if (mounted) {
        ErrorHandler.showSuccessSnackbar(
          context,
          message: 'Craving updated successfully!',
        );
        Navigator.pop(context, true);
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError('EditCravingPage._saveChanges', e, stackTrace);
      if (mounted) {
        ErrorHandler.showErrorDialog(
          context,
          title: 'Failed to Save',
          message: 'Could not update craving.',
          details: e.toString(),
          onRetry: _saveChanges,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: CravingAppBar(isSaving: _isSaving, onSave: _saveChanges),
      drawer: const CommonDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: a.primary))
          : SingleChildScrollView(
              padding: EdgeInsets.all(sp.md),
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  CravingDetailsSection(
                    selectedCravings: selectedCravings,
                    intensity: intensity,
                    location: location,
                    withWho: withWho,
                    onCravingsChanged: (value) =>
                        setState(() => selectedCravings = value),
                    onIntensityChanged: (value) =>
                        setState(() => intensity = value),
                    onLocationChanged: (value) =>
                        setState(() => location = value ?? 'Select a location'),
                    onWithWhoChanged: (value) =>
                        setState(() => withWho = value ?? ''),
                  ),
                  CommonSpacer.vertical(sp.lg),
                  EmotionalStateSection(
                    selectedEmotions: primaryEmotions,
                    secondaryEmotions: secondaryEmotions,
                    thoughts: thoughts,
                    onEmotionsChanged: (value) =>
                        setState(() => primaryEmotions = value),
                    onSecondaryEmotionsChanged: (value) =>
                        setState(() => secondaryEmotions = value),
                    onThoughtsChanged: (value) =>
                        setState(() => thoughts = value),
                  ),
                  CommonSpacer.vertical(sp.lg),
                  BodyMindSignalsSection(
                    sensations: sensations,
                    selectedSensations: selectedSensations,
                    onSensationsChanged: (value) =>
                        setState(() => selectedSensations = value),
                  ),
                  CommonSpacer.vertical(sp.lg),
                  OutcomeSection(
                    whatDidYouDo: whatDidYouDo,
                    actedOnCraving: actedOnCraving,
                    onWhatDidYouDoChanged: (value) =>
                        setState(() => whatDidYouDo = value),
                    onActedOnCravingChanged: (value) =>
                        setState(() => actedOnCraving = value),
                  ),
                  CommonSpacer.vertical(sp.xl),
                ],
              ),
            ),
    );
  }
}
