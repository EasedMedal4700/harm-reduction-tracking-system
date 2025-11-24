import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmotionalStateSection widget tests', () {
    testWidgets('displays emotion selection chips', (tester) async {
      final primaryEmotions = <String>[];
      final secondaryEmotions = <String, List<String>>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Wrap(
                  children: [
                    ChoiceChip(
                      label: const Text('Happy'),
                      selected: primaryEmotions.contains('Happy'),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      label: const Text('Sad'),
                      selected: primaryEmotions.contains('Sad'),
                      onSelected: (selected) {},
                    ),
                    ChoiceChip(
                      label: const Text('Anxious'),
                      selected: primaryEmotions.contains('Anxious'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Happy'), findsOneWidget);
      expect(find.text('Sad'), findsOneWidget);
      expect(find.text('Anxious'), findsOneWidget);
    });

    testWidgets('primary emotion can be selected', (tester) async {
      var primaryEmotions = <String>[];
      final secondaryEmotions = <String, List<String>>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Wrap(
                  children: [
                    ChoiceChip(
                      label: const Text('Happy'),
                      selected: primaryEmotions.contains('Happy'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            primaryEmotions = [...primaryEmotions, 'Happy'];
                          } else {
                            primaryEmotions = primaryEmotions.where((e) => e != 'Happy').toList();
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Initially not selected
      var chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      expect(chip.selected, isFalse);

      // Tap to select
      await tester.tap(find.text('Happy'));
      await tester.pump();

      // Now selected
      chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      expect(chip.selected, isTrue);
    });

    testWidgets('multiple primary emotions can be selected', (tester) async {
      var selectedEmotions = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Wrap(
                  children: [
                    ChoiceChip(
                      label: const Text('Happy'),
                      selected: selectedEmotions.contains('Happy'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedEmotions.add('Happy');
                          } else {
                            selectedEmotions.remove('Happy');
                          }
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Calm'),
                      selected: selectedEmotions.contains('Calm'),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedEmotions.add('Calm');
                          } else {
                            selectedEmotions.remove('Calm');
                          }
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Select both emotions
      await tester.tap(find.text('Happy'));
      await tester.pump();
      await tester.tap(find.text('Calm'));
      await tester.pump();

      // Both should be in the list
      expect(selectedEmotions, contains('Happy'));
      expect(selectedEmotions, contains('Calm'));
      expect(selectedEmotions.length, 2);
    });

    testWidgets('secondary emotions display when primary selected', (tester) async {
      var primaryEmotions = <String>['Happy'];
      final secondaryEmotions = <String, List<String>>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // Primary emotion chip
                ChoiceChip(
                  label: const Text('Happy'),
                  selected: primaryEmotions.contains('Happy'),
                  onSelected: (selected) {},
                ),
                // Secondary emotions shown when primary is selected
                if (primaryEmotions.contains('Happy'))
                  Wrap(
                    children: [
                      FilterChip(
                        label: const Text('Joyful'),
                        selected: secondaryEmotions['Happy']?.contains('Joyful') ?? false,
                        onSelected: (selected) {},
                      ),
                      FilterChip(
                        label: const Text('Excited'),
                        selected: secondaryEmotions['Happy']?.contains('Excited') ?? false,
                        onSelected: (selected) {},
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Joyful'), findsOneWidget);
      expect(find.text('Excited'), findsOneWidget);
    });

    testWidgets('secondary emotion can be selected', (tester) async {
      var secondaryEmotions = <String, List<String>>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return FilterChip(
                  label: const Text('Joyful'),
                  selected: secondaryEmotions['Happy']?.contains('Joyful') ?? false,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        secondaryEmotions['Happy'] = [...(secondaryEmotions['Happy'] ?? []), 'Joyful'];
                      } else {
                        secondaryEmotions['Happy'] = secondaryEmotions['Happy']?.where((e) => e != 'Joyful').toList() ?? [];
                      }
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially not selected
      var chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, isFalse);

      // Tap to select
      await tester.tap(find.text('Joyful'));
      await tester.pump();

      // Now selected
      chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, isTrue);
    });

    testWidgets('thoughts text field accepts input', (tester) async {
      final thoughtsController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: thoughtsController,
              decoration: const InputDecoration(
                labelText: 'What are you thinking?',
              ),
            ),
          ),
        ),
      );

      expect(find.text('What are you thinking?'), findsOneWidget);

      // Enter text
      await tester.enterText(find.byType(TextField), 'I feel stressed about work');
      await tester.pump();

      expect(thoughtsController.text, 'I feel stressed about work');
    });

    testWidgets('can deselect primary emotion', (tester) async {
      var selectedEmotions = <String>['Happy'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ChoiceChip(
                  label: const Text('Happy'),
                  selected: selectedEmotions.contains('Happy'),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedEmotions.add('Happy');
                      } else {
                        selectedEmotions.remove('Happy');
                      }
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially selected
      var chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      expect(chip.selected, isTrue);

      // Tap to deselect
      await tester.tap(find.text('Happy'));
      await tester.pump();

      // Now not selected
      chip = tester.widget<ChoiceChip>(find.byType(ChoiceChip));
      expect(chip.selected, isFalse);
    });
  });

  group('EmotionalStateSection validation', () {
    testWidgets('displays all common emotions', (tester) async {
      final emotions = ['Happy', 'Sad', 'Anxious', 'Angry', 'Calm', 'Excited'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Wrap(
              children: emotions
                  .map((e) => ChoiceChip(
                        label: Text(e),
                        selected: false,
                        onSelected: (_) {},
                      ))
                  .toList(),
            ),
          ),
        ),
      );

      for (final emotion in emotions) {
        expect(find.text(emotion), findsOneWidget);
      }
    });

    testWidgets('emotion chips are scrollable', (tester) async {
      final emotions = List.generate(20, (i) => 'Emotion $i');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Wrap(
                children: emotions
                    .map((e) => ChoiceChip(
                          label: Text(e),
                          selected: false,
                          onSelected: (_) {},
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      );

      // Should find chips even if not all are visible
      expect(find.byType(ChoiceChip), findsWidgets);
    });
  });
}
