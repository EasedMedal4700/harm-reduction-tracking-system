import 'package:flutter/material.dart';
import '../../widgets/common/drawer_menu.dart';
import '../../services/craving_service.dart';
import '../../utils/error_handler.dart';
import '../../constants/body_and_mind_catalog.dart';
import '../../constants/drug_use_catalog.dart';
import '../../widgets/cravings/craving_details_section.dart';
import '../../widgets/cravings/emotional_state_section.dart';
import '../../widgets/cravings/body_mind_signals_section.dart';
import '../../widgets/cravings/outcome_section.dart';

class EditCravingPage extends StatefulWidget {
  final Map<String, dynamic> entry;
  const EditCravingPage({super.key, required this.entry});

  @override
  State<EditCravingPage> createState() => _EditCravingPageState();
}

class _EditCravingPageState extends State<EditCravingPage> {
  final CravingService _cravingService = CravingService();
  
  // Form fields
  List<String> selectedCravings = [];
  double intensity = 5.0;
  String location = 'Select a location';
  String withWho = '';
  List<String> selectedEmotions = [];
  String thoughts = '';
  List<String> selectedSensations = [];
  String whatDidYouDo = '';
  bool actedOnCraving = false;
  
  bool _isLoading = true;
  bool _isSaving = false;
  String? _cravingId;

  final List<String> sensations = physicalSensations;
  final List<String> emotions = DrugUseCatalog.primaryEmotions.map((e) => e['name']!).toList();

  @override
  void initState() {
    super.initState();
    _loadCravingData();
  }

  Future<void> _loadCravingData() async {
    setState(() => _isLoading = true);

    try {
      _cravingId = widget.entry['craving_id']?.toString();
      
      if (_cravingId == null || _cravingId!.isEmpty) {
        throw Exception('Missing craving ID');
      }

      ErrorHandler.logDebug('EditCravingPage', 'Loading craving with ID: $_cravingId');

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
          selectedCravings = substanceStr
              .split(';')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
          
          ErrorHandler.logDebug('EditCravingPage', 'Parsed substances from DB: $selectedCravings');
        }

        intensity = double.tryParse(data['intensity']?.toString() ?? '5.0') ?? 5.0;
        
        // Validate location against allowed values
        final dbLocation = data['location']?.toString() ?? 'Select a location';
        if (DrugUseCatalog.locations.contains(dbLocation)) {
          location = dbLocation;
        } else {
          // If DB has invalid/custom location, default to 'Other' or first valid option
          ErrorHandler.logWarning('EditCravingPage', 'Invalid location in DB: $dbLocation, defaulting to "Other"');
          location = 'Other';
        }
        
        // Validate "who were you with" against allowed values
        final dbWithWho = data['people']?.toString() ?? '';
        const validWithWhoOptions = ['Alone', 'Friends', 'Family', 'Other'];
        if (dbWithWho.isEmpty || !validWithWhoOptions.contains(dbWithWho)) {
          // If DB has invalid/custom value, default to empty or 'Other'
          ErrorHandler.logWarning('EditCravingPage', 'Invalid withWho in DB: $dbWithWho, defaulting to empty');
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
            : sensationsStr.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

        // Parse emotions
        final emotionsStr = data['primary_emotion']?.toString() ?? '';
        selectedEmotions = emotionsStr.isEmpty
            ? []
            : emotionsStr.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

        // Parse action
        final actionStr = data['action']?.toString() ?? '';
        actedOnCraving = actionStr.toLowerCase() == 'acted';
      });

      ErrorHandler.logDebug('EditCravingPage', 'Craving loaded - substance: $selectedCravings, intensity: $intensity');
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
      ErrorHandler.logDebug('EditCravingPage', 'Saving changes for craving: $_cravingId');

      final updateData = {
        'substance': selectedCravings.isNotEmpty ? selectedCravings.join('; ') : '', // Use semicolon like DB
        'intensity': intensity.toInt(),
        'location': location,
        'people': withWho,
        'activity': whatDidYouDo,
        'thoughts': thoughts,
        'body_sensations': selectedSensations.join(','),
        'primary_emotion': selectedEmotions.isNotEmpty ? selectedEmotions.join(', ') : '',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Craving'),
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.check),
              label: const Text('Save'),
            ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CravingDetailsSection(
                    selectedCravings: selectedCravings,
                    intensity: intensity,
                    location: location,
                    withWho: withWho,
                    onCravingsChanged: (value) => setState(() => selectedCravings = value),
                    onIntensityChanged: (value) => setState(() => intensity = value),
                    onLocationChanged: (value) => setState(() => location = value ?? 'Select a location'),
                    onWithWhoChanged: (value) => setState(() => withWho = value ?? ''),
                  ),
                  const SizedBox(height: 24),
                  EmotionalStateSection(
                    selectedEmotions: selectedEmotions,
                    thoughts: thoughts,
                    onEmotionsChanged: (value) => setState(() => selectedEmotions = value),
                    onThoughtsChanged: (value) => setState(() => thoughts = value),
                  ),
                  const SizedBox(height: 24),
                  BodyMindSignalsSection(
                    sensations: sensations,
                    selectedSensations: selectedSensations,
                    onSensationsChanged: (value) => setState(() => selectedSensations = value),
                  ),
                  const SizedBox(height: 24),
                  OutcomeSection(
                    whatDidYouDo: whatDidYouDo,
                    actedOnCraving: actedOnCraving,
                    onWhatDidYouDoChanged: (value) => setState(() => whatDidYouDo = value),
                    onActedOnCravingChanged: (value) => setState(() => actedOnCraving = value),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
