# Seed: Sustainability Habit Tracking App
## Architecture & Development Plan

**Version:** 1.1
**Last Updated:** January 2026
**Author:** Miles

### Current Status
✅ Project initialized with Flutter 3.38.7 / Dart 3.10.7
✅ Directory structure implemented
✅ Dependencies configured and resolved
✅ Localization infrastructure set up (EN/JP)
✅ Firebase project configured (seed-3d48d)
✅ Mascot assets added (vector SVGs)
✅ **Phase 1 complete!** (Auth, Actions, Action Library, Progress, Profile)
⏳ Phase 2 in progress (Level system logic done, Mascot UI pending)

### App Identifiers
| Platform | Bundle ID | Firebase App ID |
|----------|-----------|-----------------|
| Android | com.seedapp | 1:49522523534:android:f1503259d97a83b4adf8df |
| iOS | com.seedapp | 1:49522523534:ios:74fd1f064405f5ffadf8df |

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Architecture Overview](#architecture-overview)
3. [Tech Stack Recommendations](#tech-stack-recommendations)
4. [Infrastructure & Services](#infrastructure--services)
5. [Data Architecture](#data-architecture)
6. [Security Best Practices](#security-best-practices)
7. [Development Phases](#development-phases)
8. [Key Decisions Checklist](#key-decisions-checklist)
9. [CO₂ Data Sources](#co2-data-sources)
10. [Cost Projections](#cost-projections)

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
│   ├── language: "en" | "ja"
│   ├── notificationTime: string (e.g., "09:00")
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

### Phase 1: Foundation (Weeks 1-6)
**Goal:** Working app with core loop

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Project setup | Flutter project, Firebase connection, folder structure | P0 | ✅ Done |
| Basic UI shell | Navigation, theme, placeholder screens | P0 | ✅ Done |
| Localization setup | EN/JP infrastructure (can translate later) | P1 | ✅ Done |
| Authentication | Email/password + Google + Apple sign-in | P0 | ✅ Done |
| Action logging | Log action → points awarded → stored in Firestore | P0 | ✅ Done |
| Action library | Seed database with 20-30 common actions | P0 | ✅ Done |
| Action history | View past logged actions with filtering | P1 | ✅ Done |
| Progress tracking | Calendar view with daily summaries | P1 | ✅ Done |
| SDG integration | Link actions to UN SDGs with info cards | P1 | ✅ Done |
| User profile | Display points, level, basic stats | P0 | ✅ Done |

**Deliverable:** You can sign up, log actions, see points accumulate, view profile with stats. ✅ Core loop complete!

### Phase 2: Mascot MVP (Weeks 7-12)
**Goal:** Engaging mascot system

| Task | Description | Priority | Status |
|------|-------------|----------|--------|
| Level system (logic) | Points → levels with thresholds | P0 | ✅ Done |
| Evolution thresholds | Define stages at levels 1, 10, 25, 50 | P0 | ✅ Done |
| Mascot selection | Choose starter mascot on signup | P0 | ⏳ Next |
| Mascot display | Render mascot on home screen | P0 | Pending |
| Evolution stages | Mascot appearance changes at milestones | P0 | Pending |
| Basic animations | Idle animation, happy reaction on action log | P1 | Pending |
| Mascot naming | User can name their mascot | P1 | Pending |

**Deliverable:** Mascot that evolves as user levels up.

### Phase 3: Engagement (Weeks 13-18)
**Goal:** Habit formation features

| Task | Description | Priority |
|------|-------------|----------|
| Local notifications | Daily reminder at user-set time | P0 |
| Streak tracking | Consecutive day tracking | P0 |
| SDG education | Action categories mapped to SDGs, info cards | P1 |
| Action history | View past logged actions | P1 |
| Settings screen | Notification time, language, account | P1 |

**Deliverable:** App that helps form habits with reminders and streaks.

### Phase 4: Polish & Cosmetics (Weeks 19-24)
**Goal:** Premium features and monetization prep

| Task | Description | Priority |
|------|-------------|----------|
| Cosmetic shop | Browse items, purchase with points | P1 |
| Item equipping | Visual customization on mascot | P1 |
| Multiple mascot species | Unlock additional mascots | P2 |
| RevenueCat integration | Subscription infrastructure | P1 |
| Premium tier | Define free vs premium features | P1 |
| App Store prep | Screenshots, descriptions, review | P0 |

**Deliverable:** Shippable MVP with monetization.

### Phase 5: Post-Launch (Ongoing)
**Goal:** Iterate based on feedback

- Analytics review
- User feedback integration
- Social features (if validated)
- CO₂ dashboard
- Achievement system

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
1. ~~**Run `flutterfire configure`**~~ ✅ Done (project: seed-3d48d)
2. ~~**Implement authentication**~~ ✅ Done (Email/Google/Apple)
3. ~~**Build action logging flow**~~ ✅ Done (atomic transactions, points calculation)
4. ~~**Action library**~~ ✅ Done (Firestore integration)
5. ~~**Progress tracking**~~ ✅ Done (calendar view, daily summaries)
6. ~~**SDG integration**~~ ✅ Done (carousel, goal details)
7. ~~**Level system logic**~~ ✅ Done (logarithmic scaling formula)

### Current Priority
1. **User profile screen:**
   - Display points, level, and stats
   - Show current streak
2. **Mascot selection flow:**
   - Choose starter mascot on signup
   - Store mascot in user document
3. **Mascot display:**
   - Render mascot on home screen
   - Show evolution stage based on level

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
