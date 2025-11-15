import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/common/location_dropdown.dart';

void main() {
  group('LocationDropdown Widget', () {
    testWidgets('renders with initial location', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationDropdown(
              location: 'Home',
              onLocationChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('displays all available locations when opened', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationDropdown(
              location: 'Home',
              onLocationChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.text('Select a location'), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('School'), findsOneWidget);
      expect(find.text('Public'), findsOneWidget);
    });

    testWidgets('calls onLocationChanged when new location selected', (tester) async {
      String? selectedLocation;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationDropdown(
              location: 'Home',
              onLocationChanged: (location) {
                selectedLocation = location;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();

      expect(selectedLocation, 'Work');
    });

    testWidgets('shows currently selected location', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationDropdown(
              location: 'School',
              onLocationChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('School'), findsOneWidget);
    });

    testWidgets('renders as DropdownButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationDropdown(
              location: 'Home',
              onLocationChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('contains all catalog locations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationDropdown(
              location: 'Home',
              onLocationChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Check for all expected locations
      expect(find.text('Select a location'), findsOneWidget);
      expect(find.text('Home'), findsWidgets); // Multiple instances
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('School'), findsOneWidget);
      expect(find.text('Public'), findsOneWidget);
      expect(find.text('Vehicle'), findsOneWidget);
      expect(find.text('Gym'), findsOneWidget);
      expect(find.text('Other'), findsOneWidget);
    });
  });
}
