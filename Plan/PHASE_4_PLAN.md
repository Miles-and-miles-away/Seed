# Phase 4: Action Library Expansion & Core Features

**Version:** 1.0
**Created:** January 2026
**Status:** Planning

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Feature Breakdown](#feature-breakdown)
4. [Action Library Expansion](#action-library-expansion)
5. [SDG Detail Screen Enhancement](#sdg-detail-screen-enhancement)
6. [Cosmetic Shop](#cosmetic-shop)
7. [Additional Mascot Species](#additional-mascot-species)
8. [Streak Break Cloud Function](#streak-break-cloud-function)
9. [Firebase Services](#firebase-services)
10. [Legal Compliance](#legal-compliance)
11. [Point Economy](#point-economy)
12. [Implementation Order](#implementation-order)
13. [Testing Strategy](#testing-strategy)
14. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

Phase 4 is a substantial feature phase focused on two major areas:

1. **Action Library Expansion** - Grow from 29 to ~100 actions covering all 17 UN SDGs with proper research and CO₂ data
2. **Core Feature Completion** - Cosmetic shop, mascot unlocks, analytics, and legal compliance

This phase prepares the app for eventual soft launch (targeted for Phase 10).

### Key Objectives

- Expand action library from 29 to ~100 researched actions
- Cover all 17 UN SDGs (direct actions or "Learn Only" with resources)
- Enhance SDG detail screen with related actions and personal stats
- Add action search and filtering (keywords, alphabetical, CO₂ impact, by SDG)
- Implement cosmetic shop with 5 initial items
- Add placeholder mascot species (3 total, unlock with points)
- Implement streak break Cloud Function notification
- Configure Firebase Analytics and Crashlytics
- Create privacy policy and terms of service

---

## Goals & Deliverables

### Primary Deliverables

| Deliverable | Description |
|-------------|-------------|
| ~100 Actions | Researched actions with CO₂ data covering all 17 SDGs |
| RESEARCH_STRATEGY.md | Documentation of research sources and methodology |
| Enhanced Action Library UI | Search, sort, and filter functionality |
| SDG Detail Screen v2 | Related actions + personal stats per SDG |
| Cosmetic Shop | 5 purchasable items (accessories + backgrounds) |
| Mascot Unlock System | 3 species with point-based unlocking |
| Streak Break Notifications | Cloud Function for push notifications |
| Analytics & Crash Reporting | Firebase Analytics events + Crashlytics |
| Legal Screens | Privacy policy and terms of service |

---

## Feature Breakdown

### Summary Table

| Feature | Priority | Complexity | Status |
|---------|----------|------------|--------|
| 4.1 Action Library Research | P0 | High | Pending |
| 4.2 Action Library UI Enhancement | P0 | Medium | Pending |
| 4.3 SDG Detail Screen Enhancement | P0 | Medium | Pending |
| 4.4 Cosmetic Shop | P0 | Medium | Pending |
| 4.5 Mascot Species Unlocking | P0 | Low | Pending |
| 4.6 Streak Break Cloud Function | P1 | Medium | Pending |
| 4.7 Firebase Analytics | P0 | Low | Pending |
| 4.8 Firebase Crashlytics | P0 | Low | Pending |
| 4.9 Privacy Policy & Terms | P0 | Low | Pending |
| 4.10 Polish Items | P2 | Low | Pending |

---

## Action Library Expansion

### 4.1 Research & Data Collection

**Priority:** P0 | **Complexity:** High

This is the largest task in Phase 4. See [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md) for detailed methodology.

#### Current State

- **29 actions** across 6 categories
- **9 SDGs covered** (2, 3, 6, 7, 11, 12, 13, 14, 15)
- **8 SDGs missing** (1, 4, 5, 8, 9, 10, 16, 17)

#### Target State

- **~100 actions** across expanded categories
- **All 17 SDGs covered**
- Actions categorized as:
  - **Direct Actions** - User can personally do (most actions)
  - **Learn Only** - Educational content with resource links (for difficult SDGs)

#### SDG Coverage Strategy

| SDG | Type | Strategy |
|-----|------|----------|
| 1 - No Poverty | Learn + Indirect | Donate, volunteer, advocate actions |
| 2 - Zero Hunger | Direct | Food waste, local food, gardening |
| 3 - Good Health | Direct | Active transport, wellness actions |
| 4 - Quality Education | Learn + Indirect | Mentor, donate supplies, share knowledge |
| 5 - Gender Equality | Learn + Indirect | Support women-owned businesses, advocate |
| 6 - Clean Water | Direct | Water conservation, pollution prevention |
| 7 - Affordable Energy | Direct | Energy saving, renewable choices |
| 8 - Decent Work | Learn + Indirect | Support fair trade, ethical purchases |
| 9 - Industry/Innovation | Learn + Indirect | Support sustainable businesses, repair items |
| 10 - Reduced Inequalities | Learn + Indirect | Support inclusive businesses, advocacy |
| 11 - Sustainable Cities | Direct | Public transit, urban gardening, community |
| 12 - Responsible Consumption | Direct | Reduce, reuse, recycle, conscious buying |
| 13 - Climate Action | Direct | Carbon reduction, advocacy, education |
| 14 - Life Below Water | Direct | Reduce plastic, sustainable seafood |
| 15 - Life on Land | Direct | Native plants, wildlife support, no pesticides |
| 16 - Peace & Justice | Learn Only | Educational resources, civic participation |
| 17 - Partnerships | Learn Only | Community engagement, collaboration resources |

#### Action Target by Category

| Category | Current | Target | New Actions Needed |
|----------|---------|--------|-------------------|
| Recycling | 4 | 10 | 6 |
| Transport | 4 | 12 | 8 |
| Food | 3 | 15 | 12 |
| Energy | 4 | 12 | 8 |
| Consumption | 5 | 15 | 10 |
| Water | 4 | 10 | 6 |
| Community | 0 | 10 | 10 (NEW) |
| Advocacy | 0 | 8 | 8 (NEW) |
| Learning | 0 | 8 | 8 (NEW - for Learn Only SDGs) |
| **TOTAL** | **29** | **~100** | **~71** |

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create RESEARCH_STRATEGY.md | Document research methodology and sources | Pending |
| Research SDG 1 actions | No Poverty - indirect/learn actions | Pending |
| Research SDG 2 actions | Zero Hunger - expand food actions | Pending |
| Research SDG 3 actions | Good Health - expand wellness/transport | Pending |
| Research SDG 4 actions | Quality Education - learn/indirect | Pending |
| Research SDG 5 actions | Gender Equality - learn/indirect | Pending |
| Research SDG 6 actions | Clean Water - expand water actions | Pending |
| Research SDG 7 actions | Affordable Energy - expand energy actions | Pending |
| Research SDG 8 actions | Decent Work - learn/indirect | Pending |
| Research SDG 9 actions | Industry/Innovation - learn/indirect | Pending |
| Research SDG 10 actions | Reduced Inequalities - learn/indirect | Pending |
| Research SDG 11 actions | Sustainable Cities - expand urban actions | Pending |
| Research SDG 12 actions | Responsible Consumption - expand | Pending |
| Research SDG 13 actions | Climate Action - expand | Pending |
| Research SDG 14 actions | Life Below Water - expand ocean actions | Pending |
| Research SDG 15 actions | Life on Land - expand biodiversity actions | Pending |
| Research SDG 16 actions | Peace & Justice - learn only | Pending |
| Research SDG 17 actions | Partnerships - learn only | Pending |
| Validate CO₂ data | Cross-reference with multiple sources | Pending |
| Localize action names | EN/ES/JA for all new actions | Pending |
| Update seed script | Add all new actions to seed_action_library.js | Pending |
| Seed Firestore | Run seed script to populate actionLibrary | Pending |

#### Files to Create/Modify

- **Create:** `Plan/RESEARCH_STRATEGY.md`
- **Create:** `Plan/ACTION_RESEARCH/` folder with per-SDG research notes
- **Modify:** `scripts/seed_action_library.js`
- **Modify:** `lib/core/l10n/app_en.arb`, `app_es.arb`, `app_ja.arb`

---

### 4.2 Action Library UI Enhancement

**Priority:** P0 | **Complexity:** Medium

Add search, sort, and filter capabilities to the action library.

#### Current State

- Actions displayed in grid by category
- No search functionality
- No sorting options
- No SDG filtering

#### Target State

- **Keyword search** - Search action names and descriptions
- **Sort options:**
  - Alphabetical (A-Z, Z-A)
  - CO₂ impact (highest first, lowest first)
  - Points (highest first, lowest first)
  - Recently logged (personal)
- **Filter options:**
  - By category (existing)
  - By SDG (new)
  - Show all

#### UI Design

```
┌─────────────────────────────────────────┐
│  ←         Action Library               │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐   │
│  │ 🔍 Search actions...            │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Sort: [CO₂ Impact ▼]    Filter: [All] │
│                                         │
│  ─────── SDG 12: Responsible ────────  │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ 🛍️  │ │ ♻️  │ │ 🥤  │ │ 📦  │      │
│  │Bag  │ │Can  │ │Cup  │ │Card │      │
│  │+2   │ │+5   │ │+3   │ │+4   │      │
│  └─────┘ └─────┘ └─────┘ └─────┘      │
│                                         │
│  ─────── SDG 13: Climate Action ─────  │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ 🚴  │ │ 🚌  │ │ 🥗  │ │ 💡  │      │
│  │Bike │ │Bus  │ │Veg  │ │Light│      │
│  │+20  │ │+15  │ │+20  │ │+2   │      │
│  └─────┘ └─────┘ └─────┘ └─────┘      │
│                                         │
└─────────────────────────────────────────┘
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Add search bar widget | Text field with debounced search | Pending |
| Implement search provider | Filter actions by keyword | Pending |
| Add sort dropdown | Sort by CO₂, points, alphabetical | Pending |
| Add SDG filter chips | Horizontal scrollable SDG filter | Pending |
| Update action grid | Group by SDG when SDG filter active | Pending |
| Add "Learn Only" badge | Visual indicator for non-loggable actions | Pending |
| Add empty state | "No actions match your search" | Pending |
| Localize new strings | Search, sort, filter labels | Pending |
| Write widget tests | Test search, sort, filter behavior | Pending |

#### Files to Create/Modify

- **Modify:** `lib/features/actions/presentation/screens/action_log_screen.dart`
- **Create:** `lib/features/actions/presentation/widgets/action_search_bar.dart`
- **Create:** `lib/features/actions/presentation/widgets/action_sort_dropdown.dart`
- **Create:** `lib/features/actions/presentation/widgets/sdg_filter_chips.dart`
- **Modify:** `lib/features/actions/presentation/providers/action_providers.dart`
- **Create:** `test/features/actions/presentation/widgets/action_search_bar_test.dart`

---

## SDG Detail Screen Enhancement

### 4.3 SDG Detail Screen v2

**Priority:** P0 | **Complexity:** Medium

Enhance the SDG detail screen to show related actions and personal statistics.

#### Current State

- Shows SDG description and info
- "Learn More" link to UN website
- No related actions displayed
- No personal stats

#### Target State

- **SDG Info Section** - Description, icon, goal number (existing)
- **Your Impact Section** - Personal stats for this SDG:
  - Actions logged for this SDG
  - Total CO₂ saved for this SDG
  - Streak for this SDG (optional)
- **Related Actions Section** - Actions linked to this SDG:
  - Grid of loggable actions
  - "Learn Only" resources for difficult SDGs
- **Resources Section** - External links (for Learn Only SDGs)

#### UI Design

```
┌─────────────────────────────────────────┐
│  ←      SDG 12: Responsible             │
│         Consumption                      │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐   │
│  │     [SDG 12 Icon/Color]         │   │
│  │                                  │   │
│  │  Ensure sustainable consumption  │   │
│  │  and production patterns...      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── Your Impact ───────            │
│  ┌─────────────────────────────────┐   │
│  │  🎯 42 actions    💨 12.5 kg CO₂ │   │
│  │  logged           saved          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── Log an Action ───────          │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ 🛍️  │ │ ♻️  │ │ 🥤  │ │ +   │      │
│  │Bag  │ │Can  │ │Cup  │ │More │      │
│  └─────┘ └─────┘ └─────┘ └─────┘      │
│                                         │
│  ─────── Learn More ───────             │
│  ┌─────────────────────────────────┐   │
│  │ 🔗 UN SDG 12 Official Page   →  │   │
│  │ 📚 Tips for Sustainable Living → │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

#### For "Learn Only" SDGs

```
┌─────────────────────────────────────────┐
│  ←      SDG 16: Peace, Justice          │
│         and Strong Institutions          │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐   │
│  │     [SDG 16 Icon/Color]         │   │
│  │                                  │   │
│  │  Promote peaceful and inclusive  │   │
│  │  societies for sustainable...    │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── About This Goal ───────        │
│  ┌─────────────────────────────────┐   │
│  │  📖 This goal focuses on        │   │
│  │  institutional change. While     │   │
│  │  individual actions are limited, │   │
│  │  you can still make a difference │   │
│  │  through civic engagement.       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── Ways to Contribute ───────     │
│  ┌─────────────────────────────────┐   │
│  │ 🗳️ Vote in local elections   →  │   │
│  │ 📝 Contact representatives   →  │   │
│  │ 🤝 Volunteer for justice orgs → │   │
│  │ 📚 Learn about civic rights  →  │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create SDG stats provider | Calculate actions/CO₂ per SDG for user | Pending |
| Create SDG actions provider | Filter actions by SDG | Pending |
| Add "Your Impact" section | Stats card with actions logged, CO₂ saved | Pending |
| Add "Log an Action" section | Grid of related actions | Pending |
| Add "Learn Only" variant | Educational content for difficult SDGs | Pending |
| Create SDG resources data | Links and tips for each SDG | Pending |
| Update SdgDetailScreen | Rebuild with new sections | Pending |
| Localize new strings | Section headers, descriptions | Pending |
| Write widget tests | Test stats display, action grid | Pending |

#### Files to Create/Modify

- **Modify:** `lib/features/sdg/presentation/screens/sdg_detail_screen.dart`
- **Create:** `lib/features/sdg/presentation/widgets/sdg_impact_card.dart`
- **Create:** `lib/features/sdg/presentation/widgets/sdg_actions_grid.dart`
- **Create:** `lib/features/sdg/presentation/widgets/sdg_resources_list.dart`
- **Create:** `lib/features/sdg/presentation/providers/sdg_stats_provider.dart`
- **Create:** `lib/features/sdg/data/sdg_resources.dart`
- **Modify:** `lib/features/sdg/data/sdg_data.dart` (add isLearnOnly flag)

---

## Cosmetic Shop

### 4.4 Cosmetic Shop Implementation

**Priority:** P0 | **Complexity:** Medium

Implement a shop where users can purchase cosmetic items with points.

#### Features

- Browse cosmetic items
- View item details (preview, price, requirements)
- Purchase items with points
- Equip/unequip items on mascot
- View owned items

#### Data Model

```dart
@freezed
class CosmeticItemModel with _$CosmeticItemModel {
  const factory CosmeticItemModel({
    required String id,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required String type,           // 'hat', 'accessory', 'background'
    required String imageUrl,       // SVG or PNG URL
    required int pointsCost,
    @Default(1) int requiredLevel,
    @Default(true) bool isAvailable,
    String? descriptionEn,
    String? descriptionJa,
    String? descriptionEs,
  }) = _CosmeticItemModel;
}
```

#### User Ownership Model

```dart
// In AppUserModel or separate collection
@freezed
class UserCosmeticsModel with _$UserCosmeticsModel {
  const factory UserCosmeticsModel({
    @Default([]) List<String> ownedItemIds,
    String? equippedHatId,
    String? equippedAccessoryId,
    String? equippedBackgroundId,
  }) = _UserCosmeticsModel;
}
```

#### Initial Items (5 total)

| Item | Type | Cost | Description |
|------|------|------|-------------|
| Party Hat | Hat | 200 | Colorful celebration hat |
| Leaf Crown | Hat | 300 | Crown made of green leaves |
| Tiny Sunglasses | Accessory | 150 | Cool shades for your mascot |
| Forest Background | Background | 400 | Lush forest scene |
| Ocean Background | Background | 400 | Peaceful ocean waves |

#### UI Design - Shop Screen

```
┌─────────────────────────────────────────┐
│  ←           Shop           💰 1,250    │
├─────────────────────────────────────────┤
│                                         │
│  ─────── Hats ───────                   │
│  ┌─────────┐ ┌─────────┐               │
│  │  🎉     │ │  🌿     │               │
│  │ Party   │ │ Leaf    │               │
│  │ Hat     │ │ Crown   │               │
│  │ 200 pts │ │ 300 pts │               │
│  └─────────┘ └─────────┘               │
│                                         │
│  ─────── Accessories ───────            │
│  ┌─────────┐                            │
│  │  🕶️     │                            │
│  │ Tiny    │                            │
│  │Shades   │                            │
│  │ 150 pts │                            │
│  └─────────┘                            │
│                                         │
│  ─────── Backgrounds ───────            │
│  ┌─────────┐ ┌─────────┐               │
│  │  🌲     │ │  🌊     │               │
│  │ Forest  │ │ Ocean   │               │
│  │ 400 pts │ │ 400 pts │               │
│  └─────────┘ └─────────┘               │
│                                         │
└─────────────────────────────────────────┘
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create CosmeticItemModel | Freezed model for items | Pending |
| Create UserCosmeticsModel | Track owned/equipped items | Pending |
| Create CosmeticsRepository | CRUD operations for cosmetics | Pending |
| Create cosmetics providers | Shop state, owned items, equipped | Pending |
| Create ShopScreen | Browse all items | Pending |
| Create ItemDetailSheet | Preview, purchase button | Pending |
| Create OwnedItemsScreen | View and equip owned items | Pending |
| Implement purchase logic | Deduct points, add to owned | Pending |
| Implement equip/unequip | Update equipped item in Firestore | Pending |
| Update MascotDisplay | Render equipped items on mascot | Pending |
| Create 5 cosmetic item SVGs | AI-generated vector art | Pending |
| Seed cosmetic items | Add to Firestore | Pending |
| Add shop route | Navigation from profile/home | Pending |
| Localize strings | Item names, UI text | Pending |
| Write tests | Repository, purchase flow, display | Pending |

#### Files to Create

```
lib/features/shop/
├── shop.dart                           # Barrel file
├── data/
│   ├── models/
│   │   ├── cosmetic_item_model.dart
│   │   └── user_cosmetics_model.dart
│   ├── datasources/
│   │   └── shop_remote_datasource.dart
│   └── repositories/
│       └── shop_repository.dart
└── presentation/
    ├── providers/
    │   └── shop_providers.dart
    ├── screens/
    │   ├── shop_screen.dart
    │   └── owned_items_screen.dart
    └── widgets/
        ├── shop_item_card.dart
        ├── item_detail_sheet.dart
        └── equipped_items_preview.dart
```

---

## Additional Mascot Species

### 4.5 Mascot Species Unlocking

**Priority:** P0 | **Complexity:** Low

Add 2 additional mascot species (3 total) with point-based unlocking.

#### Current State

- 1 mascot species (Sprout) with 4 evolution stages
- No unlocking mechanism

#### Target State

- 3 mascot species total
- First species free (starter)
- Additional species unlockable with points
- Placeholder images for now (final art in Phase 5)

#### Species Data

| Species | Unlock Cost | Description |
|---------|-------------|-------------|
| Sprout | Free | Plant-based mascot (existing) |
| Coral | 3,000 pts | Ocean-themed mascot (placeholder) |
| Ember | 5,000 pts | Energy-themed mascot (placeholder) |

*Point costs designed to require sustained engagement*

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Update MascotSpeciesModel | Add unlockCost, isUnlocked fields | Pending |
| Create species unlock provider | Check if user can unlock | Pending |
| Create species selection screen | Show locked/unlocked species | Pending |
| Implement unlock purchase | Deduct points, unlock species | Pending |
| Create placeholder SVGs | 8 images (2 species × 4 stages) | Pending |
| Seed mascot species | Add to Firestore | Pending |
| Update mascot selection flow | Show unlock option | Pending |
| Add "Change Mascot" option | In mascot detail screen | Pending |
| Localize strings | Species names, unlock prompts | Pending |
| Write tests | Unlock flow, species switching | Pending |

#### Files to Modify

- `lib/features/mascot/data/models/mascot_species_model.dart`
- `lib/features/mascot/presentation/screens/mascot_selection_screen.dart`
- `lib/features/mascot/presentation/providers/mascot_providers.dart`
- `scripts/seed_mascot_species.js` (create)

---

## Streak Break Cloud Function

### 4.6 Streak Break Notification

**Priority:** P1 | **Complexity:** Medium

Implement a Cloud Function to send push notifications when a user's streak is about to break.

#### Logic

1. Cloud Function runs daily at 8 PM (user's timezone, or fixed time)
2. Query users who:
   - Have `notificationsEnabled: true`
   - Have `currentStreak > 0`
   - Have NOT logged an action today (`lastActionDate` < today)
3. Send FCM push notification to those users

#### Implementation Options

**Option A: Scheduled Function (Recommended)**
- Runs at fixed time (e.g., 8 PM UTC)
- Simpler implementation
- Works for global audience

**Option B: Per-User Timezone**
- More complex, requires storing user timezone
- Better UX but higher complexity
- Defer to future phase

#### Cloud Function Code

```typescript
// functions/src/streakReminder.ts
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const sendStreakReminders = functions.pubsub
  .schedule('0 20 * * *')  // 8 PM UTC daily
  .onRun(async (context) => {
    const db = admin.firestore();
    const messaging = admin.messaging();

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Query users at risk of losing streak
    const usersAtRisk = await db.collection('users')
      .where('notificationsEnabled', '==', true)
      .where('currentStreak', '>', 0)
      .where('lastActionDate', '<', today)
      .get();

    const notifications: Promise<string>[] = [];

    usersAtRisk.forEach(doc => {
      const user = doc.data();
      if (user.fcmToken) {
        const message = {
          token: user.fcmToken,
          notification: {
            title: "Don't break your streak!",
            body: `You have a ${user.currentStreak}-day streak. Log an action today!`,
          },
          data: {
            type: 'streak_reminder',
            userId: doc.id,
          },
        };
        notifications.push(messaging.send(message));
      }
    });

    await Promise.allSettled(notifications);
    console.log(`Sent ${notifications.length} streak reminders`);
  });
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Initialize Firebase Functions | Set up functions folder | Pending |
| Create streakReminder function | Scheduled Cloud Function | Pending |
| Deploy to Firebase | `firebase deploy --only functions` | Pending |
| Test with emulator | Local testing | Pending |
| Monitor logs | Verify function runs correctly | Pending |
| Localize notification text | EN/ES/JA messages | Pending |

#### Files to Create

```
firebase/
└── functions/
    ├── src/
    │   ├── index.ts
    │   └── streakReminder.ts
    ├── package.json
    └── tsconfig.json
```

---

## Firebase Services

### 4.7 Firebase Analytics

**Priority:** P0 | **Complexity:** Low

Implement event tracking for user behavior analysis.

#### Events to Track

| Event | Parameters | When |
|-------|------------|------|
| `sign_up` | `method` | User creates account |
| `login` | `method` | User logs in |
| `action_logged` | `action_id`, `category`, `points`, `sdg` | User logs an action |
| `mascot_evolved` | `species`, `new_stage` | Mascot evolves |
| `streak_milestone` | `days`, `weeks` | User hits streak milestone |
| `shop_item_viewed` | `item_id`, `item_type` | User views shop item |
| `shop_item_purchased` | `item_id`, `points_spent` | User buys item |
| `mascot_unlocked` | `species`, `points_spent` | User unlocks new mascot |
| `sdg_viewed` | `sdg_number` | User views SDG detail |
| `notification_enabled` | - | User enables notifications |
| `notification_disabled` | - | User disables notifications |
| `language_changed` | `language` | User changes language |

#### Implementation

```dart
// lib/shared/services/analytics_service.dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logActionLogged({
    required String actionId,
    required String category,
    required int points,
    required List<String> sdgs,
  }) async {
    await _analytics.logEvent(
      name: 'action_logged',
      parameters: {
        'action_id': actionId,
        'category': category,
        'points': points,
        'sdg': sdgs.join(','),
      },
    );
  }

  // ... other event methods
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create AnalyticsService | Wrapper for Firebase Analytics | Pending |
| Add sign_up event | In auth flow | Pending |
| Add login event | In auth flow | Pending |
| Add action_logged event | In action log repository | Pending |
| Add mascot_evolved event | In evolution flow | Pending |
| Add streak_milestone event | In streak service | Pending |
| Add shop events | In shop repository | Pending |
| Add sdg_viewed event | In SDG detail screen | Pending |
| Add settings events | In settings providers | Pending |
| Create analytics provider | Riverpod provider for service | Pending |
| Write tests | Mock analytics, verify events | Pending |

#### Files to Create

- `lib/shared/services/analytics_service.dart`
- `lib/shared/providers/analytics_provider.dart`
- `test/shared/services/analytics_service_test.dart`

---

### 4.8 Firebase Crashlytics

**Priority:** P0 | **Complexity:** Low

Configure crash reporting for production monitoring.

#### Setup Steps

1. Add dependency to pubspec.yaml
2. Configure native platforms (iOS/Android)
3. Initialize in main.dart
4. Optionally set user identifier for crash context

#### Implementation

```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(...);

  // Configure Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(...);
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Add firebase_crashlytics dependency | pubspec.yaml | Pending |
| Configure iOS | GoogleService-Info.plist, Podfile | Pending |
| Configure Android | build.gradle | Pending |
| Initialize in main.dart | Error handlers | Pending |
| Set user identifier | After login | Pending |
| Add custom keys | App version, mascot species, etc. | Pending |
| Test crash reporting | Force a crash, verify in console | Pending |

#### Files to Modify

- `pubspec.yaml`
- `lib/main.dart`
- `ios/Podfile`
- `android/app/build.gradle`

---

## Legal Compliance

### 4.9 Privacy Policy & Terms of Service

**Priority:** P0 | **Complexity:** Low

Create and display legal documents required for app store submission.

#### Approach

1. Use a generator service (Termly, iubenda, or similar)
2. Customize for Seed's data practices
3. Display in app with links from About screen
4. Host on web (Firebase Hosting or simple static site)

#### Data Practices to Document

- **Data Collected:**
  - Email address
  - Display name
  - Action log history
  - Device FCM token
  - Usage analytics

- **Data Usage:**
  - Authentication
  - App functionality
  - Push notifications
  - Analytics (anonymized)

- **Data Storage:**
  - Firebase (Google Cloud)
  - US/EU data centers

- **Data Sharing:**
  - No third-party sharing
  - Firebase/Google services only

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Generate privacy policy | Use Termly or similar | Pending |
| Generate terms of service | Use Termly or similar | Pending |
| Review and customize | Ensure accuracy | Pending |
| Create PrivacyPolicyScreen | WebView or markdown display | Pending |
| Create TermsOfServiceScreen | WebView or markdown display | Pending |
| Host documents | Firebase Hosting | Pending |
| Add links to About screen | Already have placeholders | Pending |
| Localize documents | EN/ES/JA versions | Pending |

#### Files to Create/Modify

- `lib/features/settings/presentation/screens/privacy_policy_screen.dart`
- `lib/features/settings/presentation/screens/terms_of_service_screen.dart`
- `web/privacy-policy.html` (for hosting)
- `web/terms-of-service.html` (for hosting)

---

## Point Economy

### Pricing Strategy

Based on estimated user activity levels:
- **Conservative user:** ~25-35 points/day
- **Active user:** ~50-75 points/day
- **Very Active user:** ~100+ points/day

#### Item Pricing

| Item Type | Price Range | Effort Level |
|-----------|-------------|--------------|
| Basic Accessory | 100-200 pts | Low (few sessions) |
| Premium Accessory | 300-400 pts | Medium |
| Background | 400-500 pts | Medium-High |
| Mascot Species | 3,000-5,000 pts | High (aspirational goal) |

#### Balance Considerations

- Prices should feel achievable but require engagement
- First purchase should be possible after initial sessions
- Mascot unlocks are aspirational goals
- Consider "sales" or discounts for engagement

---

## Implementation Order

### Recommended Sequence

```
Stage 4.1: Foundation
├── Create RESEARCH_STRATEGY.md
├── Set up Firebase Analytics
├── Set up Firebase Crashlytics
├── Create privacy policy and terms
└── Update About screen with legal links

Stage 4.2: Action Research
├── Research actions for each SDG
├── Document CO₂ sources
├── Create action entries
├── Localize action names
└── Update seed script incrementally

Stage 4.3: Action Library UI
├── Add search functionality
├── Add sort options
├── Add SDG filter
├── Update action grid layout
└── Write tests

Stage 4.4: SDG Detail Screen
├── Create SDG stats provider
├── Add "Your Impact" section
├── Add related actions grid
├── Create "Learn Only" variant
├── Add resources section
└── Write tests

Stage 4.5: Cosmetic Shop
├── Create data models
├── Create repository
├── Build shop UI
├── Create 5 cosmetic items (SVGs)
├── Implement purchase flow
├── Integrate with mascot display
└── Write tests

Stage 4.6: Mascot Species
├── Update species model
├── Create placeholder SVGs
├── Implement unlock flow
├── Update selection screen
└── Write tests

Stage 4.7: Cloud Function
├── Set up Firebase Functions
├── Create streak reminder function
├── Deploy and test
└── Monitor logs

Stage 4.8: Polish & Testing
├── End-to-end testing
├── Bug fixes
├── Performance optimization
├── Documentation updates
└── Prepare for Phase 5
```

---

## Testing Strategy

### Unit Tests

| Component | Test File | Key Scenarios |
|-----------|-----------|---------------|
| Action search/filter | `action_search_test.dart` | Keyword matching, SDG filtering |
| SDG stats provider | `sdg_stats_provider_test.dart` | Calculate per-SDG stats |
| Shop repository | `shop_repository_test.dart` | Purchase, equip, ownership |
| Mascot unlock | `mascot_unlock_test.dart` | Unlock flow, point deduction |
| Analytics service | `analytics_service_test.dart` | Event logging |

### Widget Tests

| Screen | Test File | Key Scenarios |
|--------|-----------|---------------|
| Action Library | `action_log_screen_test.dart` | Search, sort, filter UI |
| SDG Detail | `sdg_detail_screen_test.dart` | Stats display, action grid |
| Shop | `shop_screen_test.dart` | Item display, purchase flow |
| Item Detail | `item_detail_sheet_test.dart` | Preview, buy button states |

### Integration Tests

| Flow | Test File | Scenarios |
|------|-----------|-----------|
| Purchase cosmetic | `purchase_flow_test.dart` | Browse → purchase → equip |
| Unlock mascot | `mascot_unlock_test.dart` | View → unlock → switch |
| SDG exploration | `sdg_flow_test.dart` | Carousel → detail → log action |

---

## Acceptance Criteria

### 4.1 Action Library Research
- [ ] RESEARCH_STRATEGY.md created with methodology
- [ ] ~100 actions defined with CO₂ data
- [ ] All 17 SDGs have at least 3 actions or "Learn Only" content
- [ ] All actions localized (EN/ES/JA)
- [ ] Seed script updated and tested

### 4.2 Action Library UI
- [ ] Keyword search filters actions in real-time
- [ ] Sort by alphabetical, CO₂, points works
- [ ] SDG filter shows only related actions
- [ ] "Learn Only" badge visible on non-loggable actions
- [ ] Empty state shows when no results

### 4.3 SDG Detail Screen
- [ ] "Your Impact" shows accurate stats per SDG
- [ ] Related actions displayed in grid
- [ ] Can log action directly from SDG detail
- [ ] "Learn Only" SDGs show educational content
- [ ] Resources links are clickable

### 4.4 Cosmetic Shop
- [ ] All 5 items visible in shop
- [ ] Purchase deducts points correctly
- [ ] Cannot purchase without sufficient points
- [ ] Owned items appear in inventory
- [ ] Equipped items render on mascot

### 4.5 Mascot Species
- [ ] 3 species visible (1 free, 2 locked)
- [ ] Unlock shows confirmation with cost
- [ ] Points deducted on unlock
- [ ] Can switch between owned species
- [ ] Placeholder images display correctly

### 4.6 Streak Break Cloud Function
- [ ] Function deploys successfully
- [ ] Runs on schedule (8 PM UTC)
- [ ] Sends notifications to at-risk users
- [ ] Does not notify users who logged today
- [ ] Logs show execution details

### 4.7 Firebase Analytics
- [ ] All defined events tracked
- [ ] Events visible in Firebase console
- [ ] Parameters captured correctly

### 4.8 Firebase Crashlytics
- [ ] Crashes reported to console
- [ ] User identifier attached
- [ ] Custom keys visible

### 4.9 Legal Compliance
- [ ] Privacy policy accessible from app
- [ ] Terms of service accessible from app
- [ ] Documents hosted and loading
- [ ] EN/ES/JA versions available

---

## Dependencies

### External
- Firebase Console access
- Termly/iubenda account (for legal docs)
- AI image generation tool (for cosmetic SVGs)

### Internal
- Phase 3 complete (streak tracking, notifications)
- Seed script access
- Firebase Functions billing enabled (Blaze plan)

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Action research takes longer | High | Medium | Start research early, track progress regularly |
| CO₂ data inconsistencies | Medium | Medium | Use multiple sources, document methodology |
| Cloud Function billing | Low | Low | Monitor usage, set budget alerts |
| Cosmetic art quality | Medium | Low | Iterate on AI generation, keep simple |
| Scope creep | Medium | High | Stick to defined features, defer nice-to-haves |

---

## Notes

- Action library expansion is the largest effort; track progress by SDG completion
- Use RESEARCH_STRATEGY.md to maintain consistency
- ACTIONS_RESEARCH.md contains currently up-to-date researched data
- `co2_actions_database.csv` and `co2_actions_database.json` contain data to be used in the app. These files should be moved to appropriate location as needed. 
- `sdg_world_state_fully_sourced.json` contains lots of infomation on the SDGs. This should also be incorporated into the SDG info carousel
- Cosmetic items should be simple initially; can add more in Phase 5
- Placeholder mascot art is acceptable for soft launch
- Monitor Cloud Function costs after deployment

---

## Known UX Gaps (To Address)

### SDG Display on Actions
**Status:** Not implemented
**Priority:** P1

Currently, users cannot see which SDGs an action contributes to. When logging an action like "Recycle Aluminum Can" (which contributes to SDG 12 and SDG 13), there's no visual indication of this relationship.

**Where to display:**
- Action card in the action library grid
- Action confirmation dialog before logging
- Action history/log entries

**Suggested implementation:**
- Add small SDG number badges (colored circles) to action cards
- Show SDG icons/badges in the confirmation dialog
- Include SDG info in the "Your Impact" section

**Files to modify:**
- `lib/features/actions/presentation/widgets/action_card.dart`
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart`

This helps users understand the broader impact of their actions and creates a clearer connection to the SDG progress tracking.

---

*This plan will be updated as implementation progresses.*
