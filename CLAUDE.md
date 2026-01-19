# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Seed is a gamified sustainability habit-tracking mobile app for iOS and Android built with Flutter/Dart. Users log eco-friendly actions, earn points based on CO₂ impact, level up a mascot character, and learn about UN SDGs.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (required after modifying @riverpod or @freezed classes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development (auto-regenerates on file changes)
dart run build_runner watch --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Analyze code (strict linting enabled)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Firebase CLI (node wrapper)
npm run firebase
```

## Architecture

### Tech Stack
- **Frontend:** Flutter 3.38.7 / Dart 3.10.7
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
Excluded from linting and git:
- `*.g.dart` (Riverpod, json_serializable)
- `*.freezed.dart` (Freezed)
- `lib/core/l10n/generated/` (localization)

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

## Architecture Documentation

Detailed architecture, data models, security rules, and development phases are documented in `Plan/ARCHITECTURE.md`.
