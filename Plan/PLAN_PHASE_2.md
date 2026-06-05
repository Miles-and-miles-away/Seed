# Phase 2: Mascot MVP - Detailed Implementation Plan

**Version:** 1.0
**Created:** January 2026
**Status:** In Progress

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Current Status](#current-status)
3. [Goals & Deliverables](#goals--deliverables)
4. [Technical Architecture](#technical-architecture)
5. [Data Models](#data-models)
6. [Feature Breakdown](#feature-breakdown)
7. [Screen Designs](#screen-designs)
8. [Implementation Order](#implementation-order)
9. [Testing Strategy](#testing-strategy)
10. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

Phase 2 transforms Seed from a functional habit tracker into an engaging gamified experience. The mascot system adds emotional investment and visual feedback that rewards users for their sustainability efforts.

### Key Objectives
- Users select a starter mascot after signup
- Mascot appears on home screen with reactive animations
- Mascot visually evolves at level milestones (1, 10, 25, 50)
- Users can name and rename their mascot
- Foundation for Phase 4 cosmetics (equippable items)

---

## Current Status

### Completed (Phase 1)
| Component | Status | Location |
|-----------|--------|----------|
| Level calculation logic | ✅ Done | `lib/core/utils/helpers.dart` |
| Evolution thresholds | ✅ Done | `lib/core/constants/app_constants.dart` |
| Level progress providers | ✅ Done | `lib/features/profile/presentation/providers/profile_providers.dart` |
| Level progress bar widget | ✅ Done | `lib/shared/widgets/level_progress_bar.dart` |
| Mascot SVG assets (3 stages) | ✅ Done | `assets/images/mascot/seed_stage*.svg` |
| Mascot route placeholder | ✅ Done | `lib/app/router.dart` |
| Localization strings | ✅ Done | `lib/core/l10n/app_*.arb` |

### Pending (Phase 2)
| Component | Priority | Status |
|-----------|----------|--------|
| Mascot data models | P0 | Not started |
| Mascot selection screen | P0 | Not started |
| Mascot display widget | P0 | Not started |
| Mascot home screen integration | P0 | Not started |
| Evolution animations | P0 | Not started |
| Mascot naming feature | P1 | Not started |
| Idle/reaction animations | P1 | Not started |
| Stage 4 mascot asset | P1 | Not started |

---

## Goals & Deliverables

### Primary Deliverable
> A mascot that evolves as the user levels up, creating emotional connection and visual progress feedback.

### User Stories

1. **As a new user**, I want to choose a starter mascot during onboarding so I feel invested from the start.

2. **As a user**, I want to see my mascot on the home screen so I'm reminded of my progress every time I open the app.

3. **As a user**, I want my mascot to visually change when I reach level milestones so I feel rewarded for my efforts.

4. **As a user**, I want to name my mascot so it feels personal and unique to me.

5. **As a user**, I want my mascot to react when I log an action so I get immediate positive feedback.

---

## Technical Architecture

### Feature Module Structure

```
lib/features/mascot/
├── mascot.dart                          # Barrel file (public API)
├── data/
│   ├── datasources/
│   │   └── mascot_remote_datasource.dart   # Firestore operations
│   ├── models/
│   │   ├── mascot_model.dart               # User's mascot state
│   │   ├── mascot_model.freezed.dart       # Generated
│   │   ├── mascot_model.g.dart             # Generated
│   │   ├── mascot_species_model.dart       # Species definitions
│   │   ├── mascot_species_model.freezed.dart
│   │   └── mascot_species_model.g.dart
│   └── repositories/
│       └── mascot_repository.dart          # Data access layer
├── domain/
│   └── entities/
│       ├── mascot.dart                     # Core mascot entity
│       └── mascot_species.dart             # Species entity
└── presentation/
    ├── providers/
    │   ├── mascot_providers.dart           # Riverpod providers
    │   └── mascot_providers.g.dart         # Generated
    ├── screens/
    │   ├── mascot_selection_screen.dart    # Onboarding selection
    │   └── mascot_screen.dart              # Full mascot view
    └── widgets/
        ├── mascot_display.dart             # Main mascot renderer
        ├── mascot_avatar.dart              # Compact avatar version
        ├── mascot_reaction.dart            # Reaction overlay
        ├── evolution_celebration.dart      # Level-up animation
        └── species_card.dart               # Selection card widget
```

### Provider Architecture

```dart
// Core providers (lib/features/mascot/presentation/providers/mascot_providers.dart)

@riverpod
class MascotNotifier extends _$MascotNotifier {
  // Manages mascot state and mutations
}

@riverpod
Stream<MascotModel?> currentMascot(Ref ref) {
  // Streams user's mascot from Firestore
}

@riverpod
MascotSpeciesModel? currentSpecies(Ref ref) {
  // Resolves species data for current mascot
}

@riverpod
String mascotAssetPath(Ref ref) {
  // Returns correct SVG path based on evolution stage
}

@riverpod
bool shouldShowEvolution(Ref ref) {
  // Detects when user crosses evolution threshold
}
```

### Navigation Flow

```
                    ┌─────────────────┐
                    │   App Launch    │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  Auth Check     │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
     ┌────────▼────────┐     │     ┌────────▼────────┐
     │  Login/Register │     │     │    Home Screen  │
     └────────┬────────┘     │     └─────────────────┘
              │              │
              │     (first time)
              │              │
     ┌────────▼────────┐     │
     │ Email Verify    │     │
     └────────┬────────┘     │
              │              │
     ┌────────▼────────┐     │
     │ Mascot Selection│◄────┘
     │    Screen       │ (if no mascot)
     └────────┬────────┘
              │
     ┌────────▼────────┐
     │   Home Screen   │
     │ (with mascot)   │
     └─────────────────┘
```

---

## Data Models

### MascotModel (User's Mascot Instance)

```dart
@freezed
abstract class MascotModel with _$MascotModel {
  const factory MascotModel({
    required String speciesId,      // Reference to MascotSpeciesModel
    @Default('') String name,       // User-given name
    @Default([]) List<String> equippedItems, // For Phase 4
    @TimestampConverter() DateTime? createdAt,
  }) = _MascotModel;

  factory MascotModel.fromJson(Map<String, dynamic> json) =>
      _$MascotModelFromJson(json);
}
```

### MascotSpeciesModel (Species Definition)

```dart
@freezed
abstract class MascotSpeciesModel with _$MascotSpeciesModel {
  const factory MascotSpeciesModel({
    required String id,
    required String nameEn,
    required String nameJa,
    required String descriptionEn,
    required String descriptionJa,
    required List<EvolutionStage> evolutionStages,
    @Default('free') String availability, // 'free', 'premium', or points cost
  }) = _MascotSpeciesModel;

  factory MascotSpeciesModel.fromJson(Map<String, dynamic> json) =>
      _$MascotSpeciesModelFromJson(json);
}

@freezed
abstract class EvolutionStage with _$EvolutionStage {
  const factory EvolutionStage({
    required int level,           // Level threshold (1, 10, 25, 50)
    required String assetPath,    // Local asset path
    required String nameEn,       // Stage name (e.g., "Seedling")
    required String nameJa,       // Japanese name
  }) = _EvolutionStage;

  factory EvolutionStage.fromJson(Map<String, dynamic> json) =>
      _$EvolutionStageFromJson(json);
}
```

### Firestore Schema Updates

```
users/{userId}/
├── ... (existing fields)
├── mascot: {                    # NEW: Embedded mascot data
│   speciesId: "seed",
│   name: "Sprout",
│   equippedItems: [],
│   createdAt: timestamp
│ }

mascotSpecies/                   # Read-only collection
├── seed/
│   ├── id: "seed"
│   ├── nameEn: "Seed"
│   ├── nameJa: "シード"
│   ├── descriptionEn: "A tiny seed with big dreams..."
│   ├── descriptionJa: "大きな夢を持つ小さな種..."
│   ├── availability: "free"
│   └── evolutionStages: [
│       { level: 1,  assetPath: "assets/images/mascot/seed_stage1.svg", nameEn: "Seed", nameJa: "たね" },
│       { level: 10, assetPath: "assets/images/mascot/seed_stage2.svg", nameEn: "Sprout", nameJa: "めばえ" },
│       { level: 25, assetPath: "assets/images/mascot/seed_stage3.svg", nameEn: "Sapling", nameJa: "なえぎ" },
│       { level: 50, assetPath: "assets/images/mascot/seed_stage4.svg", nameEn: "Tree", nameJa: "たいぼく" }
│     ]
```

### AppUserModel Updates

```dart
@freezed
abstract class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    // ... existing fields
    MascotModel? mascot,           // NEW: Embedded mascot
  }) = _AppUserModel;
}
```

---

## Feature Breakdown

### Feature 2.1: Mascot Data Layer

**Priority:** P0

**Tasks:**
1. Create `MascotModel` with Freezed
2. Create `MascotSpeciesModel` with Freezed
3. Create `EvolutionStage` model
4. Create `MascotRemoteDatasource` for Firestore operations
5. Create `MascotRepository` with methods:
   - `getUserMascot(userId)` → Stream<MascotModel?>
   - `setUserMascot(userId, mascot)` → Future<void>
   - `updateMascotName(userId, name)` → Future<void>
   - `getSpecies(speciesId)` → Future<MascotSpeciesModel?>
   - `getAllSpecies()` → Future<List<MascotSpeciesModel>>
6. Update `AppUserModel` to include mascot field
7. Run `dart run build_runner build`
8. Write unit tests for repository

**Files to Create:**
- `lib/features/mascot/data/models/mascot_model.dart`
- `lib/features/mascot/data/models/mascot_species_model.dart`
- `lib/features/mascot/data/datasources/mascot_remote_datasource.dart`
- `lib/features/mascot/data/repositories/mascot_repository.dart`
- `test/features/mascot/data/repositories/mascot_repository_test.dart`

**Files to Modify:**
- `lib/features/auth/data/models/app_user_model.dart`
- `lib/features/mascot/mascot.dart` (uncomment exports)

---

### Feature 2.2: Mascot Providers

**Priority:** P0

**Tasks:**
1. Create `currentMascotProvider` - streams user's mascot
2. Create `mascotSpeciesProvider` - fetches species definition
3. Create `allSpeciesProvider` - fetches all available species
4. Create `mascotAssetPathProvider` - computes correct asset based on level
5. Create `MascotNotifier` - handles mutations (select, rename)
6. Run code generation
7. Write unit tests for providers

**Files to Create:**
- `lib/features/mascot/presentation/providers/mascot_providers.dart`
- `test/features/mascot/presentation/providers/mascot_providers_test.dart`

**Provider Signatures:**
```dart
@riverpod
Stream<MascotModel?> currentMascot(Ref ref);

@riverpod
Future<MascotSpeciesModel?> mascotSpecies(Ref ref, String speciesId);

@riverpod
Future<List<MascotSpeciesModel>> allSpecies(Ref ref);

@riverpod
String mascotAssetPath(Ref ref);

@riverpod
class MascotNotifier extends _$MascotNotifier {
  Future<void> selectMascot(String speciesId, String name);
  Future<void> renameMascot(String name);
}
```

---

### Feature 2.3: Mascot Selection Screen

**Priority:** P0

**Tasks:**
1. Create `SpeciesCard` widget - shows species preview and description
2. Create `MascotSelectionScreen` with:
   - Species carousel/grid
   - Name input field
   - "Start Journey" button
3. Integrate into auth flow (after email verification)
4. Add route guard to redirect to selection if no mascot
5. Add localization strings
6. Write widget tests

**Files to Create:**
- `lib/features/mascot/presentation/screens/mascot_selection_screen.dart`
- `lib/features/mascot/presentation/widgets/species_card.dart`
- `test/features/mascot/presentation/screens/mascot_selection_screen_test.dart`

**Files to Modify:**
- `lib/app/router.dart` - add selection route and redirect logic
- `lib/core/l10n/app_en.arb` - add selection strings
- `lib/core/l10n/app_es.arb` - add selection strings
- `lib/core/l10n/app_ja.arb` - add selection strings

**Screen Layout:**
```
┌─────────────────────────────────┐
│         Choose Your             │
│           Companion             │
│                                 │
│   ┌─────────────────────────┐   │
│   │                         │   │
│   │    [Mascot Preview]     │   │
│   │       (animated)        │   │
│   │                         │   │
│   └─────────────────────────┘   │
│                                 │
│   "Seed - A tiny seed with..."  │
│                                 │
│   ◀  ● ○ ○  ▶  (page indicator) │
│                                 │
│   ┌─────────────────────────┐   │
│   │  Name: [___________]    │   │
│   └─────────────────────────┘   │
│                                 │
│   ┌─────────────────────────┐   │
│   │     Start Journey       │   │
│   └─────────────────────────┘   │
└─────────────────────────────────┘
```

---

### Feature 2.4: Mascot Display Widget

**Priority:** P0

**Tasks:**
1. Create `MascotDisplay` widget - renders SVG at correct evolution stage
2. Add subtle idle animation (breathing/floating effect)
3. Create `MascotAvatar` - compact version for nav bar/profile
4. Handle loading/error states gracefully
5. Add shadow/glow effects based on evolution stage
6. Write widget tests

**Files to Create:**
- `lib/features/mascot/presentation/widgets/mascot_display.dart`
- `lib/features/mascot/presentation/widgets/mascot_avatar.dart`
- `lib/shared/widgets/animated_float.dart` (reusable animation wrapper)
- `test/features/mascot/presentation/widgets/mascot_display_test.dart`

**Widget API:**
```dart
class MascotDisplay extends ConsumerWidget {
  final double size;
  final bool showGlow;
  final bool animate;

  const MascotDisplay({
    this.size = 200,
    this.showGlow = true,
    this.animate = true,
  });
}

class MascotAvatar extends ConsumerWidget {
  final double size;

  const MascotAvatar({this.size = 48});
}
```

---

### Feature 2.5: Home Screen Integration

**Priority:** P0

**Tasks:**
1. Add `MascotDisplay` to home screen (prominent position)
2. Show mascot name below display
3. Add tap interaction to navigate to full mascot screen
4. Display evolution stage badge
5. Integrate mascot avatar in app bar or nav
6. Update home screen layout for balance
7. Write integration tests

**Files to Modify:**
- Create new home screen or modify existing navigation
- `lib/app/router.dart` - ensure home route exists
- `lib/features/mascot/presentation/screens/mascot_screen.dart` - full mascot view

**Home Screen Layout:**
```
┌─────────────────────────────────┐
│  [≡]     Seed     [👤 avatar]   │
├─────────────────────────────────┤
│                                 │
│        ┌─────────────┐          │
│        │             │          │
│        │  [Mascot]   │  ← tap   │
│        │             │          │
│        └─────────────┘          │
│           "Sprout"              │
│        ⭐ Stage 2               │
│                                 │
│   Points: 1,250    Level: 12    │
│   ████████████░░░░ → Lvl 13     │
│                                 │
│   ┌─────────────────────────┐   │
│   │    + Log Action         │   │
│   └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

---

### Feature 2.6: Evolution System

**Priority:** P0

**Tasks:**
1. Create `evolutionDetectorProvider` - compares previous vs current stage
2. Create `EvolutionCelebration` widget - full-screen celebration overlay
3. Add particle effects/confetti animation
4. Play celebration sound (optional, add later)
5. Store "seen evolutions" to prevent repeat triggers
6. Show evolution preview on mascot screen
7. Write tests for evolution detection

**Files to Create:**
- `lib/features/mascot/presentation/widgets/evolution_celebration.dart`
- `lib/features/mascot/presentation/providers/evolution_provider.dart`
- `test/features/mascot/presentation/providers/evolution_provider_test.dart`

**Evolution Flow:**
```
Action Logged → Points Update → Level Check → Stage Check
                                              ↓
                                         Stage Changed?
                                              ↓ yes
                                    Show Evolution Overlay
                                              ↓
                                    Update "Seen" Flag
                                              ↓
                                      Dismiss → Home
```

---

### Feature 2.7: Mascot Naming/Renaming

**Priority:** P1

**Tasks:**
1. Add rename button to mascot screen
2. Create rename dialog with validation
3. Update Firestore on rename
4. Add character limit (20 chars)
5. Filter inappropriate names (basic blocklist)
6. Write tests

**Files to Modify:**
- `lib/features/mascot/presentation/screens/mascot_screen.dart`

**Rename Dialog:**
```
┌─────────────────────────────────┐
│         Rename Mascot           │
│                                 │
│   ┌─────────────────────────┐   │
│   │  New name: [Sprout    ] │   │
│   └─────────────────────────┘   │
│   0/20 characters               │
│                                 │
│   [Cancel]          [Rename]    │
└─────────────────────────────────┘
```

---

### Feature 2.8: Action Reaction Animations

**Priority:** P1

**Tasks:**
1. Create `MascotReaction` overlay widget
2. Add "happy bounce" animation on action log
3. Show +points floating text
4. Add heart/star particle burst
5. Integrate with action logging flow
6. Write tests

**Files to Create:**
- `lib/features/mascot/presentation/widgets/mascot_reaction.dart`
- `lib/features/mascot/presentation/widgets/floating_points.dart`

**Reaction Flow:**
```
User Logs Action → Optimistic UI Update → Show Reaction Animation
                                                    ↓
                                          Mascot bounces happily
                                          +50 points floats up
                                          Small particle burst
                                                    ↓
                                          Auto-dismiss (1.5s)
```

---

### Feature 2.9: Full Mascot Screen

**Priority:** P1

**Tasks:**
1. Replace placeholder with full mascot screen
2. Show large mascot display with name
3. Display evolution timeline/progress
4. Show next evolution preview (grayed out)
5. Add rename button
6. Add stats summary (total actions, CO2 saved)
7. Prepare layout for Phase 4 cosmetics
8. Write tests

**Files to Create/Modify:**
- `lib/features/mascot/presentation/screens/mascot_screen.dart`

**Mascot Screen Layout:**
```
┌─────────────────────────────────┐
│  ←          Mascot              │
├─────────────────────────────────┤
│                                 │
│        ┌─────────────┐          │
│        │             │          │
│        │  [Mascot]   │          │
│        │   (large)   │          │
│        │             │          │
│        └─────────────┘          │
│                                 │
│    "Sprout"  [✏️ Rename]        │
│                                 │
│ ──────── Evolution ──────────  │
│                                 │
│  ● Seed    ● Sprout  ○ Sapling │
│   Lv 1      Lv 10      Lv 25   │
│                 ▲               │
│            (current)            │
│                                 │
│ ─────────── Stats ────────────  │
│                                 │
│  🌱 142 Actions   🌍 45.2kg CO2 │
│                                 │
└─────────────────────────────────┘
```

---

## Screen Designs

### Color Palette for Evolution Stages

| Stage | Level | Theme Color | Glow Effect |
|-------|-------|-------------|-------------|
| 1 - Seed | 1+ | Brown (#8B6F47) | Subtle earth glow |
| 2 - Sprout | 10+ | Light Green (#8BC34A) | Fresh green aura |
| 3 - Sapling | 25+ | Forest Green (#4CAF50) | Vibrant green glow |
| 4 - Tree | 50+ | Gold (#FFD700) | Golden radiance |

### Animation Timings

| Animation | Duration | Easing |
|-----------|----------|--------|
| Idle float | 3s loop | ease-in-out |
| Happy bounce | 500ms | bounce |
| Points float | 1.5s | ease-out |
| Evolution reveal | 2s | ease-in-out |
| Screen transitions | 300ms | ease |

---

## Implementation Order

### Step 1: Data Foundation

| Step | Task |
|------|------|
| 1.1 | Create mascot data models |
| 1.2 | Create mascot repository & datasource |
| 1.3 | Update AppUserModel, run code gen |
| 1.4 | Create mascot providers |
| 1.5 | Write unit tests for data layer |
| 1.6 | Seed Firestore with species data |
| 1.7 | Create MascotDisplay widget |

**Milestone:** Mascot data flows from Firestore to UI

### Step 2: Selection & Display

| Step | Task |
|------|------|
| 2.1 | Create SpeciesCard widget |
| 2.2 | Create MascotSelectionScreen |
| 2.3 | Integrate selection into auth flow |
| 2.4 | Add home screen mascot display |
| 2.5 | Create MascotAvatar widget |
| 2.6 | Add idle animations |
| 2.7 | Write widget tests |

**Milestone:** New users can select mascot, see it on home screen

### Step 3: Evolution & Polish

| Step | Task |
|------|------|
| 3.1 | Create evolution detection provider |
| 3.2 | Create EvolutionCelebration widget |
| 3.3 | Create MascotReaction widget |
| 3.4 | Build full MascotScreen |
| 3.5 | Add rename functionality |
| 3.6 | Create Stage 4 mascot asset |
| 3.7 | Integration testing & polish |

**Milestone:** Complete mascot MVP with evolution celebrations

---

## Testing Strategy

### Unit Tests

| Component | Test File | Coverage Target |
|-----------|-----------|-----------------|
| MascotRepository | `mascot_repository_test.dart` | 90% |
| MascotProviders | `mascot_providers_test.dart` | 85% |
| EvolutionProvider | `evolution_provider_test.dart` | 95% |
| Level helpers | `helpers_test.dart` | 100% |

### Widget Tests

| Widget | Test File | Key Scenarios |
|--------|-----------|---------------|
| MascotDisplay | `mascot_display_test.dart` | Renders correct stage, loading state |
| SpeciesCard | `species_card_test.dart` | Displays info, handles tap |
| MascotSelectionScreen | `mascot_selection_screen_test.dart` | Selection flow, validation |
| EvolutionCelebration | `evolution_celebration_test.dart` | Animation triggers, dismissal |

### Integration Tests

| Flow | Test File | Scenarios |
|------|-----------|-----------|
| Onboarding | `onboarding_flow_test.dart` | New user selects mascot |
| Evolution | `evolution_flow_test.dart` | Level up triggers celebration |
| Rename | `rename_flow_test.dart` | Valid/invalid name handling |

### Test Commands

```bash
# Run all mascot tests
flutter test test/features/mascot/

# Run with coverage
flutter test --coverage test/features/mascot/

# Run specific test file
flutter test test/features/mascot/data/repositories/mascot_repository_test.dart
```

---

## Acceptance Criteria

### Feature 2.1: Data Layer
- [ ] MascotModel serializes/deserializes correctly
- [ ] MascotSpeciesModel loads from Firestore
- [ ] Repository streams real-time updates
- [ ] All CRUD operations work
- [ ] Unit tests pass with >90% coverage

### Feature 2.2: Providers
- [ ] currentMascotProvider streams user's mascot
- [ ] mascotAssetPathProvider returns correct path for level
- [ ] MascotNotifier.selectMascot creates mascot document
- [ ] MascotNotifier.renameMascot updates name
- [ ] Unit tests pass

### Feature 2.3: Selection Screen
- [ ] Screen shows all available species
- [ ] User can swipe between species
- [ ] Name input validates (1-20 chars, no empty)
- [ ] "Start Journey" creates mascot and navigates to home
- [ ] Screen only appears for users without mascot
- [ ] Widget tests pass

### Feature 2.4: Display Widget
- [ ] MascotDisplay renders correct SVG for evolution stage
- [ ] Idle animation plays smoothly
- [ ] MascotAvatar renders at small size
- [ ] Loading/error states handled
- [ ] Widget tests pass

### Feature 2.5: Home Integration
- [ ] Mascot appears prominently on home screen
- [ ] Name displays below mascot
- [ ] Tap navigates to full mascot screen
- [ ] Layout is balanced and appealing

### Feature 2.6: Evolution System
- [ ] Evolution detected when crossing level thresholds
- [ ] Celebration overlay appears on first evolution
- [ ] Overlay dismissable by tap or timeout
- [ ] Evolution only triggers once per threshold
- [ ] Tests pass

### Feature 2.7: Naming
- [ ] Rename dialog accessible from mascot screen
- [ ] Name validates (1-20 chars)
- [ ] Name updates in Firestore and UI immediately
- [ ] Tests pass

### Feature 2.8: Reactions
- [ ] Happy animation plays on action log
- [ ] Points float up animation
- [ ] Animation auto-dismisses
- [ ] Tests pass

### Feature 2.9: Full Screen
- [ ] Shows large mascot with name
- [ ] Evolution timeline displays progress
- [ ] Next evolution shown (grayed)
- [ ] Stats summary accurate
- [ ] Rename button works
- [ ] Tests pass

---

## Dependencies & Blockers

### External Dependencies
- None (all assets are local SVGs)

### Internal Dependencies
| Feature | Depends On |
|---------|-----------|
| Selection Screen | Data Layer, Providers |
| Display Widget | Providers |
| Home Integration | Display Widget |
| Evolution System | Providers, Display Widget |
| Reactions | Display Widget |
| Full Screen | All above |

### Potential Blockers
1. **Stage 4 asset missing** - Need to create `seed_stage4.svg`
2. **Animation performance** - May need to optimize if SVG animations lag
3. **Firestore rules** - Need to update security rules for mascot field

---

## Firestore Security Rules Update

```javascript
// Add to existing rules
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;

  // Validate mascot updates
  function validMascot(mascot) {
    return mascot.keys().hasAll(['speciesId', 'name'])
        && mascot.speciesId is string
        && mascot.name is string
        && mascot.name.size() >= 1
        && mascot.name.size() <= 20;
  }
}

// Species collection (read-only)
match /mascotSpecies/{speciesId} {
  allow read: if request.auth != null;
  allow write: if false;
}
```

---

## Localization Strings to Add

### English (app_en.arb)
```json
{
  "mascotSelectionTitle": "Choose Your Companion",
  "mascotSelectionSubtitle": "Your mascot will grow with your sustainability journey",
  "mascotNameLabel": "Give your mascot a name",
  "mascotNameHint": "Enter a name...",
  "mascotStartJourney": "Start Journey",
  "mascotRenamTitle": "Rename Mascot",
  "mascotRenameButton": "Rename",
  "mascotEvolutionStage": "Stage {stage}",
  "mascotNextEvolution": "Next: Level {level}",
  "mascotEvolutionCongrats": "Congratulations!",
  "mascotEvolutionMessage": "{name} evolved into {stageName}!",
  "mascotStatsActions": "{count} Actions",
  "mascotStatsCo2": "{amount}kg CO₂ Saved"
}
```

### Spanish (app_es.arb)
```json
{
  "mascotSelectionTitle": "Elige a tu compañero",
  "mascotSelectionSubtitle": "Tu mascota crecerá con tu viaje de sostenibilidad",
  "mascotNameLabel": "Dale un nombre a tu mascota",
  "mascotNameHint": "Ingresa un nombre...",
  "mascotStartJourney": "Comenzar viaje",
  "mascotRenamTitle": "Renombrar mascota",
  "mascotRenameButton": "Renombrar",
  "mascotEvolutionStage": "Etapa {stage}",
  "mascotNextEvolution": "Siguiente: Nivel {level}",
  "mascotEvolutionCongrats": "¡Felicidades!",
  "mascotEvolutionMessage": "¡{name} evolucionó a {stageName}!",
  "mascotStatsActions": "{count} Acciones",
  "mascotStatsCo2": "{amount}kg CO₂ Ahorrado"
}
```

### Japanese (app_ja.arb)
```json
{
  "mascotSelectionTitle": "仲間を選ぼう",
  "mascotSelectionSubtitle": "マスコットはあなたの環境活動と一緒に成長します",
  "mascotNameLabel": "マスコットに名前をつけよう",
  "mascotNameHint": "名前を入力...",
  "mascotStartJourney": "旅を始める",
  "mascotRenameTitle": "名前を変更",
  "mascotRenameButton": "変更",
  "mascotEvolutionStage": "ステージ {stage}",
  "mascotNextEvolution": "次: レベル {level}",
  "mascotEvolutionCongrats": "おめでとう！",
  "mascotEvolutionMessage": "{name}は{stageName}に進化した！",
  "mascotStatsActions": "{count} アクション",
  "mascotStatsCo2": "{amount}kg CO₂削減"
}
```

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| SVG animation performance | Medium | Medium | Test on low-end devices early; consider Lottie if needed |
| Scope creep on animations | High | Medium | Stick to simple animations; defer complex ones to Phase 4 |
| Firestore cost if overfetching | Low | Low | Use proper caching; stream only needed fields |
| Evolution detection bugs | Medium | High | Comprehensive unit tests; store "seen" flag |

---

## Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Selection completion rate | >95% | Analytics: users who complete onboarding |
| Daily active users with mascot | 100% | All users should have mascot |
| Evolution celebration seen | Track per user | Analytics: evolution events |
| Rename usage | 20%+ | Analytics: rename button taps |

---

## Post-Phase 2 Notes

### Technical Debt to Address
- Consider Rive/Lottie for richer animations
- Add skeleton loading states
- Implement proper error boundaries

---

## Art & Animation Asset List

> **Note:** No artist available. Using vector SVGs created manually or programmatically. Animations implemented with `flutter_animate` package for MVP, with option to upgrade to Rive later.

### Static SVG Assets

| Asset | File | Status | Description |
|-------|------|--------|-------------|
| Seed Stage 1 | `seed_stage1.svg` | ✅ Done | Brown seed with tiny sprout, anime eyes |
| Seed Stage 2 | `seed_stage2.svg` | ✅ Done | Seed with finger buds, rootlets |
| Seed Stage 3 | `seed_stage3.svg` | ✅ Done | Sapling with legs, bigger leaves, thumbs up |
| Seed Stage 4 | `seed_stage4.svg` | ❌ Needed | Full tree (design specs below) |

### Stage 4 "Tree" Design Specifications

```
Viewbox: 0 0 220 320 (taller for full tree)
Key Elements:
- Thick brown trunk (evolved from legs)
- Full leafy crown with multiple layers
- Mature anime eyes (confident expression)
- Branch-like arms reaching out
- Optional: Small flowers or fruit
- Golden/warm accents (level 50 achievement feel)
Colors:
- Trunk: #5C4A33 (existing brown)
- Leaves: #4CAF50 (forest green) with #8BC34A highlights
- Golden accents: #FFD700
- Eyes: Same gradient as other stages
```

### Animation Specifications

All animations use `flutter_animate` with these timings:

#### 1. Idle Float Animation
- **Purpose:** Subtle breathing/hovering effect on home screen
- **Type:** Looping transform
- **Implementation:**
  ```dart
  Animate(
    onPlay: (controller) => controller.repeat(reverse: true),
    effects: [
      MoveEffect(
        duration: Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        begin: Offset(0, 0),
        end: Offset(0, -8),
      ),
    ],
  )
  ```
- **Complexity:** Simple

#### 2. Happy Bounce (Action Logged)
- **Purpose:** Positive feedback when user logs an action
- **Type:** One-shot, auto-dismiss
- **Implementation:**
  ```dart
  // Sequence: squish down → bounce up → settle
  .animate()
    .scaleXY(begin: 1.0, end: 0.9, duration: 100.ms)
    .then()
    .scaleXY(begin: 0.9, end: 1.15, duration: 150.ms, curve: Curves.easeOut)
    .then()
    .scaleXY(begin: 1.15, end: 1.0, duration: 200.ms, curve: Curves.bounceOut)
  ```
- **Duration:** ~450ms total
- **Complexity:** Simple

#### 3. Points Float Up
- **Purpose:** Show "+XX points" floating above mascot
- **Type:** One-shot, auto-dismiss
- **Implementation:**
  ```dart
  .animate()
    .moveY(begin: 0, end: -60, duration: 800.ms)
    .fadeOut(delay: 500.ms, duration: 300.ms)
    .scale(begin: Offset(1, 1), end: Offset(1.2, 1.2), duration: 800.ms)
  ```
- **Duration:** 800ms
- **Complexity:** Simple

#### 4. Evolution Celebration
- **Purpose:** Full-screen celebration when mascot evolves
- **Type:** Multi-part overlay with dismiss
- **Elements:**
  - Confetti/particle burst (use `confetti` package or custom)
  - Old mascot → fade/scale out
  - New mascot → scale in with glow
  - "Congratulations!" text animation
  - Stage name reveal
- **Duration:** ~3 seconds total
- **Complexity:** Medium
- **Implementation Notes:**
  ```dart
  // Sequence:
  // 1. Overlay fades in (200ms)
  // 2. Old mascot shrinks + fades (400ms)
  // 3. Particle burst starts
  // 4. New mascot scales in with bounce (600ms)
  // 5. Text fades in (300ms)
  // 6. Auto-dismiss after 2s or on tap
  ```

#### 5. Selection Preview Idle
- **Purpose:** Gentle animation on mascot selection screen
- **Type:** Looping
- **Same as Idle Float but slightly more pronounced
- **Complexity:** Simple

#### 6. Tap Feedback
- **Purpose:** Visual response when tapping mascot
- **Type:** One-shot
- **Implementation:**
  ```dart
  .animate()
    .scaleXY(begin: 1.0, end: 0.95, duration: 50.ms)
    .then()
    .scaleXY(begin: 0.95, end: 1.0, duration: 100.ms)
  ```
- **Duration:** 150ms
- **Complexity:** Simple

### UI Animation Specs

| Animation | Duration | Easing | Notes |
|-----------|----------|--------|-------|
| Screen transitions | 300ms | ease | Go_router default |
| Card appear | 200ms | easeOut | Stagger 50ms |
| Progress bar fill | 600ms | easeInOut | Animated on value change |
| Glow pulse | 2s loop | sine | For evolution stage badge |
| Button press | 100ms | easeOut | Scale to 0.95 |

### Particle Effects

For evolution celebration, using simple custom particles:

```dart
// Spawn 20-30 small circles
// Colors: stage theme color + gold + white
// Movement: Random upward + outward with gravity
// Duration: 1.5s with fade out
// Consider using: simple_animations or custom CustomPainter
```

### Glow Effects by Stage

| Stage | Glow Color | Intensity | Style |
|-------|------------|-----------|-------|
| 1 - Seed | #8B6F47 (brown) | Subtle | Warm earth glow |
| 2 - Sprout | #8BC34A (light green) | Medium | Fresh green aura |
| 3 - Sapling | #4CAF50 (forest green) | Strong | Vibrant pulse |
| 4 - Tree | #FFD700 (gold) | Bright | Golden radiance with shimmer |

### Future Rive Upgrade Path

When ready to upgrade to Rive:
1. Create `.riv` files in Rive editor (rive.app - free)
2. Export state machine with states: `idle`, `happy`, `sad`, `evolving`
3. Replace `flutter_animate` widgets with `RiveAnimation` widget
4. Use `StateMachineController` to trigger animations
5. Assets go in `assets/animations/mascot.riv`

---

## Bottom Navigation Addition

Adding bottom navigation during Phase 2:

```dart
// 4 tabs:
// 1. Home (mascot + SDG carousel)
// 2. Progress (calendar view)
// 3. Log Action (FAB or tab)
// 4. Profile (stats + settings)
```

---

*This plan will be updated as implementation progresses.*
