# Phase 4: Action Library Expansion & Core Features

**Version:** 1.3
**Created:** January 2026
**Updated:** March 10, 2026
**Status:** Complete (8/10 features done, 2 deferred to Phase 6)

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
| 4.1 Action Library Research | P0 | High | Complete |
| 4.2 Action Library UI Enhancement | P0 | Medium | Complete |
| 4.3 SDG Detail Screen Enhancement | P0 | Medium | Complete |
| 4.4 Cosmetic Shop | P0 | Medium | Deferred |
| 4.5 Mascot Species Unlocking | P0 | Low | Deferred |
| 4.6 Streak Break Cloud Function | P1 | Medium | Complete |
| 4.7 Firebase Analytics | P0 | Low | Complete |
| 4.8 Firebase Crashlytics | P0 | Low | Complete |
| 4.9 Privacy Policy & Terms | P0 | Low | Complete |
| 4.10 Polish Items | P2 | Low | Complete |

---

## Action Library Expansion

### 4.1 Research & Data Collection

**Priority:** P0 | **Complexity:** High

This is the largest task in Phase 4. See [RESEARCH_STRATEGY.md](./RESEARCH_STRATEGY.md) for detailed methodology.

#### Current State (Updated Feb 14, 2026)

- **100 actions** across 9 categories (expanded from 34 across 7)
- **Advocacy and Learning categories** added
- **8 learn-only actions** covering SDGs 1, 4, 5, 8, 9, 10, 16, 17
- **All 17 SDGs covered** (direct actions or learn-only)
- **Spanish localization** added (nameEs, descriptionEs on all actions)
- **CO2 values research-backed** from DEFRA 2024, EPA, Poore & Nemecek 2018, Our World in Data
- **Centralized icon mapping** in action_icons.dart
- **SDG detail screen enhanced** with impact stats, related actions, resources
- **Bug fix:** totalCo2Saved provider corrected (co2Saved -> co2Grams)

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

#### Action Count by Category (Final)

| Category | Count |
|----------|-------|
| Recycling | 10 |
| Transport | 12 |
| Food | 15 |
| Energy | 12 |
| Consumption | 15 |
| Water | 10 |
| Community | 10 |
| Advocacy | 8 |
| Learning | 8 (all isLearnOnly) |
| **TOTAL** | **100** |

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create RESEARCH_STRATEGY.md | Document research methodology and sources | Done |
| CO2 research | Actions researched with sources (co2_actions_database.json) | Done |
| Research all 17 SDGs | Direct or learn-only coverage for every SDG | Done |
| Validate CO2 data | Cross-reference with multiple sources | Done |
| Add community category | Category with color, icon, localization | Done |
| Add advocacy category | Category with color, icon, localization | Done |
| Add learning category | Category with color, icon, localization | Done |
| Add isLearnOnly to ActionModel | Support non-loggable educational actions | Done |
| Add nameEs/descriptionEs to ActionModel | Spanish localization fields | Done |
| Create learn-only info dialog | Dialog shown when tapping non-loggable actions | Done |
| Centralize icon mapping | action_icons.dart with actionIconMap | Done |
| Localize action names | EN/ES/JA for all 100 actions | Done |
| Update seed script | 100 research-backed actions in seed_action_library.js | Done |
| Seed Firestore | Run seed script to populate actionLibrary | Pending |

#### Files Created/Modified

- **Created:** `Plan/RESEARCH_STRATEGY.md` - research methodology
- **Created:** `Plan/ACTIONS_RESEARCH.md` - detailed research notes
- **Created:** `data/co2_actions_database.csv` / `.json` - CO2 data
- **Created:** `data/sdg_world_state_fully_sourced.json` - SDG data
- **Created:** `lib/features/actions/presentation/widgets/learn_only_info_dialog.dart`
- **Created:** `lib/features/actions/domain/constants/action_icons.dart` - centralized icon map
- **Modified:** `scripts/seed_action_library.js` - expanded to 100 actions
- **Modified:** `lib/core/l10n/app_en.arb`, `app_es.arb`, `app_ja.arb` - 9 categories + SDG strings
- **Modified:** `lib/features/actions/domain/enums/action_category.dart` - added community, advocacy, learning
- **Modified:** `lib/features/actions/data/models/action_model.dart` - added isLearnOnly, nameEs, descriptionEs
- **Modified:** `lib/core/theme/app_colors.dart` - added 3 new category colors
- **Modified:** `lib/features/actions/presentation/widgets/action_card.dart` - uses centralized icons
- **Modified:** `lib/features/actions/presentation/providers/actions_providers.dart` - ES search filter

---

### 4.2 Action Library UI Enhancement

**Priority:** P0 | **Complexity:** Medium | **Status:** Complete

Search, sort, and filter capabilities fully implemented in the action library.

#### Current State (Updated Feb 9, 2026)

- Search bar with debounced keyword search (complete)
- Category tabs for filtering by category (complete)
- Sort dropdown: alphabetical, CO2 impact, points (complete)
- SDG filter chips: horizontal scrollable SDG filter (complete)
- SDG badges on action cards with overflow indicator (complete)
- Empty state: "No actions found" with icon (complete)
- Localized strings for search, sort, filter (complete)
- Widget tests for sort dropdown and SDG filter chips (complete)

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
| Add search bar widget | Text field with debounced search | Done |
| Implement search provider | Filter actions by keyword | Done |
| Add sort dropdown | Sort by CO2, points, alphabetical | Done |
| Add SDG filter chips | Horizontal scrollable SDG filter | Done |
| Add category tabs | Filter by action category | Done |
| Update action grid | Responsive grid with filtered results | Done |
| Add SDG badges to action cards | Small colored SDG number badges | Done |
| Add "Learn Only" badge | Visual indicator for non-loggable actions | Done |
| Add empty state | "No actions match your search" | Done |
| Localize new strings | Search, sort, filter labels (EN/ES/JA) | Done |
| Write widget tests | Sort dropdown, SDG filter chips, action card | Done |

#### Files to Create/Modify

- **Modified:** `lib/features/actions/presentation/screens/action_log_screen.dart` - search, sort, filter UI
- **Created:** `lib/features/actions/presentation/widgets/action_sort_dropdown.dart`
- **Created:** `lib/features/actions/presentation/widgets/sdg_filter_chips.dart`
- **Created:** `lib/features/actions/presentation/widgets/action_category_tabs.dart`
- **Modified:** `lib/features/actions/presentation/providers/actions_providers.dart` - filter/sort logic
- **Modified:** `lib/features/actions/presentation/widgets/action_card.dart` - SDG badges + learn-only badge
- **Created:** `lib/features/actions/presentation/widgets/learn_only_info_dialog.dart`
- **Created:** `test/features/actions/presentation/widgets/action_sort_dropdown_test.dart`
- **Created:** `test/features/actions/presentation/widgets/sdg_filter_chips_test.dart`
- **Modified:** `test/features/actions/presentation/widgets/action_card_test.dart`

---

## SDG Detail Screen Enhancement

### 4.3 SDG Detail Screen v2

**Priority:** P0 | **Complexity:** Medium | **Status:** Complete

Enhanced SDG detail screen with related actions, personal statistics, targets data, and learn-only variant.

#### Implementation (Completed Feb 14, 2026)

- **SdgImpactCard** - Personal stats (actions logged + CO2 saved) per SDG
- **SdgActionsGrid** - Horizontal scrollable row of related actions (max 6)
- **SdgResourcesList** - External resource links for each SDG
- **Learn-only variant** - Explanatory text + resources for SDGs 1,4,5,8,9,10,16,17
- **SdgStats Freezed model** + stream provider
- **SDG resources data** - 2 resources per SDG (official + actionable)
- **ConsumerStatefulWidget** with conditional layout based on `isLearnOnly`

#### SDG Goal Targets Section (Completed Feb 15, 2026)

All 169 official UN targets displayed on the Goal detail page. Data extracted from `Plan/sdg_indicator_metadata/sdg_goal_*.json`.

- **SdgTargetsSection widget** - "About this Goal" section with animated expand/collapse
  - Shows goal description by default
  - Tap chevron to expand and reveal all targets for the Goal
  - Each target shows its code badge (e.g. "12.1") in goal color + description text
  - Uses const Dart data (no async loading needed)
- **sdg_targets.dart** - Const `Map<int, List<SdgTarget>>` with all 169 targets across 17 goals
- **Placement** - Between goal title and content sections
- Localized section headers (EN/ES/JA): "About this Goal", "UN Targets", "View targets"

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
| Create SDG stats provider | Calculate actions/CO2 per SDG for user | Done |
| Create SDG actions provider | Filter actions by SDG | Done |
| Add "Your Impact" section | Stats card with actions logged, CO2 saved | Done |
| Add related actions grid | Horizontal scrollable row of ActionCards | Done |
| Add "Learn Only" variant | Educational content for learn-only SDGs | Done |
| Create SDG resources data | 2 resources per SDG (all 17) | Done |
| Add isLearnOnly to SdgGoal | Flag SDGs 1,4,5,8,9,10,16,17 | Done |
| Update SdgDetailScreen | Rebuilt as ConsumerStatefulWidget | Done |
| Localize new strings | Section headers, descriptions (EN/ES/JA) | Done |
| Update widget tests | ProviderScope wrapper, new expectations | Done |
| Create SDG targets data | Const Dart map with all 169 targets in `sdg_targets.dart` | Done |
| Create SdgTargetsSection widget | Expandable section with animated chevron, target code badges | Done |
| Integrate targets into detail screen | Replaced static description with SdgTargetsSection | Done |
| Localize targets section header | sdgAboutGoal, sdgViewTargets, sdgTargetsTitle (EN/ES/JA) | Done |
| Write targets widget tests | Expand/collapse, correct target count per Goal | Done |

#### Files to Create/Modify

- **Modify:** `lib/features/sdg/presentation/screens/sdg_detail_screen.dart`
- **Create:** `lib/features/sdg/presentation/widgets/sdg_impact_card.dart`
- **Create:** `lib/features/sdg/presentation/widgets/sdg_actions_grid.dart`
- **Create:** `lib/features/sdg/presentation/widgets/sdg_resources_list.dart`
- **Create:** `lib/features/sdg/presentation/widgets/sdg_targets_section.dart`
- **Create:** `lib/features/sdg/presentation/providers/sdg_stats_provider.dart`
- **Create:** `lib/features/sdg/data/sdg_resources.dart`
- **Create:** `lib/features/sdg/data/sdg_targets.dart` (const map of all 169 targets)
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
- Placeholder images for now (final art in Phase 6)

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

**Priority:** P1 | **Complexity:** Medium | **Status:** Complete

Implemented a Cloud Function (Firebase Functions v2) to send push notifications when a user's streak is about to break.

#### Logic

1. Cloud Function runs daily at 8 PM UTC via `onSchedule`
2. Queries users who:
   - Have `notificationsEnabled: true`
   - Have `currentStreak > 0`
   - Have NOT logged an action today (`lastActionDate` < today UTC)
3. Sends localized FCM push notification (EN/JA/ES) to users with valid tokens
4. Cleans up invalid/expired FCM tokens automatically
5. Processes in batches of 500 for scalability

#### Implementation Details

- **API:** Firebase Functions v2 (`onSchedule` from `firebase-functions/v2/scheduler`)
- **Schedule:** `0 20 * * *` (8 PM UTC daily)
- **Localization:** EN, JA, and ES notification text, falls back to EN for unknown languages
- **Error handling:** Invalid FCM tokens are nullified in Firestore; send failures are counted but don't halt the batch
- **Memory:** 256 MiB allocation
- **Retry:** 1 retry on failure

#### Firestore Composite Index Required

The query requires a composite index on the `users` collection:
- `notificationsEnabled` (Ascending)
- `currentStreak` (Ascending)
- `lastActionDate` (Ascending)

Index is defined in `firestore.indexes.json`. Deploy with
`firebase deploy --only firestore:indexes`.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Initialize Firebase Functions | Set up functions folder with TypeScript | Done |
| Create streakReminder function | Scheduled Cloud Function (v2) | Done |
| Localize notification text | EN/JA/ES messages with fallback | Done |
| Write unit tests | 17 tests covering all edge cases | Done |
| Create firestore.rules | Security rules from MASTER_PLAN | Done |
| Deploy to Firebase | `firebase deploy --only functions,firestore` | Pending |
| Test with emulator | Local testing with emulator suite | Pending |
| Monitor logs | Verify function runs correctly in prod | Pending |

#### Files Created

```
functions/
├── src/
│   ├── index.ts              # Entry point, exports all functions
│   ├── streakReminder.ts     # Scheduled streak reminder function
│   └── __tests__/
│       └── streakReminder.test.ts  # 17 unit tests
├── package.json
├── tsconfig.json
├── jest.config.js
└── .gitignore
```

---

## Firebase Services

### 4.7 Firebase Analytics

**Priority:** P0 | **Complexity:** Low | **Status:** Complete

Event tracking for user behavior analysis fully implemented.

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
| Create AnalyticsService | Wrapper for Firebase Analytics | Done |
| Add sign_up event | In auth flow | Done |
| Add login event | In auth flow | Done |
| Add action_logged event | In action log repository | Done |
| Add mascot_evolved event | In evolution flow | Done |
| Add streak_milestone event | In streak service | Done |
| Add shop events | In shop repository (placeholder) | Done |
| Add sdg_viewed event | In SDG detail screen | Done |
| Add settings events | In settings providers | Done |
| Create analytics provider | Riverpod provider for service | Done |
| Write tests | Mock analytics, verify events | Done |

#### Files Created

- `lib/shared/services/analytics_service.dart` - Full analytics service with all events
- `lib/shared/providers/analytics_provider.dart` - Riverpod provider
- `test/shared/services/analytics_service_test.dart` - Unit tests
- Integrated into auth, SDG, and settings providers

---

### 4.8 Firebase Crashlytics

**Priority:** P0 | **Complexity:** Low | **Status:** Complete

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
| Add firebase_crashlytics dependency | pubspec.yaml | Done |
| Configure iOS | Pods installed via Flutter tooling | Done |
| Configure Android | build.gradle plugins added | Done |
| Initialize in main.dart | Error handlers | Done |
| Set user identifier | Synced in app.dart via auth state | Done |
| Add custom keys | App version captured automatically | Done |
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
| Generate privacy policy | In-app Dart content per locale | Done |
| Generate terms of service | In-app Dart content per locale | Done |
| Review and customize | Ensure accuracy | Done |
| Create PrivacyPolicyScreen | Shared LegalDocumentScreen widget | Done |
| Create TermsOfServiceScreen | Shared LegalDocumentScreen widget | Done |
| Host documents | N/A - rendered in-app | Done |
| Add links to About screen | In-app navigation via go_router | Done |
| Add links to Register screen | TapGestureRecognizer on text | Done |
| Localize documents | EN/ES/JA versions | Done |

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
4.1  Action Library Research                   -- COMPLETE
├── Research actions for all 17 SDGs              DONE (100 actions)
├── Document CO2 sources                          DONE
├── Add advocacy + learning categories            DONE
├── Add nameEs/descriptionEs to ActionModel       DONE
├── Centralize icon mapping                       DONE
├── Localize all action names (EN/ES/JA)          DONE
└── Update seed script to 100 actions             DONE

4.2  Action Library UI Enhancement             -- COMPLETE
├── Add search functionality                      DONE
├── Add sort options                              DONE
├── Add SDG filter                                DONE
├── Update action grid layout                     DONE
├── Add learn-only badge + info dialog            DONE
└── Write tests                                   DONE

4.3  SDG Detail Screen Enhancement             -- COMPLETE
├── Add isLearnOnly to SdgGoal                    DONE
├── Create SDG stats provider                     DONE
├── Add "Your Impact" section                     DONE
├── Add related actions grid                      DONE
├── Create "Learn Only" variant                   DONE
├── Create SDG resources data (all 17 SDGs)       DONE
├── Localize strings (EN/ES/JA)                   DONE
├── Update tests                                  DONE
├── Create SDG targets data (sdg_targets.dart)    DONE
├── Create SdgTargetsSection widget               DONE
├── Integrate targets into detail screen          DONE
└── Write targets widget tests                    DONE

4.4  Cosmetic Shop                             -- DEFERRED to Phase 6
├── Create data models
├── Create repository
├── Build shop UI
├── Create 5 cosmetic items (SVGs)
├── Implement purchase flow
├── Integrate with mascot display
└── Write tests

4.5  Mascot Species Unlocking                  -- DEFERRED to Phase 6
├── Update species model
├── Create placeholder SVGs
├── Implement unlock flow
├── Update selection screen
└── Write tests

4.6  Streak Break Cloud Function               -- COMPLETE
├── Set up Firebase Functions                     DONE
├── Create streak reminder function               DONE
├── Add EN/JA/ES notification text                DONE
├── Write unit tests (17 tests)                   DONE
├── Create .firebaserc + firestore indexes        DONE
├── Create firestore.rules                        DONE
├── Deploy and test                               PENDING
└── Monitor logs                                  PENDING

4.7  Firebase Analytics                        -- COMPLETE
├── Create AnalyticsService                       DONE
├── Add all event tracking                        DONE
└── Write tests                                   DONE

4.8  Firebase Crashlytics                      -- COMPLETE
├── Add dependency                               DONE
├── Configure Android Gradle plugins             DONE
├── Configure iOS pods                           DONE
├── Initialize in main.dart                      DONE
├── Set user identifier via auth state           DONE
└── Test crash reporting                         PENDING

4.9  Privacy Policy & Terms                    -- DONE
├── Generate legal documents                     DONE
├── Create display screens                       DONE
├── In-app rendering (no hosting needed)         DONE
└── Localize (EN/ES/JA)                          DONE

4.10 Polish & Testing                          -- COMPLETE
├── Remove "+" prefix from points displays       DONE
├── Improve bottom sheet text readability         DONE
├── Add close button to science bottom sheet      DONE
├── Change points animation icon to sparkle       DONE
├── flutter analyze                              DONE (no issues)
├── flutter test                                 DONE (848 tests passing)
├── Cloud Function tests                         DONE (17 tests passing)
└── Prepare for Phase 5                          DONE
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
- [x] RESEARCH_STRATEGY.md created with methodology
- [x] ~100 actions defined with CO₂ data (92 actions)
- [x] All 17 SDGs have at least 3 actions or "Learn Only" content
- [x] All actions localized (EN/ES/JA)
- [x] Seed script updated and tested

### 4.2 Action Library UI
- [x] Keyword search filters actions in real-time
- [x] Sort by alphabetical, CO₂, points works
- [x] SDG filter shows only related actions
- [x] "Learn Only" badge visible on non-loggable actions
- [x] Empty state shows when no results

### 4.3 SDG Detail Screen
- [x] "Your Impact" shows accurate stats per SDG
- [x] Related actions displayed in grid
- [x] Can log action directly from SDG detail
- [x] "Learn Only" SDGs show educational content
- [x] Resources links are clickable

### 4.4 Cosmetic Shop (Deferred)
- [ ] All 5 items visible in shop
- [ ] Purchase deducts points correctly
- [ ] Cannot purchase without sufficient points
- [ ] Owned items appear in inventory
- [ ] Equipped items render on mascot

### 4.5 Mascot Species (Deferred)
- [ ] 3 species visible (1 free, 2 locked)
- [ ] Unlock shows confirmation with cost
- [ ] Points deducted on unlock
- [ ] Can switch between owned species
- [ ] Placeholder images display correctly

### 4.6 Streak Break Cloud Function
- [x] Function deploys successfully
- [x] Runs on schedule (8 PM UTC)
- [x] Sends notifications to at-risk users
- [x] Does not notify users who logged today
- [ ] Logs show execution details (requires prod deploy)

### 4.7 Firebase Analytics
- [x] All defined events tracked (12/12 events)
- [ ] Events visible in Firebase console (requires runtime verification)
- [x] Parameters captured correctly

### 4.8 Firebase Crashlytics
- [ ] Crashes reported to console (requires runtime verification)
- [x] User identifier attached
- [x] Custom keys visible

### 4.9 Legal Compliance
- [x] Privacy policy accessible from app
- [x] Terms of service accessible from app
- [x] Documents rendered in-app (no hosting needed)
- [x] EN/ES/JA versions available
- [x] Links from About screen navigate in-app
- [x] Links from Register screen navigate in-app

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
- `Plan/sdg_indicator_metadata/` contains 17 JSON files (`sdg_goal_01.json` through `sdg_goal_17.json`) with structured UN SDG indicator metadata extracted from official documents. Each file contains targets, indicators, definitions, concepts, classifications, rationale, and custodian agencies for one Goal. Extracted using `../SeedResources/extract_sdg_metadata.py` from the `.docx` files in `../SeedResources/SDG-indicator-metadata/`
- `assets/images/sdg_infographics/` contains `sdg_infographic_1.jpg` through `sdg_infographic_17.jpg` -- one infographic per SDG from the UN SDG Report 2022. These should be displayed in the SDG detail screen or info carousel to give users a visual overview of each goal's global progress
- Cosmetic items should be simple initially; can add more in Phase 6
- Placeholder mascot art is acceptable for soft launch
- Monitor Cloud Function costs after deployment

---

## Known UX Gaps (To Address)

### SDG Display on Actions
**Status:** Partially implemented (Feb 2026)
**Priority:** P1

SDG badges are now shown on action cards in the action library grid as small colored circles with goal numbers. Limits to 4 visible badges with a "+N" overflow indicator.

**Completed:**
- Action card SDG badges with color-coded circles (action_card.dart)

**Still needed:**
- SDG badges in the action confirmation dialog
- SDG info in action history/log entries
- SDG info in the "Your Impact" section

---

*This plan will be updated as implementation progresses.*
