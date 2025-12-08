import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/common/old_common/feeling_selection.dart';

void main() {
  group('FeelingSelection Widget', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeelingSelection(
              feelings: const [],
              secondaryFeelings: const {},
              onFeelingsChanged: (_) {},
              onSecondaryFeelingsChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('How are you feeling?'), findsOneWidget);
    });

    testWidgets('displays primary emotions as ChoiceChips', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeelingSelection(
              feelings: const [],
              secondaryFeelings: const {},
              onFeelingsChanged: (_) {},
              onSecondaryFeelingsChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(ChoiceChip), findsWidgets);
    });

    testWidgets('selects primary feeling when tapped', (tester) async {
      List<String> selectedFeelings = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return FeelingSelection(
                  feelings: selectedFeelings,
                  secondaryFeelings: const {},
                  onFeelingsChanged: (feelings) {
                    setState(() {
                      selectedFeelings = feelings;
                    });
                  },
                  onSecondaryFeelingsChanged: (_) {},
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.textContaining('HAPPY'));
      await tester.pump();

      expect(selectedFeelings, contains('Happy'));
    });

    testWidgets('deselects feeling when tapped again', (tester) async {
      List<String> selectedFeelings = ['Happy'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return FeelingSelection(
                  feelings: selectedFeelings,
                  secondaryFeelings: const {},
                  onFeelingsChanged: (feelings) {
                    setState(() {
                      selectedFeelings = feelings;
                    });
                  },
                  onSecondaryFeelingsChanged: (_) {},
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.textContaining('HAPPY'));
      await tester.pump();

      expect(selectedFeelings, isEmpty);
    });

    testWidgets('shows secondary feelings section when primary is selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeelingSelection(
              feelings: const ['Happy'],
              secondaryFeelings: const {},
              onFeelingsChanged: (_) {},
              onSecondaryFeelingsChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Secondary feelings? (Select multiple per primary)'), findsOneWidget);
      expect(find.text('For Happy:'), findsOneWidget);
    });

    testWidgets('hides secondary feelings when no primary selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeelingSelection(
              feelings: const [],
              secondaryFeelings: const {},
              onFeelingsChanged: (_) {},
              onSecondaryFeelingsChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Secondary feelings? (Select multiple per primary)'), findsNothing);
    });

    testWidgets('displays secondary emotions for selected primary', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FeelingSelection(
                feelings: const ['Happy'],
                secondaryFeelings: const {},
                onFeelingsChanged: (_) {},
                onSecondaryFeelingsChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Should show secondary emotion chips
      await tester.pumpAndSettle();
      expect(find.byType(ChoiceChip), findsWidgets);
    });

    testWidgets('selects secondary feeling when tapped', (tester) async {
      Map<String, List<String>> secondaryFeelings = {};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return FeelingSelection(
                    feelings: const ['Happy'],
                    secondaryFeelings: secondaryFeelings,
                    onFeelingsChanged: (_) {},
                    onSecondaryFeelingsChanged: (secondary) {
                      setState(() {
                        secondaryFeelings = secondary;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Find and tap a secondary feeling chip (e.g., "Joyful")
      final secondaryChips = find.descendant(
        of: find.byType(Wrap).last,
        matching: find.byType(ChoiceChip),
      );
      
      if (secondaryChips.evaluate().isNotEmpty) {
        await tester.tap(secondaryChips.first);
        await tester.pump();

        expect(secondaryFeelings.containsKey('Happy'), true);
        expect(secondaryFeelings['Happy']!.isNotEmpty, true);
      }
    });

    testWidgets('removes secondary feelings when primary is deselected', (tester) async {
      List<String> feelings = ['Happy'];
      Map<String, List<String>> secondaryFeelings = {'Happy': ['Joyful']};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return FeelingSelection(
                  feelings: feelings,
                  secondaryFeelings: secondaryFeelings,
                  onFeelingsChanged: (newFeelings) {
                    setState(() {
                      feelings = newFeelings;
                    });
                  },
                  onSecondaryFeelingsChanged: (newSecondary) {
                    setState(() {
                      secondaryFeelings = newSecondary;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Deselect Happy
      await tester.tap(find.textContaining('HAPPY'));
      await tester.pump();

      expect(feelings, isEmpty);
      expect(secondaryFeelings.containsKey('Happy'), false);
    });

    testWidgets('allows multiple primary feelings', (tester) async {
      List<String> feelings = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return FeelingSelection(
                  feelings: feelings,
                  secondaryFeelings: const {},
                  onFeelingsChanged: (newFeelings) {
                    setState(() {
                      feelings = newFeelings;
                    });
                  },
                  onSecondaryFeelingsChanged: (_) {},
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.textContaining('HAPPY'));
      await tester.pump();
      await tester.tap(find.textContaining('SAD'));
      await tester.pump();

      expect(feelings.length, 2);
      expect(feelings, containsAll(['Happy', 'Sad']));
    });

    testWidgets('renders as Column widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeelingSelection(
              feelings: const [],
              secondaryFeelings: const {},
              onFeelingsChanged: (_) {},
              onSecondaryFeelingsChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('renders primary emotions as Wrap for responsive layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeelingSelection(
              feelings: const [],
              secondaryFeelings: const {},
              onFeelingsChanged: (_) {},
              onSecondaryFeelingsChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsWidgets);
    });
  });
}
