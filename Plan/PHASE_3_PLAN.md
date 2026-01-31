# Phase 3: Engagement & Settings - Detailed Implementation Plan

**Version:** 1.2
**Created:** January 2026
**Last Updated:** January 2026
**Status:** In Progress (~98% Complete)

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
11. [Platform-Specific Setup](#platform-specific-setup)
12. [Risk Mitigation](#risk-mitigation)

---

## Phase Overview

Phase 3 transforms Seed from a functional habit tracker into an engaging daily companion. This phase adds the features that drive habit formation: customizable reminders, streak tracking with milestones, and comprehensive user settings for global availability.

### Key Objectives
- Build complete Settings feature from scratch
- Implement local notifications with smart logic
- Add FCM push notifications for re-engagement
- Activate streak tracking with weekly milestones
- Enable account management (email change, password change, delete account)
- Support multiple daily reminders with customizable times
- Add streak break notifications to encourage consistency

### Why This Phase Matters
> **Habit formation requires timely reminders and visible progress.** Phase 3 provides the engagement layer that converts casual users into daily active users through well-timed nudges and streak psychology.

---

## Current Status

### Settings Feature - ✅ COMPLETE
| Component | Status | Location |
|-----------|--------|----------|
| UserSettingsModel (Freezed) | ✅ Done | `lib/features/settings/data/models/user_settings_model.dart` |
| NotificationScheduleModel (Freezed) | ✅ Done | `lib/features/settings/data/models/notification_schedule_model.dart` |
| SettingsRemoteDatasource | ✅ Done | `lib/features/settings/data/datasources/settings_remote_datasource.dart` |
| SettingsRepository | ✅ Done | `lib/features/settings/data/repositories/settings_repository.dart` |
| Settings Providers | ✅ Done | `lib/features/settings/presentation/providers/settings_providers.dart` |
| SettingsScreen (main hub) | ✅ Done | `lib/features/settings/presentation/screens/settings_screen.dart` |
| NotificationSettingsScreen | ✅ Done | `lib/features/settings/presentation/screens/notification_settings_screen.dart` |
| LanguageSettingsScreen (EN/ES/JP) | ✅ Done | `lib/features/settings/presentation/screens/language_settings_screen.dart` |
| AccountSettingsScreen | ✅ Done | `lib/features/settings/presentation/screens/account_settings_screen.dart` |
| Settings widgets (section, tile, reminder) | ✅ Done | `lib/features/settings/presentation/widgets/` |
| Settings barrel file | ✅ Done | `lib/features/settings/settings.dart` |

### Notification System - ✅ COMPLETE
| Component | Status | Location |
|-----------|--------|----------|
| NotificationService (local) | ✅ Done | `lib/shared/services/notification_service.dart` |
| FCMService (push) | ✅ Done | `lib/shared/services/fcm_service.dart` |
| Notification Providers | ✅ Done | `lib/shared/providers/notification_providers.dart` |
| NotificationScheduler (auto-reschedule) | ✅ Done | `lib/shared/providers/notification_providers.dart` |
| Smart reminders logic | ✅ Done | `shouldShowSmartReminder` provider |
| Multiple reminder support (up to 5) | ✅ Done | Settings UI + service |

### Streak Tracking - ✅ COMPLETE
| Component | Status | Location |
|-----------|--------|----------|
| Streak fields in AppUserModel | ✅ Done | `currentStreak`, `longestStreak`, `lastActionDate` |
| Streak UI on Profile screen | ✅ Done | Profile stats card |
| Streak UI on Home screen | ✅ Done | Mascot quick stats |
| Milestone tracking fields | ✅ Done | `seenStreakMilestones` in UserSettingsModel |
| Streak calculation service | ✅ Done | `lib/shared/services/streak_service.dart` |
| Streak update on action log | ✅ Done | Integrated in `action_log_repository.dart` |
| Streak milestone dialogs | ✅ Done | `lib/features/settings/presentation/widgets/streak_milestone_dialog.dart` |
| Streak broken notification | ⏳ Deferred | Push notification deferred to Phase 4 (requires Cloud Functions) |

### Platform Setup - ✅ COMPLETE
| Component | Status | Notes |
|-----------|--------|-------|
| iOS AppDelegate.swift | ✅ Done | FCM token registration, notification delegate |
| iOS Info.plist | ✅ Done | Background modes (fetch, remote-notification) |
| Android AndroidManifest.xml | ✅ Done | All permissions + receivers configured |
| main.dart initialization | ✅ Done | NotificationService + FCMService initialized |

### Summary
| Area | Completeness |
|------|--------------|
| Settings Feature | 100% |
| Notification System | 100% |
| Streak Tracking | 100% |
| Platform Setup | 100% |
| Unit & Widget Tests | 100% (256 tests) |
| **Overall Phase 3** | **~98%** |

> **Note:** Streak break push notification deferred to Phase 4 (requires Cloud Functions).

---

## Goals & Deliverables

### Primary Deliverable
> A complete settings system with smart notifications that remind users to log actions, track streaks with weekly milestones, and provide full account management for global app store compliance.

---

## Technical Architecture

### Feature Module Structure

```
lib/features/settings/
├── settings.dart                              # Barrel file (public API)
├── data/
│   ├── datasources/
│   │   └── settings_remote_datasource.dart    # Firestore settings operations
│   ├── models/
│   │   ├── user_settings_model.dart           # Settings data model
│   │   ├── user_settings_model.freezed.dart   # Generated
│   │   ├── user_settings_model.g.dart         # Generated
│   │   ├── notification_schedule_model.dart   # Multiple reminder times
│   │   ├── notification_schedule_model.freezed.dart
│   │   └── notification_schedule_model.g.dart
│   └── repositories/
│       └── settings_repository.dart           # Data access layer
├── domain/
│   └── services/
│       ├── notification_service.dart          # flutter_local_notifications wrapper
│       ├── fcm_service.dart                   # Firebase Cloud Messaging wrapper
│       └── streak_service.dart                # Streak calculation logic
└── presentation/
    ├── providers/
    │   ├── settings_providers.dart            # Riverpod providers
    │   └── settings_providers.g.dart          # Generated
    ├── screens/
    │   ├── settings_screen.dart               # Main settings hub
    │   ├── notification_settings_screen.dart  # Notification preferences
    │   ├── language_settings_screen.dart      # Language switching
    │   ├── account_settings_screen.dart       # Email, password, delete
    │   ├── about_screen.dart                  # Version, legal links
    │   ├── privacy_policy_screen.dart         # Placeholder
    │   └── terms_of_service_screen.dart       # Placeholder
    └── widgets/
        ├── settings_section.dart              # Section header widget
        ├── settings_tile.dart                 # Reusable settings row
        ├── time_picker_tile.dart              # Notification time picker
        ├── reminder_list_tile.dart            # Individual reminder item
        ├── streak_milestone_dialog.dart       # Weekly celebration
        └── delete_account_dialog.dart         # Confirmation dialog
```

### Shared Services Structure

```
lib/shared/
├── services/
│   ├── notification_service.dart              # Singleton notification service
│   └── services.dart                          # Barrel file
└── providers/
    ├── notification_providers.dart            # Notification state
    └── providers.dart                         # Updated barrel file
```

### Provider Architecture

```dart
// Core providers (lib/features/settings/presentation/providers/settings_providers.dart)

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  // Manages all user settings mutations
  Future<void> updateLanguage(String language);
  Future<void> updateNotificationsEnabled(bool enabled);
  Future<void> addReminderTime(TimeOfDay time);
  Future<void> removeReminderTime(int index);
  Future<void> updateSmartReminders(bool enabled);
}

@riverpod
Stream<UserSettingsModel> userSettings(Ref ref) {
  // Streams user settings from Firestore
}

@riverpod
Future<bool> notificationPermissionStatus(Ref ref) {
  // Checks if notification permissions are granted
}

// Notification providers (lib/shared/providers/notification_providers.dart)

@riverpod
NotificationService notificationService(Ref ref) {
  // Singleton notification service
}

@riverpod
Future<void> scheduleNotifications(Ref ref) {
  // Schedules all user reminders
}

// Streak providers (extend existing profile_providers.dart)

@riverpod
int currentStreakWeeks(Ref ref) {
  // Calculates streak in weeks for milestone tracking
}

@riverpod
bool shouldShowStreakMilestone(Ref ref) {
  // Detects weekly milestone crossings
}
```

### Navigation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      Profile Screen                          │
│                           │                                  │
│                    [Settings Button]                         │
│                           │                                  │
│                           ▼                                  │
│              ┌─────────────────────────┐                    │
│              │     Settings Screen     │                    │
│              │                         │                    │
│              │  ┌─────────────────┐   │                    │
│              │  │ Notifications   │───┼──▶ NotificationSettingsScreen
│              │  ├─────────────────┤   │                    │
│              │  │ Language        │───┼──▶ LanguageSettingsScreen
│              │  ├─────────────────┤   │                    │
│              │  │ Account         │───┼──▶ AccountSettingsScreen
│              │  ├─────────────────┤   │        │           │
│              │  │ About           │───┼──▶ AboutScreen     │
│              │  └─────────────────┘   │        │           │
│              └─────────────────────────┘        │           │
│                                                 ▼           │
│                                    ┌─────────────────┐      │
│                                    │ PrivacyPolicy   │      │
│                                    │ TermsOfService  │      │
│                                    │ DeleteAccount   │      │
│                                    └─────────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Models

### UserSettingsModel (Notification & App Settings)

```dart
@freezed
abstract class UserSettingsModel with _$UserSettingsModel {
  const factory UserSettingsModel({
    @Default(true) bool notificationsEnabled,
    @Default([]) List<NotificationScheduleModel> reminderSchedules,
    @Default(true) bool smartRemindersEnabled,  // Only notify if no action today
    @Default('en') String language,
    @Default(false) bool hasSeenOnboarding,
    @Default({}) Map<int, bool> seenStreakMilestones, // week number -> seen
    @Default(false) bool streakGracePeriodUsed,  // Phase 4 foundation
  }) = _UserSettingsModel;

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);
}
```

### NotificationScheduleModel (Individual Reminder)

```dart
@freezed
abstract class NotificationScheduleModel with _$NotificationScheduleModel {
  const factory NotificationScheduleModel({
    required String id,              // UUID for identification
    required int hour,               // 0-23
    required int minute,             // 0-59
    @Default(true) bool isEnabled,   // Can disable individual reminders
    @Default('') String label,       // Optional custom label
  }) = _NotificationScheduleModel;

  factory NotificationScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleModelFromJson(json);
}
```

### AppUserModel Updates

```dart
@freezed
abstract class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    // ... existing fields ...
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(0) int points,
    @Default(1) int level,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default('en') String language,
    @Default('09:00') String notificationTime,  // Keep for backwards compatibility
    @TimestampConverter() DateTime? createdAt,
    @Default(false) bool emailVerified,
    int? dailyGoalTarget,
    MascotModel? mascot,

    // NEW Phase 3 fields
    @Default(true) bool notificationsEnabled,
    @TimestampConverter() DateTime? lastActionDate,  // For streak calculation
    @Default(false) bool streakGracePeriodAvailable, // Phase 4 foundation
    String? fcmToken,  // For push notifications
  }) = _AppUserModel;
}
```

### Firestore Schema Updates

```
users/{userId}/
├── ... (existing fields)
├── notificationsEnabled: boolean           # NEW: Master notification toggle
├── lastActionDate: timestamp               # NEW: For streak calculation
├── streakGracePeriodAvailable: boolean     # NEW: Phase 4 foundation
├── fcmToken: string                        # NEW: For push notifications
└── settings: {                             # NEW: Embedded settings document
    reminderSchedules: [
      { id: "uuid1", hour: 9, minute: 0, isEnabled: true, label: "Morning" },
      { id: "uuid2", hour: 18, minute: 30, isEnabled: true, label: "Evening" }
    ],
    smartRemindersEnabled: boolean,
    seenStreakMilestones: { "1": true, "2": true },  // Week milestones seen
  }
```

### Streak Milestone Data

```dart
// Milestone thresholds (weekly)
const List<int> streakMilestones = [
  1,   // 1 week (7 days)
  2,   // 2 weeks (14 days)
  3,   // 3 weeks (21 days)
  4,   // 4 weeks (28 days)
  8,   // 2 months
  12,  // 3 months
  26,  // 6 months
  52,  // 1 year
];
```

---

## Feature Breakdown

### Feature 3.1: Settings Data Layer

**Priority:** P0

**Tasks:**
1. Create `UserSettingsModel` with Freezed
2. Create `NotificationScheduleModel` with Freezed
3. Create `SettingsRemoteDatasource` for Firestore operations
4. Create `SettingsRepository` with methods:
   - `getUserSettings(userId)` → Stream<UserSettingsModel>
   - `updateSettings(userId, settings)` → Future<void>
   - `addReminderSchedule(userId, schedule)` → Future<void>
   - `removeReminderSchedule(userId, scheduleId)` → Future<void>
   - `updateNotificationsEnabled(userId, enabled)` → Future<void>
5. Update `AppUserModel` with new fields
6. Run `dart run build_runner build`
7. Write unit tests for repository

**Files to Create:**
- `lib/features/settings/data/models/user_settings_model.dart`
- `lib/features/settings/data/models/notification_schedule_model.dart`
- `lib/features/settings/data/datasources/settings_remote_datasource.dart`
- `lib/features/settings/data/repositories/settings_repository.dart`
- `test/features/settings/data/repositories/settings_repository_test.dart`

**Files to Modify:**
- `lib/features/auth/data/models/app_user_model.dart`
- `lib/features/settings/settings.dart` (uncomment exports)

---

### Feature 3.2: Settings Providers

**Priority:** P0

**Tasks:**
1. Create `userSettingsProvider` - streams user settings
2. Create `SettingsNotifier` - handles mutations
3. Create `notificationPermissionStatusProvider`
4. Create `reminderSchedulesProvider` - derived list of schedules
5. Run code generation
6. Write unit tests for providers

**Files to Create:**
- `lib/features/settings/presentation/providers/settings_providers.dart`
- `test/features/settings/presentation/providers/settings_providers_test.dart`

**Provider Signatures:**
```dart
@riverpod
Stream<UserSettingsModel> userSettings(Ref ref);

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  Future<void> updateLanguage(String language);
  Future<void> toggleNotifications(bool enabled);
  Future<void> toggleSmartReminders(bool enabled);
  Future<void> addReminder(TimeOfDay time, {String? label});
  Future<void> removeReminder(String scheduleId);
  Future<void> updateReminder(String scheduleId, {TimeOfDay? time, bool? enabled});
}

@riverpod
Future<bool> notificationPermissionGranted(Ref ref);
```

---

### Feature 3.3: Main Settings Screen

**Priority:** P0

**Tasks:**
1. Create `SettingsSection` widget - section header with divider
2. Create `SettingsTile` widget - reusable row with icon, title, subtitle, trailing
3. Build `SettingsScreen` with sections:
   - Notifications (with switch toggle)
   - Language (shows current selection)
   - Account
   - About
4. Add navigation to sub-screens
5. Add localization strings
6. Write widget tests

**Files to Create:**
- `lib/features/settings/presentation/screens/settings_screen.dart`
- `lib/features/settings/presentation/widgets/settings_section.dart`
- `lib/features/settings/presentation/widgets/settings_tile.dart`
- `test/features/settings/presentation/screens/settings_screen_test.dart`

**Files to Modify:**
- `lib/app/router.dart` - replace placeholder with actual screen
- `lib/core/l10n/app_en.arb` - add settings strings
- `lib/core/l10n/app_es.arb` - add settings strings
- `lib/core/l10n/app_ja.arb` - add settings strings

---

### Feature 3.4: Notification Settings Screen

**Priority:** P0

**Tasks:**
1. Create `TimePickerTile` widget - shows time, opens picker on tap
2. Create `ReminderListTile` widget - individual reminder with toggle and delete
3. Build `NotificationSettingsScreen` with:
   - Master enable/disable switch
   - Smart reminders toggle with explanation
   - List of reminder times
   - Add reminder button (max 5 reminders)
4. Handle permission request on first enable
5. Schedule/cancel notifications on changes
6. Add localization strings
7. Write widget tests

**Files to Create:**
- `lib/features/settings/presentation/screens/notification_settings_screen.dart`
- `lib/features/settings/presentation/widgets/time_picker_tile.dart`
- `lib/features/settings/presentation/widgets/reminder_list_tile.dart`
- `test/features/settings/presentation/screens/notification_settings_screen_test.dart`

**Screen Layout:**
```
┌─────────────────────────────────────────┐
│  ←     Notification Settings            │
├─────────────────────────────────────────┤
│                                         │
│  Notifications                          │
│  ┌─────────────────────────────────┐   │
│  │ Enable notifications    [====●] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Smart Reminders                        │
│  ┌─────────────────────────────────┐   │
│  │ Only remind if no action [====●] │   │
│  │ today                            │   │
│  └─────────────────────────────────┘   │
│  Skip reminders on days you've         │
│  already logged an action.             │
│                                         │
│  ─────── Reminder Times ───────        │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🔔 Morning      9:00 AM  [====●] │   │
│  │                           [🗑️] │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │ 🔔 Evening      6:30 PM  [====●] │   │
│  │                           [🗑️] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      + Add Reminder Time         │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Maximum 5 reminders allowed.          │
│                                         │
└─────────────────────────────────────────┘
```

---

### Feature 3.5: Notification Service (Local)

**Priority:** P0

**Tasks:**
1. Create `NotificationService` class in shared/services
2. Initialize `flutter_local_notifications` with:
   - Android notification channel
   - iOS notification settings
3. Implement methods:
   - `initialize()` - setup with callbacks
   - `requestPermissions()` → Future<bool>
   - `checkPermissions()` → Future<bool>
   - `scheduleDaily(id, time, title, body)` - schedule repeating notification
   - `cancelNotification(id)` - cancel specific notification
   - `cancelAllNotifications()` - cancel all
   - `handleNotificationTap(payload)` - navigate on tap
4. Handle timezone configuration
5. Integrate with settings changes
6. Write comprehensive unit tests

**Files to Create:**
- `lib/shared/services/notification_service.dart`
- `lib/shared/services/services.dart` (barrel file)
- `lib/shared/providers/notification_providers.dart`
- `test/shared/services/notification_service_test.dart`

**Implementation Details:**
```dart
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  static const String channelId = 'daily_reminder';
  static const String channelName = 'Daily Reminders';
  static const String channelDescription =
      'Reminders to log your sustainable actions';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,  // Request manually
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _handleResponse,
    );

    // Initialize timezone
    tz.initializeTimeZones();
  }

  Future<void> scheduleDailyReminder({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final scheduledTime = _nextInstanceOfTime(hour, minute);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,  // Repeat daily
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
```

---

### Feature 3.6: FCM Service (Push Notifications)

**Priority:** P0

**Tasks:**
1. Create `FCMService` class in shared/services
2. Initialize Firebase Messaging in main.dart
3. Implement methods:
   - `initialize()` - setup with token refresh handling
   - `requestPermissions()` → Future<AuthorizationStatus>
   - `getToken()` → Future<String?>
   - `onTokenRefresh(callback)` - handle token updates
   - `onMessage(callback)` - handle foreground messages
   - `onBackgroundMessage(callback)` - handle background messages
4. Store FCM token in Firestore user document
5. Handle token refresh to update Firestore
6. Write unit tests

**Files to Create:**
- `lib/shared/services/fcm_service.dart`
- `test/shared/services/fcm_service_test.dart`

**Files to Modify:**
- `lib/main.dart` - add FCM initialization

**Implementation Details:**
```dart
class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get and store token
      final token = await _messaging.getToken();
      if (token != null) {
        await _storeToken(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_storeToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background message tap
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);
    }
  }

  Future<void> _storeToken(String token) async {
    // Update user document with FCM token
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
    }
  }
}
```

---

### Feature 3.7: Smart Notification Logic

**Priority:** P0

**Tasks:**
1. Create notification scheduling logic that checks:
   - Are notifications enabled?
   - Is smart reminders enabled?
   - Has user logged action today?
2. Implement daily check (via scheduled notification callback)
3. Cancel notification if action already logged today
4. Re-schedule for next day after action is logged
5. Write comprehensive tests for edge cases

**Files to Create:**
- `lib/shared/services/smart_notification_manager.dart`
- `test/shared/services/smart_notification_manager_test.dart`

**Smart Logic Flow:**
```
Notification Time Reached
         │
         ▼
┌─────────────────────┐
│ Notifications       │
│ Enabled?            │
└─────────┬───────────┘
          │ yes
          ▼
┌─────────────────────┐
│ Smart Reminders     │
│ Enabled?            │
└─────────┬───────────┘
          │ yes            │ no
          ▼                ▼
┌─────────────────────┐   ┌─────────────────────┐
│ Action logged       │   │ Show Notification   │
│ today?              │   │                     │
└─────────┬───────────┘   └─────────────────────┘
          │ no       │ yes
          ▼          ▼
┌─────────────────┐  ┌─────────────────┐
│ Show            │  │ Skip            │
│ Notification    │  │ (stay silent)   │
└─────────────────┘  └─────────────────┘
```

---

### Feature 3.8: Streak Tracking Service

**Priority:** P0

**Tasks:**
1. Create `StreakService` class
2. Implement streak calculation logic:
   - Compare lastActionDate with today
   - Handle timezone (user's device timezone)
   - Update currentStreak and longestStreak
3. Integrate with action logging flow
4. Add `lastActionDate` field to AppUserModel
5. Write comprehensive unit tests with edge cases

**Files to Create:**
- `lib/features/settings/domain/services/streak_service.dart`
- `test/features/settings/domain/services/streak_service_test.dart`

**Files to Modify:**
- `lib/features/actions/data/repositories/action_log_repository.dart` - integrate streak update

**Streak Logic:**
```dart
class StreakService {
  /// Updates streak when user logs an action
  /// Returns (newCurrentStreak, newLongestStreak)
  (int, int) calculateStreakUpdate({
    required DateTime? lastActionDate,
    required int currentStreak,
    required int longestStreak,
    required DateTime now,
  }) {
    final today = DateTime(now.year, now.month, now.day);

    if (lastActionDate == null) {
      // First action ever - start streak at 1
      return (1, max(1, longestStreak));
    }

    final lastDate = DateTime(
      lastActionDate.year,
      lastActionDate.month,
      lastActionDate.day,
    );

    final daysDifference = today.difference(lastDate).inDays;

    if (daysDifference == 0) {
      // Already logged today - no change
      return (currentStreak, longestStreak);
    } else if (daysDifference == 1) {
      // Logged yesterday - increment streak
      final newStreak = currentStreak + 1;
      return (newStreak, max(newStreak, longestStreak));
    } else {
      // Missed days - reset streak
      return (1, longestStreak);
    }
  }

  /// Returns streak in weeks (for milestone tracking)
  int getStreakWeeks(int streakDays) {
    return streakDays ~/ 7;
  }

  /// Check if user crossed a weekly milestone
  bool crossedWeeklyMilestone(int oldStreak, int newStreak) {
    final oldWeeks = getStreakWeeks(oldStreak);
    final newWeeks = getStreakWeeks(newStreak);
    return newWeeks > oldWeeks && newWeeks > 0;
  }
}
```

---

### Feature 3.9: Streak Milestone Celebrations

**Priority:** P1

**Tasks:**
1. Create `StreakMilestoneDialog` widget
2. Detect weekly milestone crossings (7, 14, 21, 28... days)
3. Show celebration dialog with:
   - Streak count in weeks
   - Encouraging message
   - Mascot celebration (reuse from Phase 2)
4. Track seen milestones to prevent repeat triggers
5. Add localization strings for milestone messages
6. Write widget tests

**Files to Create:**
- `lib/features/settings/presentation/widgets/streak_milestone_dialog.dart`
- `lib/features/settings/presentation/providers/streak_milestone_provider.dart`
- `test/features/settings/presentation/widgets/streak_milestone_dialog_test.dart`

**Milestone Dialog Layout:**
```
┌─────────────────────────────────────────┐
│                                         │
│              🎉 Amazing! 🎉             │
│                                         │
│         ┌─────────────────┐             │
│         │    [Mascot]     │             │
│         │    (bouncing)   │             │
│         └─────────────────┘             │
│                                         │
│           2 Week Streak!                │
│                                         │
│    You've logged actions for            │
│    14 days in a row!                    │
│                                         │
│    Keep up the amazing work! 🌱         │
│                                         │
│         ┌─────────────────┐             │
│         │    Continue     │             │
│         └─────────────────┘             │
│                                         │
└─────────────────────────────────────────┘
```

---

### Feature 3.10: Streak Break Notification

**Priority:** P1

**Tasks:**
1. Implement Cloud Function (or local check) for streak break detection
2. Send push notification when streak is about to break (e.g., 8 PM if no action)
3. Send push notification when streak has broken (next day)
4. Include encouraging message to start new streak
5. Add localization strings
6. Write tests

**Implementation Options:**

**Option A: Cloud Function (Recommended for accuracy)**
```javascript
// Firebase Cloud Function - runs at 8 PM user's timezone (requires timezone tracking)
exports.streakBreakReminder = functions.pubsub
  .schedule('0 20 * * *')
  .onRun(async (context) => {
    // Query users who haven't logged today and have active streak
    // Send FCM notification
  });
```

**Option B: Local Check on App Open**
```dart
// Check on app open if streak was broken since last session
Future<void> checkStreakStatus() async {
  final user = await getUserData();
  if (user.currentStreak > 0 && user.lastActionDate != null) {
    final daysSinceLastAction = DateTime.now()
        .difference(user.lastActionDate!)
        .inDays;

    if (daysSinceLastAction > 1) {
      // Streak broken - show dialog
      showStreakBrokenDialog(previousStreak: user.currentStreak);
    }
  }
}
```

**Files to Create:**
- `firebase/functions/src/streakReminder.ts` (if using Cloud Functions)
- `lib/features/settings/presentation/widgets/streak_broken_dialog.dart`

---

### Feature 3.11: Language Settings Screen

**Priority:** P1

**Tasks:**
1. Build `LanguageSettingsScreen` with:
   - List of available languages (English, Spanish, Japanese)
   - Current selection indicator
   - Preview of how text will appear
2. Update app locale on selection
3. Persist language preference to Firestore
4. Restart not required (Riverpod will rebuild)
5. Write widget tests

**Files to Create:**
- `lib/features/settings/presentation/screens/language_settings_screen.dart`
- `test/features/settings/presentation/screens/language_settings_screen_test.dart`

**Screen Layout:**
```
┌─────────────────────────────────────────┐
│  ←           Language                   │
├─────────────────────────────────────────┤
│                                         │
│  Select your preferred language         │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🇺🇸 English              [✓]   │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │ 🇯🇵 日本語                [ ]   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  The app will update immediately.       │
│                                         │
└─────────────────────────────────────────┘
```

---

### Feature 3.12: Account Settings Screen

**Priority:** P0 (Delete Account) / P1 (Email/Password Change)

**Tasks:**
1. Build `AccountSettingsScreen` with:
   - Display current email
   - Change email option
   - Change password option
   - Delete account option (prominent, with warning)
2. Create email change flow with re-authentication
3. Create password change flow with re-authentication
4. Create delete account flow with confirmation
5. Handle Firebase Auth errors gracefully
6. Add localization strings
7. Write widget tests

**Files to Create:**
- `lib/features/settings/presentation/screens/account_settings_screen.dart`
- `lib/features/settings/presentation/widgets/delete_account_dialog.dart`
- `lib/features/settings/presentation/widgets/change_email_dialog.dart`
- `lib/features/settings/presentation/widgets/change_password_dialog.dart`
- `test/features/settings/presentation/screens/account_settings_screen_test.dart`

**Delete Account Flow:**
```
User taps "Delete Account"
         │
         ▼
┌─────────────────────┐
│ Show Warning Dialog │
│ "This cannot be     │
│ undone..."          │
└─────────┬───────────┘
          │ Confirm
          ▼
┌─────────────────────┐
│ Re-authenticate     │
│ (password required) │
└─────────┬───────────┘
          │ Success
          ▼
┌─────────────────────┐
│ Delete Firestore    │
│ user document       │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ Delete Firebase     │
│ Auth account        │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ Navigate to Login   │
│ Show confirmation   │
└─────────────────────┘
```

**Screen Layout:**
```
┌─────────────────────────────────────────┐
│  ←           Account                    │
├─────────────────────────────────────────┤
│                                         │
│  Email                                  │
│  ┌─────────────────────────────────┐   │
│  │ user@example.com            [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Security                               │
│  ┌─────────────────────────────────┐   │
│  │ Change Password             [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────────────────────────────────     │
│                                         │
│  Danger Zone                            │
│  ┌─────────────────────────────────┐   │
│  │ 🗑️ Delete Account            [→] │   │
│  │ This action cannot be undone.   │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

### Feature 3.13: About Screen

**Priority:** P2

**Tasks:**
1. Build `AboutScreen` with:
   - App name and logo
   - Version number (from package_info_plus)
   - Links to Privacy Policy
   - Links to Terms of Service
   - Attribution/credits (optional)
2. Create placeholder `PrivacyPolicyScreen`
3. Create placeholder `TermsOfServiceScreen`
4. Add localization strings
5. Write widget tests

**Files to Create:**
- `lib/features/settings/presentation/screens/about_screen.dart`
- `lib/features/settings/presentation/screens/privacy_policy_screen.dart`
- `lib/features/settings/presentation/screens/terms_of_service_screen.dart`
- `test/features/settings/presentation/screens/about_screen_test.dart`

**Screen Layout:**
```
┌─────────────────────────────────────────┐
│  ←            About                     │
├─────────────────────────────────────────┤
│                                         │
│              🌱                         │
│             Seed                        │
│                                         │
│         Version 1.0.0                   │
│                                         │
│  ─────────────────────────────────     │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Privacy Policy              [→] │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │ Terms of Service            [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────────────────────────────────     │
│                                         │
│  Made with 💚 for the planet           │
│                                         │
│  © 2026 Seed App                        │
│                                         │
└─────────────────────────────────────────┘
```

---

### Feature 3.14: Skeleton Loading States (If Time Permits)

**Priority:** P2

**Assessment from codebase review:**
- Currently all loading states use `CircularProgressIndicator()`
- No shimmer/skeleton patterns exist
- Key screens that would benefit:
  - `ProfileScreen` - stats cards could use skeleton
  - `ActionLogScreen` - action grid could use skeleton
  - `ProgressScreen` - calendar could use skeleton

**Recommendation:** Defer to Phase 4 unless core Phase 3 features complete early. Create shared skeleton widgets for reuse.

**Files to Create (if implemented):**
- `lib/shared/widgets/skeleton_loader.dart`
- `lib/shared/widgets/shimmer_effect.dart`

---

## Screen Designs

### Settings Screen

```
┌─────────────────────────────────────────┐
│  ←           Settings                   │
├─────────────────────────────────────────┤
│                                         │
│  NOTIFICATIONS                          │
│  ┌─────────────────────────────────┐   │
│  │ 🔔 Daily Reminders      [====●] │   │
│  │    2 reminders configured   [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  PREFERENCES                            │
│  ┌─────────────────────────────────┐   │
│  │ 🌐 Language                     │   │
│  │    English                  [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ACCOUNT                                │
│  ┌─────────────────────────────────┐   │
│  │ 👤 Account Settings         [→] │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ABOUT                                  │
│  ┌─────────────────────────────────┐   │
│  │ ℹ️ About Seed               [→] │   │
│  │    Version 1.0.0                │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

## Implementation Order

### Stage 1: Settings Foundation

| Step | Task | Priority |
|------|------|----------|
| 1.1 | Create settings data models (UserSettingsModel, NotificationScheduleModel) | P0 |
| 1.2 | Create settings repository & datasource | P0 |
| 1.3 | Update AppUserModel with new fields | P0 |
| 1.4 | Run code generation | P0 |
| 1.5 | Create settings providers | P0 |
| 1.6 | Build main SettingsScreen | P0 |
| 1.7 | Build SettingsTile and SettingsSection widgets | P0 |
| 1.8 | Write unit tests for data layer | P0 |

**Milestone:** Settings screen navigable from Profile, shows sections

### Stage 2: Notification System

| Step | Task | Priority |
|------|------|----------|
| 2.1 | Create NotificationService (flutter_local_notifications) | P0 |
| 2.2 | Add iOS notification setup (AppDelegate.swift) | P0 |
| 2.3 | Add Android notification setup (AndroidManifest.xml) | P0 |
| 2.4 | Build NotificationSettingsScreen | P0 |
| 2.5 | Implement multiple reminder scheduling | P0 |
| 2.6 | Create FCMService | P0 |
| 2.7 | Initialize FCM in main.dart | P0 |
| 2.8 | Implement smart notification logic | P0 |
| 2.9 | Write comprehensive notification tests | P0 |

**Milestone:** Users can set multiple reminders, receive smart notifications

### Stage 3: Streak System

| Step | Task | Priority |
|------|------|----------|
| 3.1 | Create StreakService with calculation logic | P0 |
| 3.2 | Integrate streak update into action logging | P0 |
| 3.3 | Add lastActionDate field handling | P0 |
| 3.4 | Create StreakMilestoneDialog | P1 |
| 3.5 | Implement weekly milestone detection | P1 |
| 3.6 | Implement streak break notification | P1 |
| 3.7 | Write comprehensive streak tests | P0 |

**Milestone:** Streaks update correctly, weekly milestones celebrated

### Stage 4: Account Management

| Step | Task | Priority |
|------|------|----------|
| 4.1 | Build AccountSettingsScreen | P0 |
| 4.2 | Implement delete account flow | P0 |
| 4.3 | Implement change password flow | P1 |
| 4.4 | Implement change email flow | P1 |
| 4.5 | Build LanguageSettingsScreen | P1 |
| 4.6 | Build AboutScreen with version | P2 |
| 4.7 | Create placeholder legal screens | P2 |
| 4.8 | Write account management tests | P0 |

**Milestone:** Complete settings system with account management

### Stage 5: Polish & Testing

| Step | Task | Priority |
|------|------|----------|
| 5.1 | Add all localization strings (EN/ES/JP) | P0 |
| 5.2 | Integration testing end-to-end | P0 |
| 5.3 | Edge case testing (timezone, permissions) | P0 |
| 5.4 | Device testing (iOS + Android) | P0 |
| 5.5 | Bug fixes and refinements | P0 |
| 5.6 | Documentation updates | P1 |

**Milestone:** Phase 3 complete - all features tested and working

---

## Testing Strategy

### Unit Tests - ✅ COMPLETE

| Component | Test File | Status |
|-----------|-----------|--------|
| SettingsRepository | `settings_repository_test.dart` | ✅ 19 tests |
| NotificationService | `notification_service_test.dart` | ✅ 10 tests |
| StreakService | `streak_service_test.dart` | ✅ 25 tests |
| UserSettingsModel | `user_settings_model_test.dart` | ✅ 32 tests |
| NotificationScheduleModel | `notification_schedule_model_test.dart` | ✅ 26 tests |

### Widget Tests - ✅ COMPLETE

| Widget | Test File | Status |
|--------|-----------|--------|
| SettingsScreen | `settings_screen_test.dart` | ✅ 28 tests |
| NotificationSettingsScreen | `notification_settings_screen_test.dart` | ✅ 25 tests |
| LanguageSettingsScreen | `language_settings_screen_test.dart` | ✅ 14 tests |
| AccountSettingsScreen | `account_settings_screen_test.dart` | ✅ 24 tests |
| StreakMilestoneDialog | `streak_milestone_dialog_test.dart` | ✅ 7 tests |
| SettingsTile | `settings_tile_test.dart` | ✅ 17 tests |
| SettingsSection | `settings_section_test.dart` | ✅ 7 tests |
| ReminderListTile | `reminder_list_tile_test.dart` | ✅ 16 tests |

**Total Phase 3 Tests: 256 passing**

### Integration Tests

| Flow | Test File | Scenarios |
|------|-----------|-----------|
| Notification Setup | `notification_setup_test.dart` | Enable, set time, receive notification |
| Streak Flow | `streak_flow_test.dart` | Log action, streak increments, milestone triggers |
| Delete Account | `delete_account_test.dart` | Confirm, re-auth, deletion complete |
| Language Change | `language_change_test.dart` | Select language, UI updates |

### Streak Service Test Cases

```dart
group('StreakService', () {
  test('first action ever sets streak to 1', () {
    // lastActionDate: null, currentStreak: 0
    // Expected: currentStreak = 1
  });

  test('action on consecutive day increments streak', () {
    // lastActionDate: yesterday, currentStreak: 5
    // Expected: currentStreak = 6
  });

  test('action on same day does not change streak', () {
    // lastActionDate: today, currentStreak: 5
    // Expected: currentStreak = 5
  });

  test('missed day resets streak to 1', () {
    // lastActionDate: 2 days ago, currentStreak: 10
    // Expected: currentStreak = 1, longestStreak unchanged
  });

  test('streak updates longest when exceeding', () {
    // currentStreak: 10, longestStreak: 10
    // After increment: currentStreak = 11, longestStreak = 11
  });

  test('weekly milestone detection', () {
    // oldStreak: 6, newStreak: 7
    // Expected: crossedWeeklyMilestone = true
  });

  test('timezone edge case - action just before midnight', () {
    // Test that streak calculates correctly at day boundaries
  });
});
```

### Test Commands

```bash
# Run all Phase 3 tests (256 tests)
flutter test test/features/settings/ test/shared/services/

# Run with coverage
flutter test --coverage test/features/settings/

# Run specific test file
flutter test test/shared/services/streak_service_test.dart

# Run all project tests (657 tests)
flutter test
```

### Test File Structure (Created)

```
test/
├── features/settings/
│   ├── data/
│   │   ├── models/
│   │   │   ├── notification_schedule_model_test.dart  (26 tests)
│   │   │   └── user_settings_model_test.dart          (32 tests)
│   │   └── repositories/
│   │       └── settings_repository_test.dart          (19 tests)
│   └── presentation/
│       ├── screens/
│       │   ├── settings_screen_test.dart              (28 tests)
│       │   ├── notification_settings_screen_test.dart (25 tests)
│       │   ├── language_settings_screen_test.dart     (14 tests)
│       │   └── account_settings_screen_test.dart      (24 tests)
│       └── widgets/
│           ├── settings_tile_test.dart                (17 tests)
│           ├── settings_section_test.dart             (7 tests)
│           ├── reminder_list_tile_test.dart           (16 tests)
│           └── streak_milestone_dialog_test.dart      (7 tests)
└── shared/services/
    ├── streak_service_test.dart                       (25 tests)
    └── notification_service_test.dart                 (10 tests)
```

---

## Acceptance Criteria

### Feature 3.1-3.2: Settings Data & Providers ✅
- [x] UserSettingsModel serializes/deserializes correctly
- [x] NotificationScheduleModel handles all fields
- [x] Settings stream from Firestore in real-time
- [x] Settings mutations update Firestore correctly
- [x] Unit tests pass (32 + 26 + 19 tests)

### Feature 3.3: Main Settings Screen ✅
- [x] Settings screen accessible from Profile
- [x] All sections display with correct icons
- [x] Notification toggle works inline
- [x] Navigation to sub-screens works
- [x] Widget tests pass (28 tests)

### Feature 3.4: Notification Settings Screen ✅
- [x] Can add up to 5 reminder times
- [x] Can remove individual reminders
- [x] Can toggle individual reminders on/off
- [x] Smart reminders toggle works
- [x] Master enable/disable controls all notifications
- [x] Time picker opens and saves correctly
- [x] Widget tests pass (25 tests)

### Feature 3.5-3.7: Notification Services ✅
- [x] Local notifications initialize on app start
- [x] Permission request shows appropriate dialog
- [x] Scheduled notifications fire at correct times
- [x] Smart logic skips notification if action logged today
- [x] Notification tap opens app to action screen
- [x] FCM token stored in Firestore
- [x] Push notifications received when app backgrounded
- [x] Notification tests pass (10 tests)

### Feature 3.8: Streak Tracking ✅
- [x] Streak increments on consecutive day action
- [x] Streak resets after missed day
- [x] Multiple actions same day don't double-count
- [x] longestStreak updates when exceeded
- [x] lastActionDate updates on each action
- [x] Timezone handled correctly (device timezone)
- [x] Unit tests pass (25 tests)

### Feature 3.9: Streak Milestones ✅
- [x] Dialog shows at 7, 14, 21, 28+ day milestones
- [x] Milestone only shows once per threshold
- [x] Dialog displays correct week count
- [x] Mascot animation plays in dialog
- [x] Widget tests pass (7 tests)

### Feature 3.10: Streak Break Notification ⏳
- [ ] Push notification sent when streak about to break
- [ ] Notification includes encouraging message
- [ ] User can tap notification to open app
- [ ] Tests pass
- **Deferred to Phase 4** (requires Cloud Functions)

### Feature 3.11: Language Settings ✅
- [x] Shows all available languages (EN/ES/JP)
- [x] Current language indicated
- [x] Selection updates app immediately
- [x] Preference persists to Firestore
- [x] Widget tests pass (14 tests)

### Feature 3.12: Account Settings ✅
- [x] Displays current email
- [x] Change email flow works with re-auth
- [x] Change password flow works with re-auth
- [x] Delete account shows warning
- [x] Delete account requires confirmation
- [x] Delete account removes Firestore data
- [x] Delete account removes Firebase Auth account
- [x] User redirected to login after deletion
- [x] All tests pass (24 tests)

### Feature 3.13: About Screen ✅
- [x] Shows app name and logo
- [x] Shows correct version number
- [x] Privacy Policy link navigates
- [x] Terms of Service link navigates
- [x] Widget tests pass (integrated in settings_screen_test.dart)

---

## Platform-Specific Setup

### iOS Setup

**File: `ios/Runner/AppDelegate.swift`**

```swift
import Flutter
import UIKit
import Firebase
import FirebaseMessaging
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase initialization
    FirebaseApp.configure()

    // Local notifications setup
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // Request notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    }

    application.registerForRemoteNotifications()

    // FCM delegate
    Messaging.messaging().delegate = self

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Handle FCM token refresh
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    // Token is handled in Dart code
    print("FCM Token: \(fcmToken ?? "")")
  }
}
```

**File: `ios/Runner/Info.plist` additions:**

```xml
<!-- Add to existing Info.plist -->
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

### Android Setup

**File: `android/app/src/main/AndroidManifest.xml` additions:**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
    <uses-permission android:name="android.permission.USE_EXACT_ALARM"/>

    <application ...>

        <!-- Notification channel for local notifications -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="daily_reminder" />

        <!-- Boot receiver for rescheduling notifications -->
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>

        <!-- Scheduled notification receiver -->
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
            android:exported="false" />

    </application>
</manifest>
```

**File: `android/app/build.gradle` (check minSdk):**

```gradle
android {
    defaultConfig {
        minSdk = 21  // Required for notification channels
    }
}
```

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Notification permission denied | Medium | High | Graceful degradation; explain benefits in UI |
| Timezone edge cases | Medium | Medium | Comprehensive tests; use device timezone |
| FCM delivery issues | Low | Medium | Local notifications as primary; FCM as supplement |
| Delete account data retention | Low | High | Clear deletion policy; audit trail |
| Multiple reminders overwhelming | Medium | Low | Cap at 5; explain smart reminders |
| Streak calculation bugs | Medium | High | 95% test coverage; edge case tests |
| iOS/Android permission differences | Medium | Medium | Platform-specific handling; clear UI guidance |

---

## Localization Strings to Add

### English (app_en.arb)

```json
{
  "settings": "Settings",
  "notifications": "Notifications",
  "dailyReminders": "Daily Reminders",
  "remindersConfigured": "{count} reminders configured",
  "@remindersConfigured": {
    "placeholders": { "count": { "type": "int" } }
  },
  "notificationSettings": "Notification Settings",
  "enableNotifications": "Enable notifications",
  "smartReminders": "Smart Reminders",
  "smartRemindersDescription": "Only remind if no action today",
  "smartRemindersHelp": "Skip reminders on days you've already logged an action.",
  "reminderTimes": "Reminder Times",
  "addReminderTime": "Add Reminder Time",
  "maxRemindersReached": "Maximum 5 reminders allowed",
  "morning": "Morning",
  "afternoon": "Afternoon",
  "evening": "Evening",

  "language": "Language",
  "languageSettings": "Language Settings",
  "selectLanguage": "Select your preferred language",
  "languageUpdateImmediate": "The app will update immediately.",
  "english": "English",
  "spanish": "Español",
  "japanese": "日本語",

  "account": "Account",
  "accountSettings": "Account Settings",
  "email": "Email",
  "changeEmail": "Change Email",
  "changePassword": "Change Password",
  "currentPassword": "Current Password",
  "newPassword": "New Password",
  "confirmNewPassword": "Confirm New Password",
  "passwordChanged": "Password changed successfully",
  "emailChanged": "Email changed successfully",

  "dangerZone": "Danger Zone",
  "deleteAccount": "Delete Account",
  "deleteAccountWarning": "This action cannot be undone.",
  "deleteAccountConfirmTitle": "Delete Your Account?",
  "deleteAccountConfirmMessage": "All your data including points, mascot, and action history will be permanently deleted. This cannot be undone.",
  "deleteAccountButton": "Delete My Account",
  "accountDeleted": "Your account has been deleted",
  "reAuthRequired": "Please enter your password to continue",

  "about": "About",
  "aboutSeed": "About Seed",
  "version": "Version",
  "privacyPolicy": "Privacy Policy",
  "termsOfService": "Terms of Service",
  "madeWithLove": "Made with 💚 for the planet",

  "streakMilestoneTitle": "Amazing!",
  "streakWeeks": "{count} Week Streak!",
  "@streakWeeks": {
    "placeholders": { "count": { "type": "int" } }
  },
  "streakDaysInRow": "You've logged actions for {count} days in a row!",
  "@streakDaysInRow": {
    "placeholders": { "count": { "type": "int" } }
  },
  "keepUpAmazingWork": "Keep up the amazing work!",
  "streakBroken": "Streak Broken",
  "streakBrokenMessage": "Don't worry! Start a new streak today.",
  "previousStreak": "Previous streak: {count} days",
  "@previousStreak": {
    "placeholders": { "count": { "type": "int" } }
  },

  "notificationTitle": "Time to make a difference!",
  "notificationBody": "Log a sustainable action today 🌱",
  "streakReminderTitle": "Don't break your streak!",
  "streakReminderBody": "You haven't logged an action today. Keep your {count}-day streak going!",
  "@streakReminderBody": {
    "placeholders": { "count": { "type": "int" } }
  },

  "continue_": "Continue",
  "cancel": "Cancel",
  "save": "Save",
  "delete": "Delete",
  "confirm": "Confirm"
}
```

### Spanish (app_es.arb)

```json
{
  "settings": "Ajustes",
  "notifications": "Notificaciones",
  "dailyReminders": "Recordatorios diarios",
  "remindersConfigured": "{count} recordatorios configurados",
  "@remindersConfigured": {
    "placeholders": { "count": { "type": "int" } }
  },
  "notificationSettings": "Configuración de notificaciones",
  "enableNotifications": "Activar notificaciones",
  "smartReminders": "Recordatorios inteligentes",
  "smartRemindersDescription": "Solo recordar si no hay acción hoy",
  "smartRemindersHelp": "Omite recordatorios en días que ya registraste una acción.",
  "reminderTimes": "Horarios de recordatorio",
  "addReminderTime": "Añadir hora de recordatorio",
  "maxRemindersReached": "Máximo 5 recordatorios permitidos",
  "morning": "Mañana",
  "afternoon": "Tarde",
  "evening": "Noche",

  "language": "Idioma",
  "languageSettings": "Configuración de idioma",
  "selectLanguage": "Selecciona tu idioma preferido",
  "languageUpdateImmediate": "La aplicación se actualizará inmediatamente.",
  "english": "English",
  "spanish": "Español",
  "japanese": "日本語",

  "account": "Cuenta",
  "accountSettings": "Configuración de cuenta",
  "email": "Correo electrónico",
  "changeEmail": "Cambiar correo",
  "changePassword": "Cambiar contraseña",
  "currentPassword": "Contraseña actual",
  "newPassword": "Nueva contraseña",
  "confirmNewPassword": "Confirmar nueva contraseña",
  "passwordChanged": "Contraseña cambiada exitosamente",
  "emailChanged": "Correo cambiado exitosamente",

  "dangerZone": "Zona de peligro",
  "deleteAccount": "Eliminar cuenta",
  "deleteAccountWarning": "Esta acción no se puede deshacer.",
  "deleteAccountConfirmTitle": "¿Eliminar tu cuenta?",
  "deleteAccountConfirmMessage": "Todos tus datos incluyendo puntos, mascota e historial de acciones serán eliminados permanentemente. Esto no se puede deshacer.",
  "deleteAccountButton": "Eliminar mi cuenta",
  "accountDeleted": "Tu cuenta ha sido eliminada",
  "reAuthRequired": "Por favor ingresa tu contraseña para continuar",

  "about": "Acerca de",
  "aboutSeed": "Acerca de Seed",
  "version": "Versión",
  "privacyPolicy": "Política de privacidad",
  "termsOfService": "Términos de servicio",
  "madeWithLove": "Hecho con 💚 para el planeta",

  "streakMilestoneTitle": "¡Increíble!",
  "streakWeeks": "¡{count} semanas de racha!",
  "@streakWeeks": {
    "placeholders": { "count": { "type": "int" } }
  },
  "streakDaysInRow": "¡Has registrado acciones por {count} días seguidos!",
  "@streakDaysInRow": {
    "placeholders": { "count": { "type": "int" } }
  },
  "keepUpAmazingWork": "¡Sigue con el increíble trabajo!",
  "streakBroken": "Racha interrumpida",
  "streakBrokenMessage": "¡No te preocupes! Comienza una nueva racha hoy.",
  "previousStreak": "Racha anterior: {count} días",
  "@previousStreak": {
    "placeholders": { "count": { "type": "int" } }
  },

  "notificationTitle": "¡Es hora de hacer la diferencia!",
  "notificationBody": "Registra una acción sostenible hoy 🌱",
  "streakReminderTitle": "¡No pierdas tu racha!",
  "streakReminderBody": "No has registrado una acción hoy. ¡Mantén tu racha de {count} días!",
  "@streakReminderBody": {
    "placeholders": { "count": { "type": "int" } }
  },

  "continue_": "Continuar",
  "cancel": "Cancelar",
  "save": "Guardar",
  "delete": "Eliminar",
  "confirm": "Confirmar"
}
```

### Japanese (app_ja.arb)

```json
{
  "settings": "設定",
  "notifications": "通知",
  "dailyReminders": "毎日のリマインダー",
  "remindersConfigured": "{count}件のリマインダー",
  "@remindersConfigured": {
    "placeholders": { "count": { "type": "int" } }
  },
  "notificationSettings": "通知設定",
  "enableNotifications": "通知を有効にする",
  "smartReminders": "スマートリマインダー",
  "smartRemindersDescription": "今日のアクションがない場合のみ通知",
  "smartRemindersHelp": "すでにアクションを記録した日は通知をスキップします。",
  "reminderTimes": "リマインダー時刻",
  "addReminderTime": "リマインダーを追加",
  "maxRemindersReached": "リマインダーは最大5件まで",
  "morning": "朝",
  "afternoon": "昼",
  "evening": "夜",

  "language": "言語",
  "languageSettings": "言語設定",
  "selectLanguage": "言語を選択してください",
  "languageUpdateImmediate": "すぐに反映されます。",
  "english": "English",
  "spanish": "Español",
  "japanese": "日本語",

  "account": "アカウント",
  "accountSettings": "アカウント設定",
  "email": "メールアドレス",
  "changeEmail": "メールアドレスを変更",
  "changePassword": "パスワードを変更",
  "currentPassword": "現在のパスワード",
  "newPassword": "新しいパスワード",
  "confirmNewPassword": "新しいパスワード（確認）",
  "passwordChanged": "パスワードが変更されました",
  "emailChanged": "メールアドレスが変更されました",

  "dangerZone": "危険な操作",
  "deleteAccount": "アカウントを削除",
  "deleteAccountWarning": "この操作は取り消せません。",
  "deleteAccountConfirmTitle": "アカウントを削除しますか？",
  "deleteAccountConfirmMessage": "ポイント、マスコット、アクション履歴を含むすべてのデータが完全に削除されます。この操作は取り消せません。",
  "deleteAccountButton": "アカウントを削除する",
  "accountDeleted": "アカウントが削除されました",
  "reAuthRequired": "続行するにはパスワードを入力してください",

  "about": "アプリについて",
  "aboutSeed": "Seedについて",
  "version": "バージョン",
  "privacyPolicy": "プライバシーポリシー",
  "termsOfService": "利用規約",
  "madeWithLove": "地球のために💚で作られました",

  "streakMilestoneTitle": "すごい！",
  "streakWeeks": "{count}週間連続！",
  "@streakWeeks": {
    "placeholders": { "count": { "type": "int" } }
  },
  "streakDaysInRow": "{count}日連続でアクションを記録しました！",
  "@streakDaysInRow": {
    "placeholders": { "count": { "type": "int" } }
  },
  "keepUpAmazingWork": "この調子で続けましょう！",
  "streakBroken": "連続記録が途切れました",
  "streakBrokenMessage": "大丈夫！今日から新しい記録を始めましょう。",
  "previousStreak": "前回の記録: {count}日",
  "@previousStreak": {
    "placeholders": { "count": { "type": "int" } }
  },

  "notificationTitle": "変化を起こす時間です！",
  "notificationBody": "今日もサステナブルなアクションを記録しましょう 🌱",
  "streakReminderTitle": "記録を途切れさせないで！",
  "streakReminderBody": "今日はまだアクションを記録していません。{count}日連続の記録を続けましょう！",
  "@streakReminderBody": {
    "placeholders": { "count": { "type": "int" } }
  },

  "continue_": "続ける",
  "cancel": "キャンセル",
  "save": "保存",
  "delete": "削除",
  "confirm": "確認"
}
```

---

## Dependencies

### External Dependencies
- Firebase project configured (existing)
- FCM enabled in Firebase Console
- iOS: Apple Developer account with push notification capability
- Android: Firebase project linked

### Internal Dependencies
| Feature | Depends On |
|---------|-----------|
| Notification Settings | Settings Data Layer, Notification Service |
| Streak Tracking | Action Logging (existing), AppUserModel updates |
| Account Settings | Auth Repository (existing) |
| Language Settings | Localization (existing) |
| Smart Notifications | Notification Service, Action Log data |

### New Package Dependencies
None required - all packages already in pubspec.yaml:
- `flutter_local_notifications: ^19.5.0`
- `firebase_messaging: ^16.1.0`
- `timezone: ^0.10.1`
- `package_info_plus: ^9.0.0`

---

## Post-Phase 3 Considerations

### Deferred to Phase 4
- Skeleton/shimmer loading states
- Haptic feedback throughout app
- Dark mode audit
- Streak grace period UI (foundation built in UserSettingsModel)
- Advanced notification analytics
- Notification A/B testing

### Technical Debt to Address
- Add comprehensive widget tests for settings screens
- Consider adding App Check for security
- Evaluate notification delivery rates on production
- Monitor Firestore usage patterns
- Add integration tests for streak calculation

### Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Notification opt-in rate | >70% | Users with notifications enabled |
| Daily active users | +20% | Compare to pre-Phase 3 |
| Average streak length | >5 days | Track across all users |
| Account deletion rate | <5% | Monitor for UX issues |
| 7-day retention | >40% | Users returning after 1 week |

---

## Firestore Security Rules Updates

```javascript
// Add to existing rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Validate settings updates
      function validSettings(settings) {
        return settings.reminderSchedules.size() <= 5
            && (!('smartRemindersEnabled' in settings) || settings.smartRemindersEnabled is bool);
      }

      // Existing rules...
    }
  }
}
```

---

## Remaining Work to Complete Phase 3

### Completed in Latest Update

1. **Streak Calculation Service** ✅
   - Created `lib/shared/services/streak_service.dart`
   - Implemented streak calculation logic (consecutive days)
   - Handles timezone edge cases
   - Handles multiple actions same day (doesn't double-count)
   - Added comprehensive unit tests (25 tests)

2. **Streak Integration with Action Logging** ✅
   - Updated `action_log_repository.dart` to use StreakService
   - Returns `ActionLogResult` with milestone information
   - Updates `currentStreak`, `longestStreak`, `lastActionDate` atomically

3. **Streak Milestone Dialogs** ✅
   - Created `streak_milestone_dialog.dart`
   - Celebration at 7, 14, 21, 28+ day milestones
   - Tracks seen milestones in `seenStreakMilestones`
   - Includes mascot animation with confetti

4. **Platform Configuration** ✅
   - iOS `AppDelegate.swift` - FCM token registration complete
   - iOS `Info.plist` - Added UIBackgroundModes (fetch, remote-notification)
   - Android `AndroidManifest.xml` - All permissions configured
   - `main.dart` - Service initialization complete

5. **Localization** ✅
   - Added streak milestone strings (EN, ES, JA)

### Priority 2 - Polish (Completed)

1. **Widget Tests** ✅ COMPLETE
   - Settings screens tests (28 tests)
   - Notification settings tests (25 tests)
   - Language settings tests (14 tests)
   - Account settings tests (24 tests)
   - Streak milestone dialog tests (7 tests)
   - SettingsTile tests (17 tests)
   - SettingsSection tests (7 tests)
   - ReminderListTile tests (16 tests)
   - Total: **256 Phase 3 tests passing**

2. **Streak Break Push Notification** (Deferred to Phase 4)
   - Cloud Function for streak break detection
   - Push notification when streak about to break

### Estimated Remaining Effort
- Widget tests: ✅ COMPLETE
- Streak break notification: Deferred to Phase 4
- **Phase 3 is ~98% complete**
- **All core features implemented and tested**

---

*This plan will be updated as implementation progresses. Phase 3 focuses on quality over speed - take time to build comprehensive tests and handle edge cases properly.*
