# 🔬 Technical Deep Dive: Pharmacology Meets Code

*A comprehensive technical reference for developers who want to understand the science, math, and architecture behind the tolerance tracking and pharmacokinetic modeling systems.*

---

## 📚 Table of Contents

1. [Pharmacokinetic Modeling](#pharmacokinetic-modeling)
2. [Tolerance System Architecture](#tolerance-system-architecture)
3. [Neurochemical Bucket System](#neurochemical-bucket-system)
4. [Tolerance Calculation Algorithms](#tolerance-calculation-algorithms)
5. [Encryption System](#encryption-system)
6. [Design System Architecture](#design-system-architecture)
7. [Database Architecture](#database-architecture)
8. [Backend Data Pipeline](#backend-data-pipeline)
9. [Testing Strategy](#testing-strategy)
10. [Performance Optimizations](#performance-optimizations)
11. [Historical Evolution & Lessons Learned](#historical-evolution)

---

## 🧬 Pharmacokinetic Modeling

### The Challenge

Traditional drug half-life tracking apps use oversimplified models that don't account for:
- Multiple doses stacking in the bloodstream
- Non-linear tolerance development
- Different neurochemical systems having different tolerance mechanisms
- Active metabolites with different half-lives than parent compounds

**Our Approach**: Multi-compartment pharmacokinetic modeling with receptor-specific tolerance tracking.

### Half-Life Decay Formula

For a single dose, the plasma concentration at time `t` follows exponential decay:

```
C(t) = C₀ × e^(-kt)

where:
  C(t) = concentration at time t
  C₀   = initial concentration (dose)
  k    = elimination rate constant = ln(2) / t½
  t½   = half-life in hours
```

**Implementation** (`lib/services/blood_levels_service.dart`):
```dart
double calculateRemainingLevel(DateTime useTime, double dose, double halfLifeHours) {
  final hoursElapsed = DateTime.now().difference(useTime).inMinutes / 60.0;
  final k = ln2 / halfLifeHours;
  return dose * exp(-k * hoursElapsed);
}
```

### Multiple Dose Superposition

When multiple doses are taken, their plasma levels **superpose** (add together):

```
C_total(t) = Σ [C_i × e^(-k(t - t_i))]
             i=1 to n

where:
  C_i = dose of use i
  t_i = time of use i
  t   = current time
```

**Why This Matters**: Taking 5mg Dexedrine every 4 hours doesn't just maintain 5mg in your system—it builds up to ~12-15mg steady state due to overlapping half-lives.

### Active Threshold Concept

Not all plasma concentration contributes to tolerance. We define an **active threshold**:

```
active_level = max(0, C_total - threshold)

where:
  threshold = 15% of "strong" dose (from drug_profiles.formatted_dose)
```

**Rationale**: Trace amounts (<15%) don't significantly activate receptors. This prevents tiny residual concentrations from contributing to tolerance weeks later.

---

## 🎯 Tolerance System Architecture

### Two-System Design

The app uses **TWO parallel tolerance systems** for different purposes:

#### 1. System-Wide Tolerance (Legacy)
**File**: `lib/utils/tolerance_calculator.dart`

Used for aggregate statistics across all substances:
- Average tolerance across all neurochemical systems
- Summary metrics in analytics
- Historical data compatibility

**Formula**: Exponential decay with logistic curve limiting:
```dart
tolerance = Σ(doses) × decay_factor × (1 - e^(-gain × active_level))
capped at: 1 / (1 + e^(-steepness × (tolerance - midpoint)))
```

#### 2. Per-Substance Bucket Tolerance (Current)
**File**: `lib/utils/bucket_tolerance_calculator.dart`

Used for precise tolerance tracking per substance and neurochemical system:
- Individual drug tolerance breakdown
- Bucket-specific tolerance percentages
- Realistic tolerance growth curves

**Formula**: Logarithmic growth with per-event decay (see next section)

### Why Two Systems?

**Historical Context**: The app started with system-wide tolerance. When we discovered unrealistic tolerance values (3636%!), we built the bucket system with better math. The old system remains for backward compatibility and aggregate views.

**Migration Path**: Future versions will fully migrate to bucket-only tolerance.

---

## 🧪 Neurochemical Bucket System

### The 7 Buckets

Each substance affects multiple neurotransmitter systems. We model this with **7 canonical buckets**:

| Bucket ID | Systems Affected | Example Drugs | Tolerance Characteristics |
|-----------|------------------|---------------|---------------------------|
| `stimulant` | Dopamine, Norepinephrine | Amphetamine, Cocaine, Caffeine | Fast buildup (2-3 days), moderate decay (3-5 days) |
| `serotonin_release` | Serotonin (SERT reversal) | MDMA, Mephedrone | Rapid buildup (1 dose), SLOW decay (4-12 weeks) |
| `serotonin_psychedelic` | 5-HT2A agonism | LSD, Psilocybin, Mescaline | Extremely fast (1 dose = 90%+), moderate decay (5-7 days) |
| `gabaergic` | GABA-A | Alcohol, Benzodiazepines, GHB | Gradual buildup, dangerous withdrawal |
| `opioid` | μ-opioid receptor | Morphine, Oxycodone, Kratom | Fast buildup, physical dependence risk |
| `cannabinoid` | CB1/CB2 | THC, Synthetic cannabinoids | Moderate buildup, slow decay (7-14 days) |
| `nmda_antagonist` | NMDA receptor blockade | Ketamine, DXM, PCP | Moderate buildup, cross-tolerance within class |

### Bucket Weight System

Each substance has a **weight** (0.0 to 1.0) for each bucket it affects:

```json
{
  "name": "MDMA",
  "tolerance_model": {
    "neuro_buckets": {
      "serotonin_release": {
        "weight": 1.0,
        "tolerance_type": "serotonin_release"
      },
      "stimulant": {
        "weight": 0.3,
        "tolerance_type": "stimulant"
      }
    }
  }
}
```

**Interpretation**: MDMA is **primarily** a serotonin releaser (weight 1.0) with **minor** stimulant effects (weight 0.3). Tolerance to each bucket accumulates independently.

### Cross-Tolerance Modeling

Substances in the same bucket exhibit **cross-tolerance**:

```
Example: LSD tolerance
- Day 0: Take 100μg LSD → Full effects
- Day 1: Take 100μg LSD → 10-20% effects (90% tolerance)
- Day 1: Take 2g mushrooms → 10-20% effects (CROSS-TOLERANCE via shared 5-HT2A bucket)
```

**Implementation**: Each bucket has its own tolerance curve. Using LSD increases `serotonin_psychedelic` tolerance, which affects ALL substances with that bucket (mushrooms, mescaline, 2C-x, etc.).

---

## 📐 Tolerance Calculation Algorithms

### The Problem: Unrealistic Linear Growth

**Before Fix** (November 2025):
- User took 8 doses of 5mg Dexedrine over 4 days
- Expected tolerance: 20-40%
- **ACTUAL tolerance shown: 1010% (10.108)** ❌

**Root Causes**:
1. Tolerance added on every recalculation (not per-use)
2. No per-event decay (all tolerance decayed together)
3. Active level incorrectly adding tolerance instead of pausing decay
4. No calibration factor for realistic progression

### The Solution: Logarithmic Growth Model

**Key Insight**: Real biological tolerance follows **logarithmic growth** with diminishing returns:
- First few uses: Rapid tolerance buildup
- Moderate use: Gradual increase
- Heavy chronic use: Asymptotic plateau (~80-95% max)

**Formula**:
```dart
// Per-event tolerance contribution
double calculateToleranceIncrement(double activeLevel, double weight) {
  // Logarithmic growth: log(1 + x) / log(2) normalized
  final rawContribution = log(1 + activeLevel) / log(2);
  
  // Apply bucket weight and calibration factor
  final calibrationFactor = 0.05; // Tuned for realistic progression
  return rawContribution * weight * calibrationFactor;
}

// Apply decay
double applyDecay(double currentTolerance, double daysSinceLastUse, double halfLife) {
  final k = ln2 / halfLife;
  return currentTolerance * exp(-k * daysSinceLastUse);
}
```

### Per-Event vs. Continuous Calculation

**OLD (Broken)**: Recalculate tolerance every time UI refreshes
- ❌ Tolerance grows on every page load
- ❌ No distinction between "no use" and "active use"

**NEW (Fixed)**: Calculate tolerance only when logging new use
- ✅ Tolerance increments only for actual drug events
- ✅ Decay happens between events (based on time delta)
- ✅ Viewing tolerance dashboard doesn't change values

**Implementation** (`lib/utils/bucket_tolerance_calculator.dart`):
```dart
Map<String, double> calculateBucketTolerances(List<LogEntry> entries) {
  final bucketStates = <String, BucketState>{};
  
  // Sort entries chronologically
  entries.sort((a, b) => a.useTime.compareTo(b.useTime));
  
  for (final entry in entries) {
    final profile = getDrugProfile(entry.substance);
    
    // For each affected bucket
    for (final bucket in profile.neuroBuckets.entries) {
      final state = bucketStates.putIfAbsent(
        bucket.key,
        () => BucketState(tolerance: 0.0, lastEventTime: null),
      );
      
      // Apply decay since last event
      if (state.lastEventTime != null) {
        final daysSince = entry.useTime.difference(state.lastEventTime!).inDays.toDouble();
        state.tolerance = applyDecay(state.tolerance, daysSince, bucket.value.halfLife);
      }
      
      // Calculate active level for this dose
      final activeLevel = calculateActiveLevel(entry.dose, profile);
      
      // Add tolerance increment (logarithmic)
      state.tolerance += calculateToleranceIncrement(activeLevel, bucket.value.weight);
      
      // Cap at 100%
      state.tolerance = min(1.0, state.tolerance);
      
      // Update last event time
      state.lastEventTime = entry.useTime;
    }
  }
  
  // Apply final decay to present
  final now = DateTime.now();
  for (final bucket in bucketStates.entries) {
    if (bucket.value.lastEventTime != null) {
      final daysSince = now.difference(bucket.value.lastEventTime!).inDays.toDouble();
      bucket.value.tolerance = applyDecay(
        bucket.value.tolerance,
        daysSince,
        getBucketHalfLife(bucket.key),
      );
    }
  }
  
  return Map.fromEntries(
    bucketStates.entries.map((e) => MapEntry(e.key, e.value.tolerance))
  );
}
```

---

## 🔐 Encryption System

### Zero-Knowledge Architecture

**Core Principle**: The server never sees plaintext data, PIN, or encryption keys.

### Components

#### 1. Master Key (256-bit AES)
- Generated client-side on first setup
- Encrypted with PIN-derived key (PBKDF2)
- Stored in Supabase (encrypted blob)
- Never leaves device in plaintext

#### 2. PIN (6 digits)
- User-chosen, memorable
- Used to derive encryption key (PBKDF2 with 100k iterations)
- Salt stored server-side (non-secret)
- PIN never sent to server

#### 3. Recovery Key (24-char hex)
- Backup mechanism for master key
- Shown once during setup
- Can decrypt master key without PIN
- User must save offline

#### 4. Biometric Unlock (Optional)
- Uses Flutter `local_auth` plugin
- Master key stored in device keychain (encrypted by OS)
- Device-specific (doesn't work on other devices)
- Falls back to PIN if biometric fails

### Encryption Flow

**Setup (First Time)**:
```
1. Generate master_key (random 256-bit)
2. User creates PIN
3. Derive pin_key = PBKDF2(PIN, salt, 100k iterations)
4. encrypted_master_key = AES-GCM(master_key, pin_key)
5. recovery_key = hex(master_key)[0:24]
6. Store encrypted_master_key in Supabase
7. Show recovery_key to user (SAVE THIS!)
```

**Unlock with PIN**:
```
1. Fetch encrypted_master_key and salt from Supabase
2. Derive pin_key = PBKDF2(entered_PIN, salt, 100k iterations)
3. master_key = AES-GCM-decrypt(encrypted_master_key, pin_key)
4. If decryption succeeds → Unlocked
5. Store master_key in memory (Provider state)
```

**Unlock with Biometric**:
```
1. Request biometric auth (fingerprint/face)
2. If approved, retrieve master_key from OS keychain
3. Load master_key into memory
```

**Encrypt User Data**:
```
1. Generate random IV (12 bytes)
2. ciphertext = AES-GCM(plaintext, master_key, IV)
3. Store: IV || ciphertext (concatenated)
4. Save to Supabase
```

**Decrypt User Data**:
```
1. Fetch encrypted_data from Supabase
2. Split into IV (first 12 bytes) and ciphertext
3. plaintext = AES-GCM-decrypt(ciphertext, master_key, IV)
4. Display to user
```

### Implementation Details

**File**: `lib/services/encryption_service_v2.dart`

**Key Classes**:
- `EncryptionServiceV2`: Main service with setup/unlock/encrypt/decrypt
- `SecretStorage`: Interface to `flutter_secure_storage` (master key cache)
- `BiometricAuth`: Wrapper around `local_auth` plugin

**Encrypted Fields**:
- Log entry notes
- Craving context
- Reflection journal entries
- Any user-generated free text

**Non-Encrypted Data** (for queries/analytics):
- Substance name
- Dose (numeric)
- Route of administration
- Timestamps
- User ID

### Security Considerations

**Strengths**:
- ✅ True zero-knowledge (server can't decrypt)
- ✅ Industry-standard crypto (AES-256-GCM, PBKDF2)
- ✅ Recovery mechanism (recovery key)
- ✅ Biometric convenience without compromising security

**Trade-offs**:
- ⚠️ If user loses PIN AND recovery key → Data unrecoverable
- ⚠️ Biometric only works on enrolled device
- ⚠️ Server-side search on encrypted fields not possible

**Future Improvements**:
- Multi-device sync with encrypted keys
- Shamir secret sharing for recovery (split key into 3-of-5 shards)
- Hardware security module (HSM) integration

---

## 🎨 Design System Architecture

### Philosophy

**Centralized, Token-Based Design**: All UI constants live in a single source of truth, eliminating magic numbers and ensuring consistency.

### Structure

```
lib/constants/
├── theme/
│   ├── app_colors.dart          # Color palette (light/dark modes)
│   ├── app_spacing.dart         # Spacing scale (xs to xxxl)
│   ├── app_radii.dart           # Border radius scale
│   ├── app_shadows.dart         # Elevation system
│   ├── app_typography.dart      # Text styles (responsive)
│   ├── app_animation.dart       # Animation durations/curves
│   └── app_layout.dart          # Layout enums (alignment, fit, etc.)
├── domain/
│   ├── categories.dart          # Drug categories
│   ├── drug_category_colors.dart
│   ├── intentions.dart
│   ├── triggers.dart
│   ├── mood_emojis.dart
│   └── reflection_*.dart
└── system/
    ├── feature_flags.dart
    └── time_period.dart
```

### Theme Extension Pattern

**File**: `lib/common/theme/app_theme_extension.dart`

```dart
extension AppThemeExtension on BuildContext {
  AppTheme get theme => AppThemeProvider.of(this);
  ColorPalette get colors => theme.colors;
  AppTypography get text => theme.typography;
  AppSpacing get spacing => theme.spacing;
  AppSizes get sizes => theme.sizes;
  AppShapes get shapes => theme.shapes;
  AppAnimations get animations => theme.animations;
  AppLayout get layout => AppLayout();
}
```

**Usage**:
```dart
// OLD (before migration)
Container(
  color: Colors.blue,
  padding: EdgeInsets.all(16),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  ),
)

// NEW (after migration)
Container(
  color: context.colors.primary,
  padding: EdgeInsets.all(context.spacing.md),
  child: Text(
    'Hello',
    style: context.text.bodyBold,
  ),
)
```

### Common Components

**Location**: `lib/common/`

**Component Library** (30+ widgets):
- **Buttons**: `CommonPrimaryButton`, `CommonSecondaryButton`, `CommonIconButton`
- **Cards**: `CommonCard`, `CommonFormCard`, `CommonSectionHeader`
- **Inputs**: `CommonInputField`, `CommonDropdown`, `CommonSlider`, `CommonSwitchTile`
- **Feedback**: `CommonLoader`, `CommonErrorState`, `CommonEmptyState`
- **Layout**: `CommonSpacer`, `CommonDrawer`, `CommonScaffold`
- **Text**: `CommonLabel`, `CommonSubheading`, `CommonBody`

**Design Principles**:
1. **Consistent API**: All components accept same props (e.g., `onTap`, `isDisabled`)
2. **Theme-Aware**: Automatically use theme colors/spacing
3. **Accessible**: Semantic labels, proper contrast, keyboard navigation
4. **Responsive**: Adapt to screen size and orientation

### Migration Process

**Completed Batches**:
1. ✅ Batch 2: Analytics, Blood Levels, Bug Report, Catalog
2. ✅ Batch 3: Daily Checkin, Catalog, Edit Reflection, Feature Flags
3. ✅ Batch 4: Login, Setup Account, Settings
4. ✅ Batch 5: Log Entry
5. ✅ Batch 6: Edit Log Entry
6. ✅ Batch 7: Analytics
7. ✅ Batch 8: Activity
8. ✅ Batch 9: Settings, Stockpile, Tolerance

**Migration Scripts**: Python-based automated refactoring in `scripts/ci/design_system/`

**Verification**: CI checks ensure no hardcoded values slip through:
```bash
python scripts/ci/design_system/run.py
# Checks: colors, spacing, typography, component usage, accessibility
```

---

## 🗄️ Database Architecture

### Supabase (PostgreSQL)

**Schema Overview**:

#### Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  encrypted_master_key TEXT, -- AES-encrypted master key
  encryption_salt TEXT,       -- PBKDF2 salt
  recovery_key_hash TEXT,     -- bcrypt hash of recovery key
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Log Entries Table
```sql
CREATE TABLE log_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  substance TEXT NOT NULL,
  dose NUMERIC NOT NULL,
  unit TEXT NOT NULL,
  route TEXT NOT NULL,
  use_time TIMESTAMPTZ NOT NULL,
  notes TEXT,                  -- ENCRYPTED with master key
  feelings JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Cravings Table
```sql
CREATE TABLE cravings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  substance TEXT NOT NULL,
  intensity INT CHECK (intensity BETWEEN 1 AND 10),
  triggers JSONB,
  coping_strategies JSONB,
  context TEXT,                -- ENCRYPTED
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Drug Profiles Table
```sql
CREATE TABLE drug_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  category TEXT NOT NULL,
  half_life_hours NUMERIC,
  formatted_dose JSONB,        -- {threshold, light, common, strong, heavy}
  tolerance_model JSONB,       -- neuro_buckets configuration
  routes JSONB,                -- valid routes of administration
  effects JSONB,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Row Level Security (RLS)

**Principle**: Users can only access their own data.

**Example Policies**:
```sql
-- Users can only read their own log entries
CREATE POLICY log_entries_select ON log_entries
  FOR SELECT USING (auth.uid() = user_id);

-- Users can only insert their own log entries
CREATE POLICY log_entries_insert ON log_entries
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can only update their own log entries
CREATE POLICY log_entries_update ON log_entries
  FOR UPDATE USING (auth.uid() = user_id);

-- Users can only delete their own log entries
CREATE POLICY log_entries_delete ON log_entries
  FOR DELETE USING (auth.uid() = user_id);
```

### Indexing Strategy

**Performance-Critical Indexes**:
```sql
-- Queries by user and time range
CREATE INDEX idx_log_entries_user_time ON log_entries(user_id, use_time DESC);

-- Substance-specific queries
CREATE INDEX idx_log_entries_substance ON log_entries(user_id, substance);

-- Craving lookups
CREATE INDEX idx_cravings_user_time ON cravings(user_id, created_at DESC);

-- Drug profile lookups (case-insensitive)
CREATE INDEX idx_drug_profiles_name ON drug_profiles(LOWER(name));
```

---

## 🔄 Backend Data Pipeline

### Overview

**Purpose**: Scrape, normalize, and merge drug data from multiple public sources.

**Location**: `backend/`

**Language**: Python 3.8+

**Dependencies**:
- `requests` - HTTP client
- `beautifulsoup4` - HTML parsing
- `supabase-py` - Database client (optional)

### Architecture

```
backend/
├── pipeline.py                # Main orchestrator
├── scrapers/
│   ├── scrape_tripsit_file.py      # Fetch TripSit JSON
│   ├── scrape_tripsit.py           # Scrape TripSit factsheets
│   ├── scrape_psychonautwiki_index.py  # Get PW substance list
│   ├── scrape_psychonautwiki.py    # Scrape PW pages
│   ├── scrape_wikipedia.py         # Scrape Wikipedia
│   └── scrape_pubchem.py           # Fetch PubChem data
├── processors/
│   ├── normalize_data.py           # Clean and standardize
│   ├── merge_scraped_data.py       # Merge multiple sources
│   ├── validate_data.py            # Check for errors
│   └── generate_diff.py            # Compare with existing DB
└── utils/
    ├── config.py                   # Paths and settings
    └── logging_utils.py            # Logging setup
```

### Pipeline Stages

#### Stage A: Scraping
```bash
python -m backend.pipeline --run-all
```

**Process**:
1. Fetch TripSit JSON (baseline - 550+ drugs)
2. For each drug:
   - Scrape PsychonautWiki (dosages, effects, tolerance)
   - Scrape Wikipedia (general info)
   - Scrape PubChem (chemical data)
3. Save raw HTML/JSON to `data/scraped/`

**Output**: `data/scraped/raw_YYYYMMDD.json`

#### Stage B: Processing
```bash
python -m backend.processors.normalize_data
```

**Process**:
1. **Normalize**: Clean HTML, extract structured data
2. **Merge**: Combine data from multiple sources per substance
3. **Validate**: Check for missing fields, inconsistencies
4. **Diff**: Compare with existing database

**Output**:
- `data/cleaned/normalized_YYYYMMDD.json`
- `data/processed/final_merged.json`
- `data/diff/db_vs_scrape_YYYYMMDD.json`

#### Stage C: Upload (Manual)
```bash
# Review final_merged.json
# Upload to Supabase via SQL or admin interface
```

### Rate Limiting

**Configuration**:
```python
# backend/utils/config.py
DELAY_BETWEEN_REQUESTS = 0.5  # seconds
MAX_PSYCHONAUTWIKI_PAGES = None  # or integer to limit
```

**Usage**:
```bash
# Reduced rate for testing
python -m backend.pipeline --run-all --delay 1.0 --max-pw 5
```

### Data Quality

**Validation Rules**:
- ✅ All substances must have a name and category
- ✅ Dosages must be numeric (mg, g, μg)
- ✅ Routes must be from standard list
- ✅ Half-life must be positive number
- ⚠️ Missing tolerance data logged but not blocking

**Sources Priority** (highest to lowest):
1. PsychonautWiki (dosages, tolerance)
2. TripSit (routes, effects)
3. Wikipedia (general info)
4. PubChem (chemistry)

---

## 🧪 Testing Strategy

### Current Coverage: 12.44%

**Files with Excellent Coverage (>80%)**:
- `common/inputs/input_field.dart` (100%)
- `common/inputs/slider.dart` (100%)
- `services/onboarding_service.dart` (100%)
- `utils/log_entry_serializer.dart` (100%)
- `utils/entry_validation.dart` (100%)

**Files Needing Coverage** (<20%):
- Most services (craving, log_entry, reflection, tolerance)
- Most features (activity, analytics, catalog)
- Most models

### Test Structure

```
test/
├── constants/           # Design system constant tests
├── helpers/             # Test utilities & mocks
├── models/              # Model serialization tests
├── services/            # Service logic tests
├── utils/               # Utility function tests
├── providers/           # State management tests
└── integration/         # End-to-end flow tests
```

### Testing Approach

#### Unit Tests
**Target**: Pure functions, utilities, models

**Example** (`test/utils/bucket_tolerance_calculator_test.dart`):
```dart
test('calculates stimulant tolerance correctly', () {
  final entries = [
    LogEntry(
      substance: 'Dexedrine',
      dose: 5,
      useTime: DateTime(2025, 1, 1, 8, 0),
    ),
    LogEntry(
      substance: 'Dexedrine',
      dose: 5,
      useTime: DateTime(2025, 1, 1, 12, 0),
    ),
  ];
  
  final tolerances = BucketToleranceCalculator.calculate(entries);
  
  expect(tolerances['stimulant'], closeTo(0.15, 0.05)); // ~15% tolerance
});
```

#### Service Tests
**Target**: Business logic, API calls, encryption

**Strategy**: Mock dependencies (Supabase, EncryptionService)

**Example** (`test/services/craving_service_test.dart`):
```dart
test('saves craving with encryption', () async {
  final mockSupabase = MockSupabaseClient();
  final mockEncryption = MockEncryptionService();
  final service = CravingService(
    supabase: mockSupabase,
    encryption: mockEncryption,
  );
  
  when(mockEncryption.encryptText('Test context'))
    .thenReturn('encrypted_blob_123');
  
  final craving = Craving(
    substance: 'Cannabis',
    intensity: 7,
    context: 'Test context',
  );
  
  await service.saveCraving(craving);
  
  verify(mockSupabase.from('cravings').insert({
    'substance': 'Cannabis',
    'intensity': 7,
    'context': 'encrypted_blob_123',
  })).called(1);
});
```

#### Widget Tests
**Target**: UI components, interaction logic

**Example** (`test/common/buttons/common_primary_button_test.dart`):
```dart
testWidgets('CommonPrimaryButton calls onTap', (tester) async {
  var tapped = false;
  
  await tester.pumpWidget(
    AppThemeProvider(
      child: MaterialApp(
        home: Scaffold(
          body: CommonPrimaryButton(
            label: 'Tap Me',
            onTap: () => tapped = true,
          ),
        ),
      ),
    ),
  );
  
  await tester.tap(find.text('Tap Me'));
  await tester.pump();
  
  expect(tapped, isTrue);
});
```

#### Integration Tests
**Target**: Full user flows (login → log entry → view analytics)

**Example** (`integration_test/create_log_entry_flow_test.dart`):
```dart
testWidgets('complete log entry flow', (tester) async {
  // Setup Supabase test environment
  // ...
  
  // 1. Login
  await tester.enterText(find.byType(TextField).first, 'test@example.com');
  await tester.enterText(find.byType(TextField).last, 'password123');
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  
  // 2. Navigate to log entry
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  
  // 3. Fill form
  await tester.enterText(find.byKey(Key('substance-field')), 'Caffeine');
  await tester.enterText(find.byKey(Key('dose-field')), '200');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
  
  // 4. Verify entry appears in activity feed
  expect(find.text('Caffeine'), findsOneWidget);
  expect(find.text('200mg'), findsOneWidget);
});
```

### Continuous Integration

**GitHub Actions** (planned):
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v2
```

---

## ⚡ Performance Optimizations

### 1. Tolerance Calculation Caching

**Problem**: Recalculating tolerance on every UI frame (60 FPS)

**Solution**: Cache tolerance values, invalidate on new log entry

```dart
class ToleranceCache {
  Map<String, double>? _cachedTolerances;
  int? _lastEntryCount;
  
  Map<String, double> getTolerances(List<LogEntry> entries) {
    if (_cachedTolerances != null && _lastEntryCount == entries.length) {
      return _cachedTolerances!;
    }
    
    _cachedTolerances = BucketToleranceCalculator.calculate(entries);
    _lastEntryCount = entries.length;
    return _cachedTolerances!;
  }
  
  void invalidate() {
    _cachedTolerances = null;
    _lastEntryCount = null;
  }
}
```

### 2. Pagination for Activity Feed

**Problem**: Loading 1000+ log entries on startup

**Solution**: Paginate, fetch 50 at a time

```dart
Future<List<LogEntry>> fetchLogEntries({int page = 0, int limit = 50}) async {
  final response = await supabase
    .from('log_entries')
    .select()
    .eq('user_id', userId)
    .order('use_time', ascending: false)
    .range(page * limit, (page + 1) * limit - 1);
  
  return response.map((json) => LogEntry.fromJson(json)).toList();
}
```

### 3. Lazy Loading for Drug Profiles

**Problem**: Loading 550+ drug profiles on startup (2MB+ JSON)

**Solution**: Load on-demand, cache in memory

```dart
class DrugProfileCache {
  final _cache = <String, DrugProfile>{};
  
  Future<DrugProfile?> getProfile(String name) async {
    if (_cache.containsKey(name)) {
      return _cache[name];
    }
    
    final profile = await _fetchFromDatabase(name);
    if (profile != null) {
      _cache[name] = profile;
    }
    return profile;
  }
}
```

### 4. Image Optimization

**Problem**: Large PNG assets (icons, drug images)

**Solution**: Use SVG where possible, compress PNGs

```bash
# Compress all PNG files
find . -name "*.png" -exec pngquant --quality=65-80 --ext .png --force {} \;
```

### 5. Build Size Reduction

**Problem**: Release APK size >30MB

**Optimizations**:
- Tree-shaking (automatic with Flutter)
- Remove unused assets
- Use `--split-per-abi` for Android
- Obfuscate Dart code

```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=./debug-info
```

---

## 📜 Historical Evolution & Lessons Learned

### Timeline

**October 2025**: Initial prototype
- ✅ Basic log entry CRUD
- ✅ Simple tolerance calculation (linear)
- ❌ No encryption
- ❌ Hardcoded UI values everywhere

**November 2025**: Tolerance refactoring
- ✅ Discovered 1010% tolerance bug
- ✅ Implemented logarithmic growth model
- ✅ Added neurochemical bucket system
- ✅ Per-event tolerance calculation

**December 2025**: Design system migration
- ✅ Created `AppThemeExtension` and `Common*` components
- ✅ Migrated all 164 Flutter files
- ✅ Python CI scripts for automated checking
- ✅ Zero blocking issues in design system report

**December 2025**: Encryption & testing
- ✅ Implemented zero-knowledge PIN system
- ✅ Added biometric unlock and recovery key
- ✅ Test coverage from 0% → 12.44%
- ⏳ Roadmap for 80%+ coverage

### Lessons Learned

#### 1. Test Early, Test Often
**Mistake**: Built tolerance system without tests, discovered 1010% bug in production usage

**Solution**: Now writing tests alongside features, aiming for 80%+ coverage

#### 2. Design Systems Save Time
**Mistake**: Copy-pasted UI code across 200+ files, making changes painful

**Solution**: Centralized theme system + Common components. Now changes propagate automatically.

#### 3. Document as You Build
**Mistake**: Forgot why certain tolerance formulas were chosen after 2 weeks

**Solution**: This document. Explain the "why" not just the "what".

#### 4. Performance Matters
**Mistake**: Recalculating tolerance 60 times/second on dashboard page

**Solution**: Caching, pagination, lazy loading. Measure before optimizing.

#### 5. Security is Hard
**Mistake**: First encryption attempt stored PIN in SharedPreferences (plaintext!)

**Solution**: Proper zero-knowledge architecture with PBKDF2, recovery keys, biometrics.

### Future Improvements

**Short-term** (Q1 2026):
- Finish Riverpod migration
- Reach 80%+ test coverage
- Add CSV export
- Medication reminders

**Medium-term** (Q2-Q3 2026):
- Multi-language support (i18n)
- Enhanced analytics (ML-based predictions)
- Community drug data contributions
- iOS release

**Long-term** (2026+):
- Desktop app (Windows/macOS/Linux)
- Web app (with WebCrypto API)
- Wearable integration (smartwatch tracking)
- Peer-reviewed tolerance model publication

---

## 📚 References

### Pharmacology
1. Goodman & Gilman's *The Pharmacological Basis of Therapeutics* (13th ed.)
2. Stahl's *Essential Psychopharmacology* (5th ed.)
3. PsychonautWiki - [psychonautwiki.org](https://psychonautwiki.org)
4. TripSit - [tripsit.me](https://tripsit.me)

### Cryptography
1. NIST SP 800-132: *Recommendation for Password-Based Key Derivation*
2. RFC 5084: *Using AES-CCM and AES-GCM*
3. OWASP *Cryptographic Storage Cheat Sheet*

### Flutter/Dart
1. Flutter Documentation - [flutter.dev](https://flutter.dev)
2. Effective Dart - [dart.dev/guides/language/effective-dart](https://dart.dev/guides/language/effective-dart)
3. Riverpod Documentation - [riverpod.dev](https://riverpod.dev)

---

**Last Updated**: December 21, 2025  
**Maintainer**: [Your Name/GitHub]  
**Questions?**: Open an issue on GitHub or consult inline code comments.
