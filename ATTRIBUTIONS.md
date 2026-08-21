# Attributions and third-party content

Seed bundles and references material owned by third parties. The project
[LICENSE](./LICENSE) covers only original code and original assets; it grants
no rights in anything listed here. Each item below records what it is, where
it came from, and the terms it is used under.

Last verified: 2026-08-21.

---

## United Nations

### SDG icons (referenced, not redistributed)

- **What:** the 17 official SDG icons, shown in the SDG carousel and detail
  screens.
- **Source:** `https://sdgs.un.org/sites/default/files/goals/E_SDG_Icons-NN.jpg`,
  referenced by `iconUrl` in `data/app/sdg_goals.json`.
- **How used:** loaded over the network at runtime. No icon file is stored in
  this repository or bundled into the app.
- **Terms:** [Guidelines for the use of the SDG logo, including the colour
  wheel, and 17 icons](https://unsdg.un.org/resources/guidelines-use-sdg-logo-including-colour-wheel-and-17-icons)
  (UN Department of Global Communications, September 2023).

  Seed's use is informational: illustrative and not intended to raise funds.
  Per section II of the guidelines, such use "does not require prior
  permission from the United Nations nor the conclusion of a licensing
  agreement."

  Obligations Seed meets:

  - each icon is displayed in its entirety, including number, title, and
    graphic element;
  - no element of the SDG logo or icons is integrated into Seed's own logo or
    mascot design, which the guidelines prohibit;
  - the disclaimer below is reproduced.

  Permitted until 31 December 2030 unless the UN advises otherwise.

  **If Seed ever monetises** (see `Plan/PLAN_PHASE_9.md`), icon use becomes
  commercial. Section II then requires prior UN permission and a licensing
  agreement, requested through the UN's online Permission Request Form. This
  is a request to file, not a bar. Revisit this entry at that point.

### SDG goal titles, descriptions, and targets

- **What:** official goal titles and descriptions, and all 169 targets.
- **Where:** `data/app/sdg_goals.json`, `data/app/sdg_targets.json`,
  `data/app/sdg_resources.json`.
- **Source:** United Nations, `https://sdgs.un.org/goals`.
- **Note:** Spanish is a UN official language; Japanese is not. Per section VI
  of the guidelines, the UN "will not assume any responsibility or liability
  arising from the translation of the text of the SDG icons into non-UN
  official languages." Japanese strings here are unofficial translations.

### SDG indicator metadata

- **What:** indicator metadata for all 17 goals.
- **Where:** `data/reference/sdg_indicator_metadata/sdg_goal_NN.json`.
- **Source:** UN Statistics Division, `https://unstats.un.org/sdgs/metadata/`.
- **How used:** reference data for research and validation. Not shipped in the
  app bundle.

### UN International Days

- **What:** observance names and dates.
- **Where:** `data/reference/un_world_days.json`.
- **Source:** United Nations, `https://www.un.org/en/observances`.

### SDG Report 2022 infographics

- **What:** 17 per-goal infographic pages.
- **Where:** `assets/images/sdg_infographics/sdg_infographic_NN.jpg`.
- **Source:** *The Sustainable Development Goals Report 2022*, UN Department
  of Economic and Social Affairs / UN Statistics Division.
  `https://unstats.un.org/sdgs/report/2022/`
- **Status: unresolved. See "Open item" below.** These are pages of a UN
  publication, not part of the SDG icon set, so the icon guidelines above do
  not apply to them.

### Required UN disclaimer

Reproduced per section VI of the SDG logo and icon guidelines:

> The use of the SDG Logo, including the colour wheel, and icons by an entity
> does not imply the endorsement of the United Nations of such entity, its
> products or services, or of its planned activities.

The content of this application has not been approved by the United Nations
and does not reflect the views of the United Nations, its officials, or its
Member States.

---

## Natural Earth

- **What:** 1:50m land polygons, plus a derived raster.
- **Where:** `data/reference/natural_earth/`.
- **Source:** `https://naciscdn.org/naturalearth/50m/physical/ne_50m_land.zip`,
  dataset `ne_50m_land` version 4.1.0.
- **Terms:** public domain. No permission or attribution required; credited
  here as a courtesy. See `data/reference/natural_earth/README.md`.
- **How used:** by `scripts/generators/build_water_blocklist.py`. Not shipped
  in the app bundle.

---

## Eco facts and CO2 action data

Every entry in `data/app/eco_facts.json` carries its own `sourceEn`,
`sourceEs`, `sourceJa`, and `sourceUrl` fields, so provenance travels with
the data rather than being duplicated here. The same applies to the CO2
factors in `data/seed/co2_actions_database.json`. Sourcing criteria are
defined in `Plan/AUDIT_FACT_DATA.md` and `Plan/AUDIT_ACTION_DATA.md`.

Publication and source names are recorded in their original language and are
never translated.

---

## Open item: SDG Report 2022 infographics

The 17 files in `assets/images/sdg_infographics/` are bundled into the app and
committed to this repository. That is redistribution of a UN publication.

The [UN Terms of Use](https://www.un.org/en/about-us/terms-of-use) grant
permission to "download and copy the information, documents and materials
... for the User's personal, non-commercial use", while withholding any right
"to resell or redistribute them or to compile or create derivative works
therefrom." The [UN copyright notice](https://www.un.org/en/about-us/copyright)
adds that materials may not be reproduced "without permission in writing from
the publisher."

Attribution does not substitute for permission. Options, in increasing cost:

1. **Remove the bundled files and link out** to the official infographics PDF
   per goal. Removes the exposure entirely, drops about 2.2 MB from the app,
   and the linked version stays current as the UN republishes.
2. **Build original progress visuals** from openly licensed indicator data,
   drawing on the UN indicator metadata already held in
   `data/reference/sdg_indicator_metadata/`. Removes the exposure and
   replaces static 2022 pages with themed, trilingual, interactive charts.
   Note that UNdata's terms permit redistribution with citation, in direct
   contrast to the report-PDF terms above.
3. **Request written permission** from UN Publications rights and permissions.
   Slow and uncertain, to license something replaceable in an afternoon.
4. **Keep them and accept the risk.** Not advisable for a public repository or
   a store release.

Option 1 clears the problem immediately; option 2 is the better end state.
Doing 1 now does not preclude 2 later. Until it is resolved, treat these 17
files as the one piece of content in this project without a clear right to
redistribute.
