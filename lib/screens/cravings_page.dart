import 'package:flutter/material.dart';
import '../services/analytics_service.dart'; // For user ID and potential saving
import '../constants/body_and_mind_catalog.dart'; // For physical sensations
import '../constants/drug_use_catalog.dart'; // For emotions
import '../widgets/log_entry/craving_slider.dart'; // For intensity slider
import '../widgets/log_entry/feeling_selection.dart'; // For emotions
import '../widgets/common/location_dropdown.dart'; // For location dropdown

class CravingsPage extends StatefulWidget {
  const CravingsPage({super.key});

  @override
  State<CravingsPage> createState() => _CravingsPageState();
}

class _CravingsPageState extends State<CravingsPage> {
  final AnalyticsService _service = AnalyticsService('user_id'); // Use service for user context
  String? cravingWhat;
  double intensity = 5.0;
  String? location;
  String? withWho;
  List<String> selectedEmotions = [];
  String? thoughts;
  List<String> selectedSensations = [];
  String? whatDidYouDo;
  bool actedOnCraving = false;
  String? howFeelNow;

  // Reuse constants for options
  final List<String> withWhos = ['Alone', 'Friends', 'Family', 'Other'];
  final List<String> sensations = physicalSensations; // From body_and_mind_catalog.dart
  final List<String> emotions = DrugUseCatalog.primaryEmotions.map((e) => e['name']!).toList(); // From drug_use_catalog.dart

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
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text('Craving Reflection', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Log your recent craving experience'),
            const Divider(),

            // Craving Details
            const Text('Craving Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: const InputDecoration(labelText: 'What were you craving?'),
              onChanged: (value) => cravingWhat = value,
            ),
            CravingSlider( // Reuse widget
              value: intensity,
              onChanged: (value) => setState(() => intensity = value),
            ),
 
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Who were you with?'),
              value: withWho,
              items: withWhos.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => withWho = value),
            ),
            const Divider(),

            // Emotional State
            const Text('Emotional State', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            FeelingSelection( // Reuse widget
              feelings: emotions, // Required: list of primary emotions
              secondaryFeelings: <String, List<String>>{}, // Required: list of secondary emotions (empty if not used)
              onFeelingsChanged: (emotions) => setState(() => selectedEmotions = emotions), // Required: callback for primary
              onSecondaryFeelingsChanged: (_) {}, // Required: callback for secondary (do nothing if not used)
            ),
            
            TextFormField(
              decoration: const InputDecoration(labelText: 'Thoughts'),
              maxLines: 3,
              onChanged: (value) => thoughts = value,
            ),
            const Divider(),

            // Body & Mind Signals
            const Text('Body & Mind Signals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              children: sensations.map((sensation) {
                return FilterChip(
                  label: Text(sensation),
                  selected: selectedSensations.contains(sensation),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      selectedSensations.add(sensation);
                    } else {
                      selectedSensations.remove(sensation);
                    }
                  }),
                );
              }).toList(),
            ),
            const Divider(),

            // Outcome
            const Text('Outcome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextFormField(
              decoration: const InputDecoration(labelText: 'What did you do?'),
              maxLines: 3,
              onChanged: (value) => whatDidYouDo = value,
            ),
            SwitchListTile(
              title: const Text('Acted on craving?'),
              value: actedOnCraving,
              onChanged: (value) => setState(() => actedOnCraving = value),
            ),
            const Text('How do you feel now?'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['😊', '😐', '😔', '😡', '😌'].map((emoji) {
                return ElevatedButton(
                  onPressed: () => setState(() => howFeelNow = emoji),
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                );
              }).toList(),
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