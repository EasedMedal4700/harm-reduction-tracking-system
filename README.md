# 🧪 Drug Use Tracking & Harm Reduction App

A comprehensive Flutter-based mobile application for tracking substance use, managing tolerance, and promoting safer use practices through data-driven insights.

---

## 📱 What Is This?

This app helps users track their drug use patterns, monitor tolerance buildup, manage cravings, and make informed decisions about their consumption. It combines pharmacokinetic modeling, neurochemical tolerance tracking, and wellness monitoring into a privacy-focused mobile experience.

## ✨ Key Features

### 📊 Core Tracking

- **Drug Use Logging** - Record every use with dose, route, time, feelings, and context
- **Craving Management** - Track craving intensity, triggers, and coping strategies
- **Daily Check-ins** - Monitor mood and wellness throughout the day (morning/afternoon/evening)
- **Activity Feed** - Timeline view of all entries with quick access and editing
- **Reflections** - Journal your experiences and insights

### 🧬 Science-Based Tools

- **Tolerance Dashboard** - Real-time tolerance calculations across 7 neurochemical systems:
  - Stimulant (dopamine/norepinephrine)
  - Serotonin Release (MDMA-type)
  - Serotonin Psychedelic (classic psychedelics)
  - GABAergic (depressants)
  - Opioid
  - Cannabinoid
  - NMDA Antagonist (dissociatives)
- **Blood Levels Timeline** - Visualize active drug concentrations using half-life decay
- **Weekly Usage Analytics** - Charts, graphs, and insights into your consumption patterns
- **Personal Drug Library** - Curated list of your substances with usage statistics

### 🎯 Harm Reduction

- **Route of Administration Validation** - Warns about non-standard ROAs
- **Stockpile Management** - Track your supply and consumption rates
- **Safety Warnings** - Tolerance disclaimers and risk information
- **Data Export** - Download your complete data for backup or analysis

### 🔒 Privacy & Security

- **End-to-End Encryption** - All sensitive free-text data encrypted with AES-256-GCM
- **Zero-Knowledge PIN System** - 6-digit PIN with biometric unlock and recovery key backup
- **Zero-Knowledge PIN System** - 6-digit PIN with biometric unlock and recovery key backup
- **Local-First Storage** - Your data stays on your device and your private database
- **No Analytics/Tracking** - Zero third-party services or data collection
- **Account Management** - Full control with data export and account deletion

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.9.2
- Android Studio or VS Code with Flutter extensions
- Dart SDK (included with Flutter)
- A Supabase account and project
- Python 3.8+ (for backend data pipeline - optional)
- Python 3.8+ (for backend data pipeline - optional)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/EasedMedal4700/mobile_drug_use_app.git
   cd mobile_drug_use_app
   ```

2. **Install Flutter dependencies**

   ```bash
   flutter pub get
   ```

3. **Setup Python virtual environment (optional, for backend)**

   ```bash
   python -m venv .venv
   .venv\Scripts\activate  # Windows
   # or: source .venv/bin/activate  # Linux/Mac
   pip install requests beautifulsoup4
   ```

4. **Setup environment variables** Create a .env file in the project root:

   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

5. **Run database migrations** Execute the SQL scripts in DB/ folder in your Supabase SQL editor (in order):
   - Database schema migrations
   - Add encryption recovery key column
   - Set up Row Level Security policies

6. **Run the app**

   ```bash
   flutter run
   ```

### Building for Release

**Android:**

```bash
flutter build apk --release
```

# Or for app bundle:

```bash
flutter build appbundle --release
```

**Windows:**

```bash
flutter build windows --release
```

**iOS/macOS:**

```bash
flutter build ios --release
flutter build macos --release
```

## 📖 User Guide

### First Time Setup

1. Launch app and create an account
2. Set up your 6-digit PIN for encryption
3. **IMPORTANT**: Save your recovery key in a secure location (24-character hex backup)
4. Optional: Enable biometric unlock (fingerprint/face)
5. Start by adding your first drug use entry or daily check-in
2. Set up your 6-digit PIN for encryption
3. **IMPORTANT**: Save your recovery key in a secure location (24-character hex backup)
4. Optional: Enable biometric unlock (fingerprint/face)
5. Start by adding your first drug use entry or daily check-in

### Daily Workflow

1. **Morning**: Complete daily check-in to track baseline mood
2. **Use Logging**: Log any substance use immediately with dose/route/time
3. **Check Tolerance**: Review tolerance dashboard before re-dosing
4. **Blood Levels**: Monitor active concentrations in your system
5. **Evening**: Complete evening check-in and optional reflection

### Understanding Tolerance

The app calculates tolerance based on:

- **Active drug levels** in your system (half-life based)
- **Neurochemical system activation** (which receptors are affected)
- **Logarithmic growth model** (realistic diminishing returns)
- **Individual decay rates** per substance

Tolerance is shown as a percentage where:

- **0-20%**: Minimal tolerance, baseline sensitivity
- **20-50%**: Moderate tolerance, effects may be reduced
- **50-80%**: High tolerance, significant dose increase needed
- **80-100%**: Near-maximum tolerance, high risk/low reward

### Security Features

#### PIN Encryption

- **6-Digit PIN**: Simple and memorable for daily unlock
- **Zero-Knowledge**: Server never sees your PIN or encryption keys
- **AES-256-GCM**: Industry-standard encryption for all sensitive data

#### Biometric Unlock

- Optional fingerprint/face unlock
- **Device-specific**: Only works on the device where enrolled
- Falls back to PIN if biometric fails

#### Recovery Key

- **24-character hex backup**: Can recover data on any device
- **Store securely**: Write it down offline, use a password manager, or both
- **Cross-device**: Works on all devices, unlike biometrics

## 🏗️ Architecture Overview

### Tech Stack

- **Framework**: Flutter (Dart)
- **Database**: Supabase (PostgreSQL)
- **State Management**: Provider pattern (migrating to Riverpod)
- **State Management**: Provider pattern (migrating to Riverpod)
- **Encryption**: AES-256-GCM (cryptography package)
- **Charts**: FL_Chart
- **Storage**: SharedPreferences (local cache)
- **Backend**: Python data pipeline (requests, BeautifulSoup4)

### Project Structure

```
mobile_drug_use_app/
├── lib/
│   ├── common/           # Reusable UI components (CommonCard, CommonButton, etc.)
│   ├── constants/        # Design system constants
│   │   ├── theme/        # Colors, spacing, typography, animations
│   │   ├── domain/       # Drug categories, moods, reflection options
│   │   └── system/       # Feature flags, time periods
│   ├── features/         # Feature-based organization
│   │   ├── activity/     # Activity feed
│   │   ├── analytics/    # Usage analytics
│   │   ├── catalog/      # Drug catalog & personal library
│   │   ├── craving/      # Craving tracking
│   │   ├── log_entry/    # Use logging
│   │   ├── reflection/   # Reflection journal
│   │   ├── settings/     # App settings
│   │   ├── stockpile/    # Stockpile management
│   │   └── tolerence/    # Tolerance dashboard (sic)
│   ├── models/           # Data models
│   ├── providers/        # State management
│   ├── services/         # Business logic & API
│   ├── routes/           # Navigation
│   └── utils/            # Helpers & calculators
├── backend/              # Python data pipeline
│   ├── scrapers/         # Web scrapers (TripSit, PsychonautWiki, etc.)
│   ├── processors/       # Data normalization & validation
│   └── pipeline.py       # Main orchestrator
├── scripts/
│   └── ci/               # CI/CD scripts & design system checker
├── test/                 # Unit & integration tests
└── docs/                 # Additional documentation
```

### Design System

The app uses a comprehensive design system with:

- **Theme System**: AppThemeExtension for consistent colors, spacing, typography
- **Common Components**: 30+ standardized widgets (buttons, cards, inputs, etc.)
- **Accessibility**: Semantic colors, proper contrast ratios, screen reader support
- **Responsive**: Adapts to different screen sizes and orientations

**Migration Status**:

- ✅ Theme system fully implemented
- ✅ Common widgets standardized across all features
- ⏳ Riverpod migration in progress
- ✅ All features migrated to design system

See [THEME_MIGRATION_COMPLETE.md](THEME_MIGRATION_COMPLETE.md) and batch completion docs for details.

## 🧪 For Developers

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/craving_service_test.dart

# Run integration tests
flutter test integration_test/
```

**Current Test Coverage**: ~12.44% (target: 80%+)

See [TEST_COVERAGE_IMPROVEMENT_PLAN.md](TEST_COVERAGE_IMPROVEMENT_PLAN.md) for improvement roadmap.

### Backend Data Pipeline

The app includes a Python backend for scraping and processing drug data:

```bash
# Activate virtual environment
.venv\Scripts\activate

# Run full pipeline (use with caution - makes many web requests)
python -m backend.pipeline --run-all

# Run with limited requests for testing
python -m backend.pipeline --run-all --skip-wikipedia --skip-pubchem --max-pw 2
```

**Data Sources**:

- TripSit drug database (baseline)
- PsychonautWiki (dosages, effects, tolerance)
- Wikipedia (general info)
- PubChem (chemical data)

### CI/CD

Design system checks are automated via Python scripts:

```bash
# Run design system checker
python scripts/ci/design_system/run.py

# Run with quiet mode (CI-friendly)
python scripts/ci/design_system/run.py --quiet
```

**Checks**:

- Color usage (hardcoded colors vs theme)
- Typography (hardcoded fonts vs AppTypography)
- Spacing (magic numbers vs AppSpacing)
- Component usage (old widgets vs Common components)
- Accessibility (contrast ratios, semantic labels)
- Performance (missing const constructors)

### Code Style & Conventions

- **Widget naming**: Use Common* prefix for design system components
- **Theme access**: Always use context.theme, context.colors, context.spacing
- **Spacing**: Use CommonSpacer instead of SizedBox for vertical spacing
- **Buttons**: Use CommonPrimaryButton, CommonSecondaryButton, etc.
- **Cards**: Use CommonCard instead of raw Container or Card
- **Migration headers**: All migrated files have // MIGRATION // Theme: [Migrated] // Common: [Migrated]

### Technical Deep Dive

Want to understand the deep technical details? Check out **[TECHNICAL_DEEP_DIVE.md](TECHNICAL_DEEP_DIVE.md)** for:

- Pharmacokinetic formulas and derivations
- Tolerance calculation algorithms
- Neurochemical bucket system architecture
- Encryption implementation details
- Database schema and RLS policies
- Performance optimizations
- Historical evolution and lessons learned

### Key Documentation

- **[ENCRYPTION_QUICKSTART.md](ENCRYPTION_QUICKSTART.md)** - Zero-knowledge PIN encryption system
- **[CONSTANTS_MIGRATION_GUIDE.md](CONSTANTS_MIGRATION_GUIDE.md)** - Design system migration guide
- **[FEATURES_MIGRATION_COMPLETE.md](FEATURES_MIGRATION_COMPLETE.md)** - Feature migration status
- **[PHASE_1_TEST_COVERAGE_COMPLETE.md](PHASE_1_TEST_COVERAGE_COMPLETE.md)** - Test coverage report
- **Batch Completion Docs** - Detailed migration reports for each feature batch

## 🎯 Roadmap

### Completed (Dec 2025)

- ✅ Design system implementation
- ✅ Theme migration across all features
- ✅ Common component library
- ✅ Zero-knowledge encryption system
- ✅ Tolerance calculation refactoring
- ✅ Activity feed & analytics
- ✅ Settings, stockpile, and tolerance features

### In Progress

- ⏳ Riverpod migration
- ⏳ Test coverage improvement (12% → 80%+)
- ⏳ Backend data pipeline optimization

### Planned

- 🔜 Multi-language support (i18n)
- 🔜 Export to CSV/JSON
- 🔜 Medication reminder system
- 🔜 Enhanced analytics (trends, predictions)
- 🔜 Community-sourced drug data contributions
- 🔜 iOS release

## 🤝 Contributing

This is currently a personal project, but contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Follow existing code style and conventions
4. Add tests for new functionality
5. Update documentation as needed
6. Submit a pull request
2. Create a feature branch
3. Follow existing code style and conventions
4. Add tests for new functionality
5. Update documentation as needed
6. Submit a pull request

## ⚠️ Disclaimer

**This app is for harm reduction and personal tracking only.** It does not:

- Encourage or promote drug use
- Provide medical advice
- Replace professional healthcare
- Guarantee accuracy of pharmacological data

**Always**:

- Consult healthcare professionals
- Research substances thoroughly
- Start with low doses
- Never mix substances without understanding interactions
- Use in safe environments with trusted people

## 📄 License

[License information to be added]

## 💬 Contact

For questions, bug reports, or feature requests:

- GitHub Issues: [Create an issue](https://github.com/EasedMedal4700/mobile_drug_use_app/issues)
- Email: [Contact information]

---

**Last Updated**: December 21, 2025

**Version**: 1.0.0 (Design System Migration Complete)
