# Test Coverage

Last reviewed: 2026-06-08

## Summary

- **Test files:** 144
- **Source files (excluding generated, barrels, `main.dart`, `firebase_options.dart`):** ~127
- **Rough file-level coverage:** ~86% (was ~80%; 17 checklist gaps closed and
  reconciled into "Currently Covered" on 2026-06-08, plus the mascot screen,
  mascot selection screen, and reactions/points-overlay tests added the same day)
- **CI:** `.github/workflows/ci.yml` runs `flutter analyze` + `flutter test` on push
  to `development`/`main` and PRs to `main`.
- **Integration tests:** none.

Recent pass: Tier 1 repositories (`ActionLogRepository` with ~34 tests),
`AuthRepository`, `AuthRemoteDataSource`, `ProgressRepository`,
`ChallengeSelectionService`. Tier 2 core Riverpod providers (actions, sdg stats,
progress, challenge, eco-dex). Tier 3 models and loaders (egg, evolution stage,
daily summary, sdg stats, challenge templates, asset loaders for mascot species,
SDG goals/targets/resources). Reconciled 2026-06-08: mascot/settings providers,
`app_logger`, several action/auth/eco-dex/mascot/sdg/shared widgets, and
`legal_content` now have tests.

---

## Currently Covered

### Core utilities

- [x] `core/utils/app_logger.dart`
- [x] `core/utils/auth_error_mapper.dart`
- [x] `core/utils/external_link.dart`
- [x] `core/utils/firestore_converters.dart`
- [x] `core/utils/helpers.dart`
- [x] `core/utils/readable_color.dart`
- [x] `core/utils/validators.dart`

### Shared

- [x] `shared/providers/day_change_provider.dart`
- [x] `shared/services/analytics_service.dart`
- [x] `shared/services/notification_service.dart`
- [x] `shared/services/streak_service.dart`
- [x] `shared/widgets/error_display.dart`
- [x] `shared/widgets/level_progress_bar.dart`
- [x] `shared/widgets/stat_card.dart`

### Actions

- [x] `features/actions/data/datasources/action_library_remote_datasource.dart`
- [x] `features/actions/data/datasources/action_log_remote_datasource.dart`
- [x] `features/actions/data/models/action_log_model.dart`
- [x] `features/actions/data/models/action_model.dart`
- [x] `features/actions/data/repositories/action_library_repository.dart`
- [x] `features/actions/data/repositories/action_log_repository.dart`
- [x] `features/actions/domain/constants/action_icons.dart`
- [x] `features/actions/domain/enums/action_category.dart`
- [x] `features/actions/domain/enums/action_sort_option.dart`
- [x] `features/actions/presentation/providers/actions_providers.dart`
      (state notifiers, filter, sort logic)
- [x] `features/actions/presentation/screens/action_log_screen.dart`
- [x] `features/actions/presentation/widgets/action_card.dart`
- [x] `features/actions/presentation/widgets/action_category_tabs.dart`
- [x] `features/actions/presentation/widgets/action_log_item.dart`
- [x] `features/actions/presentation/widgets/action_sort_dropdown.dart`
- [x] `features/actions/presentation/widgets/learn_only_info_dialog.dart`
- [x] `features/actions/presentation/widgets/points_animation_overlay.dart`
- [x] `features/actions/presentation/widgets/sdg_filter_chips.dart`

### Auth

- [x] `features/auth/data/datasources/auth_remote_datasource.dart`
- [x] `features/auth/data/datasources/user_remote_datasource.dart`
- [x] `features/auth/data/models/app_user_model.dart`
- [x] `features/auth/data/repositories/auth_repository.dart`
- [x] `features/auth/presentation/screens/email_verification_screen.dart`
- [x] `features/auth/presentation/screens/login_screen.dart`
- [x] `features/auth/presentation/screens/register_screen.dart`
- [x] `features/auth/presentation/widgets/auth_text_field.dart`
- [x] `features/auth/presentation/widgets/social_sign_in_button.dart`

### Challenge

- [x] `features/challenge/data/challenge_templates_data.dart` (loader)
- [x] `features/challenge/domain/models/active_multi_day_challenge.dart`
- [x] `features/challenge/domain/models/challenge_templates.dart`
- [x] `features/challenge/domain/services/challenge_selection_service.dart`
- [x] `features/challenge/presentation/providers/challenge_providers.dart`
      (derived state + dialog/streak providers)
- [x] `features/challenge/presentation/screens/challenges_screen.dart`
- [x] `features/challenge/presentation/widgets/daily_challenge_card.dart`
- [x] `features/challenge/presentation/widgets/multi_day_challenge_card.dart`

### Eco-Dex

- [x] `features/eco_dex/data/eco_dex_entries_data.dart`
- [x] `features/eco_dex/data/models/eco_dex_category_model.dart`
- [x] `features/eco_dex/data/models/eco_dex_condition_model.dart`
- [x] `features/eco_dex/data/models/eco_dex_entry_model.dart`
- [x] `features/eco_dex/domain/services/condition_evaluator.dart`
- [x] `features/eco_dex/presentation/providers/eco_dex_providers.dart`
      (discovered list, count, de-dup)
- [x] `features/eco_dex/presentation/widgets/eco_dex_entry_card.dart`
- [x] `features/eco_dex/presentation/widgets/eco_dex_entry_image.dart`
- [x] `features/eco_dex/presentation/widgets/eco_dex_locked_sheet.dart`
- [x] `features/eco_dex/presentation/widgets/eco_dex_progress_header.dart`

### Eco-Fact

- [x] `features/eco_fact/data/eco_facts_data.dart`
- [x] `features/eco_fact/data/models/eco_fact_model.dart`
- [x] `features/eco_fact/presentation/providers/eco_fact_providers.dart`
- [x] `features/eco_fact/presentation/providers/eco_fact_gating` (gating logic)
- [x] `features/eco_fact/presentation/screens/eco_fact_screen.dart`
- [x] `features/eco_fact/presentation/widgets/eco_fact_card.dart`
- [x] `features/eco_fact/presentation/widgets/mail_icon_button.dart`
- [x] `features/eco_fact/presentation/widgets/mail_list_tile.dart`

### Mascot

- [x] `features/mascot/data/mascot_species_loader.dart`
- [x] `features/mascot/data/models/egg_model.dart`
- [x] `features/mascot/data/models/evolution_stage_model.dart`
- [x] `features/mascot/data/models/mascot_model.dart`
- [x] `features/mascot/data/models/mascot_species_model.dart`
- [x] `features/mascot/data/repositories/mascot_repository.dart`
- [x] `features/mascot/data/services/egg_hatching_service.dart`
- [x] `features/mascot/data/services/mascot_migration_service.dart`
- [x] `features/mascot/presentation/providers/mascot_providers.dart`
- [x] `features/mascot/presentation/screens/mascot_screen.dart`
- [x] `features/mascot/presentation/screens/mascot_selection_screen.dart`
- [x] `features/mascot/presentation/widgets/egg_progress_widget.dart`
- [x] `features/mascot/presentation/widgets/mascot_display.dart`

### Profile

- [x] `features/profile/presentation/providers/profile_providers.dart`

### Progress

- [x] `features/progress/data/datasources/daily_summary_remote_datasource.dart`
- [x] `features/progress/data/models/daily_summary_model.dart`
- [x] `features/progress/data/repositories/progress_repository.dart`
- [x] `features/progress/domain/entities/calendar_day_data.dart`
- [x] `features/progress/presentation/providers/progress_providers.dart`
      (SelectedMonth notifier, goal target selectors)
- [x] `features/progress/presentation/screens/progress_screen.dart`
- [x] `features/progress/presentation/widgets/calendar_day_cell.dart`
- [x] `features/progress/presentation/widgets/daily_target_picker.dart`
- [x] `features/progress/presentation/widgets/day_detail_bottom_sheet.dart`
- [x] `features/progress/presentation/widgets/progress_calendar.dart`
- [x] `features/progress/presentation/widgets/rainbow_sun_painter.dart`
- [x] `features/progress/presentation/widgets/rainbow_sun_widget.dart`

### SDG

- [x] `features/sdg/data/sdg_data.dart`
- [x] `features/sdg/data/sdg_goals_loader.dart`
- [x] `features/sdg/data/sdg_resources.dart`
- [x] `features/sdg/data/sdg_resources_data.dart` (loader)
- [x] `features/sdg/data/sdg_targets.dart`
- [x] `features/sdg/data/sdg_targets_loader.dart`
- [x] `features/sdg/domain/models/sdg_stats.dart`
- [x] `features/sdg/presentation/providers/sdg_stats_provider.dart`
      (and `sdg_related_actions`)
- [x] `features/sdg/presentation/screens/home_screen.dart`
- [x] `features/sdg/presentation/screens/sdg_detail_screen.dart`
- [x] `features/sdg/presentation/widgets/sdg_carousel.dart`
- [x] `features/sdg/presentation/widgets/sdg_impact_card.dart`
- [x] `features/sdg/presentation/widgets/sdg_resources_list.dart`
- [x] `features/sdg/presentation/widgets/sdg_targets_section.dart`

### Settings

- [x] `features/settings/data/datasources/settings_remote_datasource.dart`
- [x] `features/settings/data/legal_content.dart`
- [x] `features/settings/data/models/notification_schedule_model.dart`
- [x] `features/settings/data/models/user_settings_model.dart`
- [x] `features/settings/data/repositories/settings_repository.dart`
- [x] `features/settings/presentation/providers/settings_providers.dart`
- [x] `features/settings/presentation/screens/about_screen.dart`
- [x] `features/settings/presentation/screens/account_settings_screen.dart`
- [x] `features/settings/presentation/screens/language_settings_screen.dart`
- [x] `features/settings/presentation/screens/notification_settings_screen.dart`
- [x] `features/settings/presentation/screens/settings_screen.dart`
- [x] `features/settings/presentation/widgets/reminder_list_tile.dart`
- [x] `features/settings/presentation/widgets/settings_section.dart`
- [x] `features/settings/presentation/widgets/settings_tile.dart`
- [x] `features/settings/presentation/widgets/streak_milestone_dialog.dart`

---

## Future Coverage Checklist

Ordered by priority. The biggest remaining gaps are `FcmService`, the
`AuthNotifier` / remaining Riverpod notifiers, and the UI layer
(screens/celebration widgets not yet exercised, and any integration tests).

### Tier 1 — Remaining critical services

- [ ] `shared/services/fcm_service.dart`
      — uses `FirebaseMessaging.instance`, `FirebaseAuth.instance`,
      `FirebaseFirestore.instance` as statics. Needs DI refactor before it
      can be mocked meaningfully.

### Tier 2 — Remaining Riverpod providers

- [ ] `features/auth/presentation/providers/auth_providers.dart`
      — `AuthNotifier` sign-in/sign-out flows. Needs mocked
      `authRepositoryProvider` + analytics override.
- [ ] `shared/providers/analytics_provider.dart`
- [ ] `shared/providers/notification_providers.dart`
- [ ] `shared/providers/package_info_provider.dart`

### Tier 3 — Remaining minor constants/data

- [ ] `features/eco_dex/domain/constants/zero_co2_action_ids.dart`
      (set membership invariants; low value)
- [ ] `features/eco_dex/domain/models/eco_dex_entry_state.dart`
      (trivial data holder; low value)

### Tier 4 — Screens

- [ ] `features/actions/presentation/screens/action_history_screen.dart`
- [ ] `features/profile/presentation/screens/profile_screen.dart`
- [ ] `features/eco_dex/presentation/screens/eco_dex_screen.dart`
- [ ] `features/eco_fact/presentation/screens/eco_fact_detail_screen.dart`
- [ ] `features/settings/presentation/screens/legal_document_screen.dart`
- [ ] `features/settings/presentation/screens/privacy_policy_screen.dart`
- [ ] `features/settings/presentation/screens/terms_of_service_screen.dart`

### Tier 5 — Widgets

Actions:
- [ ] `action_log_confirmation_dialog.dart`
- [ ] `action_science_bottom_sheet.dart`

Eco-Dex:
- [ ] `eco_dex_category_section.dart`
- [ ] `eco_dex_entry_sheet.dart`

Mascot:
- [ ] `egg_discovery_celebration.dart`
- [ ] `egg_hatching_celebration.dart`
- [ ] `evolution_celebration.dart`

SDG:
- [ ] `sdg_actions_grid.dart`
- [ ] `sdg_infographic_viewer.dart`

### Tier 6 — App wiring and integration

- [ ] `app/router.dart` — guard behavior.
- [ ] `app/main_shell.dart` — bottom-nav routing.
- [ ] `app/app.dart` — theme/locale wiring.
- [ ] Integration test: log-an-action flow end-to-end.
- [ ] Integration test: sign-up → email verification → mascot selection.
- [ ] Integration test: calendar month view reflects logged actions.

### Tier 7 — Presentation utils

- [ ] `features/actions/presentation/utils/handle_action_tap.dart`

---

## Patterns to Follow

- **Firestore tests:** `fake_cloud_firestore` — see
  `test/features/mascot/data/repositories/mascot_repository_test.dart` or
  `test/features/actions/data/repositories/action_log_repository_test.dart`
  for the transaction-heavy case.
- **Mocked collaborators:** `mocktail` — see
  `test/features/settings/data/repositories/settings_repository_test.dart`
  or `test/features/auth/data/repositories/auth_repository_test.dart`.
- **Riverpod provider tests:** build a `ProviderContainer` with overrides.
  See `test/features/actions/presentation/providers/actions_providers_test.dart`
  for the filter-and-sort pattern.
- **Asset-loader tests:** call `TestWidgetsFlutterBinding.ensureInitialized()`
  and assert on the real bundled JSON (see
  `test/features/sdg/data/sdg_goals_loader_test.dart`).
- **Mocktail gotchas:**
  - Never call a helper that uses `when()` inside another `when(...).thenReturn(...)`
    — that triggers "Cannot call when within a stub response". Build the mock
    subject first.
  - `fake_cloud_firestore` does not honour `update(field, <empty map>)` cleanly
    — assert on a distinguishable side-effect instead.
- **Style:** 88-char line limit, no emojis, only *why* comments.

## Verification

```bash
flutter test test/path/to/new_test.dart   # single file
flutter test                              # full suite
flutter analyze
```
