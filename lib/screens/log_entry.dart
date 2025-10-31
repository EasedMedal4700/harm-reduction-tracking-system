import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/drawer_menu.dart';

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
  DateTime _date = DateTime.now(); // Add this: Initialize with current date
  int _hour = TimeOfDay.now().hour;
  int _minute = TimeOfDay.now().minute;
  final _notesCtrl = TextEditingController();


  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  DateTime get selectedDateTime => DateTime(_date.year, _date.month, _date.day, _hour, _minute);

  void _save() {
    final result = {
      'dosage': _dose,
      'unit': _unit,
      'route': _route,
      'feeling': _feeling,
      'datetime': selectedDateTime.toIso8601String(), // Now works
      'location': _location,
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
      drawer: const DrawerMenu(),
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
          
          // Add date selector here
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Select Date'),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(_date)),
            trailing: TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
              child: const Text('Change'),
            ),
          ),
          const SizedBox(height: 16),

          // Time selector
          const Text('Time'),
          Row(
            children: [
              const Text('Hour:'),
              Expanded(
                child: Slider(
                  value: _hour.toDouble(),
                  min: 0,
                  max: 23,
                  divisions: 23,
                  label: _hour.toString(),
                  onChanged: (v) => setState(() => _hour = v.toInt()),
                ),
              ),
              Text(_hour.toString().padLeft(2, '0')),
            ],
          ),
          Row(
            children: [
              const Text('Minute:'),
              Expanded(
                child: Slider(
                  value: _minute.toDouble(),
                  min: 0,
                  max: 59,
                  divisions: 59,
                  label: _minute.toString(),
                  onChanged: (v) => setState(() => _minute = v.toInt()),
                ),
              ),
              Text(_minute.toString().padLeft(2, '0')),
            ],
          ),
          const SizedBox(height: 16),


          // Selected time text (shown below the selector)
          Text(
            'Selected time: ${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          // Location
          const Text('Location'),
          DropdownButton<String>(
            value: _location,
            items: locations
                .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                .toList(),
            onChanged: (v) => setState(() => _location = v!),
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
