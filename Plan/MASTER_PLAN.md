# Seed: Sustainability Habit Tracking App
## Architecture & Development Plan

**Version:** 1.3
**Last Updated:** February 2026
**Author:** Miles

### Current Status
✅ Project initialized with Flutter 3.38.7 / Dart 3.10.7
✅ Directory structure implemented
✅ Dependencies configured and resolved
✅ Localization infrastructure set up (EN/ES/JP)
✅ Firebase project configured (seed-3d48d)
✅ Mascot assets added (vector SVGs)
✅ **Phase 1 complete!** (Auth, Actions, Action Library, Progress, Profile)
✅ **Phase 2 complete!** (Mascot selection, display, evolution, animations, naming)
✅ **Phase 3 complete!** (Settings, Notifications, Streak tracking)
⏳ **Phase 4 in progress** (Action library expansion, UI enhancements, Cloud Functions, Analytics)
📊 **713 tests passing** (up from 657)

### App Identifiers
| Platform | Bundle ID | Firebase App ID |
|----------|-----------|-----------------|
| Android | com.seedapp | 1:49522523534:android:f1503259d97a83b4adf8df |
| iOS | com.seedapp | 1:49522523534:ios:74fd1f064405f5ffadf8df |

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Architecture Overview](#architecture-overview)
3. [Jargon](#jargon)
4. [Screen Map & Navigation](#screen-map--navigation)
5. [Tech Stack Recommendations](#tech-stack-recommendations)
6. [Infrastructure & Services](#infrastructure--services)
7. [Data Architecture](#data-architecture)
8. [Security Best Practices](#security-best-practices)
9. [Development Phases](#development-phases)
10. [Key Decisions Checklist](#key-decisions-checklist)
11. [CO₂ Data Sources](#co2-data-sources)
12. [Cost Projections](#cost-projections)

---

## Executive Summary

**Seed** is a gamified sustainability habit-tracking mobile app for iOS and Android. Users log eco-friendly actions, earn points based on real CO₂ impact data, level up a mascot character, and learn about UN Sustainable Development Goals.

### Key Constraints
- **Solo developer**, first mobile app (but experienced in web/backend/cloud)
- **Budget:** $10-50/month
- **Scale:** <100 users in year 1
- **Regions:** Japan (primary), English-speaking markets
- **Monetization:** Subscription model

### Tech Stack (Implemented)
| Layer | Technology | Version |
|-------|------------|---------|
| Frontend | Flutter/Dart | 3.38.7 / 3.10.7 |
| State Management | Riverpod | 3.0.x |
| Navigation | go_router | 17.0.x |
| Backend | Firebase | 4.x |
| Auth | Firebase Auth + Google + Apple | 6.x |
| Database | Cloud Firestore | 6.x |
| Push Notifications | FCM + flutter_local_notifications | 16.x / 19.x |
| Subscriptions | RevenueCat | 9.x |
| Code Generation | Freezed + Riverpod Generator | 3.x |

---

## Architecture Overview

### High-Level System Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         MOBILE APP                              │
│                      (Flutter/Dart)                             │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   UI Layer  │  │   State     │  │  Services   │             │
│  │  (Widgets)  │  │ Management  │  │   Layer     │             │
│  │             │  │  (Riverpod) │  │             │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      FIREBASE BACKEND                           │
├─────────────┬─────────────┬─────────────┬─────────────┬────────┤
│   Auth      │  Firestore  │    FCM      │  Functions  │Storage │
│             │  (Database) │   (Push)    │ (Serverless)│(Assets)│
└─────────────┴─────────────┴─────────────┴─────────────┴────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    EXTERNAL SERVICES                            │
├─────────────────────────────┬───────────────────────────────────┤
│        RevenueCat           │        CO₂ Data API               │
│   (Subscription Management) │      (or static JSON)             │
└─────────────────────────────┴───────────────────────────────────┘
```

### App Architecture Pattern

**Implemented: Clean Architecture with Riverpod**

```
lib/
├── main.dart                    # Entry point
├── app/
│   ├── app.dart                 # MaterialApp configuration
│   ├── router.dart              # Navigation (go_router)
│   └── router.g.dart            # Generated route provider
├── core/
│   ├── constants/
│   │   └── app_constants.dart   # App-wide constants (points, levels, etc.)
│   ├── theme/
│   │   ├── app_theme.dart       # Light/dark ThemeData
│   │   └── app_colors.dart      # Color palette
│   ├── utils/
│   │   └── helpers.dart         # Level calculation, formatting helpers
│   └── l10n/
│       ├── app_en.arb           # English strings
│       ├── app_es.arb           # Spanish strings
│       ├── app_ja.arb           # Japanese strings
│       └── generated/           # Auto-generated localization code
├── features/
│   ├── auth/
│   │   ├── auth.dart            # Barrel file
│   │   ├── data/                # Repositories, data sources
│   │   ├── domain/              # Entities, use cases
│   │   └── presentation/        # Screens, widgets, providers
│   ├── actions/
│   │   ├── actions.dart
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── mascot/
│   │   ├── mascot.dart
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── profile/
│   │   ├── profile.dart
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/
│       ├── settings.dart
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/
    ├── widgets/
    │   └── widgets.dart         # Barrel file for shared widgets
    └── providers/
        └── providers.dart       # Barrel file for global providers
```

**Why this structure:**
- Feature-based organization scales well
- Clear separation of concerns (data/domain/presentation layers)
- Each feature can be developed/tested independently
- Barrel files provide clean public APIs for each module
- Generated files (*.g.dart, *.freezed.dart) excluded from linting

---

## Jargon

Key terms used throughout the codebase and documentation.

### Core Concepts

| Term | Definition |
|------|------------|
| **Action** | A pre-defined eco-friendly activity from the action library (e.g., "Recycled an aluminum can"). Stored in `actionLibrary` collection. |
| **Action Log** | A user's recorded instance of completing an action. Stored per-user in `users/{uid}/actionLog`. Immutable once created. |
| **Action Category** | Grouping for actions: `recycling`, `transport`, `food`, `energy`, `consumption`, `water`, `community`, `advocacy`, `learning`. |
| **Points** | Virtual currency earned by logging actions. Drives leveling and mascot evolution. |
| **Level** | User progression tier calculated from total points. Geometric scaling: base 100 pts, 1.5x per level. |
| **CO2 Savings** | Environmental impact measured in grams of CO2 saved per action. Aggregated per user and per SDG. |
| **Daily Goal** | User-defined target number of actions to log per day. |
| **Daily Summary** | Aggregated snapshot of a single day's activity (action count, points, CO2). Stored at `users/{uid}/dailySummaries/{YYYY-MM-DD}`. |

### Mascot & Gamification

| Term | Definition |
|------|------------|
| **Mascot** | A virtual pet that grows and evolves as the user levels up. Users can own up to 20 mascots. |
| **Active Mascot** | The currently displayed mascot (one at a time), tracked by `activeMascotId` on the user doc. |
| **Mascot Species** | Template defining a type of mascot (e.g., "seed"). Each has 4 evolution stages and SVG assets. Stored in `mascotSpecies` collection. |
| **Evolution Stage** | Visual form of a mascot at a level threshold. 4 stages: Stage 1 (L1), Stage 2 (L10), Stage 3 (L25), Stage 4 (L50). |
| **Evolution Celebration** | Full-screen confetti overlay shown when a mascot advances to the next stage. |
| **Egg** | Reward received when a mascot reaches max evolution (level 50). Requires 30 consecutive days of activity to hatch into a new species. |
| **Cosmetic Item** | Optional decoration equippable on mascots (hats, accessories, backgrounds). Stored in `cosmeticItems` collection. |

### Streaks & Engagement

| Term | Definition |
|------|------------|
| **Streak** | Consecutive days of logging at least one action. Tracked as `currentStreak` and `longestStreak`. |
| **Streak Bonus** | Points multiplier for maintaining a streak: +3.3% per day, capped at 2x at 30+ days. |
| **Streak Milestone** | Weekly achievement for sustaining a streak (7, 14, 21, 28 days). Tracked in `seenStreakMilestones`. |
| **Streak Grace Period** | One-time buffer preventing streak loss when a user misses a day. Premium feature (future). |
| **Smart Reminders** | Notification logic that skips the reminder if the user already logged an action today. |

### SDGs

| Term | Definition |
|------|------------|
| **SDG** | UN Sustainable Development Goal. 17 global goals (numbered 1-17) for peace and prosperity. |
| **SDG Stats** | Per-user aggregated actions and CO2 saved for each SDG. Stored in user doc as `sdgStats` map. |
| **SDG Target** | Specific sub-goal within an SDG (e.g., SDG 12.3: "Halve per capita food waste"). |
| **SDG Resource** | External educational link tied to an SDG. Types: `official`, `action`, `education`. |
| **Learn-Only** | Flag on actions/SDGs with no loggable action (educational only). SDGs 4, 8, 9, 16, 17 are learn-only. |

### Auth & Settings

| Term | Definition |
|------|------------|
| **App User** | A registered Seed user. Model: `AppUserModel`. Holds points, level, streaks, mascot refs, settings. |
| **Email Verification** | Required step for email/password auth users before accessing the app. |
| **Subscription** | Premium tier via RevenueCat. Status: `free` or `premium`. Provider: `apple` or `google`. |
| **FCM Token** | Firebase Cloud Messaging device token for push notifications. Stored on user doc. |
| **Barrel File** | A Dart file that re-exports a feature's public API (e.g., `actions.dart`, `mascot.dart`). |

### Architecture

| Term | Definition |
|------|------------|
| **Feature Module** | Self-contained directory under `lib/features/` with `data/`, `domain/`, and `presentation/` layers. |
| **Clean Architecture** | Three-layer pattern: data (repos, models), domain (entities, services), presentation (screens, widgets, providers). |
| **Riverpod Provider** | Reactive state holder generated via `@riverpod` annotation. Uses `Ref` (not generated `*Ref` types). |
| **Freezed** | Code generation tool producing immutable data classes with `copyWith`, `==`, and JSON serialization. |
| **go_router** | Declarative navigation library. Routes defined in `lib/app/router.dart`. |
| **StatefulShellRoute** | go_router construct that powers the bottom navigation with independent navigation stacks per tab. |
| **MainShell** | The scaffold wrapping all tabbed screens, providing the bottom nav bar and FAB. |

---

## Screen Map & Navigation

### Bottom Navigation Tabs

```
 ┌─────────────────────────────────────────────────────┐
 │                    MainShell                         │
 │  ┌────────┬──────────┬──────────┬─────────────┐     │
 │  │  Home  │ Progress │  Mascot  │   Profile    │     │
 │  │ Tab 0  │  Tab 1   │  Tab 2   │   Tab 3     │     │
 │  └────────┴──────────┴──────────┴─────────────┘     │
 │              [ + ] FAB (Log Action)                  │
 └─────────────────────────────────────────────────────┘
```

### Full Navigation Map

```
UNAUTHENTICATED
===============
/ (Splash)
├── /login (Login)
│   └── /register (Register)
└── /verify-email (Email Verification)

POST-SIGNUP
===========
/mascot-selection (Choose First Mascot)

AUTHENTICATED (Bottom Nav Tabs)
===============================
/home ··························· Tab 0: Home
│                                 SDG carousel, mascot card,
│                                 streak display
└── /home/sdg/:goalNumber ······ SDG Detail
                                  Targets, resources,
                                  infographic, related actions

/progress ······················ Tab 1: Progress
│                                Calendar view, daily summary,
│                                rainbow sun widget
└── /progress/history ·········· Action History
                                  Past logged actions by date

/mascot ························ Tab 2: Mascot
                                 Active mascot display,
                                 evolution timeline, rename,
                                 stats, egg status

/profile ······················· Tab 3: Profile
│                                Points, level, streaks,
│                                CO2 saved, stats cards
└── /profile/settings ·········· Settings Hub
    ├── /notifications ········· Notification Settings
    │                            Reminder schedules, smart
    │                            reminders, enable/disable
    ├── /language ·············· Language Settings
    │                            EN / ES / JA
    ├── /account ··············· Account Settings
    │                            Email, password, delete
    └── /about ················· About
        ├── /privacy ··········· Privacy Policy
        └── /terms ············· Terms of Service

MODAL (outside tab navigation)
==============================
/log-action ···················· Action Log
                                 Browse action library,
                                 search/filter/sort,
                                 log an action
                                 (opened via FAB)

DEEP LINKS (standalone routes)
==============================
/sdg/:goalNumber ··············· SDG Detail (standalone)
/history ······················· Action History (standalone)
/settings ······················ Settings (standalone)
/settings/notifications
/settings/language
/settings/account
/settings/about
/settings/about/privacy
/settings/about/terms
/settings/privacy
/settings/terms
```

### Screen Inventory

| # | Route | Screen | File |
|---|-------|--------|------|
| 1 | `/` | Splash | `lib/app/router.dart` (internal) |
| 2 | `/login` | Login | `lib/features/auth/.../login_screen.dart` |
| 3 | `/register` | Register | `lib/features/auth/.../register_screen.dart` |
| 4 | `/verify-email` | Email Verification | `lib/features/auth/.../email_verification_screen.dart` |
| 5 | `/mascot-selection` | Mascot Selection | `lib/features/mascot/.../mascot_selection_screen.dart` |
| 6 | `/home` | Home | `lib/features/sdg/.../home_screen.dart` |
| 7 | `/home/sdg/:n` | SDG Detail | `lib/features/sdg/.../sdg_detail_screen.dart` |
| 8 | `/progress` | Progress | `lib/features/progress/.../progress_screen.dart` |
| 9 | `/progress/history` | Action History | `lib/features/actions/.../action_history_screen.dart` |
| 10 | `/mascot` | Mascot | `lib/features/mascot/.../mascot_screen.dart` |
| 11 | `/profile` | Profile | `lib/features/profile/.../profile_screen.dart` |
| 12 | `/profile/settings` | Settings | `lib/features/settings/.../settings_screen.dart` |
| 13 | `.../notifications` | Notification Settings | `lib/features/settings/.../notification_settings_screen.dart` |
| 14 | `.../language` | Language Settings | `lib/features/settings/.../language_settings_screen.dart` |
| 15 | `.../account` | Account Settings | `lib/features/settings/.../account_settings_screen.dart` |
| 16 | `.../about` | About | `lib/features/settings/.../about_screen.dart` |
| 17 | `.../privacy` | Privacy Policy | `lib/features/settings/.../privacy_policy_screen.dart` |
| 18 | `.../terms` | Terms of Service | `lib/features/settings/.../terms_of_service_screen.dart` |
| 19 | `/log-action` | Action Log | `lib/features/actions/.../action_log_screen.dart` |

### Navigation Flow Diagram

```
                    ┌─────────┐
                    │  Splash │
                    └────┬────┘
                         │
              ┌──────────┴──────────┐
              │                     │
         [not authed]          [authed]
              │                     │
         ┌────▼────┐          ┌─────▼─────┐
         │  Login  │◄────────►│ Register  │
         └────┬────┘          └─────┬─────┘
              │                     │
              │  [email/password]   │
              │    ┌────────────┐   │
              └───►│  Verify    │◄──┘
                   │  Email     │
                   └─────┬─────┘
                         │
                   [no mascot?]
                   ┌─────▼─────┐
                   │  Mascot   │
                   │ Selection │
                   └─────┬─────┘
                         │
    ┌────────────────────▼────────────────────┐
    │          MAIN APP (Bottom Nav)          │
    │                                         │
    │  ┌──────┐ ┌────────┐ ┌──────┐ ┌──────┐│
    │  │ Home │ │Progress│ │Mascot│ │Profil││
    │  │      │ │        │ │      │ │  e   ││
    │  └──┬───┘ └───┬────┘ └──────┘ └──┬───┘│
    │     │         │                   │    │
    │     │    ┌────▼────┐    ┌────────▼───┐│
    │     │    │ History │    │  Settings  ││
    │     │    └─────────┘    └──┬──┬──┬──┬┘│
    │  ┌──▼──────┐   ┌──────┐┌──▼┐ │  │  │ │
    │  │SDG      │   │Notif.││Lang│ │  │  │ │
    │  │Detail   │   └──────┘└────┘ │  │  │ │
    │  └─────────┘           ┌──────▼┐ │  │ │
    │                        │Account│ │  │ │
    │                        └───────┘ │  │ │
    │                           ┌──────▼┐ │ │
    │                           │ About │ │ │
    │                           └─┬──┬──┘ │ │
    │                      ┌─────▼┐ │     │ │
    │                      │Privcy│ │     │ │
    │                      └──────┘ │     │ │
    │                         ┌─────▼──┐  │ │
    │                         │ Terms  │  │ │
    │                         └────────┘  │ │
    │                                     │ │
    │  ┌─────────────┐                    │ │
    │  │  Log Action  │◄── FAB (+) button │ │
    │  │  (modal)     │                   │ │
    │  └─────────────┘                    │ │
    └─────────────────────────────────────┘
```

---

## Tech Stack Recommendations

### Frontend: Flutter + Dart

**Why Flutter over alternatives:**

| Option | Pros | Cons | Verdict |
|--------|------|------|---------|
| **Flutter** | Single codebase, hot reload, great docs, growing ecosystem | Learning Dart (minor), slightly larger app size | **Recommended** |
| React Native | JS familiarity from React | Bridge performance issues, less polished | Good alternative |
| Native (Kotlin/Swift) | Best performance, native UX | Two codebases, 2x development time | Overkill for MVP |
| Kotlin Multiplatform | Shared business logic | UI still separate, newer/less mature | Future consideration |

**Key Flutter packages (current versions in use):**

```yaml
dependencies:
  # State Management (Riverpod 3.x)
  flutter_riverpod: ^3.0.0
  riverpod_annotation: ^3.0.0

  # Navigation
  go_router: ^17.0.1

  # Firebase
  firebase_core: ^4.3.0
  firebase_auth: ^6.1.3
  cloud_firestore: ^6.1.1
  firebase_messaging: ^16.1.0
  firebase_analytics: ^12.1.0
  firebase_storage: ^13.0.5

  # Authentication
  google_sign_in: ^7.2.0
  sign_in_with_apple: ^7.0.1

  # Subscriptions
  purchases_flutter: ^9.10.6      # RevenueCat SDK

  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

  # UI/UX
  flutter_animate: ^4.5.0
  rive: ^0.14.1
  lottie: ^3.1.2
  cached_network_image: ^3.3.1
  flutter_svg: ^2.0.10

  # Local Storage
  shared_preferences: ^2.2.3      # Key-value storage (Firestore for structured data)

  # Notifications
  flutter_local_notifications: ^19.5.0
  timezone: ^0.10.1

  # Utilities
  freezed_annotation: ^3.1.0      # Immutable data classes (Freezed 3.x)
  json_annotation: ^4.9.0
  equatable: ^2.0.5
  uuid: ^4.4.2
  logger: ^2.4.0
  url_launcher: ^6.3.0
  package_info_plus: ^9.0.0
  connectivity_plus: ^7.0.0

dev_dependencies:
  build_runner: ^2.4.11
  freezed: ^3.0.0
  json_serializable: ^6.8.0
  riverpod_generator: ^3.0.0
  flutter_lints: ^6.0.0
  very_good_analysis: ^10.0.0
  mocktail: ^1.0.4
  fake_cloud_firestore: ^4.0.1
```

**Note:** Hive was removed in favor of using `shared_preferences` for simple key-value storage and Firestore for structured data. This simplifies the dependency tree and avoids version conflicts with Riverpod 3.x.

### Backend: Firebase

**Why Firebase over alternatives:**

| Option | Pros | Cons | Your Use Case |
|--------|------|------|---------------|
| **Firebase** | Excellent Flutter SDK, auth+db+push unified, offline sync built-in, generous free tier | Vendor lock-in, NoSQL learning curve | **Best fit** |
| Supabase | PostgreSQL (familiar), open source, good dashboard | Flutter SDK less mature, push notifications need extra setup | Good alternative |
| Custom (AWS) | Full control, you know AWS/Terraform | Overkill for <100 users, much more work | Future migration path |

**Firebase services you'll use:**

| Service | Purpose | Free Tier Limit |
|---------|---------|-----------------|
| Authentication | User accounts | 10K verifications/month |
| Cloud Firestore | Database | 1GB storage, 50K reads/day |
| Cloud Functions | Server logic | 2M invocations/month |
| Cloud Messaging | Push notifications | Unlimited |
| Cloud Storage | Mascot assets | 5GB storage |
| Analytics | Usage tracking | Unlimited |

For <100 users, you'll stay well within free tier.

### State Management: Riverpod

**Why Riverpod:**
- Compile-time safety (catches errors before runtime)
- No BuildContext needed for accessing state
- Great for dependency injection
- Excellent documentation and Flutter team endorsement
- If you know React hooks, the mental model is similar

```dart
// Example: User points provider (Riverpod 3.x syntax)
@riverpod
Stream<int> userPoints(Ref ref) {  // Note: Use Ref, not generated *Ref types
  final userId = ref.watch(authProvider).userId;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => doc.data()?['points'] ?? 0);
}

// In widget
class PointsDisplay extends ConsumerWidget {
  const PointsDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(userPointsProvider);
    return points.when(
      data: (pts) => Text('$pts points'),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => const Text('Error'),
    );
  }
}
```

### Subscriptions: RevenueCat

**Why RevenueCat:**
- Handles App Store + Play Store subscription complexity
- Unified API for both platforms
- Webhook support for server-side validation
- Free up to $2,500/month revenue
- Dashboard for subscription analytics

You don't need this in Phase 1, but architect for it.

---

## Infrastructure & Services

### Firebase Project Setup

```
seed-app-prod/          # Production project
seed-app-dev/           # Development project (optional but recommended)
```

**Recommended Firebase configuration:**

1. **Authentication providers:**
   - Email/Password (required)
   - Google Sign-In (recommended - reduces friction)
   - Apple Sign-In (required for iOS if you have social login)
   - Anonymous auth (for "try before signup" flow)

2. **Firestore indexes:**
   - Will need composite indexes for leaderboards (future)
   - Firebase creates these automatically when you hit the error

3. **Security rules:** See [Security section](#security-best-practices)

### Push Notifications Setup

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   App        │────▶│    FCM       │────▶│  User Device │
│ (schedules)  │     │  (Firebase)  │     │              │
└──────────────┘     └──────────────┘     └──────────────┘
        │
        ▼
┌──────────────┐
│ Cloud        │ (for server-triggered notifications)
│ Functions    │
└──────────────┘
```

**Two types of reminders:**
1. **Local notifications:** Scheduled on-device (use `flutter_local_notifications`)
2. **Push notifications:** Server-sent (use FCM for re-engagement)

For daily habit reminders, **local notifications** are simpler and don't require server.

### Localization Infrastructure

```
lib/
└── core/
    └── l10n/
        ├── app_en.arb          # English strings
        ├── app_es.arb          # Spanish strings
        ├── app_ja.arb          # Japanese strings
        └── l10n.dart           # Generated code
```

**Example ARB file (app_en.arb):**
```json
{
  "@@locale": "en",
  "appTitle": "Seed",
  "logAction": "Log Action",
  "points": "{count} points",
  "@points": {
    "placeholders": {
      "count": {"type": "int"}
    }
  },
  "recycledItem": "Recycled {item}",
  "@recycledItem": {
    "placeholders": {
      "item": {"type": "String"}
    }
  }
}
```

---

## Data Architecture

### Firestore Data Model

```
users/
├── {userId}/
│   ├── email: string
│   ├── displayName: string
│   ├── createdAt: timestamp
│   ├── points: number
│   ├── level: number
│   ├── currentStreak: number
│   ├── longestStreak: number
│   ├── lastActionDate: timestamp          # For streak calculation (Phase 3)
│   ├── language: "en" | "es" | "ja"
│   ├── notificationTime: string (e.g., "09:00")
│   ├── notificationsEnabled: boolean      # Phase 3 addition
│   ├── subscription/
│   │   ├── status: "free" | "premium"
│   │   ├── expiresAt: timestamp | null
│   │   └── provider: "apple" | "google" | null
│   └── mascot/
│       ├── species: string
│       ├── evolutionStage: number
│       ├── name: string
│       └── equippedItems: string[]

users/{userId}/actionLog/
├── {actionId}/
│   ├── actionType: string (reference to action library)
│   ├── timestamp: timestamp
│   ├── pointsEarned: number
│   ├── co2Saved: number (grams)
│   └── sdgCategory: string

actionLibrary/                    # Read-only, admin-managed
├── {actionId}/
│   ├── name_en: string
│   ├── name_ja: string
│   ├── description_en: string
│   ├── description_ja: string
│   ├── points: number
│   ├── co2Grams: number
│   ├── sdgGoals: string[]        # e.g., ["12", "13"]
│   ├── category: string
│   ├── icon: string
│   └── isActive: boolean

mascotSpecies/                    # Read-only, admin-managed
├── {speciesId}/
│   ├── name_en: string
│   ├── name_ja: string
│   ├── baseImageUrl: string
│   ├── evolutionStages: [
│   │   { level: 1, imageUrl: "...", name_en: "...", name_ja: "..." },
│   │   { level: 10, imageUrl: "...", ... },
│   │   { level: 25, imageUrl: "...", ... }
│   │ ]
│   └── availableAt: "free" | "premium" | number (points to unlock)

cosmeticItems/                    # Read-only, admin-managed
├── {itemId}/
│   ├── name_en: string
│   ├── name_ja: string
│   ├── type: "hat" | "accessory" | "background" | ...
│   ├── imageUrl: string
│   ├── pointsCost: number
│   └── requiredLevel: number
```

### Offline Support Strategy

Firestore provides offline persistence by default. Configure it explicitly:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Enable offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(const SeedApp());
}
```

**Offline behavior:**
- User can log actions offline → queued in local cache
- When online, Firestore auto-syncs
- Points update optimistically in UI
- Action library cached locally after first fetch

---

## Security Best Practices

### Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Subcollection: action log
      match /actionLog/{actionId} {
        allow read: if request.auth != null && request.auth.uid == userId;
        allow create: if request.auth != null
                      && request.auth.uid == userId
                      && request.resource.data.keys().hasAll(['actionType', 'timestamp', 'pointsEarned'])
                      && request.resource.data.pointsEarned is number
                      && request.resource.data.pointsEarned >= 0
                      && request.resource.data.pointsEarned <= 10000; // Prevent point injection
        allow update, delete: if false; // Actions are immutable
      }
    }

    // Action library is read-only for all authenticated users
    match /actionLibrary/{actionId} {
      allow read: if request.auth != null;
      allow write: if false; // Admin only via Firebase Console or Cloud Functions
    }

    // Mascot species are read-only
    match /mascotSpecies/{speciesId} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    // Cosmetic items are read-only
    match /cosmeticItems/{itemId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

### Points Integrity

**Problem:** Client calculates points → user could cheat by modifying the app.

**Solutions (in order of complexity):**

1. **Trust client (Phase 1):** For <100 users (friends/family), acceptable risk. Log everything for audit.

2. **Server validation (Phase 2):** Cloud Function validates point calculations:
   ```javascript
   // Cloud Function triggered on action creation
   exports.validateAction = functions.firestore
     .document('users/{userId}/actionLog/{actionId}')
     .onCreate(async (snap, context) => {
       const action = snap.data();
       const actionDef = await db.collection('actionLibrary').doc(action.actionType).get();

       if (!actionDef.exists || actionDef.data().points !== action.pointsEarned) {
         // Log suspicious activity, optionally delete the action
         console.warn(`Suspicious action from ${context.params.userId}`);
       }
     });
   ```

3. **Server-authoritative (Phase 3):** Client sends action type, server calculates and writes points.

### Authentication Security

- **Enable email enumeration protection** in Firebase Console
- **Require email verification** before full access
- **Implement rate limiting** on Cloud Functions
- **Use App Check** to prevent API abuse (add in Phase 2)

### Secrets Management

```
# DO NOT commit to git:
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart  # If it contains API keys

# Use .gitignore
*.env
*.pem
**/google-services.json
**/GoogleService-Info.plist
```

For RevenueCat and other API keys, use `--dart-define` for builds:
```bash
flutter build apk --dart-define=REVENUECAT_KEY=pk_xxxxx
```

---

## Development Phases

### Phase 1: Foundation ✅ COMPLETE
**Goal:** Working app with core loop

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Project setup | Flutter project, Firebase connection, folder structure | P0 | ✅ Done |
| Basic UI shell | Navigation (4-tab bottom nav), theme, screens | P0 | ✅ Done |
| Localization setup | EN/ES/JP infrastructure with ARB files | P1 | ✅ Done |
| Authentication | Email/password + Google + Apple sign-in | P0 | ✅ Done |
| Action logging | Log action → points → Firestore with confirmation dialog | P0 | ✅ Done |
| Action library | 30+ actions with category filtering and search | P0 | ✅ Done |
| Action history | View past logged actions grouped by date | P1 | ✅ Done |
| Progress tracking | Rainbow Sun widget + Calendar view + Daily target | P1 | ✅ Done |
| SDG integration | Infinite carousel + detailed goal screens | P1 | ✅ Done |
| User profile | Points, level, streaks, CO₂ saved, stats cards | P0 | ✅ Done |

**Deliverable:** Full core loop with sign up, log actions, track progress, view profile. ✅ Complete!

### Phase 2: Mascot MVP ✅ COMPLETE
**Goal:** Engaging mascot system

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Level system (logic) | Points → levels with logarithmic scaling | P0 | ✅ Done |
| Evolution thresholds | 4 stages at levels 1, 10, 25, 50 | P0 | ✅ Done |
| Mascot selection | Choose starter mascot + name on signup | P0 | ✅ Done |
| Mascot display | Render mascot on home screen with quick stats | P0 | ✅ Done |
| Evolution stages | Mascot SVG changes at level milestones | P0 | ✅ Done |
| Basic animations | Idle float, tap feedback, glow pulse, bounce | P1 | ✅ Done |
| Mascot naming | Initial naming + inline rename on mascot screen | P1 | ✅ Done |
| Evolution celebration | Confetti animation on evolution with before/after | P1 | ✅ Done |
| Evolution timeline | Visual progress showing all 4 stages | P1 | ✅ Done |
| Mascot detail screen | Full mascot view with rename, stats, timeline | P1 | ✅ Done |

**Deliverable:** Mascot that evolves as user levels up. ✅ Complete!

### Phase 3: Engagement & Settings ✅ COMPLETE
**Goal:** Habit formation features and user preferences

**Overview:** The core app loop is complete. Phase 3 focuses on features that drive daily engagement: reminders, streak tracking, and user control over settings.

#### 3.1 Settings Feature ✅ COMPLETE

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Settings screen | Main settings hub with navigation to sub-screens | P0 | ✅ Done |
| Notification settings | Enable/disable, multiple reminders, smart logic | P0 | ✅ Done |
| Language settings | Switch between EN/ES/JP with live preview | P1 | ✅ Done |
| Account settings | Email/password change, delete account | P1 | ✅ Done |
| About screen | App version, privacy policy, terms links | P2 | ✅ Done |
| Settings repository | Persist settings to Firestore user document | P0 | ✅ Done |
| Settings providers | Riverpod providers for settings state | P0 | ✅ Done |

**Settings Screen Structure:**
```
/profile/settings (SettingsScreen)
├── /notifications (NotificationSettingsScreen)
├── /language (LanguageSettingsScreen)
├── /account (AccountSettingsScreen)
└── /about (AboutScreen)
```

**Data Model (already in AppUserModel):**
- `language: String` - "en" | "es" | "ja"
- `notificationTime: String` - "09:00" format
- `notificationsEnabled: bool` - (need to add)

#### 3.2 Notification System ✅ COMPLETE

Local and push notification infrastructure fully implemented.

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Notification service | NotificationService singleton with scheduling | P0 | ✅ Done |
| FCM service | FCMService for push notifications | P0 | ✅ Done |
| Permission handling | Request iOS/Android notification permissions | P0 | ✅ Done |
| Schedule daily reminder | Multiple reminders with timezone support | P0 | ✅ Done |
| Notification tap handling | Navigate to action log on tap | P1 | ✅ Done |
| Reschedule on time change | NotificationScheduler auto-reschedules | P0 | ✅ Done |
| Localized notification text | EN/ES/JP notification content | P1 | ✅ Done |
| Cancel notifications | Disable when user turns off setting | P0 | ✅ Done |
| Smart reminders | Skip reminder if action logged today | P1 | ✅ Done |

**Implementation Details:**
```dart
// Notification channel (Android)
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'daily_reminder',
  'Daily Reminder',
  description: 'Daily reminder to log sustainable actions',
  importance: Importance.high,
);

// Schedule at user's preferred time
await flutterLocalNotificationsPlugin.zonedSchedule(
  0,  // Notification ID
  'Time to make a difference!',
  'Log a sustainable action today',
  _nextInstanceOfTime(userTime),
  notificationDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  matchDateTimeComponents: DateTimeComponents.time,  // Repeat daily
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
);
```

**iOS Setup:** ✅ Complete (AppDelegate.swift configured, Info.plist updated)

**Android Setup:** ✅ Complete (AndroidManifest.xml permissions and receivers configured)

#### 3.3 Streak Tracking ✅ COMPLETE

Track consecutive days of action logging with weekly milestone celebrations.

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Streak fields in model | `currentStreak`, `longestStreak`, `lastActionDate` | P0 | ✅ Done |
| Streak display (profile) | Show current + longest streak | P0 | ✅ Done |
| Streak display (home) | Show streak on mascot card | P0 | ✅ Done |
| Milestone tracking fields | `seenStreakMilestones` in settings | P1 | ✅ Done |
| Streak calculation logic | StreakService with timezone handling | P0 | ✅ Done |
| Update streak on action log | Integrated in action_log_repository | P0 | ✅ Done |
| Streak milestone celebrations | Weekly milestones (7, 14, 21, 28+ days) | P1 | ✅ Done |
| Streak broken dialog | Show on app open if streak was lost | P2 | ✅ Done |
| Streak break push notification | Server-triggered reminder | P2 | ⏳ Phase 4 |
| Streak recovery (premium?) | Grace period foundation in data model | P2 | ⏳ Phase 4 |

**Implementation:** See `lib/shared/services/streak_service.dart` for full implementation with 25 unit tests covering all edge cases (timezone handling, multiple actions same day, first action ever).

#### 3.4 Additional Polish ⏳ DEFERRED TO PHASE 4

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Loading states | Consistent shimmer/skeleton loading | P2 | ⏳ Phase 4 |
| Error handling | User-friendly error messages | P1 | ⏳ Phase 4 |
| Empty states | Friendly messages when no data | P2 | ⏳ Phase 4 |
| Haptic feedback | Subtle vibration on key actions | P2 | ⏳ Phase 4 |
| Dark mode refinement | Ensure all screens look good in dark mode | P2 | ⏳ Phase 4 |

#### Phase 3 File Structure

```
lib/features/settings/
├── settings.dart                           # Barrel file
├── data/
│   ├── repositories/
│   │   └── settings_repository.dart        # Firestore settings operations
│   └── models/
│       └── notification_settings_model.dart # Notification preferences
├── domain/
│   └── services/
│       └── notification_service.dart       # flutter_local_notifications wrapper
└── presentation/
    ├── providers/
    │   └── settings_providers.dart         # Settings state management
    ├── screens/
    │   ├── settings_screen.dart            # Main settings hub
    │   ├── notification_settings_screen.dart
    │   ├── language_settings_screen.dart
    │   ├── account_settings_screen.dart
    │   └── about_screen.dart
    └── widgets/
        ├── settings_tile.dart              # Reusable settings row
        └── time_picker_tile.dart           # Notification time picker
```

#### Phase 3 Localization Strings Needed

```json
{
  "settings": "Settings",
  "notifications": "Notifications",
  "notificationSettings": "Notification Settings",
  "enableDailyReminder": "Enable daily reminder",
  "reminderTime": "Reminder time",
  "language": "Language",
  "languageSettings": "Language Settings",
  "account": "Account",
  "accountSettings": "Account Settings",
  "deleteAccount": "Delete Account",
  "deleteAccountConfirm": "Are you sure? This cannot be undone.",
  "about": "About",
  "version": "Version",
  "privacyPolicy": "Privacy Policy",
  "termsOfService": "Terms of Service",
  "streakDays": "{count} day streak",
  "streakMilestone7": "One week streak!",
  "streakMilestone30": "One month streak!",
  "notificationTitle": "Time to make a difference!",
  "notificationBody": "Log a sustainable action today"
}
```

**Deliverable:** Complete settings system with notifications and active streak tracking. ✅ Complete!

---

### Phase 4: Action Library Expansion & Core Features ⏳ IN PROGRESS
**Goal:** Expand action library to ~100 actions covering all 17 SDGs, add cosmetic shop, complete core features

See [PHASE_4_PLAN.md](./PHASE_4_PLAN.md) for detailed implementation plan.
See [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md) for action research methodology.

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Action library expansion | 100 actions across 9 categories, all 17 SDGs | P0 | ✅ Done |
| Action library UI | Search, sort, filter by SDG | P0 | ✅ Done |
| SDG detail enhancement | Impact stats, related actions, learn-only variant | P0 | ✅ Done |
| Cosmetic shop | 5 items (hats, accessories, backgrounds) | P0 | Pending |
| Mascot species unlocking | 3 species, point-based unlocks | P0 | Pending |
| Streak break Cloud Function | Push notification for at-risk streaks | P1 | ✅ Done |
| Firebase Analytics | Event tracking implementation | P0 | ✅ Done |
| Firebase Crashlytics | Crash reporting setup | P0 | Pending |
| Privacy policy & terms | Generate and display legal docs | P0 | Pending |

**Deliverable:** Complete action library covering all SDGs, cosmetic shop, analytics, legal compliance.

### Phase 5: Gamification & Daily Engagement (Future)
**Goal:** Daily engagement hooks -- garden, challenges, collection, facts

See [PHASE_5_PLAN.md](./PHASE_5_PLAN.md) for detailed implementation plan.

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Growing Ecosystem | Personal garden derived from action history | P0 | Planned |
| Garden assets | 15-18 simple SVG elements for garden | P0 | Planned |
| Biome system | 4 unlockable garden themes | P1 | Planned |
| Daily Challenges | 3 rotating daily missions with bonus points | P0 | Planned |
| Challenge templates | ~30 parameterized challenge definitions | P0 | Planned |
| Eco-Dex | Collection album with ~50 discoverable entries | P0 | Planned |
| Daily Eco-Fact | 365 curated sustainability facts | P0 | Planned |

**Deliverable:** Four interlocking engagement systems that give users a reason to open the app every day.

### Phase 6: Mascot Art & Premium Features (Future)
**Goal:** Final mascot art, RevenueCat integration, premium tier

See [PHASE_6_PLAN.md](./PHASE_6_PLAN.md) for detailed implementation plan.

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Final mascot art | Commission/create art for 3 species × 4 stages | P0 | Planned |
| RevenueCat integration | Subscription infrastructure + entitlements | P0 | Planned |
| Premium tier definition | Define free vs premium features | P0 | Planned |
| Paywall UI | Subscription screen with benefits | P0 | Planned |
| Restore purchases | Handle subscription restoration | P0 | Planned |
| Premium cosmetic items | Premium-only shop items | P1 | Planned |
| Streak grace period | Premium feature for streak recovery | P1 | Planned |
| Ad-free experience | Remove ads for premium (if ads added) | P2 | Planned |
| Premium mascot species | Exclusive species for subscribers | P2 | Planned |

**Deliverable:** Polished mascot art and working subscription monetization.

### Phase 7: CO₂ Dashboard & Achievements (Future)
**Goal:** Visualize environmental impact, gamify with achievements

See [PHASE_7_PLAN.md](./PHASE_7_PLAN.md) for detailed implementation plan.

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| CO₂ dashboard | Visualize total/daily/monthly CO₂ saved | P0 | Planned |
| Impact comparisons | "Equivalent to X trees" visualizations | P1 | Planned |
| CO₂ trends | Charts showing progress over time | P1 | Planned |
| Achievement system | Unlockable badges and rewards | P0 | Planned |
| Achievement categories | Action, streak, level, SDG achievements | P1 | Planned |
| Achievement notifications | Celebrate when achievements unlock | P1 | Planned |
| Achievement display | Profile section showing earned badges | P1 | Planned |

**Deliverable:** Comprehensive impact visualization and achievement-based gamification.

### Phase 8+: App Store & Post-Launch (Future)
**Goal:** App store submission and iteration

- App Store prep (screenshots, descriptions, review guidelines)
- Play Store prep (listing, signing, review)
- Beta testing (TestFlight, internal testing)
- Soft launch (limited markets)
- Analytics review and optimization
- User feedback integration
- Social features (if validated)
- Leaderboards (optional)

---

## Key Decisions Checklist

### Decisions Made ✅

| Decision | Choice | Notes |
|----------|--------|-------|
| State management | **Riverpod 3.x** | With code generation via riverpod_generator |
| Navigation | **go_router 17.x** | Declarative routing with type-safe routes |
| Local storage | **shared_preferences + Firestore** | Hive removed due to version conflicts |
| Code generation | **Freezed 3.x** | For immutable data classes |
| Linting | **flutter_lints + very_good_analysis** | Strict analysis enabled |
| Auth providers | **Email + Google + Apple** | Sign in with Apple required for iOS |

### Can Decide Later

| Decision | When to Decide | Notes |
|----------|----------------|-------|
| Subscription price | Before App Store submission | Research competitors |
| Premium features | Phase 4 | See what users value |
| Additional languages | Post-launch | Based on user demographics |
| Social features | Post-launch | Based on user feedback |

### Art Assets Decision

This is your biggest non-code challenge. Options:

1. **Commission artist:** $500-2000+ for full mascot set with evolutions
2. **Use asset packs:** Sites like itch.io have character packs ($10-50)
3. **AI-generated + cleanup:** Midjourney/DALL-E for concepts, clean up yourself
4. **Placeholder first:** Use simple shapes/emojis, replace later
5. **Learn to draw:** Pixel art is approachable for beginners

**Recommendation:** Start with simple placeholders or a small asset pack. Validate the app concept before investing in custom art.

---

## CO₂ Data Sources

### Recommended Data Sources

| Source | Coverage | Format | License |
|--------|----------|--------|---------|
| **UK DEFRA** | Comprehensive emission factors | Excel/CSV | Open Government |
| **EPA (US)** | US-specific factors | Various | Public domain |
| **IPCC** | Global standards | Reports | Academic |
| **Our World in Data** | Aggregated, accessible | CSV/API | CC BY |
| **Carbon Footprint Ltd** | Calculator factors | Web | Free for reference |

### Starting Point: Curated Action List

For MVP, hardcode ~30 actions with researched values:

```dart
// Example action definitions (store in Firestore)
final seedActions = [
  Action(
    id: 'recycle_aluminum_can',
    nameEn: 'Recycled an aluminum can',
    nameJa: 'アルミ缶をリサイクル',
    points: 5,
    co2Grams: 150,  // ~150g CO2 saved vs landfill
    sdgGoals: ['12', '13'],
    category: 'recycling',
  ),
  Action(
    id: 'bike_instead_of_car_5km',
    nameEn: 'Biked instead of driving (5km)',
    nameJa: '車の代わりに自転車（5km）',
    points: 50,
    co2Grams: 1000,  // ~200g/km for average car
    sdgGoals: ['11', '13'],
    category: 'transport',
  ),
  Action(
    id: 'reusable_bag',
    nameEn: 'Used reusable shopping bag',
    nameJa: 'エコバッグを使用',
    points: 2,
    co2Grams: 33,  // Lifecycle vs single-use plastic
    sdgGoals: ['12', '14'],
    category: 'consumption',
  ),
  Action(
    id: 'meatless_meal',
    nameEn: 'Had a meatless meal',
    nameJa: '肉なしの食事',
    points: 20,
    co2Grams: 2500,  // Beef meal vs vegetarian
    sdgGoals: ['2', '12', '13'],
    category: 'food',
  ),
  // ... more actions
];
```

### Point Scaling Philosophy

**Recommendation:** Use logarithmic-ish scaling for user psychology:

| CO₂ Impact | Points | Example |
|------------|--------|---------|
| 1-100g | 1-5 | Reusable bag, recycling |
| 100-500g | 5-20 | Short bike ride, composting |
| 500-2000g | 20-50 | Meatless meal, longer bike commute |
| 2000-10000g | 50-200 | Train instead of car trip |
| 10000g+ | 200-1000 | Train instead of flight |

This keeps small actions rewarding while making big actions feel appropriately impactful.

---

## Cost Projections

### Year 1 (< 100 users)

| Service | Monthly Cost | Notes |
|---------|--------------|-------|
| Firebase | $0 | Free tier covers everything |
| RevenueCat | $0 | Free under $2,500 MTR |
| Apple Developer | $8.25 | $99/year |
| Google Play Developer | $2.08 | $25 one-time |
| Domain (optional) | $1-2 | For landing page |
| **Total** | ~$12/month | |

### Year 2 (scaling to 1,000+ users)

| Service | Monthly Cost | Notes |
|---------|--------------|-------|
| Firebase | $10-30 | Blaze plan, pay-as-you-go |
| RevenueCat | $0-25 | Depends on revenue |
| Apple Developer | $8.25 | |
| Google Play | $0 | Already paid |
| **Total** | ~$20-65/month | |

---

## Next Steps

### Completed ✅

**Phase 1:**
1. ~~**Run `flutterfire configure`**~~ ✅ Done (project: seed-3d48d)
2. ~~**Implement authentication**~~ ✅ Done (Email/Google/Apple)
3. ~~**Build action logging flow**~~ ✅ Done (atomic transactions, points calculation)
4. ~~**Action library**~~ ✅ Done (Firestore integration)
5. ~~**Progress tracking**~~ ✅ Done (calendar view, rainbow sun, daily summaries)
6. ~~**SDG integration**~~ ✅ Done (carousel, goal details)
7. ~~**User profile**~~ ✅ Done (stats cards, level progress, CO₂ saved)

**Phase 2:**
8. ~~**Level system logic**~~ ✅ Done (logarithmic scaling formula)
9. ~~**Mascot selection**~~ ✅ Done (species selection + naming)
10. ~~**Mascot display**~~ ✅ Done (home screen + detail screen)
11. ~~**Evolution stages**~~ ✅ Done (4 stages with SVG assets)
12. ~~**Mascot animations**~~ ✅ Done (idle, tap, glow, bounce, confetti)
13. ~~**Evolution celebration**~~ ✅ Done (full-screen confetti overlay)
14. ~~**Evolution timeline**~~ ✅ Done (visual progress widget)

### Phase 3 Complete ✅

**Settings Feature:**
- ~~Create settings screen structure~~ ✅ Done
- ~~Implement notification settings screen~~ ✅ Done (multiple reminders, smart logic)
- ~~Implement language settings screen~~ ✅ Done (EN/ES/JP)
- ~~Implement account settings screen~~ ✅ Done (email/password change, delete account)
- ~~Add settings repository and providers~~ ✅ Done

**Notification System:**
- ~~Initialize flutter_local_notifications~~ ✅ Done
- ~~Request permissions (iOS/Android)~~ ✅ Done
- ~~Schedule daily reminders~~ ✅ Done (up to 5 reminders)
- ~~Handle notification tap~~ ✅ Done
- ~~FCM push notifications~~ ✅ Done

**Streak Tracking:**
- ~~Implement streak calculation~~ ✅ Done (StreakService)
- ~~Update currentStreak/longestStreak~~ ✅ Done (integrated in action log)
- ~~Handle timezone edge cases~~ ✅ Done
- ~~Streak milestone celebrations~~ ✅ Done (weekly milestones)

**Testing:**
- ~~Unit & widget tests~~ ✅ Done (256 Phase 3 tests, 713 total)

### Current Priority (Phase 4)

See [PHASE_4_PLAN.md](./PHASE_4_PLAN.md) for full details.

**Completed so far:**
- ✅ Action Library UI (search, sort, filter, SDG badges, learn-only badge)
- ✅ Firebase Analytics (AnalyticsService with all events, Riverpod provider)
- ✅ Streak break Cloud Function (scheduled, localized, with 16 tests)
- ✅ About screen with legal link placeholders
- ✅ Community category added (7 categories total)
- ✅ isLearnOnly support for educational actions
- ✅ 34 research-backed actions in seed script

**Remaining work:**
1. **Action Library Expansion (Major Focus):**
   - Research ~66 more actions with CO₂ data
   - Cover remaining 8 SDGs (1, 4, 5, 8, 9, 10, 16, 17)
   - Seed Firestore with expanded action library

2. **SDG Detail Screen Enhancement:**
   - Personal stats per SDG, related actions grid

3. **Cosmetic Shop:**
   - 5 initial items, purchase with points, equip on mascot

4. **Remaining Core Features:**
   - Mascot species unlocking (3 species)
   - Firebase Crashlytics
   - Privacy policy & terms of service

### Development Commands
```bash
# Install dependencies
flutter pub get

# Run code generation (after modifying @riverpod or @freezed classes)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development
dart run build_runner watch --delete-conflicting-outputs

# Analyze code
flutter analyze

# Run tests
flutter test

# Update firestore
npm run firebase -- deploy --only firestore

# Update actions
node scripts/seed_action_library.js 

```

---

## Appendix: Learning Resources

### Flutter
- [Flutter Official Docs](https://docs.flutter.dev/) - Excellent, start here
- [Flutter Codelabs](https://docs.flutter.dev/codelabs) - Hands-on tutorials
- [Riverpod Documentation](https://riverpod.dev/) - State management

### Firebase
- [Firebase Flutter Codelab](https://firebase.google.com/codelabs/firebase-get-to-know-flutter)
- [FlutterFire Docs](https://firebase.flutter.dev/)

### Design
- [Material Design 3](https://m3.material.io/) - Google's design system (Flutter default)
- [Figma](https://figma.com) - Free for designing screens

### Japanese Localization
- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)

---

*This document is a living plan. Update it as you make decisions and learn more.*
