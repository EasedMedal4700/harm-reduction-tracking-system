# Test Coverage Improvement Plan
**Current Overall Coverage: 12.44%**  
**Target Coverage: 80-90%**  
**Date: December 20, 2025**

## Executive Summary

Test coverage is critically low at 12.44% (2,095/16,847 lines). Only 39 files have ≥80% coverage, while 196 files have <20% coverage. This document provides a prioritized action plan to achieve 80%+ overall coverage.

---

## Current State Analysis

### Coverage Distribution
- **≥ 80% coverage**: 39 files ✅
- **60-79% coverage**: 8 files  
- **40-59% coverage**: 7 files  
- **20-39% coverage**: 7 files  
- **< 20% coverage**: 196 files ⚠️

### Files with Excellent Coverage (100%)
- `input_field.dart`
- `slider.dart`
- `dosage_input.dart`
- `onboarding_service.dart`
- `complex_fields.dart`
- `emotion_selector.dart`
- `textarea.dart`
- `reflection_selection.dart`
- `log_entry_serializer.dart`
- `entry_validation.dart`

---

## Priority Tiers (Based on Impact & File Size)

### 🔴 TIER 1: Critical Services (0% → 80%+)
**Impact: 1,200+ uncovered lines**

1. **admin_service.dart** (0/174 lines)
   - Error logging analytics
   - System diagnostics
   - **Tests needed**: CRUD operations, error handling, analytics aggregation

2. **error_logging_service.dart** (0/72 lines)
   - Critical for debugging
   - **Tests needed**: Error capture, severity classification, storage

3. **daily_checkin_service.dart** (0/94 lines)
   - **Tests needed**: Save/update/fetch/delete operations, date handling

4. **personal_library_service.dart** (0/86 lines)
   - **Tests needed**: Substance CRUD, library management

5. **reflection_service.dart** (0/84 lines)
   - **Tests needed**: Reflection CRUD, validation

6. **stockpile_repository.dart** (0/84 lines)
   - **Tests needed**: Repository pattern, CRUD operations

7. **tolerance_service.dart** (0/60 lines)
   - **Tests needed**: Tolerance data fetching, substance lookups

8. **app_lock_controller.dart** (0/58 lines)
   - **Tests needed**: PIN timing, timeout logic

### 🟠 TIER 2: High-Value Services (Low Coverage)
**Impact: 400+ lines to improve**

1. **log_entry_service.dart** (3.53% - 3/85 lines)
   - **Expand tests for**: Validation, encryption integration, batch operations

2. **craving_service.dart** (7.37% - 7/95 lines)
   - **Expand tests for**: Edge cases, validation, encryption

3. **analytics_service.dart** (37.36% - 34/91 lines)
   - **Expand tests for**: Aggregation logic, time-based filtering, trends

4. **feature_flag_service.dart** (40.26% - 31/77 lines)
   - **Expand tests for**: Cache invalidation, admin overrides

### 🟡 TIER 3: Models & Utilities
**Impact: 500+ lines**

1. **app_settings_model.dart** (1/97 lines)
   - **Tests needed**: JSON serialization, validation, defaults

2. **curve_point.dart** (1/6 lines)
   - **Tests needed**: Coordinate calculations, interpolation

3. **settings_provider.dart** (0/81 lines)
   - **Tests needed**: State management, persistence

4. **bucket_definitions.dart** - Fully test neurochemical bucket logic

5. **tolerance_bucket.dart** - Test bucket calculations

### 🟢 TIER 4: Widget Tests
**Impact: 2,000+ lines**

Focus on high-interaction widgets:
- **Activity widgets** (activity_card.dart: 0/72)
- **Tolerance widgets** (various: 0-20%)
- **Blood levels widgets** (filter_panel.dart: 0/57)
- **Admin/error widgets** (error_analytics_section.dart: 0/151)

---

## Implementation Strategy

### Phase 1: Foundation (Week 1)
**Target: 30-40% coverage**

#### Day 1-2: Service Layer Tests
```dart
// Priority files to test:
- error_logging_service_test.dart (NEW)
- daily_checkin_service_test.dart (NEW)  
- tolerance_service_test.dart (NEW)
```

**Template:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/YOUR_SERVICE.dart';

void main() {
  group('ServiceName', () {
    // Test groups:
    // - Initialization
    // - CRUD Operations
    // - Validation
    // - Error Handling
    // - Edge Cases
  });
}
```

#### Day 3-4: Model Tests
```dart
// Priority files:
- app_settings_model_test.dart (EXPAND)
- tolerance_bucket_test.dart (NEW)
- curve_point_test.dart (EXPAND)
```

#### Day 5: Repository Tests
```dart
- stockpile_repository_test.dart (NEW)
- reflection_service_test.dart (NEW)
```

### Phase 2: Expansion (Week 2)
**Target: 50-60% coverage**

#### Day 6-7: Expand Existing Tests
- `craving_service_test.dart` - Add 50+ test cases
- `log_entry_service_test.dart` - Add validation scenarios
- `analytics_service_test.dart` - Add aggregation tests

#### Day 8-9: Provider & Controller Tests
- `settings_provider_test.dart` (NEW)
- `app_lock_controller_test.dart` (NEW)
- State management patterns

#### Day 10: Admin & Error Handling
- `admin_service_test.dart` (NEW)
- `personal_library_service_test.dart` (NEW)

### Phase 3: Widget Coverage (Week 3)
**Target: 70-80% coverage**

#### Day 11-14: Critical Widget Tests
Focus on user-facing features:
1. **Tolerance Widgets**
   - `system_tolerance_widget_test.dart`
   - `bucket_detail_section_test.dart`
   - `tolerance_summary_card_test.dart`

2. **Activity Widgets**
   - `activity_card_test.dart` (expand)
   - Activity list rendering

3. **Blood Levels Widgets**
   - `metabolism_timeline_card_test.dart`
   - `filter_panel_test.dart`

4. **Admin/Debug Widgets**
   - `error_analytics_section_test.dart`
   - `debug_panel_widget_test.dart`

#### Day 15: Integration Tests
- Create 5-10 integration tests for critical user flows
- Test cross-service interactions

### Phase 4: Polish & Edge Cases (Week 4)
**Target: 80-90% coverage**

#### Day 16-18: Edge Cases & Error Paths
- Null safety scenarios
- Boundary conditions
- Network failures
- Invalid data handling

#### Day 19-20: Performance & Regression
- Add performance benchmarks
- Regression test suites
- CI/CD integration

---

## Test Templates & Patterns

### Service Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/your_service.dart';

void main() {
  group('YourService', () {
    group('Initialization', () {
      test('initializes with correct defaults', () {
        // Test initialization
      });
    });

    group('CRUD Operations', () {
      test('creates new entry successfully', () async {
        // Test create
      });

      test('reads existing entries', () async {
        // Test read
      });

      test('updates entry correctly', () async {
        // Test update
      });

      test('deletes entry successfully', () async {
        // Test delete
      });
    });

    group('Validation', () {
      test('rejects invalid input', () {
        // Test validation
      });

      test('accepts valid input', () {
        // Test validation success
      });
    });

    group('Error Handling', () {
      test('handles network errors gracefully', () async {
        // Test error handling
      });

      test('throws appropriate exceptions', () {
        // Test error throwing
      });
    });

    group('Edge Cases', () {
      test('handles empty data', () {
        // Test edge case
      });

      test('handles large datasets', () {
        // Test performance
      });
    });
  });
}
```

### Model Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/your_model.dart';

void main() {
  group('YourModel', () {
    group('Construction', () {
      test('creates with required fields', () {
        // Test construction
      });

      test('creates with optional fields', () {
        // Test optional fields
      });
    });

    group('JSON Serialization', () {
      test('toJson includes all fields', () {
        // Test serialization
      });

      test('fromJson reconstructs object', () {
        // Test deserialization
      });

      test('handles null values correctly', () {
        // Test null handling
      });
    });

    group('Validation', () {
      test('validates required fields', () {
        // Test validation
      });

      test('enforces business rules', () {
        // Test business logic
      });
    });

    group('CopyWith', () {
      test('creates copy with updated fields', () {
        // Test immutability
      });
    });

    group('Equality', () {
      test('equals works correctly', () {
        // Test equality
      });

      test('hashCode is consistent', () {
        // Test hashCode
      });
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/your_feature/widgets/your_widget.dart';
import '../../helpers/test_app_wrapper.dart';

void main() {
  group('YourWidget', () {
    testWidgets('renders with required props', (tester) async {
      await tester.pumpWidget(
        TestAppWrapper(
          child: YourWidget(/* props */),
        ),
      );

      expect(find.byType(YourWidget), findsOneWidget);
    });

    testWidgets('handles user interaction', (tester) async {
      await tester.pumpWidget(
        TestAppWrapper(
          child: YourWidget(/* props */),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify state changes
    });

    testWidgets('displays error state correctly', (tester) async {
      // Test error rendering
    });

    testWidgets('displays loading state correctly', (tester) async {
      // Test loading state
    });
  });
}
```

---

## Quick Wins (Can Be Done Today)

### 1. Model Tests (30 minutes each)
- `curve_point_test.dart` - Simple coordinate class
- `bucket_definitions.dart` - Constants testing

### 2. Utility Tests (20 minutes each)
- `time_period_utils_test.dart`
- Simple helper function tests

### 3. Expand Existing Tests (1 hour each)
- `craving_service_test.dart` - Add 30 more test cases
- `feature_flag_service_test.dart` - Add edge cases

---

## Automation & CI/CD

### Pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

flutter test --coverage
COVERAGE=$(lcov --summary coverage/lcov.info | grep lines | cut -d ':' -f 2 | cut -d '%' -f 1 | tr -d ' ')

if (( $(echo "$COVERAGE < 80" | bc -l) )); then
  echo "❌ Coverage is $COVERAGE% - below 80% threshold"
  exit 1
fi

echo "✅ Coverage is $COVERAGE%"
```

### GitHub Actions
```yaml
name: Test Coverage
on: [push, pull_request]
jobs:
  coverage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          fail_ci_if_error: true
```

---

## Metrics & Monitoring

### Daily Tracking
```bash
# Run this daily to track progress
flutter test --coverage
lcov --summary coverage/lcov.info
```

### Weekly Goals
- Week 1: 30-40% coverage
- Week 2: 50-60% coverage
- Week 3: 70-80% coverage
- Week 4: 80-90% coverage

### Coverage by Category
| Category | Current | Week 1 | Week 2 | Week 3 | Week 4 |
|----------|---------|--------|--------|--------|--------|
| Services | 15%     | 40%    | 60%    | 75%    | 85%    |
| Models   | 20%     | 50%    | 70%    | 80%    | 90%    |
| Widgets  | 5%      | 20%    | 40%    | 65%    | 80%    |
| Utils    | 35%     | 60%    | 75%    | 85%    | 90%    |

---

## Tools & Resources

### Coverage Visualization
```bash
# Generate HTML report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
# Open coverage/html/index.html in browser
```

### VS Code Extensions
- **Coverage Gutters** - Shows coverage in editor
- **Test Explorer UI** - Better test management
- **Flutter Test Runner** - Enhanced test running

### Helpful Commands
```bash
# Run specific test file
flutter test test/services/your_service_test.dart

# Run tests with verbose output
flutter test --reporter=expanded

# Run only failed tests
flutter test --rerun-failed

# Test a specific pattern
flutter test --name "YourService"
```

---

## Success Criteria

✅ **Minimum Acceptable (80%)**
- All services: ≥75% coverage
- All models: ≥85% coverage  
- Critical widgets: ≥70% coverage
- Utils: ≥80% coverage

🎯 **Target (90%)**
- All services: ≥85% coverage
- All models: ≥95% coverage
- All widgets: ≥80% coverage
- Utils: ≥90% coverage

🏆 **Stretch Goal (95%)**
- Comprehensive integration tests
- Performance benchmarks
- E2E test coverage

---

## Next Steps

1. **TODAY**: Review this plan with the team
2. **TOMORROW**: Start Phase 1, Day 1 (Service tests)
3. **THIS WEEK**: Complete Phase 1 (30-40% coverage)
4. **ONGOING**: Daily coverage checks, weekly reviews

---

## Files Requiring Immediate Attention

### Copy this checklist and start working through it:

```
Priority 1 (Critical - Do First):
[ ] error_logging_service_test.dart (NEW)
[ ] daily_checkin_service_test.dart (NEW)
[ ] tolerance_service_test.dart (NEW)
[ ] app_settings_model_test.dart (EXPAND)
[ ] stockpile_repository_test.dart (NEW)

Priority 2 (High Value):
[ ] Expand craving_service_test.dart (7% → 80%)
[ ] Expand log_entry_service_test.dart (3% → 80%)
[ ] Expand analytics_service_test.dart (37% → 80%)
[ ] settings_provider_test.dart (NEW)
[ ] app_lock_controller_test.dart (NEW)

Priority 3 (Medium Value):
[ ] admin_service_test.dart (NEW)
[ ] personal_library_service_test.dart (NEW)
[ ] reflection_service_test.dart (NEW)
[ ] tolerance_bucket_test.dart (NEW)
[ ] curve_point_test.dart (EXPAND)

Priority 4 (Widget Tests):
[ ] activity_card_test.dart (EXPAND)
[ ] system_tolerance_widget_test.dart (NEW)
[ ] metabolism_timeline_card_test.dart (NEW)
[ ] error_analytics_section_test.dart (NEW)
[ ] filter_panel_test.dart (NEW)
```

---

**Remember**: Test coverage is not just about hitting a number—it's about confidence in your code. Write meaningful tests that catch real bugs and document expected behavior.

**Questions?** Review the test templates above and start with the easiest files first to build momentum!

## Progress Update (Current Session)
- **Refactored & Tested**:
  - ErrorLoggingService: 100% coverage (Mocked DeviceInfo & PackageInfo)
  - ToleranceService: 100% coverage (Refactored to instance-based, Mocked Supabase)
  - DailyCheckinService: 100% coverage (Refactored to instance-based, Mocked Supabase & Cache)
  - DailyCheckin Model: 100% coverage
