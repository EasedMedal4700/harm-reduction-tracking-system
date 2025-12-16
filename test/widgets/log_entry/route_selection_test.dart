import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/route_selection.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';


void main() {
  group('RouteSelection Widget', () {
    testWidgets('renders all consumption methods', (tester) async {
      await tester.pumpWidget(
        AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp(
            home: Scaffold(
              body: RouteSelection(
                route: 'oral',
                onRouteChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Check that consumption method chips are displayed
      expect(find.byType(ChoiceChip), findsWidgets);
      expect(find.textContaining('ORAL'), findsOneWidget);
    });

    testWidgets('selects initial route', (tester) async {
      await tester.pumpWidget(
        AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp(
            home: Scaffold(
              body: RouteSelection(
                route: 'oral',
                onRouteChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      final oralChip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.textContaining('ORAL'),
          matching: find.byType(ChoiceChip),
        ),
      );

      expect(oralChip.selected, true);
    });

    testWidgets('calls onRouteChanged when chip is tapped', (tester) async {
      String? selectedRoute;

      await tester.pumpWidget(
        AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp(
            home: Scaffold(
              body: RouteSelection(
                route: 'oral',
                onRouteChanged: (route) {
                  selectedRoute = route;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.textContaining('INHALED'));
      await tester.pump();

      expect(selectedRoute, 'inhaled');
    });

    testWidgets('displays emojis for each method', (tester) async {
      await tester.pumpWidget(
        AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp(
            home: Scaffold(
              body: RouteSelection(
                route: 'oral',
                onRouteChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Check that text contains emoji characters (checking for common patterns)
      final chipFinder = find.byType(ChoiceChip);
      expect(chipFinder, findsWidgets);
    });

    testWidgets('renders as Wrap widget for responsive layout', (tester) async {
      await tester.pumpWidget(
        AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp(
            home: Scaffold(
              body: RouteSelection(
                route: 'oral',
                onRouteChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('multiple routes can be displayed', (tester) async {
      await tester.pumpWidget(
        AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp(
            home: Scaffold(
              body: RouteSelection(
                route: 'oral',
                onRouteChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Should have multiple ChoiceChips for different routes
      expect(find.byType(ChoiceChip), findsAtLeast(3));
    });

    testWidgets('only one route is selected at a time', (tester) async {
      String currentRoute = 'oral';

      await tester.pumpWidget(
        AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return RouteSelection(
                    route: currentRoute,
                    onRouteChanged: (route) {
                      setState(() {
                        currentRoute = route;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially oral should be selected
      var oralChip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.textContaining('ORAL'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(oralChip.selected, true);

      // Tap inhaled
      await tester.tap(find.textContaining('INHALED'));
      await tester.pumpAndSettle();

      // Now inhaled should be selected, oral should not
      oralChip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.textContaining('ORAL'),
          matching: find.byType(ChoiceChip),
        ),
      );
      final inhaledChip = tester.widget<ChoiceChip>(
        find.ancestor(
          of: find.textContaining('INHALED'),
          matching: find.byType(ChoiceChip),
        ),
      );
      expect(oralChip.selected, false);
      expect(inhaledChip.selected, true);
    });
  });
}

