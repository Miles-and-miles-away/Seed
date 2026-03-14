# Data Check Guide

Reference for verifying, adding, or modifying data files
in `assets/data/`. Covers the structure, quality standards,
and verification checklist for each data file so all facts
and targets remain accurate, well-sourced, and consistent.

---

## 1. File Inventory

| File | Purpose | Records |
|------|---------|---------|
| `eco_facts.json` | Daily eco-facts shown to users (one per day of year) | 365 |
| `sdg_targets.json` | Official UN SDG targets for all 17 goals | 169 |

---

## 2. eco_facts.json

### Schema

```json
{
  "dayOfYear": 1,
  "category": "comparison",
  "factEn": "English fact text",
  "sourceEn": "Source name / organization",
  "sourceUrl": "https://...",
  "relatedSdgs": [2, 12, 13],
  "unWorldDay": "Veganuary"
}
```

### Field Rules

| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| `dayOfYear` | int | yes | 1-365, unique, no gaps |
| `category` | string | yes | One of 5 categories (see below) |
| `factEn` | string | yes | 1-2 sentences, clear and concise |
| `sourceEn` | string | yes | Organization or study name |
| `sourceUrl` | string | yes | Valid URL to the source |
| `relatedSdgs` | int[] | yes | 1-4 SDG numbers (1-17) |
| `unWorldDay` | string/null | yes | UN observance name or null |

### Categories (5)

| Category | Count | Purpose |
|----------|-------|---------|
| `comparison` | ~73 | CO2 or resource comparisons that put impact in perspective |
| `positiveNews` | ~73 | Encouraging developments in sustainability |
| `mythBuster` | ~74 | Corrects common misconceptions |
| `individual` | ~74 | Actionable tips users can apply personally |
| `natureWonder` | ~71 | Fascinating facts about ecosystems and biodiversity |

Categories should be roughly evenly distributed across
the year (~73 each). Avoid long runs of the same category
on consecutive days.

### Fact Quality Standards

#### Be accurate, not sensational

Every claim must be defensible from the cited source.
Do not round numbers in ways that exaggerate impact.
Users who fact-check and find errors lose trust
permanently.

#### Be specific with numbers

Bad: "Cars produce a lot of CO2."
Good: "The average petrol car emits 4.6 metric tons
of CO2 per year."

Always include units (kg, tons, %, kWh) and timeframes
(per year, per day, since 2020).

#### Be current

Facts referencing statistics should use the most recent
available data. If a fact cites a year (e.g., "in 2023"),
verify the claim still holds. Replace outdated facts
rather than leaving stale data.

#### Be source-verifiable

The `sourceUrl` must point to a page where the reader
can find the specific claim. Do not link to a homepage
when the data is in a specific report or article.

#### Tone

- Informative, not preachy
- Empowering, not guilt-inducing
- Balanced -- acknowledge complexity where it exists
- No exclamation marks or clickbait phrasing

---

## 3. sdg_targets.json

### Schema

```json
{
  "1": [
    {
      "code": "1.1",
      "description": "English target text",
      "descriptionJa": "Japanese target text",
      "descriptionEs": "Spanish target text"
    }
  ]
}
```

### Field Rules

| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| top-level keys | string | yes | "1" through "17" |
| `code` | string | yes | SDG number + target letter/number (e.g., "1.1", "1.a") |
| `description` | string | yes | Official UN target text in English |
| `descriptionJa` | string | yes | Japanese translation |
| `descriptionEs` | string | yes | Spanish translation |

### SDG Target Standards

#### Use official UN text

Target descriptions must match the official UN
Sustainable Development Goals documentation. Do not
paraphrase or summarize. The canonical source is:
https://sdgs.un.org/goals

#### All three languages required

Every target must have EN, JA, and ES translations.
Translations should match the official UN translations
where available, not be machine-translated.

#### Complete coverage

All 17 SDGs must be present with all their official
targets (numbered and lettered). Current expected counts:

| SDG | Targets | SDG | Targets | SDG | Targets |
|-----|---------|-----|---------|-----|---------|
| 1 | 7 | 7 | 5 | 13 | 5 |
| 2 | 8 | 8 | 12 | 14 | 10 |
| 3 | 13 | 9 | 8 | 15 | 12 |
| 4 | 10 | 10 | 10 | 16 | 12 |
| 5 | 9 | 11 | 10 | 17 | 19 |
| 6 | 8 | 12 | 11 | | |

Total: 169 targets across 17 goals.

---

## 4. Verification Checklist: eco_facts.json

### Structural checks

- [ ] Exactly 365 entries
- [ ] `dayOfYear` values are 1-365 with no duplicates
      or gaps
- [ ] Every entry has all 7 required fields
- [ ] `category` is one of the 5 valid values
- [ ] `relatedSdgs` contains only integers 1-17
- [ ] `relatedSdgs` has 1-4 entries per fact
- [ ] `unWorldDay` is either a non-empty string or null
- [ ] Valid JSON (no trailing commas, proper encoding)

### Content checks

- [ ] Each fact is a complete, grammatically correct
      sentence
- [ ] Numbers include units and timeframes
- [ ] No duplicate or near-duplicate facts
- [ ] No outdated statistics (check year references)
- [ ] Tone is informative and empowering, not preachy
- [ ] No exclamation marks or clickbait language
- [ ] Categories are roughly evenly distributed
- [ ] No more than 3 consecutive days of the same
      category

### Source checks

- [ ] `sourceEn` names a real, credible organization
      or study
- [ ] `sourceUrl` is a valid, accessible URL
- [ ] The URL leads to a page containing the specific
      claim (not just a homepage)
- [ ] The source is tier-1 (peer-reviewed journal,
      government agency, UN body, or major NGO)
- [ ] The claim in `factEn` is supported by the source

### SDG mapping checks

- [ ] Each fact maps to at least one relevant SDG
- [ ] SDG assignments are accurate (the fact genuinely
      relates to that goal's focus area)
- [ ] All 17 SDGs are represented across the 365 facts

### UN World Day checks

- [ ] World days are assigned to the correct `dayOfYear`
- [ ] The fact content is thematically related to the
      world day
- [ ] Official UN observance names are used (not
      informal names)

---

## 5. Verification Checklist: sdg_targets.json

### Structural checks

- [ ] All 17 SDGs present (keys "1" through "17")
- [ ] Target counts match official UN counts per goal
- [ ] Every target has all 4 required fields
- [ ] Target codes follow the pattern `N.N` or `N.a`
- [ ] Targets are ordered correctly within each SDG
- [ ] Valid JSON

### Content checks

- [ ] English descriptions match official UN target text
- [ ] Japanese translations are accurate and complete
- [ ] Spanish translations are accurate and complete
- [ ] No truncated or incomplete descriptions
- [ ] Special characters and diacritics are preserved
      correctly in all languages

---

## 6. Tier-1 Sources for Fact Verification

These are acceptable sources for eco-facts. New facts
should cite from this list where possible.

- **UN Environment Programme (UNEP)** - Environmental
  reports, biodiversity, pollution
- **IPCC** - Climate science, emissions projections
- **IEA** - Energy data, renewables, grid factors
- **Our World in Data** - Compiled peer-reviewed data
  with visualizations
- **WHO** - Health-environment intersection
- **World Bank** - Development, poverty, economics
- **NASA / NOAA** - Climate data, temperature records,
  ocean science
- **Poore & Nemecek 2018** - Food lifecycle emissions
- **DEFRA** - UK greenhouse gas conversion factors
- **US EPA** - Environmental data, recycling, air quality
- **WWF** - Wildlife, biodiversity, conservation
- **FAO** - Food systems, agriculture, fisheries
- **Nature / Science** - Peer-reviewed research
- **WRAP UK** - Waste, food waste, circular economy
- **European Commission** - EU environmental policy

Avoid: blogs, opinion pieces, industry-funded studies
without independent verification, social media posts,
news articles without primary source links.

---

## 7. Adding a New Eco Fact: Checklist

1. **Find the claim.** Use a tier-1 source. Verify the
   specific number or statistic at the source URL.

2. **Write the fact.** 1-2 sentences. Include specific
   numbers with units. Make it interesting but not
   sensational.

3. **Choose the category.** Pick the best fit from the
   5 categories. Check that the target day does not
   create a long same-category streak.

4. **Assign SDGs.** Map to 1-4 relevant SDGs. SDG 13
   (Climate Action) applies to most climate-related
   facts but do not over-assign it.

5. **Check for UN World Day.** If the `dayOfYear`
   coincides with a UN observance, set `unWorldDay`
   and ensure the fact is thematically relevant.

6. **Check for duplicates.** Search existing facts for
   similar claims, same source, or overlapping topics.

7. **Verify the URL.** Open the `sourceUrl` and confirm
   the page loads and contains the cited claim.

---

## 8. Common Pitfalls

### Stale statistics

Facts citing specific years ("in 2023, renewables
grew by 50%") become outdated. When updating, replace
the entire fact with current data rather than just
changing the year.

### Broken source URLs

URLs rot over time. Periodically verify that all
`sourceUrl` values still resolve. Replace broken links
with archived versions (web.archive.org) or updated
URLs from the same source.

### Over-assigning SDG 13

Climate Action (SDG 13) relates to many facts, but
not all environmental facts are primarily about climate.
A fact about ocean plastic is SDG 14 (Life Below Water)
first, SDG 12 (Responsible Consumption) second, and
only SDG 13 if it explicitly discusses climate impact.

### Machine-translated SDG targets

The `sdg_targets.json` translations should use official
UN translations, not machine translations. The UN
provides official translations in all six UN languages.
Verify against:
- JA: https://www.unic.or.jp/
- ES: https://www.un.org/sustainabledevelopment/es/

### Vague sourcing

"Various sources" or "Studies show" is not acceptable.
Every fact needs a specific, named source with a
working URL.
