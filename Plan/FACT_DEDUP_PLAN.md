# Eco-Fact Deduplication Plan

**Created:** 2026-03-14
**Updated:** 2026-03-15
**Status:** Template
**File:** `data/app/eco_facts.json`

---

## 1. Internal Near-Duplicates in eco_facts.json

<!-- List facts within eco_facts.json that cover the same topic with overlapping claims -->

---

## 2. Overlaps Between eco_facts.json and co2_actions_database.json

<!-- List eco_facts that restate claims from the actions database. Categorize by severity (HIGH/MEDIUM/LOW). Note data inconsistencies to resolve. -->

---

## 3. Category Balance

<!-- Tally current category counts vs target (~73 each for 365 facts). Note which categories need more or fewer entries. -->

---

## 4. UN World Day Alignment Audit

<!-- Cross-reference data/reference/un_world_days.json against eco_facts.json unWorldDay tags. Note missing UN days, name mismatches, spurious tags, and non-UN observances. -->

---

## 5. Overlaps Between eco_facts.json and sdg_targets.json

<!-- Check whether any eco_facts duplicate content from sdg_targets.json. -->

---

## 6. co2_actions_database.csv vs co2_actions_database.json

<!-- Verify the CSV and JSON are in sync and neither contains unique content. -->

---

## 7. Theme and SDG Gap Analysis

<!-- Categorize facts by theme and SDG. Identify overrepresented and underrepresented themes and SDGs. -->

---

## 8. Fix Plan

<!-- Organize fixes into phases from smallest/most mechanical to largest/most research-intensive. -->

### Phase 1: Tag and Name Fixes (no content changes)

### Phase 2: Data Correction (verify before applying)

### Phase 3: Replace Duplicates

### Phase 4: UN World Day Gaps

### Phase 5: Data Inconsistencies (research needed)

---

## 9. URL and Accuracy Audit

<!-- Full audit of all facts. Check URLs, source attribution, and factual accuracy. -->

### 9.1 Broken URLs

### 9.2 Homepage URLs (need specific article links)

### 9.3 Source Attribution Mismatches

### 9.4 Factual Accuracy Issues

#### HIGH priority

#### MEDIUM priority

#### LOW priority

### 9.5 Pre-2015 Sources

<!-- Seminal/landmark publications acceptable from 2015+; all others must be 2020+. -->

### 9.6 Category Mismatches

---

## 10. Implementation Checklist

<!-- Ordered from smallest/most mechanical changes to largest/most research-intensive. Use checkboxes to track progress. -->
