Test Coverage Expansion Plan                                                              

 Context

 Seed has 51 test files covering ~41% of source files. Coverage is
 concentrated on models, utilities, and widget rendering. Critical gaps
 exist in the data layer (repositories, datasources), state
 management (Riverpod providers), and services. There are zero
 integration tests and no CI/CD pipeline. This plan systematically
 closes these gaps, prioritized by risk and complexity.

 ---
 Phase 1: Pure Dart Services (Low complexity, high value)

 1a. EggHatchingService tests

 - File: lib/features/mascot/data/services/egg_hatching_service.dart
 - Create: test/features/mascot/data/services/egg_hatching_service_test.dart
 - What to test:
   - calculateEggStreakUpdate() - same day (no change), next day
 (increment), gap (reset), first action ever
   - selectHatchingSpecies() - prefers unevolved species, falls back
 to random, handles single species, handles all evolved
 - Approach: Pure unit tests, seed Random for deterministic results
 - Est. test cases: ~15

 1b. MascotMigrationService tests

 - File: lib/features/mascot/data/services/mascot_migration_service.dart
 - Create: test/features/mascot/data/services/mascot_migration_service_test.dart
 - What to test:
   - migrateIfNeeded() - user already migrated (no-op), user with
 old schema (migrates), user missing mascot field, idempotency
 - Approach: fake_cloud_firestore
 - Est. test cases: ~8

 ---
 Phase 2: Datasources (Firestore CRUD - straightforward)

 2a. ActionLibraryRemoteDataSource tests

 - File: lib/features/actions/data/datasources/action_library_remote_datasource.dart
 - Create: test/features/actions/data/datasources/action_library_remote_datasource_test.dart
 - What to test:
   - watchActions() - returns stream of actions, handles empty
   - getAction() - returns action by ID, handles missing ID
 - Approach: fake_cloud_firestore, seed with ActionModel JSON
 - Est. test cases: ~6

 2b. ActionLogRemoteDataSource tests

 - File: lib/features/actions/data/datasources/action_log_remote_datasource.dart
 - Create: test/features/actions/data/datasources/action_log_remote_datasource_test.dart
 - What to test:
   - createActionLog() - writes doc, verify fields
   - watchUserActionLogs() - stream with ordering
   - getRecentActionLogs() - limit param
   - getActionLogCollection() - correct path
 - Approach: fake_cloud_firestore
 - Est. test cases: ~10

 2c. UserRemoteDataSource tests

 - File: lib/features/auth/data/datasources/user_remote_datasource.dart
 - Create: test/features/auth/data/datasources/user_remote_datasource_test.dart
 - What to test:
   - getUser(), createUser(), updateUser(), watchUser()
   - deleteUser() - batch deletion of action logs subcollection
 - Approach: fake_cloud_firestore
 - Est. test cases: ~12

 2d. DailySummaryRemoteDataSource tests

 - File: lib/features/progress/data/datasources/daily_summary_remote_datasource.dart
 - Create: test/features/progress/data/datasources/daily_summary_remote_datasource_test.dart
 - What to test:
   - watchTodaySummary() - stream for today's date
   - getSummary() - by date string
   - getSummariesInRange() - date range query
   - incrementDailySummary() - Firestore transaction, creates new
 vs increments existing
 - Approach: fake_cloud_firestore
 - Est. test cases: ~12

 2e. SettingsRemoteDataSource tests

 - File: lib/features/settings/data/datasources/settings_remote_datasource.dart
 - Create: test/features/settings/data/datasources/settings_remote_datasource_test.dart
 - What to test:
   - CRUD operations, reminder array operations (add/remove/update),
 nested field updates, boundary conditions (max reminders)
 - Approach: fake_cloud_firestore
 - Est. test cases: ~18

 ---
 Phase 3: Repositories

 3a. ActionLibraryRepository tests

 - File: lib/features/actions/data/repositories/action_library_repository.dart
 - Create: test/features/actions/data/repositories/action_library_repository_test.dart
 - What to test: Pure delegation (watchActions, getAction)
 - Approach: mocktail (mock datasource)
 - Est. test cases: ~4

 3b. ActionLogRepository tests (CRITICAL)

 - File: lib/features/actions/data/repositories/action_log_repository.dart
 - Create: test/features/actions/data/repositories/action_log_repository_test.dart
 - What to test:
   - logAction() - the core 200-line transaction:
       - Points calculation and level-up detection
     - Streak update via StreakService
     - Per-SDG stats aggregation
     - Mascot leveling and evolution detection
     - Egg discovery flag and hatching logic
   - watchUserActionLogs(), getRecentActionLogs()
 - Approach: fake_cloud_firestore + mocktail for services
 - Est. test cases: ~25
 - Note: This is the highest-value single test file in the project

 3c. ProgressRepository tests

 - File: lib/features/progress/data/repositories/progress_repository.dart
 - Create: test/features/progress/data/repositories/progress_repository_test.dart
 - What to test:
   - getMonthCalendarData() - date iteration, isToday/isFuture
   - recordAction(), saveDailyGoalTarget()
   - watchTodaySummary()
 - Approach: fake_cloud_firestore or mocktail (mock datasource)
 - Est. test cases: ~12

 3d. AuthRepository tests

 - File: lib/features/auth/data/repositories/auth_repository.dart
 - Create: test/features/auth/data/repositories/auth_repository_test.dart
 - What to test:
   - _getOrCreateUser() sync logic
   - Sign in/up flows coordinating two datasources
   - Account deletion cascade
   - Email verification status sync
 - Approach: mocktail (mock both datasources)
 - Est. test cases: ~20

 ---
 Phase 4: Providers (state management)

 4a. SdgStatsProvider tests (simplest)

 - File: lib/features/sdg/presentation/providers/sdg_stats_provider.dart
 - Create: test/features/sdg/presentation/providers/sdg_stats_provider_test.dart
 - Est. test cases: ~6

 4b. ProgressProviders tests

 - File: lib/features/progress/presentation/providers/progress_providers.dart
 - Create: test/features/progress/presentation/providers/progress_providers_test.dart
 - Est. test cases: ~10

 4c. ActionsProviders tests (filtering/sorting logic)

 - File: lib/features/actions/presentation/providers/actions_providers.dart
 - Create: test/features/actions/presentation/providers/actions_providers_test.dart
 - Est. test cases: ~15

 ---
 Phase 5: CI/CD Pipeline

 GitHub Actions workflow

 - Create: .github/workflows/ci.yml
 - What it does:
   - Trigger on push to main/development and PRs
   - flutter analyze
   - flutter test
   - Coverage report generation
 - Value: Prevents regressions from silently merging

 ---
 Execution Order

 Start with Phase 1 + 2 (services and datasources) as they are the
 foundation. Phase 3 repositories depend on understanding datasource
 behavior. Phase 4 providers depend on repository patterns. Phase 5
 CI/CD can be done anytime.

 Today's target: Phases 1-2 (services + all datasources)

 Verification

 After each test file:
 flutter test test/path/to/new_test.dart

 After all files:
 flutter test
 flutter analyze

 Patterns to Follow

 - Existing repo test patterns:
   - test/features/mascot/data/repositories/mascot_repository_test.dart
 (fake_cloud_firestore pattern)
   - test/features/settings/data/repositories/settings_repository_test.dart
 (mocktail pattern)
 - Test helpers: test/helpers/test_helpers.dart
 - Line length: 88 chars max
 - No emojis, no redundant comments