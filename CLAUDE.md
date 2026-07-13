# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Seed is a gamified sustainability habit-tracking mobile app for iOS and Android built with Flutter/Dart. Users log eco-friendly actions, earn points based on CO₂ impact, level up a mascot character, and learn about UN SDGs.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (required after modifying @riverpod or @freezed classes)
# Generated files (.g.dart, .freezed.dart) ARE committed -- run this locally
# and stage the regenerated files alongside your source change. CI does not
# run codegen. Note: `flutter pub run` is deprecated, and build_runner 2.7+
# deletes conflicting outputs by default (the old flag was removed).
dart run build_runner build

# Watch mode for development (auto-regenerates on file changes)
dart run build_runner watch

# Generate localization files (also committed -- run after editing .arb files)
flutter gen-l10n

# Analyze code (strict linting enabled)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Firebase CLI (node wrapper)
npm run firebase

# Release builds (always use obfuscation)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
flutter build ipa --release --obfuscate --split-debug-info=build/debug-info
```

## Architecture

### Tech Stack
- **Frontend:** Flutter 3.44.1 / Dart 3.12.1
- **State Management:** Riverpod 3.x with code generation
- **Navigation:** go_router 17.x
- **Backend:** Firebase (Auth, Firestore, FCM, Storage)
- **Subscriptions:** RevenueCat
- **Code Generation:** Freezed 3.x for immutable data classes

### Directory Structure
```
lib/
├── main.dart                 # Entry point, Firebase init
├── app/
│   ├── app.dart              # MaterialApp configuration
│   └── router.dart           # go_router navigation setup
├── core/
│   ├── constants/            # App-wide constants (points, levels, Firebase collections)
│   ├── theme/                # Light/dark themes, color palette
│   ├── utils/                # Helper functions
│   └── l10n/                 # Localization (EN/JP) - ARB files
├── features/                 # Feature modules (Clean Architecture)
│   ├── auth/                 # Authentication
│   ├── actions/              # Action logging
│   ├── mascot/               # Mascot display/evolution
│   ├── profile/              # User profile
│   └── settings/             # App settings
└── shared/
    ├── widgets/              # Reusable widgets
    └── providers/            # Global Riverpod providers
```

### Feature Module Structure
Each feature follows Clean Architecture with three layers:
```
features/{feature}/
├── {feature}.dart            # Barrel file (public API)
├── data/                     # Repositories, data sources, models
├── domain/                   # Entities, use cases
└── presentation/             # Screens, widgets, providers
```

### Riverpod 3.x Patterns
Use `Ref` (not generated `*Ref` types) in provider functions:
```dart
@riverpod
Stream<int> userPoints(Ref ref) {
  final userId = ref.watch(authProvider).userId;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.data()?['points'] ?? 0);
}
```

## Key Configuration

### Localization
- Config: `l10n.yaml`
- ARB files: `lib/core/l10n/app_en.arb`, `app_ja.arb`
- Generated output: `lib/core/l10n/generated/`

### Linting
Strict analysis enabled in `analysis_options.yaml`:
- `strict-casts: true`
- `strict-inference: true`
- `strict-raw-types: true`
- Uses `flutter_lints` + `very_good_analysis`

### Generated Files
Excluded from linting (via `analysis_options.yaml`) but **committed** to
git so CI does not need to run codegen. Regenerate locally and commit
alongside source changes:
- `*.g.dart` (Riverpod, json_serializable)
- `*.freezed.dart` (Freezed)
- `lib/core/l10n/generated/` (localization)

### Data Files
```
data/
├── app/          # Bundled with Flutter app (declared in pubspec.yaml)
│   ├── challenge_templates.json  # Daily + multi-day challenges (EN/JA/ES)
│   ├── eco_dex_entries.json      # Eco-Dex categories + entries (EN/JA/ES)
│   ├── eco_facts.json            # Daily sustainability facts (365 days)
│   ├── mascot_species.json       # Mascot species + evolution stages (EN/JA/ES)
│   ├── sdg_goals.json            # 17 SDG goals with colors + translations (EN/JA/ES)
│   ├── sdg_resources.json        # SDG external resource links (EN/JA/ES)
│   └── sdg_targets.json          # All 169 SDG targets (EN/JA/ES)
├── seed/         # Used by scripts to populate Firestore
│   ├── co2_actions_database.json
│   ├── co2_actions_database.csv
│   └── sdg_world_state_fully_sourced.json
└── reference/    # Source-of-truth reference data
    ├── un_world_days.json       # UN International Days with URLs
    └── sdg_indicator_metadata/  # 17 SDG goal indicator JSONs
```

### Firebase Collections
Defined in `lib/core/constants/app_constants.dart`:
- `users` - User profiles with subcollection `actionLog`
- `actionLibrary` - Read-only action definitions
- `mascotSpecies` - Read-only mascot data
- `cosmeticItems` - Read-only shop items

## Testing

- Unit tests: `fake_cloud_firestore` for Firestore mocking
- Mocking: `mocktail`
- Run all: `flutter test`
- Run single: `flutter test test/path/to/file_test.dart`
- Rive: tests that render `.riv` mascots need the rive_native host
  library (gitignored under `build/`). If they fail with a missing
  `loadRiveFile` symbol, run once:
  `dart run rive_native:setup --clean --platform macos`

### Firestore security-rules tests
Rules (`firestore.rules`) can't be tested by the Dart suite
(`fake_cloud_firestore` ignores rules) — they run against the Firestore
emulator via Jest. Requires a JDK (installed in the `seed` conda env:
`conda install -n seed -c conda-forge openjdk=21`). Run from repo root:
```bash
conda activate seed   # puts java on PATH for the emulator
npm run test:rules
```
See `test/firestore/README.md`.

## Python Environment (conda: seed)

Always activate the `seed` conda env before running Python scripts:
```bash
conda activate seed
```
Path: `/Users/milesd/miniconda3/envs/seed` (Python 3.14)

### Available Python Packages

Use these packages in scripts for data tasks, web research, and automation:

| Category | Package | Use For |
|----------|---------|---------|
| **Web Search** | `duckduckgo-search` | Free web search (no API key) |
| | `googlesearch-python` | Google search scraping |
| **Web Fetching** | `requests` | HTTP requests |
| | `httpx` | Async HTTP client |
| | `beautifulsoup4` | HTML parsing |
| | `trafilatura` | Extract clean text from URLs |
| | `newspaper4k` | Article/fact extraction |
| **JSON/Data** | `pandas` | Bulk JSON/CSV manipulation |
| | `jsonschema` | JSON schema validation |
| | `jmespath` | JSON query expressions |
| **YAML** | `pyyaml` | Parse/edit pubspec.yaml, l10n.yaml |
| **Validation** | `pydantic` | Typed JSON models with validation |
| | `yamllint` | Lint YAML config files |
| **Automation** | `watchdog` | File system watcher |
| | `anthropic` | Claude API client |
| **Output** | `rich` | Pretty terminal output |
| **Graphics** | `cairosvg`, `pillow` | SVG/image processing |

## Architecture Documentation

Detailed architecture, data models, security rules, and development phases are documented in `Plan/MASTER_PLAN.md`.

### Data Audit Checklists
Before doing any research, updating, auditing, or validating data files (eco facts, CO2 actions, SDG data), always check:
- `Plan/AUDIT_FACT_DATA.md` — criteria and checklist for eco facts
- `Plan/AUDIT_ACTION_DATA.md` — criteria and checklist for action data
