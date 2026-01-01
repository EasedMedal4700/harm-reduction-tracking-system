# Standardization & Refactoring Report

## Overview
This document outlines the standardization efforts undertaken to improve code quality, consistency, and maintainability across the application.

## Key Changes

### 1. Graph Constants
- **File**: `lib/constants/data/graph_constants.dart`
- **Purpose**: Centralized constants for graph visualization (step hours, bar width, curve smoothness).
- **Usage**:
  ```dart
  import 'package:mobile_drug_use_app/constants/data/graph_constants.dart';
  
  // Use constants
  double step = GraphConstants.defaultStepHours;
  double width = GraphConstants.defaultBarWidth;
  ```

### 2. Animation Constants
- **File**: `lib/constants/theme/app_animations.dart`
- **Purpose**: Standardized animation durations and curves.
- **Usage**:
  ```dart
  // Access via context (preferred)
  duration: context.animations.normal // 300ms
  
  // Or direct usage for const contexts
  duration: const AppAnimations().normal
  ```

### 3. String Constants
- **File**: `lib/constants/strings/app_strings.dart`
- **Purpose**: Centralized string constants to avoid hardcoding and facilitate future localization.
- **Usage**:
  ```dart
  import 'package:mobile_drug_use_app/constants/strings/app_strings.dart';
  
  Text(AppStrings.entryDeletedSuccess)
  ```

### 4. Semantic Labels
- Added `semanticLabel` to `Icon` widgets to improve accessibility.
- Example: `Icon(Icons.add, semanticLabel: 'Add Entry')`

## Files Modified
- `lib/features/blood_levels/services/decay_service.dart`
- `lib/features/blood_levels/widgets/blood_levels/blood_level_graph.dart`
- `lib/features/blood_levels/widgets/blood_levels/metabolism_timeline_card.dart`
- `lib/features/home/home_page.dart`
- `lib/features/home/home_page_main.dart`
- `lib/features/tolerence/tolerance_dashboard_page.dart`
- `lib/features/activity/activity_page.dart`
- `lib/features/activity/widgets/activity/activity_card.dart`
- `lib/features/admin/widgets/app_bar/admin_app_bar.dart`

## Next Steps
- Continue replacing hardcoded strings with `AppStrings`.
- Continue adding `semanticLabel` to all Icons.
- Enforce usage of `GraphConstants` in new charts.
