# Phase 9: Premium & Monetization

**Version:** 1.0
**Created:** July 2026 (extracted from PLAN_PHASE_7 v1.1)
**Status:** Planning

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Feature Breakdown](#feature-breakdown)
4. [RevenueCat Integration](#revenuecat-integration)
5. [Premium Tier Definition](#premium-tier-definition)
6. [Paywall UI](#paywall-ui)
7. [Subscription State Management](#subscription-state-management)
8. [Restore Purchases](#restore-purchases)
9. [Premium Features](#premium-features)
10. [Data Models](#data-models)
11. [Implementation Order](#implementation-order)
12. [Testing Strategy](#testing-strategy)
13. [Acceptance Criteria](#acceptance-criteria)
14. [Dependencies](#dependencies)
15. [App Store Requirements](#app-store-requirements)
16. [Pricing Considerations](#pricing-considerations)

---

## Phase Overview

Phase 9 implements premium monetization: RevenueCat subscription
infrastructure, a clear free vs premium split, and the premium-only
features that sit on top of the mascot/shop foundation built in
Phase 7 (see `PLAN_PHASE_7.md`).

This phase transforms the app from a free product to a freemium model
with sustainable revenue potential.

### Key Objectives

- Integrate RevenueCat SDK for subscription management
- Define clear free vs premium feature split
- Build paywall UI with subscription benefits
- Implement premium-only features (streak grace period, exclusive items)
- Handle subscription lifecycle (purchase, restore, cancel, expire)

---

## Goals & Deliverables

### Primary Deliverables

| Deliverable | Description |
|-------------|-------------|
| RevenueCat Integration | SDK setup, entitlements, webhooks |
| Premium Tier | Clear definition of free vs premium |
| Paywall Screen | Subscription purchase UI |
| Restore Purchases | Handle existing subscribers |
| Streak Grace Period | Premium streak recovery feature |
| Premium Cosmetics | Subscriber-exclusive shop items |

---

## Feature Breakdown

### Summary Table

| Feature | Priority | Complexity | Status |
|---------|----------|------------|--------|
| 9.1 RevenueCat Setup | P0 | Medium | Pending |
| 9.2 Entitlements & Products | P0 | Low | Pending |
| 9.3 Premium Tier Definition | P0 | Low | Pending |
| 9.4 Paywall UI | P0 | Medium | Pending |
| 9.5 Subscription State Management | P0 | Medium | Pending |
| 9.6 Restore Purchases | P0 | Low | Pending |
| 9.7 Streak Grace Period | P1 | Medium | Pending |
| 9.8 Premium Cosmetics | P1 | Low | Pending |
| 9.9 Premium Mascot Species | P2 | Low | Pending |

---

## RevenueCat Integration

### 9.1 RevenueCat Setup

**Priority:** P0 | **Complexity:** Medium

Integrate RevenueCat SDK for subscription management.

#### Why RevenueCat?

- Unified API for iOS App Store + Google Play
- Handles receipt validation server-side
- Dashboard for subscription analytics
- Webhook support for server notifications
- Free up to $2,500/month revenue

#### Setup Steps

1. Create RevenueCat account
2. Create project in RevenueCat dashboard
3. Configure App Store Connect (iOS)
4. Configure Google Play Console (Android)
5. Add SDK to Flutter app
6. Initialize SDK with API keys
7. Test sandbox purchases

#### RevenueCat Dashboard Configuration

```
RevenueCat Project: Seed
├── Apps
│   ├── iOS App (com.seedapp)
│   └── Android App (com.seedapp)
├── Products
│   ├── seed_premium_monthly
│   └── seed_premium_yearly
├── Entitlements
│   └── premium
└── Offerings
    └── default
        ├── Monthly Package
        └── Annual Package
```

#### SDK Installation

```yaml
dependencies:
  purchases_flutter: ^9.10.6  # Not yet added to pubspec.yaml
```

#### SDK Initialization

```dart
// lib/shared/services/purchases_service.dart
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesService {
  static const _apiKey = String.fromEnvironment(
    'REVENUECAT_API_KEY',
    defaultValue: '',
  );

  Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug); // Remove in production

    PurchasesConfiguration configuration;
    if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_apiKey);
    } else if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apiKey);
    } else {
      throw UnsupportedError('Platform not supported');
    }

    await Purchases.configure(configuration);
  }

  Future<void> login(String userId) async {
    await Purchases.logIn(userId);
  }

  Future<void> logout() async {
    await Purchases.logOut();
  }
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create RevenueCat account | Sign up at revenuecat.com | Pending |
| Create RevenueCat project | Set up Seed project | Pending |
| Configure iOS app | App Store Connect integration | Pending |
| Configure Android app | Google Play Console integration | Pending |
| Create products | Monthly and yearly subscriptions | Pending |
| Create entitlements | "premium" entitlement | Pending |
| Create offerings | Default offering with packages | Pending |
| Add API keys | iOS and Android keys | Pending |
| Initialize SDK in app | PurchasesService class | Pending |
| Test sandbox mode | Verify purchases work | Pending |

#### Files to Create

```
lib/shared/services/
└── purchases_service.dart

lib/shared/providers/
└── purchases_providers.dart
```

---

### 9.2 Entitlements & Products

**Priority:** P0 | **Complexity:** Low

Configure subscription products and entitlements.

#### Product Configuration

| Product ID | Type | Duration | Price (suggested) |
|------------|------|----------|-------------------|
| `seed_premium_monthly` | Auto-renewable | 1 month | $2.99/month |
| `seed_premium_yearly` | Auto-renewable | 1 year | $19.99/year |

*Yearly = ~$1.67/month, ~44% savings*

#### Entitlements

| Entitlement ID | Description | Granted By |
|----------------|-------------|------------|
| `premium` | Full premium access | Any active subscription |

#### Offerings

```
Offering: default
├── Package: monthly
│   └── Product: seed_premium_monthly
└── Package: annual
    └── Product: seed_premium_yearly
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create App Store products | In App Store Connect | Pending |
| Create Play Store products | In Google Play Console | Pending |
| Map products in RevenueCat | Link to store products | Pending |
| Create premium entitlement | In RevenueCat dashboard | Pending |
| Create default offering | With monthly/annual packages | Pending |
| Configure pricing | Set prices in both stores | Pending |

---

## Premium Tier Definition

### 9.3 Premium Tier Definition

**Priority:** P0 | **Complexity:** Low

Define which features are free vs premium.

#### Feature Matrix

| Feature | Free | Premium |
|---------|------|---------|
| Log actions | ✅ | ✅ |
| View progress | ✅ | ✅ |
| Track streaks | ✅ | ✅ |
| View SDG info | ✅ | ✅ |
| 1 mascot species | ✅ | ✅ |
| Basic cosmetics (earn with points) | ✅ | ✅ |
| Notifications (2 reminders) | ✅ | ✅ |
| CO₂ dashboard | ✅ | ✅ |
| Eco-Dex (full collection) | ✅ | ✅ |
| **Streak grace period** | ❌ | ✅ |
| **Unlimited reminders** | ❌ | ✅ |
| **Premium cosmetics** | ❌ | ✅ |
| **All mascot species** | ❌ | ✅ |
| **Ad-free** (if ads added) | ❌ | ✅ |
| **Priority support** | ❌ | ✅ |

#### Philosophy

- **Free tier should be fully functional** - Users can enjoy the core experience
- **Premium adds convenience and customization** - Not pay-to-win
- **No feature removal** - Free users keep what they have

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Finalize feature matrix | Confirm free vs premium split | Pending |
| Document in app | Help/FAQ about premium | Pending |
| Create premium check utility | `isPremium` helper | Pending |
| Gate premium features | Check entitlement before access | Pending |

---

## Paywall UI

### 9.4 Paywall UI

**Priority:** P0 | **Complexity:** Medium

Build the subscription purchase screen.

#### Paywall Design

```
┌─────────────────────────────────────────┐
│  ×                                      │
├─────────────────────────────────────────┤
│                                         │
│              🌱 Seed Premium            │
│                                         │
│         Unlock the full experience      │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  ✓ Streak grace period                  │
│    Recover from missed days             │
│                                         │
│  ✓ All mascot species                   │
│    Unlock every species in the shop     │
│                                         │
│  ✓ Premium cosmetics                    │
│    Exclusive items for your mascot      │
│                                         │
│  ✓ Unlimited reminders                  │
│    Set as many as you need              │
│                                         │
│  ─────────────────────────────────────  │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  BEST VALUE                     │   │
│  │  Yearly - $19.99/year           │   │
│  │  Just $1.67/month - Save 44%    │   │
│  │  ○                              │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Monthly - $2.99/month          │   │
│  │  ○                              │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │        Subscribe Now            │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Restore Purchases                      │
│                                         │
│  Terms of Service • Privacy Policy      │
│                                         │
└─────────────────────────────────────────┘
```

#### Paywall Triggers

Show paywall when user attempts to:
- Use streak grace period (not subscribed)
- Access premium cosmetic item
- Unlock a locked mascot species
- Add more than 2 notification reminders
- Tap "Go Premium" button in settings

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create PaywallScreen | Full subscription UI | Pending |
| Create BenefitsList widget | Premium features list | Pending |
| Create PricingCard widget | Package selection | Pending |
| Fetch offerings from RevenueCat | Display current prices | Pending |
| Implement purchase flow | Handle purchase result | Pending |
| Handle errors | Show appropriate messages | Pending |
| Add restore purchases button | For existing subscribers | Pending |
| Add legal links | Terms, privacy policy | Pending |
| Localize all strings | EN/ES/JA | Pending |
| Write widget tests | Test UI states | Pending |

#### Files to Create

```
lib/features/premium/
├── premium.dart                         # Barrel file
├── presentation/
│   ├── screens/
│   │   └── paywall_screen.dart
│   ├── widgets/
│   │   ├── benefits_list.dart
│   │   ├── pricing_card.dart
│   │   └── subscription_button.dart
│   └── providers/
│       └── paywall_providers.dart
```

---

## Subscription State Management

### 9.5 Subscription State Management

**Priority:** P0 | **Complexity:** Medium

Manage subscription state throughout the app.

#### State Model

```dart
@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    required bool isPremium,
    required bool isActive,
    String? productId,
    DateTime? expirationDate,
    DateTime? purchaseDate,
    String? managementUrl,
  }) = _SubscriptionState;

  factory SubscriptionState.free() => const SubscriptionState(
    isPremium: false,
    isActive: false,
  );
}
```

#### Provider Architecture

```dart
@riverpod
Stream<SubscriptionState> subscriptionState(Ref ref) {
  return Purchases.customerInfoStream.map((info) {
    final entitlement = info.entitlements.all['premium'];
    return SubscriptionState(
      isPremium: entitlement?.isActive ?? false,
      isActive: entitlement?.isActive ?? false,
      productId: entitlement?.productIdentifier,
      expirationDate: entitlement?.expirationDate,
      purchaseDate: entitlement?.latestPurchaseDate,
      managementUrl: info.managementURL,
    );
  });
}

@riverpod
bool isPremium(Ref ref) {
  return ref.watch(subscriptionStateProvider).valueOrNull?.isPremium ?? false;
}
```

#### Usage in App

```dart
// Check premium status before feature access
class SomeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);

    if (!isPremium) {
      return LockedFeatureCard(
        onTap: () => context.push('/paywall'),
      );
    }

    return PremiumFeatureContent();
  }
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create SubscriptionState model | Freezed model | Pending |
| Create subscriptionStateProvider | Stream from RevenueCat | Pending |
| Create isPremiumProvider | Simple boolean check | Pending |
| Handle subscription changes | React to state updates | Pending |
| Persist state locally | Cache for offline access | Pending |
| Sync with Firestore | Store subscription status | Pending |
| Write unit tests | Test state transitions | Pending |

---

## Restore Purchases

### 9.6 Restore Purchases

**Priority:** P0 | **Complexity:** Low

Handle subscription restoration for returning users.

#### Restore Flow

1. User taps "Restore Purchases"
2. Show loading indicator
3. Call `Purchases.restorePurchases()`
4. Check returned CustomerInfo for active entitlements
5. Update app state if premium restored
6. Show success/failure message

#### Implementation

```dart
Future<bool> restorePurchases() async {
  try {
    final customerInfo = await Purchases.restorePurchases();
    final isPremium = customerInfo.entitlements.all['premium']?.isActive ?? false;

    if (isPremium) {
      // Premium restored successfully
      return true;
    } else {
      // No active subscription found
      return false;
    }
  } on PlatformException catch (e) {
    // Handle error
    return false;
  }
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Implement restore function | In PurchasesService | Pending |
| Add restore button to paywall | With loading state | Pending |
| Add restore option in settings | For existing subscribers | Pending |
| Handle success message | "Subscription restored!" | Pending |
| Handle failure message | "No subscription found" | Pending |
| Write tests | Test restore scenarios | Pending |

---

## Premium Features

### 9.7 Streak Grace Period

**Priority:** P1 | **Complexity:** Medium

Allow premium users to recover from missed streak days.

#### Feature Design

- Premium users get 1 "grace day" per streak
- If user misses a day, streak is preserved (not reset)
- Grace period resets when streak is broken or after successful recovery
- Visual indicator shows grace period status

#### Data Model Updates

```dart
// In AppUserModel
@freezed
class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    // ... existing fields
    @Default(false) bool streakGracePeriodUsed,
    DateTime? gracePeriodActivatedAt,
  }) = _AppUserModel;
}
```

#### Streak Logic Updates

```dart
// In StreakService
(int, int, bool) calculateStreakWithGrace({
  required DateTime? lastActionDate,
  required int currentStreak,
  required int longestStreak,
  required bool isPremium,
  required bool gracePeriodUsed,
  required DateTime now,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final lastDate = lastActionDate != null
      ? DateTime(lastActionDate.year, lastActionDate.month, lastActionDate.day)
      : null;

  if (lastDate == null) {
    return (1, max(1, longestStreak), false);
  }

  final daysDifference = today.difference(lastDate).inDays;

  if (daysDifference == 0) {
    // Already logged today
    return (currentStreak, longestStreak, gracePeriodUsed);
  } else if (daysDifference == 1) {
    // Logged yesterday - continue streak
    final newStreak = currentStreak + 1;
    return (newStreak, max(newStreak, longestStreak), false); // Reset grace
  } else if (daysDifference == 2 && isPremium && !gracePeriodUsed) {
    // Missed 1 day but premium can use grace period
    return (currentStreak, longestStreak, true); // Grace used
  } else {
    // Streak broken
    return (1, longestStreak, false);
  }
}
```

#### UI Updates

- Show grace period badge on streak display when active
- Show "Grace Period Saved Your Streak!" message
- Show grace period status in settings/profile

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Update AppUserModel | Add grace period fields | Pending |
| Update StreakService | Add grace period logic | Pending |
| Create grace period badge | Visual indicator | Pending |
| Add grace recovery message | Notify user when grace used | Pending |
| Show grace status in UI | Profile/settings | Pending |
| Gate behind premium | Check entitlement | Pending |
| Write unit tests | Test all grace scenarios | Pending |

---

### 9.8 Premium Cosmetics

**Priority:** P1 | **Complexity:** Low

Add premium-only cosmetic items to the shop. Builds on the base
shop infrastructure from Phase 7 (§7.3 Cosmetic Shop).

#### Premium Items (5 initial)

| Item | Type | Description |
|------|------|-------------|
| Golden Crown | Hat | Sparkling golden crown |
| Rainbow Trail | Accessory | Colorful trailing effect |
| Aurora Background | Background | Northern lights scene |
| Starfield Background | Background | Night sky with stars |
| Diamond Badge | Accessory | Premium member badge |

#### Implementation

Add `isPremium` flag to CosmeticItemModel:

```dart
@freezed
class CosmeticItemModel with _$CosmeticItemModel {
  const factory CosmeticItemModel({
    // ... existing fields
    @Default(false) bool isPremiumOnly,  // NEW
  }) = _CosmeticItemModel;
}
```

#### Shop UI Updates

- Show lock icon on premium items for free users
- Tapping locked item shows paywall
- Premium users see items without lock

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Update CosmeticItemModel | Add isPremiumOnly field | Pending |
| Create 5 premium item SVGs | Art assets | Pending |
| Seed premium items | Add to Firestore | Pending |
| Update shop UI | Show lock for free users | Pending |
| Gate purchase behind premium | Check entitlement | Pending |
| Write tests | Test premium item access | Pending |

---

### 9.9 Premium Mascot Species

**Priority:** P2 | **Complexity:** Low

Make additional mascot species premium-only (alternative to point
unlock). Builds on the base unlock system from Phase 7 (§7.4
Mascot Species Unlocking).

#### Options

Coral is confirmed as species 2 (shipped in Phase 7); Species 3
is locked when the designer selects from the candidate set in
`PLAN_DESIGNER.md` §4.2.

**Option A: All species free (with points)**
- Sprout: Free (starter)
- Coral: 3,000 points
- Species 3: 5,000 points

**Option B: Premium species**
- Sprout: Free (starter)
- Coral: Premium only
- Species 3: Premium only

**Option C: Hybrid**
- Sprout: Free (starter)
- Coral: 3,000 points OR premium
- Species 3: Premium only

**Recommended:** Option A for soft launch (more accessible), consider Option C later.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Decide on species access model | Points vs premium | Pending |
| Update MascotSpeciesModel if needed | Add premium flag | Pending |
| Update unlock UI | Show premium option | Pending |
| Gate behind premium if applicable | Check entitlement | Pending |

---

## Data Models

### Subscription State

```dart
@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    required bool isPremium,
    required bool isActive,
    String? productId,
    DateTime? expirationDate,
    DateTime? purchaseDate,
    String? managementUrl,
    @Default(false) bool isInTrial,
    @Default(false) bool willRenew,
  }) = _SubscriptionState;

  factory SubscriptionState.free() => const SubscriptionState(
    isPremium: false,
    isActive: false,
  );
}
```

### Package Display Model

```dart
@freezed
class PackageDisplay with _$PackageDisplay {
  const factory PackageDisplay({
    required String id,
    required String title,
    required String priceString,
    required String period,
    String? savings,
    @Default(false) bool isBestValue,
  }) = _PackageDisplay;
}
```

---

## Implementation Order

### Recommended Sequence

```
Stage 9.1: RevenueCat Foundation
├── Create RevenueCat account and project
├── Configure iOS in App Store Connect
├── Configure Android in Google Play Console
├── Create products and entitlements
├── Add SDK to app
├── Initialize SDK
└── Test sandbox purchases

Stage 9.2: Subscription State
├── Create SubscriptionState model
├── Create subscription providers
├── Create isPremium helper
├── Cache state locally
└── Write unit tests

Stage 9.3: Paywall UI
├── Create PaywallScreen
├── Create pricing card widgets
├── Fetch offerings from RevenueCat
├── Implement purchase flow
├── Add restore purchases
├── Add legal links
└── Write widget tests

Stage 9.4: Premium Feature - Streak Grace
├── Update AppUserModel
├── Update StreakService with grace logic
├── Create grace period UI indicators
├── Gate behind premium
└── Write unit tests

Stage 9.5: Premium Feature - Cosmetics
├── Add isPremiumOnly flag to CosmeticItemModel
├── Create premium item art
├── Seed premium items
├── Update shop UI for premium items
└── Write tests

Stage 9.6: Premium Feature - Mascot Species
├── Decide on access model (points vs premium)
├── Update MascotSpeciesModel if premium tier added
├── Update unlock UI with premium option
└── Write tests

Stage 9.7: Polish & Testing
├── End-to-end purchase testing
├── Subscription lifecycle testing
├── Localization
├── Bug fixes
└── Documentation updates
```

---

## Testing Strategy

### Unit Tests

| Component | Test File | Key Scenarios |
|-----------|-----------|---------------|
| PurchasesService | `purchases_service_test.dart` | Init, login, logout |
| SubscriptionState | `subscription_state_test.dart` | State transitions |
| Streak grace period | `streak_grace_test.dart` | All grace scenarios |
| Premium check | `premium_check_test.dart` | Access control |

### Widget Tests

| Widget | Test File | Key Scenarios |
|--------|-----------|---------------|
| PaywallScreen | `paywall_screen_test.dart` | Display, selection, purchase |
| PricingCard | `pricing_card_test.dart` | Selected/unselected states |
| Premium lock | `premium_lock_test.dart` | Locked/unlocked display |

### Integration Tests

| Flow | Test File | Scenarios |
|------|-----------|-----------|
| Purchase flow | `purchase_flow_test.dart` | Select → purchase → access |
| Restore flow | `restore_flow_test.dart` | Restore → verify access |
| Grace period | `grace_period_flow_test.dart` | Miss day → grace → recover |

### Sandbox Testing

- Use sandbox accounts on iOS and Android
- Test all purchase scenarios
- Test restore on fresh install
- Test subscription expiration
- Test upgrade/downgrade (if applicable)

---

## Acceptance Criteria

### 9.1-9.2 RevenueCat Setup
- [ ] RevenueCat project configured
- [ ] iOS products created in App Store Connect
- [ ] Android products created in Google Play Console
- [ ] Products mapped in RevenueCat
- [ ] Entitlements configured
- [ ] SDK initializes without errors

### 9.3 Premium Tier
- [ ] Feature matrix documented
- [ ] Premium check utility works
- [ ] Free features remain accessible
- [ ] Premium features properly gated

### 9.4 Paywall UI
- [ ] Paywall displays correctly
- [ ] Offerings load from RevenueCat
- [ ] Package selection works
- [ ] Purchase flow completes
- [ ] Error handling works
- [ ] Restore purchases works
- [ ] Legal links navigate correctly

### 9.5 Subscription State
- [ ] State updates on purchase
- [ ] State persists across app restarts
- [ ] State syncs with RevenueCat
- [ ] isPremium check accurate

### 9.6 Restore Purchases
- [ ] Restore button visible
- [ ] Restore recovers subscription
- [ ] Success/failure messages shown

### 9.7 Streak Grace Period
- [ ] Grace period saves streak for premium
- [ ] Grace period not available for free
- [ ] Grace period resets correctly
- [ ] UI shows grace status

### 9.8 Premium Cosmetics
- [ ] Premium items show lock for free users
- [ ] Premium items accessible for subscribers
- [ ] Paywall shows when tapping locked item

### 9.9 Premium Mascot Species
- [ ] Access model decided (points vs premium vs hybrid)
- [ ] Premium-gated species (if any) show paywall on tap
- [ ] Free/point-unlock paths still work for non-premium species

---

## Dependencies

### External Dependencies

- RevenueCat account
- App Store Connect access (iOS)
- Google Play Console access (Android)

### Internal Dependencies

- Phase 7 complete: cosmetic shop (§7.3) and species unlocking
  (§7.4) provide the surfaces that premium extends
- Streak service ready for grace period updates

---

## App Store Requirements

### iOS

- Subscriptions must be reviewed by Apple
- Must include restore purchases button
- Must link to Terms and Privacy Policy
- Must clearly describe subscription terms
- Must handle subscription management URL

### Android

- Subscriptions must be published in Play Console
- Must handle billing library responses
- Must support subscription lifecycle
- Must comply with Play billing policies

---

## Pricing Considerations

### Suggested Pricing

| Package | US | Japan | Europe |
|---------|-----|-------|--------|
| Monthly | $2.99 | ¥400 | €2.99 |
| Yearly | $19.99 | ¥2,800 | €19.99 |

*Yearly offers ~44% savings over monthly*

### Free Trial Option

Consider offering 7-day free trial to reduce friction:
- User experiences premium features
- Converts to paid after trial
- Configure in App Store Connect / Play Console

---

## Notes

- RevenueCat free tier supports up to $2,500/month revenue
- Test subscription flows thoroughly in sandbox
- Keep free tier fully functional to avoid negative reviews
- Premium should feel like "nice to have" not "pay to win"

---

*This plan will be updated as implementation progresses.*
