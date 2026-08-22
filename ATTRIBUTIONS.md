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

### SDG indicator data in the progress charts

- **What:** the World-aggregate values plotted on the 17 per-goal progress
  charts.
- **Where:** `assets/images/sdg_progress/sdg_progress_NN.png`. The artwork is
  original to this project; only the underlying values come from the UN.
- **Source:** UN SDG Global Database, pulled 2026-08-22 from
  `https://unstats.un.org/SDGAPI/v1/sdg/Series/Data` at `areaCode=1` (World).
- **Terms:** UNdata terms permit redistribution with citation. Each chart
  names its custodian agency and reference year on its face, so the citation
  travels with the image rather than living only here.
- **Custodian agencies**, one per chart, as printed on each card: World Bank;
  FAO; UN IGME; UNESCO Institute for Statistics and GEM Report;
  Inter-Parliamentary Union; WHO/UNICEF Joint Monitoring Programme;
  UN DESA Statistics Division; ITU; UNHCR with UN World Population Prospects;
  UN-Habitat; UNEP WESR / Global Material Flows Database; BirdLife
  International, IUCN and UNEP-WCMC; FAO Global Forest Resources Assessment;
  UNODC.

Two charts are not sourced from the SDG database and say so on their face:

- **Goal 13** uses atmospheric CO2 concentration from the
  [NOAA Global Monitoring Laboratory](https://gml.noaa.gov/ccgg/trends/)
  (global annual mean). Atmospheric concentration is not an SDG indicator and
  no Goal 13 series has a World aggregate, so the card header reads
  `NOT AN SDG SERIES`. NOAA data is in the public domain.
- **Goal 17** uses OECD DAC ODA as a percentage of donor GNI on the
  grant-equivalent basis, because `DC_ODA_TOTG` is published per donor with no
  DAC aggregate in the SDG database. Source: OECD,
  `https://sdmx.oecd.org` (dataflow `DSD_DAC1@DF_DAC1`) and OECD published
  statistics for 2023 and 2024.

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

## Resolved: SDG Report 2022 infographics

Previous versions of this project bundled 17 pages of *The Sustainable
Development Goals Report 2022* as `assets/images/sdg_infographics/`. That was
redistribution of a UN publication, which the
[UN Terms of Use](https://www.un.org/en/about-us/terms-of-use) do not permit:
they grant personal, non-commercial download but withhold any right "to resell
or redistribute them or to compile or create derivative works therefrom".

Those files were removed on 2026-08-22 and replaced with original progress
charts built from openly licensed indicator data, documented above. This was
option 2 of the four recorded here previously, and it clears the exposure
entirely rather than deferring it. No UN publication content is redistributed
by this project any more.
