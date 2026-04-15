/// Action IDs in the library whose `co2Grams` is 0 — "selfless" actions
/// that earn points via the zero-CO2 formula for behavioral, ecological,
/// or systemic value rather than direct carbon savings.
///
/// Kept in sync manually with `scripts/seed/seed_action_library.js`.
/// When adding or removing a zero-CO2 action, update this set and any
/// Eco-Dex entry that uses `UniqueZeroCo2ActionsCondition`.
const Set<String> zeroCo2ActionIds = {
  'beach_cleanup',
  'share_sustainability_tip',
  'volunteer_environment',
  'teach_child_eco',
  'pick_up_litter',
  'take_on_household_task',
  'support_community_business',
  'sign_petition',
  'contact_representative',
  'share_eco_content',
  'attend_climate_event',
  'support_green_policy',
  'write_eco_review',
  'attend_eco_meeting',
  'request_green_option',
  'donate_women_climate_org',
  'buy_fair_trade',
  'fund_micro_loan',
  'support_women_owned_business',
  'citizen_science_project',
  'volunteer_nature_walk',
};
