# Test Configuration Guide

This directory contains the test configuration for the mobile drug use app.

## Files

### `flutter_test_config.dart`
Global test configuration file that Flutter automatically discovers and runs before all tests.

**Features:**
- Global test setup and teardown
- Common test utilities (`TestUtils`)
- Custom test matchers
- Test configuration constants
- Test data helpers

### `dart_test.yaml`
Configuration for the Dart test runner.

**Features:**
- Test timeouts
- Concurrency settings
- Reporter configuration
- Platform settings

### `helpers/test_app_wrapper.dart`
Legacy test wrapper functions (deprecated - use `TestUtils` from `flutter_test_config.dart` instead).

## Usage

### Basic Test Setup

Instead of manually wrapping widgets, use the `TestUtils` class:

```dart
import '../flutter_test_config.dart'; // Automatically imported

testWidgets('My widget test', (tester) async {
  await tester.pumpWidget(
    TestUtils.createTestApp(
      child: MyWidget(),
      themeMode: ThemeMode.dark, // Optional
    ),
  );

  // Test code here
});
```

### Advanced Test Setup

For tests needing navigation or providers:

```dart
testWidgets('Navigation test', (tester) async {
  await tester.pumpWidget(
    TestUtils.createTestAppWithNavigation(
      home: MyHomePage(),
      providerOverrides: [
        // Mock providers here
      ],
    ),
  );
});
```

### Custom Test Matchers

```dart
await tester.waitFor(find.byType(MyWidget));
await tester.pumpUntil(() => someCondition());
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widgets/my_widget_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests in verbose mode
flutter test -v

# Run tests with specific tags
flutter test --tags=unit
```

### Test Organization

```
test/
├── flutter_test_config.dart    # Global test config
├── dart_test.yaml             # Test runner config
├── helpers/                   # Test utilities
│   └── test_app_wrapper.dart
├── widgets/                   # Widget tests
├── unit/                      # Unit tests
├── integration/               # Integration tests
└── models/                    # Model tests
```

## Configuration Options

### Test Timeouts
- Default timeout: 30 seconds
- Animation timeout: 5 seconds

### Device Sizes
- Mobile: 375x667 (iPhone SE)
- Tablet: 768x1024 (iPad)
- Desktop: 1920x1080

### Test Data
Common test data is available in `TestData` class:
- `testUserId`
- `testEmail`
- `testPin`
- `createTestUserProfile()`

## Best Practices

1. **Use TestUtils** instead of manual widget wrapping
2. **Disable animations** in tests for consistency (`disableAnimations: true`)
3. **Use appropriate timeouts** for async operations
4. **Mock external dependencies** (API calls, databases, etc.)
5. **Test different screen sizes** using `TestConfig.deviceSizes`
6. **Use descriptive test names** and group related tests
7. **Clean up after tests** (especially async operations)

## Example Test

```dart
import 'package:flutter_test/flutter_test.dart';
import '../flutter_test_config.dart';

void main() {
  testWidgets('Button shows correct text', (tester) async {
    await tester.pumpWidget(
      TestUtils.createTestApp(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Click me'),
        ),
      ),
    );

    expect(find.text('Click me'), findsOneWidget);
  });

  testWidgets('Button responds to tap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      TestUtils.createTestApp(
        child: ElevatedButton(
          onPressed: () => tapped = true,
          child: Text('Tap me'),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    expect(tapped, isTrue);
  });
}
```