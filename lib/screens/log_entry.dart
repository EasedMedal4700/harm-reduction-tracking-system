import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuickLogEntryPage extends StatefulWidget {
  const QuickLogEntryPage({super.key});

  @override
  State<QuickLogEntryPage> createState() => _QuickLogEntryPageState();
}

class _QuickLogEntryPageState extends State<QuickLogEntryPage> {
  double _dose = 0;
  String _unit = 'mg';
  String _route = 'Oral';
  String _feeling = 'Neutral';
  String _location = 'Home';
  DateTime _date = DateTime.now();
  int _hour = TimeOfDay.now().hour;
  int _minute = TimeOfDay.now().minute;
  final _locationCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  

  @override
  void dispose() {
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final result = {
      'dosage': _dose,
      'unit': _unit,
      'route': _route,
      'feeling': _feeling,
      'date': DateFormat('yyyy-MM-dd').format(_date),
      'time': '$_hour:${_minute.toString().padLeft(2, '0')}',
      'location': _locationCtrl.text.trim(),
      'notes': _notesCtrl.text.trim(),
    };
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Entry saved')),
    );
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    final units = ['μg', 'mg', 'g', 'pills', 'ml'];
    final routes = ['Oral', 'Sublingual', 'Intranasal', 'Inhaled', 'Injected'];
    final feelings = ['Neutral', 'Good', 'Tired', 'Energized', 'Anxious'];
    final locations = ['Home', 'Work', 'School', 'Public', 'Vehicle', 'Other']; // Add predefined locations


    return Scaffold(
      appBar: AppBar(title: const Text('Quick Log Entry')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dosage row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => setState(() => _dose = (_dose - 1).clamp(0, 9999)),
              ),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(labelText: 'Dosage'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => setState(() => _dose = double.tryParse(v) ?? _dose),
                  controller:
                      TextEditingController(text: _dose.toStringAsFixed(1)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _dose = _dose + 1),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _unit,
                items: units
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setState(() => _unit = v!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Route
          const Text('Route of Administration'),
          Wrap(
            spacing: 8,
            children: routes.map((r) {
              return ChoiceChip(
                label: Text(r),
                selected: _route == r,
                onSelected: (_) => setState(() => _route = r),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Feeling
          const Text('How are you feeling?'),
          Wrap(
            spacing: 8,
            children: feelings.map((f) {
              return ChoiceChip(
                label: Text(f),
                selected: _feeling == f,
                onSelected: (_) => setState(() => _feeling = f),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Date
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(DateFormat('yyyy-MM-dd').format(_date)),
            trailing: TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDate: _date,
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: const Text('Change'),
            ),
          ),
          const SizedBox(height: 8),

          // Time sliders
          const Text('Hour'),
          Slider(
            min: 0,
            max: 23,
            divisions: 23,
            value: _hour.toDouble(),
            label: '$_hour',
            onChanged: (v) => setState(() => _hour = v.toInt()),
          ),
          const Text('Minute'),
          Slider(
            min: 0,
            max: 59,
            divisions: 59,
            value: _minute.toDouble(),
            label: _minute.toString(),
            onChanged: (v) => setState(() => _minute = v.toInt()),
          ),
          const SizedBox(height: 16),

          // Location
          TextFormField(
            controller: _locationCtrl,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          const SizedBox(height: 16),

          // Notes
          TextFormField(
            controller: _notesCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          const SizedBox(height: 24),

          // Save
          ElevatedButton(
            onPressed: _save,
            child: const Text('Save Entry'),
          ),
        ],
      ),
    );
  }
}
