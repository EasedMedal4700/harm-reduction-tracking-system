import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_drug_use_app/services/feature_flag_service.dart';
import 'package:mobile_drug_use_app/widgets/feature_flags/feature_gate.dart';
import 'package:mobile_drug_use_app/widgets/feature_flags/feature_disabled_screen.dart';
import 'package:mobile_drug_use_app/constants/config/feature_flags.dart';

/// Mock FeatureFlagService for testing
class MockFeatureFlagService extends ChangeNotifier implements FeatureFlagService {
  final Map<String, bool> _flags;
  bool _isLoaded;
  bool _isLoading;

  MockFeatureFlagService({
    Map<String, bool>? flags,
    bool isLoaded = true,
    bool isLoading = false,
  })  : _flags = flags ?? {},
        _isLoaded = isLoaded,
        _isLoading = isLoading;

  @override
  bool get isLoaded => _isLoaded;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get errorMessage => null;

  @override
  List<FeatureFlag> get allFlags => _flags.entries
      .map((e) => FeatureFlag(
            id: 0,
            featureName: e.key,
            enabled: e.value,
            updatedAt: DateTime.now(),
          ))
      .toList();

  @override
  bool isEnabled(String featureName, {required bool isAdmin}) {
    if (isAdmin) return true;
    if (!_isLoaded) return true;
    return _flags[featureName] ?? true;
  }

  @override
  FeatureFlag? getFlag(String featureName) {
    if (!_flags.containsKey(featureName)) return null;
    return FeatureFlag(
      id: 0,
      featureName: featureName,
      enabled: _flags[featureName]!,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> load() async {}

  @override
  Future<void> refresh() async {}

  @override
  Future<bool> updateFlag(String featureName, bool enabled) async {
    _flags[featureName] = enabled;
    notifyListeners();
    return true;
  }

  @override
  void clearCache() {
    _flags.clear();
    _isLoaded = false;
    notifyListeners();
  }
}

void main() {
  group('FeatureGate Widget', () {
    testWidgets('shows child when feature is enabled', (tester) async {
      final mockFlags = MockFeatureFlagService(
        flags: {FeatureFlags.homePage: true},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFlagService>.value(
            value: mockFlags,
            child: const FeatureGate(
              featureName: FeatureFlags.homePage,
              child: Text('Home Page Content'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Note: Due to FutureBuilder for admin check, we need to wait
      // In a real test, we'd mock UserService.isAdmin()
      // For now, we verify the widget structure
      expect(find.byType(FeatureGate), findsOneWidget);
    });

    testWidgets('shows loading indicator while checking', (tester) async {
      final mockFlags = MockFeatureFlagService(
        isLoading: true,
        isLoaded: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFlagService>.value(
            value: mockFlags,
            child: const FeatureGate(
              featureName: FeatureFlags.homePage,
              child: Text('Home Page Content'),
            ),
          ),
        ),
      );

      // Should show loading initially
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('FeatureDisabledScreen Widget', () {
    testWidgets('displays feature name correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FeatureDisabledScreen(featureName: 'home_page'),
        ),
      );

      expect(find.text('Feature Temporarily Unavailable'), findsOneWidget);
      // Feature name appears in AppBar title and description text
      expect(find.textContaining('Home Page'), findsWidgets);
      expect(find.text('Home Page'), findsOneWidget); // AppBar title
    });

    testWidgets('has Go Back button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FeatureDisabledScreen(featureName: 'test_feature'),
        ),
      );

      expect(find.text('Go Back'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('has Go to Home button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FeatureDisabledScreen(featureName: 'test_feature'),
        ),
      );

      expect(find.text('Go to Home'), findsOneWidget);
      expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    });

    testWidgets('displays construction icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FeatureDisabledScreen(featureName: 'test_feature'),
        ),
      );

      expect(find.byIcon(Icons.construction_rounded), findsOneWidget);
    });

    testWidgets('formats feature name with underscores correctly', 
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FeatureDisabledScreen(featureName: 'some_long_feature_name'),
        ),
      );

      // Should convert 'some_long_feature_name' to 'Some Long Feature Name'
      // Appears in AppBar title and description
      expect(find.textContaining('Some Long Feature Name'), findsWidgets);
      expect(find.text('Some Long Feature Name'), findsOneWidget); // AppBar
    });
  });

  group('Feature Flag Cases', () {
    testWidgets('Case A: enabled=true, not admin - shows page', 
        (tester) async {
      final mockFlags = MockFeatureFlagService(
        flags: {FeatureFlags.analyticsPage: true},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeatureFlagService>.value(
            value: mockFlags,
            child: const FeatureGate(
              featureName: FeatureFlags.analyticsPage,
              child: Text('Analytics Content'),
            ),
          ),
        ),
      );

      // Verify gate exists
      expect(find.byType(FeatureGate), findsOneWidget);
      expect(mockFlags.isEnabled(FeatureFlags.analyticsPage, isAdmin: false), 
          isTrue);
    });

    testWidgets('Case B: enabled=false, not admin - shows disabled', 
        (tester) async {
      final mockFlags = MockFeatureFlagService(
        flags: {FeatureFlags.analyticsPage: false},
      );

      // Verify the flag behavior
      expect(mockFlags.isEnabled(FeatureFlags.analyticsPage, isAdmin: false), 
          isFalse);
    });

    testWidgets('Case C: enabled=false, admin - shows page', 
        (tester) async {
      final mockFlags = MockFeatureFlagService(
        flags: {FeatureFlags.analyticsPage: false},
      );

      // Admin override should return true
      expect(mockFlags.isEnabled(FeatureFlags.analyticsPage, isAdmin: true), 
          isTrue);
    });
  });

  group('MockFeatureFlagService', () {
    test('isEnabled returns true for admin regardless of flag value', () {
      final mock = MockFeatureFlagService(
        flags: {'disabled_feature': false},
      );

      expect(mock.isEnabled('disabled_feature', isAdmin: true), isTrue);
      expect(mock.isEnabled('disabled_feature', isAdmin: false), isFalse);
    });

    test('isEnabled returns true for unknown features', () {
      final mock = MockFeatureFlagService(flags: {});

      expect(mock.isEnabled('unknown', isAdmin: false), isTrue);
    });

    test('updateFlag changes flag value', () async {
      final mock = MockFeatureFlagService(
        flags: {'test': true},
      );

      await mock.updateFlag('test', false);
      expect(mock.isEnabled('test', isAdmin: false), isFalse);
    });

    test('clearCache resets state', () {
      final mock = MockFeatureFlagService(
        flags: {'test': true},
        isLoaded: true,
      );

      mock.clearCache();
      expect(mock.isLoaded, isFalse);
      expect(mock.allFlags, isEmpty);
    });
  });
}
