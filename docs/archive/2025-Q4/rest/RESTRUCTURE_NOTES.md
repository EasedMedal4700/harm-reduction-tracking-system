# Documentation Restructure - November 30, 2025

## What Changed

Consolidated 48+ scattered markdown documentation files into 2 comprehensive READMEs:

### New Structure

```
📦 mobile_drug_use_app/
├── 📄 README.md                    # User & developer guide (setup, features, usage)
├── 📄 TECHNICAL_DEEP_DIVE.md       # Deep technical reference (formulas, algorithms, architecture)
└── 📁 docs/
    └── 📁 archive/                 # Historical development documentation
        ├── 📄 INDEX.md             # Navigation guide for archived docs
        └── 📄 48 archived .md files
```

### README.md (Main Documentation)
**Audience**: General users, new developers, Play Store visitors

**Contains**:
- What the app does (features, use cases)
- Getting started (installation, setup, first use)
- User guide (daily workflow, understanding tolerance)
- Architecture overview (high-level tech stack)
- Contributing guidelines
- License & contact info

**Length**: ~300 lines  
**Tone**: Accessible, user-friendly, harm reduction focused

---

### TECHNICAL_DEEP_DIVE.md (Nerd Shit)
**Audience**: Core developers, contributors, pharmacology nerds, security auditors

**Contains**:
1. **Pharmacokinetic Modeling**
   - Half-life decay formulas with derivations
   - Multi-dose superposition math
   - Active threshold concept & why we use 15%

2. **Tolerance System Architecture**
   - Why we have 2 parallel systems (legacy + bucket)
   - Mathematical comparison of both approaches
   - Migration strategy

3. **Neurochemical Bucket System**
   - The 7 buckets explained (stimulant, serotonin, GABA, etc.)
   - Weight system & cross-tolerance modeling
   - Clinical validation sources

4. **Tolerance Calculation Algorithms**
   - The Great Tolerance Bug of November 2025 (1010% bug)
   - Root cause analysis (4 separate issues)
   - Logarithmic growth model with full mathematical derivation
   - Per-event decay algorithm (code + explanation)
   - Bucket-specific formulas (stimulant vs psychedelic vs serotonin release)
   - Decay rates by bucket with clinical justification

5. **Encryption System**
   - Threat model & security guarantees
   - AES-256-GCM implementation details
   - Key derivation from JWT tokens
   - Auto-detection of encrypted vs plaintext data
   - Which fields are encrypted and why

6. **Database Architecture**
   - Full schema reference (all tables)
   - Row-Level Security (RLS) policies with SQL
   - Migration history: user_id → auth_user_id
   - Performance indexes

7. **Performance Optimizations**
   - Caching strategy (TTL-based in-memory cache)
   - Lazy loading & pagination
   - Debouncing search queries
   - Batch database operations

8. **Historical Evolution & Lessons Learned**
   - The Great Tolerance Bug (5-day debugging saga)
   - Database Migration Hell (27 files updated)
   - Encryption System Deployment (backward compatibility)
   - UI Refactoring Marathon (7,476 → 4,234 lines)

9. **References & Further Reading**
   - Pharmacology textbooks & papers
   - Pharmacokinetics references
   - Tolerance mechanism research
   - Harm reduction resources

**Length**: ~1,500 lines  
**Tone**: Academic, detailed, brutally honest about mistakes

---

## Archived Documentation

All 48 development markdown files moved to `docs/archive/`:
- Feature implementation notes
- Bug fix summaries
- Refactoring changelogs
- Migration documentation
- Historical design decisions

**Purpose**: Preserved for:
- Understanding why certain decisions were made
- Debugging legacy issues
- Onboarding new developers (see evolution of features)
- Historical reference

**Access**: See `docs/archive/INDEX.md` for navigation guide

---

## Benefits of This Restructure

### Before (Messy)
- ❌ 48 separate markdown files in root directory
- ❌ No clear entry point for new users/developers
- ❌ Duplicate information scattered across files
- ❌ Hard to find specific information
- ❌ Overwhelming for new contributors
- ❌ No distinction between user docs vs technical docs

### After (Clean)
- ✅ 2 focused READMEs (user guide + technical reference)
- ✅ Clear entry points (README for users, TECHNICAL for devs)
- ✅ Single source of truth for each topic
- ✅ Easy to find information (comprehensive table of contents)
- ✅ Gradual learning curve (start simple, go deep if interested)
- ✅ Clear separation: user docs vs technical deep dives
- ✅ Historical docs preserved but organized

---

## For Future Contributors

### When to Update README.md
- New features that users need to know about
- Changes to setup/installation process
- New dependencies or system requirements
- Updated user workflows

### When to Update TECHNICAL_DEEP_DIVE.md
- New algorithms or formulas
- Performance optimizations
- Security improvements
- Database schema changes
- Architecture refactors
- Bug fixes that reveal interesting technical insights

### When to Add to docs/archive/
- Feature implementation notes (once feature is complete)
- Major refactoring summaries
- Migration documentation
- One-time fixes or workarounds

---

**Never forget**: This app helps real people make safer decisions about drugs. Documentation accuracy matters. Lives may depend on it. 🧬

*"Good documentation is like tolerance: easy to lose, hard to rebuild, and everyone underestimates how important it is until it's gone."*
