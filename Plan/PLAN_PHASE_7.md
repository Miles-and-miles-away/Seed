# Phase 7: Mascot Art & Shop

**Version:** 1.3
**Created:** January 2026
**Updated:** August 2026 (7.5 mascot storage migration recorded as
deferred, from the security re-verification pass)
**Status:** In Progress (7.1/7.2 underway -- Coral shipped as animated Rive)

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Feature Breakdown](#feature-breakdown)
4. [Mascot Art](#mascot-art)
5. [Cosmetic Shop](#cosmetic-shop)
6. [Mascot Species Unlocking](#mascot-species-unlocking)
7. [Mascot Storage Migration](#mascot-storage-migration)
8. [Implementation Order](#implementation-order)
9. [Testing Strategy](#testing-strategy)
10. [Acceptance Criteria](#acceptance-criteria)
11. [Dependencies](#dependencies)

---

## Phase Overview

Phase 7 covers the mascot experience: final artwork for all 3
mascot species across 4 evolution stages, a points-based cosmetic
shop, and species unlocking. Everything here is earnable with
points -- no payment required.

Premium monetization (RevenueCat, paywall, premium-only items)
was split out to `PLAN_PHASE_9.md`; it extends the shop and
unlock systems built in this phase.

### Key Objectives

- Replace 12 placeholder mascot images with final art (3 species × 4 stages)
- Build the cosmetic shop (browse, buy with points, equip)
- Add species unlocking with point costs

---

## Goals & Deliverables

### Primary Deliverables

| Deliverable | Description |
|-------------|-------------|
| Final Mascot Art | 12 polished, animated mascot stages (Rive) |
| Cosmetic Shop | Browse/purchase/equip items with points |
| Species Unlocking | 3 species, point-based unlocks |

---

## Feature Breakdown

### Summary Table

| Feature | Priority | Complexity | Status |
|---------|----------|------------|--------|
| 7.1 Mascot Art Creation | P0 | High (art) | In Progress (Coral done) |
| 7.2 Mascot Art Integration | P0 | Low | In Progress (Coral done) |
| 7.3 Cosmetic Shop | P0 | Medium | Pending |
| 7.4 Mascot Species Unlocking | P0 | Low | Pending |
| 7.5 Mascot Storage Migration | Deferred | High | Accepted by design |

---

## Mascot Art

### 7.1 Mascot Art Creation

**Priority:** P0 | **Complexity:** High (art creation)

Create final artwork for all mascot species and evolution stages.

#### Art Requirements

Minimum 3 species × 4 stages = 12 assets. Sprout (currently
`seed` in `data/app/mascot_species.json`) is locked in as the
free starter. Coral is confirmed as species 2 and its 4 stages
have shipped. Species 3 is selected by the designer from the
candidate set in `PLAN_DESIGNER.md` §4.2 (Funghi, Breeze, Terra,
Bloom, Dewdrop), or a designer proposal that fits the
sustainability theme.

| Species | Stage 1 | Stage 2 | Stage 3 | Stage 4 | Status |
|---------|---------|---------|---------|---------|--------|
| Seed/Sprout (Plant) — confirmed starter | Seed | Sprout | Sapling | Tree | Placeholder SVGs |
| Coral (Ocean) — confirmed | Polyp | Colony | Reef | Ecosystem | **Done (animated Rive)** |
| Species 3 — TBD | — | — | — | — | Pending |

#### Art Style Guidelines

- **Format:** Rive (`.riv`, one artboard per stage) for final
  animated mascots; SVG acceptable for placeholders
- **Style:** Cute, friendly, approachable (kawaii-inspired) --
  see `Plan/STYLE_GUIDE.md`
- **Colors:** Match SDG/sustainability themes
- **Consistency:** Same style across all species and stages
- **Interactivity:** Authored idle motion plus a data-bound face
  rig (`lookX`/`lookY` gaze, `smile` trigger) per stage

#### AI Art Workflow (used for Coral)

1. Generate stage concepts (AI), split into layered body parts
2. Vectorize parts (vectorizer.ai) and optimize (svgo)
3. Author face SVG separately per the face design rules
4. Assemble and rig in Rive: one artboard per stage, idle
   animation, face view model (`lookX`/`lookY`/`smile`)
5. Export a single `.riv` containing all stages

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Define art brief | Style guide, color palette, references | Done (`Plan/STYLE_GUIDE.md`) |
| Generate Coral art | Stage 1-4, rigged and animated in Rive | Done |
| Generate Sprout art | Stage 1-4 (confirmed starter) | Pending (placeholder SVGs in app) |
| Generate Species 3 concepts | Stage 1-4 (designer-selected) | Pending |
| Review and iterate | Get feedback, refine | Ongoing |

---

### 7.2 Mascot Art Integration

**Priority:** P0 | **Complexity:** Low

Replace placeholder images with final art in the app.

#### Current State (July 2026)

- **Coral: done.** All 4 stages ship as animated Rive artboards
  in `assets/animations/coral_mascot.riv`, declared per stage via
  `assetPath` + `artboardName` in `data/app/mascot_species.json`.
- `MascotImage` dispatches on extension: `.riv` renders through
  the Rive runtime (shared file-loader cache), anything else
  falls back to static SVG.
- Interactive face wired through Rive data binding in
  `MascotDisplay`: eyes follow the user's touch anywhere on
  screen (`lookX`/`lookY`), and the mascot smiles when the
  action button is pressed (`smile` trigger from `MainShell`).
- Rive mascots use their authored idle motion; the Flutter-side
  float/idle animation only applies to SVG mascots.
- Seed/Sprout still uses placeholder SVGs
  (`assets/images/mascot/seed_stage*.svg`).

#### Remaining Integration Steps

1. Add final Sprout art (and Species 3 later) following the
   Coral pattern: one `.riv` per species, artboard per stage
2. Update `data/app/mascot_species.json` + pubspec assets
3. Test rendering at all sizes and evolution transitions

#### File Structure

```
assets/animations/
├── coral_mascot.riv       # Done: artboards Coral_stage1..4
└── sprout_mascot.riv      # Pending
assets/images/mascot/
└── seed_stage1..4.svg     # Placeholder SVGs (to be replaced)
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Rive rendering support | `MascotImage` .riv/.svg dispatch, loader cache | Done |
| Interactive face bindings | Gaze follow + smile trigger via view model | Done |
| Integrate Coral art | 4 animated stages wired to species data | Done |
| Test Coral displays | Home, detail, selection, celebrations | Done |
| Integrate Sprout final art | Replace placeholder SVGs | Pending |
| Integrate Species 3 art | After designer selection | Pending |
| Test on multiple devices | Different screen sizes | Pending |

---

## Cosmetic Shop

### 7.3 Cosmetic Shop

**Priority:** P0 | **Complexity:** Medium

Implement a shop where users can purchase cosmetic items with
points. Phase 9 (§9.8) later extends it with subscriber-only
items.

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
    required String imageUrl,       // SVG URL
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
+-----------------------------------------+
|  <-          Shop           1,250 pts   |
+-----------------------------------------+
|                                         |
|  ------- Hats -------                   |
|  +---------+ +---------+                |
|  | Party   | | Leaf    |                |
|  | Hat     | | Crown   |                |
|  | 200 pts | | 300 pts |                |
|  +---------+ +---------+                |
|                                         |
|  ------- Accessories -------            |
|  +---------+                            |
|  | Tiny    |                            |
|  | Shades  |                            |
|  | 150 pts |                            |
|  +---------+                            |
|                                         |
|  ------- Backgrounds -------            |
|  +---------+ +---------+                |
|  | Forest  | | Ocean   |                |
|  | 400 pts | | 400 pts |                |
|  +---------+ +---------+                |
|                                         |
+-----------------------------------------+
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
+-- shop.dart                           # Barrel file
+-- data/
|   +-- models/
|   |   +-- cosmetic_item_model.dart
|   |   +-- user_cosmetics_model.dart
|   +-- datasources/
|   |   +-- shop_remote_datasource.dart
|   +-- repositories/
|       +-- shop_repository.dart
+-- presentation/
    +-- providers/
    |   +-- shop_providers.dart
    +-- screens/
    |   +-- shop_screen.dart
    |   +-- owned_items_screen.dart
    +-- widgets/
        +-- shop_item_card.dart
        +-- item_detail_sheet.dart
        +-- equipped_items_preview.dart
```

---

## Mascot Species Unlocking

### 7.4 Mascot Species Unlocking

**Priority:** P0 | **Complexity:** Low

Add 2 additional mascot species (3 total) with point-based
unlocking. Ships alongside the final mascot art (7.1/7.2);
whether any species also becomes premium-gated is decided in
Phase 9 (§9.9).

#### Current State

- 2 species in app data: Seed/Sprout (placeholder SVGs) and
  Coral (animated Rive), both freely selectable
- No unlocking mechanism

#### Target State

- 3 mascot species total
- First species free (starter)
- Additional species unlockable with points
- Final art ships with 7.1/7.2; placeholders acceptable until then

#### Species Data

| Species | Unlock Cost | Description |
|---------|-------------|-------------|
| Sprout | Free | Plant-based mascot (existing, confirmed) |
| Coral | 3,000 pts | Ocean mascot (art shipped) |
| Species 3 | 5,000 pts | Designer-selected (see PLAN_DESIGNER.md §4.2) |

*Point costs designed to require sustained engagement*

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Update MascotSpeciesModel | Add unlockCost, isUnlocked fields | Pending |
| Create species unlock provider | Check if user can unlock | Pending |
| Create species selection screen | Show locked/unlocked species | Pending |
| Implement unlock purchase | Deduct points, unlock species | Pending |
| Create Species 3 placeholder SVGs | 4 images until final art lands | Pending |
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

## Mascot Storage Migration

### 7.5 Mascot Storage Migration (Deferred)

**Status:** Not started. Accepted by design, with a revisit trigger.
Raised as H3 in the 2026-03-14 security audit and re-verified
2026-08-21; see [SECURITY_REPORT.md](./SECURITY_REPORT.md).

#### Why this exists

`mascots` is a list of maps on the user document. Firestore rules
can bound its length but cannot validate its contents, because the
rules language has no iteration: no loop, no map, no filter, no
recursion. List support stops at `size()`, `hasAll()`, `hasAny()`,
`hasOnly()`, and positional indexing. Validating each element of a
variable-length list of maps is only reachable by hand-unrolling 20
guarded index blocks, which is worse than the problem it solves.

So a tampered client can currently write arbitrary `mascotLevel`,
`mascotPoints`, or `co2SavedGrams` into any mascot entry. The rules
cap the array at 20 entries and nothing else.

The real fix is structural: move mascots off the user document into
a subcollection, where per-document rules validate each mascot the
same way `actionLog`, `customActions`, and `dailySummaries` already
are. Those three are the working precedent to copy.

#### What the migration touches

| Area | Detail |
|------|--------|
| `mascot_repository.dart` | 8 sites across 5 methods: `addMascot` (arrayUnion), `updateMascotInArray`, `updateLastSeenStage`, `updateMascotName` (all read-modify-write in a transaction), `selectMascot` (whole-array overwrite) |
| `action_log_repository.dart` | 6 sites, all inside `logAction` |
| `AppUserModel` | `mascots` is a field on the user model; removing it changes the user doc shape |
| Firestore rules | New subcollection match block plus per-field validation; drop the array clause from `userFieldsOk` |
| Data migration | Backfill every existing user's array into subcollection documents |
| Tests | 6 test files reference the array |

The blocker is `logAction`. It currently writes mascot progression
in the same single-document update as points, level, and streak, so
the whole thing is atomic for free. A subcollection splits that into
a multi-document transaction. That is the highest-risk path in the
app and the reason this is deferred rather than scheduled.

#### Why deferred

- Users are isolated today. Leaderboards ship nowhere and are
  listed only as optional post-launch work in
  [PLAN_MASTER.md](./PLAN_MASTER.md).
- This deferral is consistent with a standing decision, not an
  ad-hoc excuse. PLAN_MASTER already defers server-authoritative
  scoring on the same condition: it "stays deferred until
  leaderboards or any cross-user feature is planned". Mascot
  validation is the same trade under the same trigger.
- A tampered mascot level is visible only to the user who tampered
  with it. There is no other player to gain an advantage over.
- Cosmetics in 7.3 are bought with points, but user-level points
  *are* validated in rules: deltas are checked against the action
  library, logs are immutable, and submissions are rate limited.
  Inflating a mascot does not buy anything.
- The cost is rewriting the atomic scoring transaction plus a
  backfill, against an exposure of self-cheating in a
  single-player game.

#### Revisit trigger

Leaderboards or any cross-user feature, matching the trigger
PLAN_MASTER already sets for server-authoritative scoring. In
practice: anything that makes one user's mascot state visible or
comparable to another's, including friend lists, sharing, public
profiles, or challenges scored between users. At that point do this
migration rather than trying to patch the rules, because the rules
cannot express the check. Expect to do it alongside the
server-authoritative scoring work, since both unlock on the same
condition and both touch `logAction`.

#### Tasks (only if triggered)

| Task | Detail | Status |
|------|--------|--------|
| Add subcollection rules | Per-field validation, copy the `customActions` block | Not started |
| Move writes off the array | 14 sites across 2 repositories | Not started |
| Rework `logAction` atomicity | Multi-document transaction, user doc plus mascot docs | Not started |
| Remove `mascots` from `AppUserModel` | Changes user doc shape | Not started |
| Backfill script | Array to subcollection docs for every existing user | Not started |
| Update tests | 6 Dart test files plus rules tests | Not started |

#### Files to Modify

- `firestore.rules`
- `lib/features/mascot/data/repositories/mascot_repository.dart`
- `lib/features/actions/data/repositories/action_log_repository.dart`
- `lib/features/auth/data/models/app_user_model.dart`
- `lib/features/mascot/presentation/providers/mascot_providers.dart`
- `test/firestore/firestore.rules.test.js`
- `scripts/migrate_mascots_to_subcollection.js` (create)

#### Verification

- Rules tests assert a client cannot write an arbitrary
  `mascotLevel`, `mascotPoints`, or `co2SavedGrams`.
- A test asserts `logAction` still applies points and mascot
  progression atomically, and that a failure part-way leaves
  neither applied.
- Backfill is idempotent and has a dry-run mode.
- `flutter analyze` clean; `flutter test` and `npm run test:rules`
  green.

---

## Implementation Order

### Recommended Sequence

```
Stage 7.1: Mascot Art
├── Define art brief and style guide          [DONE]
├── Generate/create Coral art (4 stages)      [DONE - animated Rive]
├── Integrate Coral into app                  [DONE - incl. face rig]
├── Generate/create Sprout art (4 stages)     [PENDING]
├── Generate/create Species 3 art (4 stages)  [PENDING]
└── Test all displays and animations          [Coral done]

Stage 7.2: Cosmetic Shop (base)
├── Create CosmeticItemModel + UserCosmeticsModel
├── Create CosmeticsRepository + providers
├── Build ShopScreen, ItemDetailSheet, OwnedItemsScreen
├── Implement purchase + equip/unequip
├── Render equipped items on mascot
├── Seed 5 cosmetic items
└── Write tests

Stage 7.3: Mascot Species Unlocking (base)
├── Update MascotSpeciesModel with unlockCost
├── Create species unlock provider
├── Update mascot selection screen with locked/unlocked states
├── Implement point-based unlock purchase
├── Add "Change Mascot" option
└── Write tests
```

---

## Testing Strategy

| Component | Test File | Key Scenarios |
|-----------|-----------|---------------|
| Shop repository | `shop_repository_test.dart` | Purchase, insufficient points, equip |
| Shop screen | `shop_screen_test.dart` | Browse, item detail, purchase flow |
| Species unlock | `species_unlock_test.dart` | Unlock, point deduction, switching |
| Mascot rendering | `mascot_image_test.dart` | .riv/.svg dispatch (exists) |

---

## Acceptance Criteria

### 7.1-7.2 Mascot Art
- [x] Coral: all 4 stages created, rigged, and animated (Rive)
- [x] Coral: interactive face (gaze follows touch, smile on
      action button)
- [x] Coral renders correctly in app across all displays
- [ ] Sprout: 4 final stages (placeholder SVGs in app today)
- [ ] Species 3: 4 stages (designer-selected)
- [ ] Art matches consistent style across species
- [ ] Evolution animations work across all species

### 7.3 Cosmetic Shop
- [ ] All 5 items visible in shop
- [ ] Purchase deducts points correctly
- [ ] Cannot purchase without sufficient points
- [ ] Owned items appear in inventory
- [ ] Equipped items render on mascot

### 7.4 Mascot Species Unlocking
- [ ] 3 species visible (1 free, 2 locked)
- [ ] Unlock shows confirmation with cost
- [ ] Points deducted on unlock
- [ ] Can switch between owned species
- [ ] Placeholder images display correctly until final art lands

---

## Dependencies

### External Dependencies

- Art creation tools (AI generation, vectorizer.ai, svgo, Rive editor)
- Designer selection of Species 3

### Downstream

- Phase 9 (Premium & Monetization) extends the shop with
  premium-only cosmetics (§9.8) and may premium-gate species
  unlocks (§9.9)

---

## Notes

- Coral shipped AI-generated + vectorized + Rive-rigged; reuse
  the same pipeline for Sprout and Species 3
- Keep placeholder art acceptable for unlock UI until final art
  lands

---

*This plan will be updated as implementation progresses.*
