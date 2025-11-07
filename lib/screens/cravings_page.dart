import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../constants/body_and_mind_catalog.dart';
import '../constants/drug_use_catalog.dart';
import '../widgets/cravings/craving_details_section.dart'; // Add imports
import '../widgets/cravings/emotional_state_section.dart';
import '../widgets/cravings/body_mind_signals_section.dart';
import '../widgets/cravings/outcome_section.dart';

class CravingsPage extends StatefulWidget {
  const CravingsPage({super.key});

  @override
  State<CravingsPage> createState() => _CravingsPageState();
}

class _CravingsPageState extends State<CravingsPage> {
  final AnalyticsService _service = AnalyticsService('user_id');
  List<String> selectedCravings = [];
  double intensity = 5.0;
  String location = 'Home';
  String? withWho;
  List<String> selectedEmotions = [];
  String? thoughts;
  List<String> selectedSensations = [];
  String? whatDidYouDo;
  bool actedOnCraving = false;

  final List<String> sensations = physicalSensations;
  final List<String> emotions = DrugUseCatalog.primaryEmotions.map((e) => e['name']!).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cravings'),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved (placeholder)')),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Craving Reflection', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Log your recent craving experience'),
            const Divider(),
            CravingDetailsSection(
              selectedCravings: selectedCravings,
              onCravingsChanged: (cravings) => setState(() => selectedCravings = cravings),
              intensity: intensity,
              onIntensityChanged: (value) => setState(() => intensity = value),
              location: location,
              onLocationChanged: (value) => setState(() => location = value ?? 'Home'),
              withWho: withWho,
              onWithWhoChanged: (value) => setState(() => withWho = value),
            ),
            const Divider(),
            EmotionalStateSection(
              selectedEmotions: selectedEmotions,
              onEmotionsChanged: (emotions) => setState(() => selectedEmotions = emotions),
              thoughts: thoughts,
              onThoughtsChanged: (value) => setState(() => thoughts = value),
            ),
            const Divider(),
            BodyMindSignalsSection(
              sensations: sensations,
              selectedSensations: selectedSensations,
              onSensationsChanged: (sensations) => setState(() => selectedSensations = sensations),
            ),
            const Divider(),
            OutcomeSection(
              whatDidYouDo: whatDidYouDo,
              onWhatDidYouDoChanged: (value) => setState(() => whatDidYouDo = value),
              actedOnCraving: actedOnCraving,
              onActedOnCravingChanged: (value) => setState(() => actedOnCraving = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Entry Saved (placeholder)')),
              ),
              child: const Text('Save Entry'),
            ),
          ],
        ),
      ),
    );
  }
}