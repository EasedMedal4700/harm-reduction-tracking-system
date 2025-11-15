import 'package:flutter/material.dart';
import '../constants/body_and_mind_catalog.dart';
import '../constants/drug_use_catalog.dart';
import '../widgets/cravings/craving_details_section.dart'; // Add imports
import '../widgets/cravings/emotional_state_section.dart';
import '../widgets/cravings/body_mind_signals_section.dart';
import '../widgets/cravings/outcome_section.dart';
import '../models/craving_model.dart'; // Add
import '../services/craving_service.dart'; // Add
import '../services/timezone_service.dart'; // Add
import '../services/user_service.dart'; // Add

class CravingsPage extends StatefulWidget {
  const CravingsPage({super.key});

  @override
  State<CravingsPage> createState() => _CravingsPageState();
}

class _CravingsPageState extends State<CravingsPage> {
  List<String> selectedCravings = [];
  double intensity = 0.0;
  String location = 'Select a location'; // Set default
  String? withWho;
  List<String> selectedEmotions = [];
  String? thoughts;
  List<String> selectedSensations = [];
  String? whatDidYouDo;
  bool actedOnCraving = false;
  final CravingService _cravingService = CravingService(); // Add
  final TimezoneService _timezoneService = TimezoneService(); // Add
  bool _isSaving = false; // Add loading state

  final List<String> sensations = physicalSensations;
  final List<String> emotions = DrugUseCatalog.primaryEmotions
      .map((e) => e['name']!)
      .toList();

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final now = DateTime.now();
    final craving = Craving(
      userId: UserService.getCurrentUserId(),
      substance: selectedCravings.isNotEmpty
          ? selectedCravings.join('; ')
          : '', // Use semicolon separator
      intensity: intensity,
      date: now,
      time:
          '${now.toIso8601String().split('T')[0]} ${now.toUtc().toIso8601String().split('T')[1].split('.')[0]}+00', // Format as '2025-11-07 21:56:00+00'
      location: location,
      people: withWho ?? '',
      activity: whatDidYouDo ?? '',
      thoughts: thoughts ?? '',
      triggers: [], // Add if you collect triggers
      bodySensations: selectedSensations,
      primaryEmotion: selectedEmotions.isNotEmpty
          ? selectedEmotions.join(', ')
          : '',
      secondaryEmotion: null, // Add if you have secondary emotions
      action: actedOnCraving ? 'Acted' : 'Resisted',
      timezone: _timezoneService.getTimezoneOffset(),
    );

    try {
      await _cravingService.saveCraving(craving);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Craving saved!')));
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _resetForm() {
    setState(() {
      selectedCravings = [];
      intensity = 5.0;
      location = 'Select a location'; // Set default on reset
      withWho = null;
      selectedEmotions = [];
      thoughts = null;
      selectedSensations = [];
      whatDidYouDo = null;
      actedOnCraving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cravings'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save, // Disable if saving
            child: _isSaving
                ? const CircularProgressIndicator()
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Craving Reflection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Log your recent craving experience'),
            const Divider(),
            CravingDetailsSection(
              selectedCravings: selectedCravings,
              onCravingsChanged: (cravings) =>
                  setState(() => selectedCravings = cravings),
              intensity: intensity,
              onIntensityChanged: (value) => setState(() => intensity = value),
              location: location,
              onLocationChanged: (value) =>
                  setState(() => location = value ?? 'Home'),
              withWho: withWho,
              onWithWhoChanged: (value) => setState(() => withWho = value),
            ),
            const Divider(),
            EmotionalStateSection(
              selectedEmotions: selectedEmotions,
              onEmotionsChanged: (emotions) =>
                  setState(() => selectedEmotions = emotions),
              thoughts: thoughts,
              onThoughtsChanged: (value) => setState(() => thoughts = value),
            ),
            const Divider(),
            BodyMindSignalsSection(
              sensations: sensations,
              selectedSensations: selectedSensations,
              onSensationsChanged: (sensations) =>
                  setState(() => selectedSensations = sensations),
            ),
            const Divider(),
            OutcomeSection(
              whatDidYouDo: whatDidYouDo,
              onWhatDidYouDoChanged: (value) =>
                  setState(() => whatDidYouDo = value),
              actedOnCraving: actedOnCraving,
              onActedOnCravingChanged: (value) =>
                  setState(() => actedOnCraving = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSaving ? null : _save, // Disable if saving
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
