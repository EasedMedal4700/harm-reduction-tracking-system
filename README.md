# 🧪 Drug Use Tracking & Harm Reduction App

A comprehensive Flutter-based mobile application for tracking substance use, managing tolerance, and promoting safer use practices through data-driven insights.

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
- **Local-First Storage** - Your data stays on your device and your private database
- **No Analytics/Tracking** - Zero third-party services or data collection
- **Account Management** - Full control with data export and account deletion

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.9.2
- Android Studio or VS Code with Flutter extensions
- A Supabase account and project

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/EasedMedal4700/mobile_drug_use_app.git
   cd mobile_drug_use_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment variables**
   
   Create a `.env` file in the project root:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Run database migrations**
   
   Execute the SQL scripts in `DB/` folder in your Supabase SQL editor (in order).

5. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android:**
```bash
flutter build apk --release
# Or for app bundle:
flutter build appbundle --release
```

**Windows:**
```bash
flutter build windows --release
```

## 📖 User Guide

### First Time Setup
1. Launch app and create an account
2. Your encryption key is automatically generated
3. Start by adding your first drug use entry or daily check-in

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

## 🏗️ Architecture Overview

### Tech Stack
- **Framework**: Flutter (Dart)
- **Database**: Supabase (PostgreSQL)
- **State Management**: Provider pattern
- **Encryption**: AES-256-GCM (cryptography package)
- **Charts**: FL_Chart
- **Storage**: SharedPreferences (local cache)

### Key Directories
```
lib/
├── constants/     # UI colors, themes, drug categories
├── models/        # Data models (LogEntry, Craving, ToleranceBucket)
├── screens/       # Main app pages (~200 lines each)
├── services/      # Business logic & API calls
├── widgets/       # Reusable UI components
├── utils/         # Helpers, calculators, formatters
└── providers/     # State management
```

## 🧪 For Developers

Want to understand the deep technical details? Check out **[TECHNICAL_DEEP_DIVE.md](TECHNICAL_DEEP_DIVE.md)** for:
- Pharmacokinetic formulas and derivations
- Tolerance calculation algorithms
- Neurochemical bucket system architecture
- Encryption implementation details
- Database schema and RLS policies
- Performance optimization strategies

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## ⚠️ Disclaimer

**This app is for harm reduction and educational purposes only.**

- Not a substitute for medical advice or addiction treatment
- Tolerance calculations are estimates, not guarantees of safety
- Always follow local laws regarding controlled substances
- Seek professional help for substance use disorders

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- Drug data sourced from PsychonautWiki and TripSit
- Pharmacokinetic models based on published research
- Inspired by harm reduction principles from organizations like DanceSafe and Erowid

## 📧 Contact

- **Developer**: EasedMedal4700
- **Repository**: https://github.com/EasedMedal4700/mobile_drug_use_app
- **Issues**: https://github.com/EasedMedal4700/mobile_drug_use_app/issues

---

**Stay safe. Stay informed. Use data to make better decisions.** 🧬
