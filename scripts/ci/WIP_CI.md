# CI – Things to Enforce

## Required (now)

- [ ] **Dart formatting enforced**
  ```bash
  dart format --set-exit-if-changed lib test
  ```

- [ ] **Static analysis passes**
  ```bash
  flutter analyze
  ```
  - No ignored warnings without justification

- [ ] **Design system usage enforced**
  - No direct `Colors.*`
  - No direct `TextStyle(...)`
  - No hardcoded `SizedBox(height|width: <number>)`
  - No direct `EdgeInsets.*`
  - No hardcoded radius / elevation / font sizes
  - No direct `Card`, `ElevatedButton`, `Padding` where Common widgets exist

  **Only allowed:**
  - `context.colors.*`
  - `context.spacing.*`
  - `context.shapes.*`
  - `context.text.*`
  - `common/*` widgets

  - Violations produce JSON report
  - CI fails if violations > 0

- [ ] **Tests pass**
  ```bash
  flutter test
  ```

## Required (during migration)

- [ ] **Migration header present in feature files**
  ```dart
  // MIGRATION:
  // Theme:
  // Common:
  // Riverpod:
  ```

- [ ] **Legacy UI regressions blocked**
  - No new Material widgets outside `common/`
  - No reintroduction of legacy constants

## Optional / Future

- [ ] Code coverage threshold
- [ ] Riverpod usage enforced
- [ ] Feature folder boundary checks
- [ ] Generated files excluded from CI rules
- [ ] Fail on TODOs in non-migration code

## CI Rules (do not break)

- [ ] CI never auto-fixes code
- [ ] CI fails fast
- [ ] Editors do not matter
- [ ] One formatter: Dart SDK



flutter anlayze add this
impoirt checker
code voverage checker no regerssion allowed from past 
