# 📐 FLUTTER PROJECT RULESET — WORKFIELD READY (FINAL)

## Scope

This ruleset applies to all files in this folder and all subfolders.  
Any new file, refactor, or feature change must comply.

Violations must be explicitly called out.

## 1. Enforcement & Feedback Policy

### 1.1 Brutal Honesty Scale

Whenever feedback is given, a Brutal Honesty Percentage MUST be stated:

- **90–100%** → Industry-grade, no mercy, interview-level critique
- **70–89%** → Strong professional critique
- **50–69%** → Mild but direct
- **<50%** → Not acceptable for this project

**Default:** 90% honesty minimum

### 1.2 Mandatory Enforcement

The assistant MUST:

- Enforce modern, production-grade Flutter practices
- Prioritize industry standards over convenience
- Explicitly warn about:
  - technical debt
  - anti-patterns
  - future migration pain
- Refuse "quick hacks" if they harm long-term quality

This project is optimized for professional software engineering readiness, not speed alone.

## 2. Absolute Non-Negotiables (Must Be Implemented)

### 2.1 State Management — Riverpod

All non-trivial state MUST live in Riverpod

Widgets may only hold:

- TextEditingController
- animation / focus / UI-only flags

Business logic in widgets is forbidden

❌ Widget-owned orchestration  
✅ Provider-driven logic

### 2.2 Models — Freezed (New Code Only)

All new models MUST use freezed, including:

- API models
- UI state
- flow state

Mutable models are forbidden in new code.

### 2.3 Navigation — Centralized Only

Widgets MUST NOT decide routes

Widgets emit intent, navigation happens elsewhere

Until GoRouter is added:

Navigation goes through one abstraction/service

❌ Navigator.push scattered  
✅ navigationService.goToX()

## 3. Structural Architecture Rules

### 3.1 One File = One Responsibility

A single file may not simultaneously:

- render UI
- manage auth
- handle encryption
- read/write storage
- decide navigation
- manage streams

If it does → it must be split

### 3.2 No Business Logic in initState

initState MAY:

- trigger a provider init
- register listeners

initState MAY NOT:

- run async flows
- branch logic
- navigate
- decide app state

### 3.3 No Service Instantiation in Widgets

Forbidden in widgets:

```dart
SomeService()
```

All services MUST come from:

- Riverpod providers

Mandatory for:

- testability
- dependency control
- mocking

## 4. Side Effects & Observability

### 4.1 Side Effects Must Be Centralized

Side effects include:

- navigation
- persistence
- auth refresh
- encryption
- session restore
- stream subscriptions

Widgets must never own these.

### 4.2 No print

`print()` is forbidden

Use:

- Logger
- debug logging abstraction

Every print is considered technical debt.

## 5. Debug & Environment Rules

### 5.1 Debug Logic Isolation

Debug behavior MUST:

- live behind providers
- be environment-gated

❌ Debug conditionals inside UI logic  
✅ Debug handled in controllers/services

## 6. Migration Transparency (MANDATORY)

### 6.1 Migration Header Required (ONLY ALLOWED FORMAT)

Every touched file MUST start with this header, exactly in this format:

```dart
// MIGRATION:
// State: LEGACY | PARTIAL | MODERN
// Navigation: LEGACY | CENTRALIZED | GOROUTER
// Models: LEGACY | FREEZED
// Theme: LEGACY | COMPLETE
// Common: LEGACY | COMPLETE
// Notes: short explanation
```

Rules:

- Header must be at the very top
- Status must be accurate
- TODOs must be concrete
- No alternative formats allowed

This rule is non-negotiable.

## 7. File Hygiene & Imports

### 7.1 Import Discipline

- No unused imports
- No deep relative chaos
- Common UI → common/
- Services → services/
- Providers → providers/

## 8. Feature Development Rules

### 8.1 New Features

Every new feature MUST:

- use Riverpod
- use Freezed for models
- respect centralized navigation
- follow one-file-one-task

### 8.2 Legacy Code

Legacy code:

- may be bug-fixed
- may be UI-tweaked
- may NOT be partially modernized

Migration happens in dedicated passes only.

## 9. Assistant Behavior Contract

When reviewing or modifying code, the assistant MUST:

- Check architectural compliance
- Flag violations explicitly
- Explain why it breaks future scalability
- Provide correct modern alternatives
- State Brutal Honesty %
- Refuse unsafe shortcuts

## 10. Core Principle

Short-term convenience is never allowed to compromise long-term maintainability.

This project is optimized for:

- real teams
- real refactors
- real production bugs
- real job readiness

### Required Feedback Format (Example)

**Brutal Honesty: 93%**  
This file violates separation of concerns and would not pass a senior Flutter code review. Business logic and navigation must be moved into Riverpod controllers before adding features.