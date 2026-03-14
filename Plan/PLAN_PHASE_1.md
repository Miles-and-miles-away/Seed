# Phase 1: Foundation - Detailed Implementation Plan

**Version:** 1.0
**Created:** January 2026
**Status:** ✅ Complete

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Technical Architecture](#technical-architecture)
4. [Feature Breakdown](#feature-breakdown)
5. [Data Models](#data-models)
6. [Implementation Order](#implementation-order)
7. [Testing Strategy](#testing-strategy)
8. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

Phase 1 establishes the core infrastructure and primary user loop for Seed. Users can authenticate, log eco-friendly actions, earn points, track progress, and view their profile with stats.

### Key Objectives
- Set up Flutter project with Clean Architecture
- Configure Firebase backend (Auth, Firestore, FCM)
- Implement authentication (Email, Google, Apple)
- Build action logging with points system
- Create progress tracking with calendar view
- Integrate UN SDG education components
- Build user profile with stats display

---

## Goals & Deliverables

### Primary Deliverable
> A working app where users can sign up, log sustainability actions, earn points, and track their progress over time.

### User Stories

1. **As a new user**, I want to create an account so I can start tracking my sustainability habits.

2. **As a user**, I want to log eco-friendly actions so I can earn points and see my impact.

3. **As a user**, I want to see my action history so I can review what I've accomplished.

4. **As a user**, I want to view a calendar of my progress so I can see my consistency over time.

5. **As a user**, I want to learn about UN SDGs so I understand how my actions contribute to global goals.

6. **As a user**, I want to see my profile stats so I can track my total points, level, and streaks.

---

## Technical Architecture

### Project Structure

```
lib/
├── main.dart                     # Entry point, Firebase init
├── app/
│   ├── app.dart                  # MaterialApp configuration
│   └── router.dart               # go_router navigation setup
├── core/
│   ├── constants/
│   │   └── app_constants.dart    # Points, levels, Firebase collections
│   ├── theme/
│   │   ├── app_theme.dart        # Light/dark ThemeData
│   │   └── app_colors.dart       # Color palette
│   ├── utils/
│   │   └── helpers.dart          # Level calculation, formatting
│   └── l10n/
│       ├── app_en.arb            # English strings
│       ├── app_es.arb            # Spanish strings
│       ├── app_ja.arb            # Japanese strings
│       └── generated/            # Auto-generated localization
├── features/
│   ├── auth/
│   │   ├── auth.dart             # Barrel file
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── app_user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_providers.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── email_verification_screen.dart
│   │       └── widgets/
│   ├── actions/
│   │   ├── actions.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── action_library_remote_datasource.dart
│   │   │   │   └── action_log_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── action_model.dart
│   │   │   │   └── action_log_model.dart
│   │   │   └── repositories/
│   │   │       ├── action_library_repository.dart
│   │   │       └── action_log_repository.dart
│   │   ├── domain/
│   │   │   └── enums/
│   │   │       └── action_category.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── actions_providers.dart
│   │       ├── screens/
│   │       │   ├── action_log_screen.dart
│   │       │   └── action_history_screen.dart
│   │       └── widgets/
│   │           ├── action_card.dart
│   │           ├── action_category_tabs.dart
│   │           ├── action_log_confirmation_dialog.dart
│   │           ├── action_log_item.dart
│   │           └── points_animation_overlay.dart
│   ├── progress/
│   │   ├── progress.dart
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── daily_summary_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── daily_summary_model.dart
│   │   │   └── repositories/
│   │   │       └── progress_repository.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── calendar_day_data.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── progress_providers.dart
│   │       ├── screens/
│   │       │   └── progress_screen.dart
│   │       └── widgets/
│   │           ├── rainbow_sun_painter.dart
│   │           ├── rainbow_sun_widget.dart
│   │           ├── progress_calendar.dart
│   │           ├── calendar_day_cell.dart
│   │           └── daily_target_picker.dart
│   ├── profile/
│   │   ├── profile.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── profile_providers.dart
│   │       ├── screens/
│   │       │   └── profile_screen.dart
│   │       └── widgets/
│   │           └── stats_card.dart
│   └── sdg/
│       ├── sdg.dart
│       └── presentation/
│           ├── screens/
│           │   └── sdg_detail_screen.dart
│           └── widgets/
│               ├── sdg_carousel.dart
│               └── sdg_card.dart
└── shared/
    ├── widgets/
    │   ├── level_progress_bar.dart
    │   └── loading_overlay.dart
    └── providers/
        └── firebase_providers.dart
```

### Tech Stack Implementation

| Layer | Technology | Version |
|-------|------------|---------|
| Frontend | Flutter/Dart | 3.38.7 / 3.10.7 |
| State Management | Riverpod | 3.0.x |
| Navigation | go_router | 17.0.x |
| Backend | Firebase | 4.x |
| Auth | Firebase Auth | 6.x |
| Database | Cloud Firestore | 6.x |
| Code Generation | Freezed | 3.x |

---

## Feature Breakdown

### Feature 1.1: Project Setup

**Priority:** P0

**Tasks:**
1. Initialize Flutter project with proper package name
2. Configure `pubspec.yaml` with all dependencies
3. Set up folder structure following Clean Architecture
4. Configure `analysis_options.yaml` with strict linting
5. Set up `.gitignore` for generated files
6. Create barrel files for each feature module

**Files Created:**
- `pubspec.yaml`
- `analysis_options.yaml`
- `lib/main.dart`
- All directory structure and barrel files

---

### Feature 1.2: Firebase Configuration

**Priority:** P0

**Tasks:**
1. Create Firebase project (seed-3d48d)
2. Run `flutterfire configure` for iOS and Android
3. Configure Firebase Auth providers (Email, Google, Apple)
4. Set up Firestore database with security rules
5. Configure FCM for push notifications
6. Add `firebase_options.dart` to project

**Files Created:**
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `firestore.rules`

---

### Feature 1.3: Theme & Localization

**Priority:** P1

**Tasks:**
1. Define color palette in `app_colors.dart`
2. Create light and dark themes in `app_theme.dart`
3. Set up localization infrastructure with `l10n.yaml`
4. Create English ARB file with all strings
5. Create Spanish ARB file with translations
6. Create Japanese ARB file with translations
7. Run `flutter gen-l10n` to generate code

**Files Created:**
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/l10n/app_en.arb`
- `lib/core/l10n/app_es.arb`
- `lib/core/l10n/app_ja.arb`
- `l10n.yaml`

---

### Feature 1.4: Authentication

**Priority:** P0

**Tasks:**
1. Create `AppUserModel` with Freezed
2. Create `AuthRemoteDatasource` for Firebase Auth operations
3. Create `AuthRepository` with sign-in/sign-out methods
4. Create Riverpod providers for auth state
5. Build login screen with email/password and social buttons
6. Build registration screen with validation
7. Build email verification screen
8. Configure go_router with auth redirect logic

**Files Created:**
- `lib/features/auth/data/models/app_user_model.dart`
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/features/auth/data/repositories/auth_repository.dart`
- `lib/features/auth/presentation/providers/auth_providers.dart`
- `lib/features/auth/presentation/screens/login_screen.dart`
- `lib/features/auth/presentation/screens/register_screen.dart`
- `lib/features/auth/presentation/screens/email_verification_screen.dart`

**AppUserModel Fields:**
```dart
@freezed
abstract class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(0) int points,
    @Default(1) int level,
    @Default(1) int currentStreak,
    @Default(1) int longestStreak,
    @Default('en') String language,
    int? dailyGoalTarget,
    @TimestampConverter() DateTime? lastActionDate,
    @TimestampConverter() DateTime? createdAt,
  }) = _AppUserModel;
}
```

---

### Feature 1.5: Action Library

**Priority:** P0

**Tasks:**
1. Define `ActionCategory` enum with 6 categories
2. Create `ActionModel` with Freezed
3. Create `ActionLibraryRemoteDatasource` for Firestore reads
4. Create `ActionLibraryRepository`
5. Create providers for action library stream
6. Seed Firestore with 20-30 initial actions

**Action Categories:**
- Recycling
- Transport
- Food
- Energy
- Consumption
- Water

**ActionModel Fields:**
```dart
@freezed
abstract class ActionModel with _$ActionModel {
  const factory ActionModel({
    required String id,
    required String nameEn,
    required String nameJa,
    @Default('') String descriptionEn,
    @Default('') String descriptionJa,
    required String category,
    required int points,
    @Default(0) int co2Grams,
    @Default('eco') String iconName,
    @Default([]) List<String> relatedSdgs,
    @Default(true) bool isActive,
    @Default(0) int sortOrder,
  }) = _ActionModel;
}
```

---

### Feature 1.6: Action Logging

**Priority:** P0

**Tasks:**
1. Create `ActionLogModel` with Freezed
2. Create `ActionLogRemoteDatasource` for Firestore writes
3. Create `ActionLogRepository` with transaction logic
4. Implement points and streak calculation in transaction
5. Create `ActionLogNotifier` provider
6. Build `ActionLogScreen` with category tabs
7. Build `ActionCard` widget
8. Build `ActionLogConfirmationDialog`
9. Build `PointsAnimationOverlay` for feedback

**Transaction Logic:**
```dart
// In single Firestore transaction:
// 1. Create action log document
// 2. Update user points
// 3. Calculate and update level
// 4. Update streak (if new day)
// 5. Update daily summary
```

**Files Created:**
- `lib/features/actions/data/models/action_log_model.dart`
- `lib/features/actions/data/datasources/action_log_remote_datasource.dart`
- `lib/features/actions/data/repositories/action_log_repository.dart`
- `lib/features/actions/presentation/screens/action_log_screen.dart`
- `lib/features/actions/presentation/widgets/action_card.dart`
- `lib/features/actions/presentation/widgets/action_category_tabs.dart`
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart`
- `lib/features/actions/presentation/widgets/points_animation_overlay.dart`

---

### Feature 1.7: Action History

**Priority:** P1

**Tasks:**
1. Create `ActionLogItem` widget
2. Build `ActionHistoryScreen` with grouped list
3. Add date grouping logic
4. Add filtering by category
5. Connect to `userActionLogs` provider

**Files Created:**
- `lib/features/actions/presentation/screens/action_history_screen.dart`
- `lib/features/actions/presentation/widgets/action_log_item.dart`

---

### Feature 1.8: Progress Tracking

**Priority:** P1

**Tasks:**
1. Create `DailySummaryModel` with Freezed
2. Create `DailySummaryRemoteDatasource`
3. Create `ProgressRepository`
4. Build Rainbow Sun visualization with CustomPainter
5. Build calendar widget with month navigation
6. Build daily target picker for first-time users
7. Build `ProgressScreen` combining all elements
8. Integrate daily summary updates with action logging

**Rainbow Sun Visualization:**
- Ball grows with completed goals (max 50% screen width)
- 17 rays extend to screen edges for completed SDG categories
- Each ray uses official SDG color
- Animated transitions

**Files Created:**
- `lib/features/progress/data/models/daily_summary_model.dart`
- `lib/features/progress/data/datasources/daily_summary_remote_datasource.dart`
- `lib/features/progress/data/repositories/progress_repository.dart`
- `lib/features/progress/presentation/screens/progress_screen.dart`
- `lib/features/progress/presentation/widgets/rainbow_sun_painter.dart`
- `lib/features/progress/presentation/widgets/rainbow_sun_widget.dart`
- `lib/features/progress/presentation/widgets/progress_calendar.dart`
- `lib/features/progress/presentation/widgets/calendar_day_cell.dart`
- `lib/features/progress/presentation/widgets/daily_target_picker.dart`

---

### Feature 1.9: SDG Integration

**Priority:** P1

**Tasks:**
1. Create SDG data constants (17 goals with colors, icons, descriptions)
2. Build `SDGCarousel` widget for home screen
3. Build `SDGCard` widget
4. Build `SDGDetailScreen` with goal information
5. Link actions to related SDGs
6. Display SDG impact in action history

**SDG Data:**
```dart
class SDGData {
  static const List<SDG> goals = [
    SDG(1, 'No Poverty', Color(0xFFE5243B), ...),
    SDG(2, 'Zero Hunger', Color(0xFFDDA63A), ...),
    // ... all 17 goals
  ];
}
```

**Files Created:**
- `lib/features/sdg/presentation/widgets/sdg_carousel.dart`
- `lib/features/sdg/presentation/widgets/sdg_card.dart`
- `lib/features/sdg/presentation/screens/sdg_detail_screen.dart`
- `lib/core/constants/sdg_constants.dart`

---

### Feature 1.10: User Profile

**Priority:** P0

**Tasks:**
1. Create profile providers for computed stats
2. Build `StatsCard` widget
3. Build `ProfileScreen` with stats display
4. Show total points, current level, level progress
5. Show current streak and longest streak
6. Show total CO₂ saved
7. Show total actions logged

**Profile Stats:**
- Total points
- Current level with progress bar
- Points to next level
- Current streak
- Longest streak
- Total actions logged
- Total CO₂ saved (kg)

**Files Created:**
- `lib/features/profile/presentation/providers/profile_providers.dart`
- `lib/features/profile/presentation/screens/profile_screen.dart`
- `lib/features/profile/presentation/widgets/stats_card.dart`
- `lib/shared/widgets/level_progress_bar.dart`

---

## Data Models

### Firestore Schema

```
users/
├── {userId}/
│   ├── uid: string
│   ├── email: string
│   ├── displayName: string?
│   ├── points: number
│   ├── level: number
│   ├── currentStreak: number
│   ├── longestStreak: number
│   ├── language: string
│   ├── dailyGoalTarget: number?
│   ├── lastActionDate: timestamp?
│   ├── createdAt: timestamp
│   │
│   ├── actionLog/{actionId}/
│   │   ├── id: string
│   │   ├── actionId: string
│   │   ├── actionName: string
│   │   ├── category: string
│   │   ├── points: number
│   │   ├── co2Grams: number
│   │   ├── relatedSdgs: string[]
│   │   ├── note: string?
│   │   └── loggedAt: timestamp
│   │
│   └── dailySummaries/{YYYY-MM-DD}/
│       ├── date: string
│       ├── goalCount: number
│       ├── completedSdgs: number[]
│       ├── totalPoints: number
│       ├── totalCo2Grams: number
│       └── updatedAt: timestamp

actionLibrary/
├── {actionId}/
│   ├── id: string
│   ├── nameEn: string
│   ├── nameJa: string
│   ├── descriptionEn: string
│   ├── descriptionJa: string
│   ├── category: string
│   ├── points: number
│   ├── co2Grams: number
│   ├── iconName: string
│   ├── relatedSdgs: string[]
│   ├── isActive: boolean
│   └── sortOrder: number
```

### Level System

```dart
// Level calculation (logarithmic scaling)
int calculateLevel(int points) {
  if (points <= 0) return 1;
  const basePoints = 100;
  const scalingFactor = 1.5;
  return (log(points / basePoints * (scalingFactor - 1) + 1) / log(scalingFactor)).floor() + 1;
}

// Points required for level
int pointsForLevel(int level) {
  const basePoints = 100;
  const scalingFactor = 1.5;
  return (basePoints * (pow(scalingFactor, level - 1) - 1) / (scalingFactor - 1)).round();
}
```

---

## Implementation Order

### Step 1: Project Foundation

| Step | Task |
|------|------|
| 1.1 | Initialize Flutter project |
| 1.2 | Configure pubspec.yaml dependencies |
| 1.3 | Set up folder structure |
| 1.4 | Configure analysis_options.yaml |
| 1.5 | Create barrel files |

**Milestone:** Project compiles with `flutter analyze` passing

### Step 2: Firebase & Theme

| Step | Task |
|------|------|
| 2.1 | Create Firebase project |
| 2.2 | Run flutterfire configure |
| 2.3 | Set up Firebase initialization in main.dart |
| 2.4 | Create color palette and themes |
| 2.5 | Set up localization infrastructure |
| 2.6 | Add initial localization strings |

**Milestone:** App launches with Firebase connected, themed UI

### Step 3: Authentication

| Step | Task |
|------|------|
| 3.1 | Create AppUserModel with Freezed |
| 3.2 | Create auth datasource and repository |
| 3.3 | Create auth providers |
| 3.4 | Build login screen |
| 3.5 | Build registration screen |
| 3.6 | Build email verification screen |
| 3.7 | Configure router with auth guards |
| 3.8 | Write auth tests |

**Milestone:** Users can sign up, log in, and sign out

### Step 4: Action System

| Step | Task |
|------|------|
| 4.1 | Create ActionCategory enum |
| 4.2 | Create ActionModel with Freezed |
| 4.3 | Create ActionLogModel with Freezed |
| 4.4 | Create action datasources |
| 4.5 | Create action repositories |
| 4.6 | Create action providers |
| 4.7 | Seed Firestore with actions |
| 4.8 | Build ActionCard widget |
| 4.9 | Build ActionCategoryTabs widget |
| 4.10 | Build ActionLogConfirmationDialog |
| 4.11 | Build PointsAnimationOverlay |
| 4.12 | Build ActionLogScreen |
| 4.13 | Build ActionLogItem widget |
| 4.14 | Build ActionHistoryScreen |
| 4.15 | Write action tests |

**Milestone:** Users can browse and log actions, view history

### Step 5: Progress & SDG

| Step | Task |
|------|------|
| 5.1 | Create DailySummaryModel |
| 5.2 | Create progress datasource and repository |
| 5.3 | Create progress providers |
| 5.4 | Build RainbowSunPainter |
| 5.5 | Build RainbowSunWidget with animations |
| 5.6 | Build CalendarDayCell widget |
| 5.7 | Build ProgressCalendar widget |
| 5.8 | Build DailyTargetPicker |
| 5.9 | Build ProgressScreen |
| 5.10 | Create SDG constants |
| 5.11 | Build SDGCard widget |
| 5.12 | Build SDGCarousel widget |
| 5.13 | Build SDGDetailScreen |
| 5.14 | Write progress tests |

**Milestone:** Progress tracking and SDG education complete

### Step 6: Profile & Polish

| Step | Task |
|------|------|
| 6.1 | Create profile providers |
| 6.2 | Build StatsCard widget |
| 6.3 | Build LevelProgressBar widget |
| 6.4 | Build ProfileScreen |
| 6.5 | Add all remaining localization strings |
| 6.6 | Final integration testing |
| 6.7 | Bug fixes and polish |

**Milestone:** Phase 1 complete - core loop functional

---

## Testing Strategy

### Unit Tests

| Component | Test File | Coverage Target |
|-----------|-----------|-----------------|
| AuthRepository | `auth_repository_test.dart` | 90% |
| ActionLogRepository | `action_log_repository_test.dart` | 90% |
| ProgressRepository | `progress_repository_test.dart` | 85% |
| Level helpers | `helpers_test.dart` | 100% |

### Widget Tests

| Widget | Test File | Key Scenarios |
|--------|-----------|---------------|
| ActionCard | `action_card_test.dart` | Displays info, handles tap |
| ActionLogScreen | `action_log_screen_test.dart` | Category filtering, logging |
| ProgressCalendar | `progress_calendar_test.dart` | Navigation, day display |
| StatsCard | `stats_card_test.dart` | Renders stats correctly |

### Integration Tests

| Flow | Test File | Scenarios |
|------|-----------|-----------|
| Auth | `auth_flow_test.dart` | Sign up, verify email, log in |
| Action logging | `action_log_flow_test.dart` | Select action, confirm, see points |

### Test Commands

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/data/repositories/auth_repository_test.dart
```

---

## Acceptance Criteria

### Feature 1.1-1.3: Project Setup
- [x] Flutter project initializes without errors
- [x] All dependencies resolve
- [x] `flutter analyze` passes with no errors
- [x] Localization generates correctly

### Feature 1.4: Authentication
- [x] Users can register with email/password
- [x] Users can sign in with Google
- [x] Users can sign in with Apple (iOS)
- [x] Email verification required before access
- [x] Auth state persists across app restarts
- [x] Sign out clears auth state

### Feature 1.5-1.6: Action Logging
- [x] Action library loads from Firestore
- [x] Actions display in categorized grid
- [x] Category tabs filter actions correctly
- [x] Confirmation dialog shows action details
- [x] Points animation plays on successful log
- [x] User points update in Firestore
- [x] Streak updates correctly

### Feature 1.7: Action History
- [x] History shows all logged actions
- [x] Actions grouped by date
- [x] Each entry shows name, time, points
- [x] Category filtering works

### Feature 1.8: Progress Tracking
- [x] Rainbow sun displays correctly
- [x] Sun grows with completed goals
- [x] Rays appear for completed SDG categories
- [x] Calendar shows monthly view
- [x] Day cells sized by completion
- [x] Month navigation works
- [x] Daily target picker saves preference

### Feature 1.9: SDG Integration
- [x] SDG carousel displays on home
- [x] SDG cards show goal info
- [x] Detail screen shows full description
- [x] Actions linked to relevant SDGs

### Feature 1.10: User Profile
- [x] Profile shows total points
- [x] Level and progress bar display
- [x] Streaks display correctly
- [x] Total CO₂ saved calculated
- [x] Total actions count accurate

---

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /actionLog/{actionId} {
        allow read: if request.auth != null && request.auth.uid == userId;
        allow create: if request.auth != null
                      && request.auth.uid == userId
                      && request.resource.data.keys().hasAll(['actionId', 'loggedAt', 'points'])
                      && request.resource.data.points >= 0
                      && request.resource.data.points <= 10000;
        allow update, delete: if false;
      }

      match /dailySummaries/{date} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }

    // Action library is read-only
    match /actionLibrary/{actionId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

---

## Dependencies

### External Dependencies
- Firebase project configured
- Apple Developer account for Sign in with Apple
- Google Cloud project for Google Sign-In

### Internal Dependencies
| Feature | Depends On |
|---------|-----------|
| Action Logging | Authentication, Action Library |
| Action History | Action Logging |
| Progress Tracking | Action Logging |
| SDG Integration | Action Library |
| Profile | Authentication, Action Logging |

---

## Post-Phase 1 Notes

### Completed Successfully
- Core loop functional: sign up → log actions → earn points → view progress
- Clean Architecture established
- Riverpod 3.x patterns implemented
- Localization infrastructure ready for expansion
- Foundation laid for Phase 2 mascot system

### Carried Forward to Phase 2
- Level system logic (completed early)
- Evolution thresholds defined
- Mascot SVG assets created

### Technical Debt Identified
- Consider adding skeleton loading states
- May need to optimize Firestore queries at scale
- Consider adding App Check for security

---

*Phase 1 completed January 2026. See PHASE_2_PLAN.md for next phase details.*
