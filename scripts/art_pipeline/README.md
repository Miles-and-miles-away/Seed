# Art Pipeline

Generate, validate, review, and optimize SVG assets for Seed using
AI generation (Recraft API) and automated quality checks.

## Setup (once per shell)

```bash
conda activate seed
export RECRAFT_API_TOKEN=...   # or add to ~/.zshrc
```

All commands below assume the token is already in the environment.

## Quick Start

The orchestrator is `generate_assets.py`. It takes a JSON filename
(auto-resolved against `data/app/`) and walks you through the full
generate -> validate -> review -> select -> optimize flow.

```bash
cd scripts/art_pipeline

# Generate one category at a time (recommended)
python generate_assets.py eco_dex_entries.json --subcategory food
python generate_assets.py eco_dex_entries.json --subcategory energy
python generate_assets.py eco_dex_entries.json --subcategory bio

# Generate specific IDs
python generate_assets.py eco_dex_entries.json --ids food_01 food_02

# Generate everything in the JSON (rarely what you want -- 102 entries)
python generate_assets.py eco_dex_entries.json
```

`--subcategory` matches against the entry ID prefix. Available
prefixes in `eco_dex_entries.json`: `bio`, `circular`, `climate`,
`energy`, `food`, `gem`, `journey`, `oceans`, `people`, `selfless`.

The interactive pipeline will:
1. Show the entries to generate and the unit cost
2. Ask before calling the API
3. Run validation on all candidates
4. Render review contact sheets and open them in Finder
5. Let you pick the best candidate per entry
6. Optimize and export selections to `assets/eco_dex/`
7. Offer to clean up temporary files

## Overview

```
              data/app/eco_dex_entries.json
                       |
                       v
  +-------------------------------------------+
  |  Step 1: GENERATE                         |
  |  generate.py                              |
  |                                           |
  |  Calls Recraft V4 Text-to-Vector API.     |
  |  N candidates per entry as SVG.           |
  |  Prompt = artPrompt + category + style    |
  +-------------------------------------------+
                       |
              candidates/<entry_id>/
              candidate_1.svg
              candidate_2.svg
              candidate_3.svg
                       |
                       v
  +-------------------------------------------+
  |  Step 2: VALIDATE                         |
  |  validate.py                              |
  |                                           |
  |  - Valid XML, no embedded rasters         |
  |  - Color palette adherence (CIELAB)       |
  |  - File size limits                       |
  |  - CLIP similarity (optional)             |
  +-------------------------------------------+
                       |
                       v
  +-------------------------------------------+
  |  Step 3: REVIEW                           |
  |  review.py                                |
  |                                           |
  |  Contact sheet PNG per entry for          |
  |  side-by-side visual comparison.          |
  +-------------------------------------------+
                       |
              review_sheets/<entry_id>_review.png
                       |
                       v
  +-------------------------------------------+
  |  Step 4: SELECT (interactive)             |
  |                                           |
  |  Pick best candidate per entry.           |
  |  Saves choices to selections_<ts>.yaml.   |
  +-------------------------------------------+
                       |
                       v
  +-------------------------------------------+
  |  Step 5: OPTIMIZE + EXPORT                |
  |  optimize.py                              |
  |                                           |
  |  SVGO -> verify render -> copy to         |
  |  assets/<category>/<id>.svg               |
  +-------------------------------------------+
```

## Running Steps Individually

Each step can be invoked standalone:

```bash
# Generate only
python generate.py --json ../../data/app/eco_dex_entries.json \
  --ids food_01 food_02

# Test a single prompt (no JSON)
python generate.py --prompt "simple flat vector oak tree" \
  --output test_oak.svg

# Validate candidates
python validate.py --candidates-dir candidates/ --all
python validate.py --svg path/to/file.svg

# Render review contact sheets
python review.py --candidates-dir candidates/

# Optimize from a selections file
python optimize.py --selections selections_20260428_120000.yaml
```

## Resuming a Previous Run

If candidates already exist from an earlier session:

```bash
python generate_assets.py eco_dex_entries.json --skip-generate
```

## Configuration

All settings live in `config.yaml`:

- **recraft** -- API URL, candidates per asset, output format
- **style.suffix** -- Style description appended to every prompt
- **style.apply_category_context** -- When false (default), the
  per-category phrase is NOT appended; the artPrompt + suffix carry
  the image alone. Colors are unaffected. Re-enable for terser asset
  types (mascots, garden) whose prompts benefit from the nudge.
- **style.categories** -- Per-category prompt context (applied only
  when `apply_category_context` is true)
- **category_colors** -- RGB palette sent to Recraft `controls.colors`
- **palette** -- App colors from `app_colors.dart` for validation
- **validation** -- Thresholds for pass/fail checks
- **output** -- Directory paths for candidates, reviews, exports
- **file_category_map** -- Maps JSON filename -> output category

## Entry Definitions

Entries live in `data/app/eco_dex_entries.json`. Each has:

```json
{
  "id": "food_01",
  "category": "food_systems",
  "nameEn": "Food's Carbon Footprint",
  "factEn": "...",
  "iconName": "restaurant",
  "artPrompt": "colorful plate of food with a grey cloud rising above it",
  "condition": { ... }
}
```

The pipeline only reads `id`, `category`, and `artPrompt` (never the
`fact*` fields -- those are for the app). The final prompt is built as:
`{artPrompt}, {style.suffix}`, with the per-category phrase inserted
between them only when `style.apply_category_context` is true.
`category` is always used for the `controls.colors` palette, and `id`
names the output files (`candidates/{id}/`, `assets/.../{id}.svg`).

## Validation Checks

| Check | What it does | Threshold |
|-------|-------------|-----------|
| Structure | Valid SVG XML, no embedded rasters, has viewBox | Pass/fail |
| File size | Raw size before optimization | < 100KB |
| Color palette | CIELAB distance from app palette | < 5 off-palette |
| CLIP similarity | Embedding vs reference images | > 0.75 (optional) |

### CLIP Validation (Optional)

For style consistency, provide reference images:

```bash
pip install open_clip_torch torch

python validate.py --candidates-dir candidates/ --all \
  --references ../../assets/eco_dex/climate_01.svg \
               ../../assets/eco_dex/oceans_04.svg
```

## Cost (Recraft Basic plan: 5000 units/month)

`recraftv4_vector` costs 80 units per SVG. Default 3 candidates
per entry = 240 units per entry.

| Batch | Entries | Units | % of monthly budget |
|-------|---------|-------|---------------------|
| Test (2 entries) | 2 | 480 | 10% |
| One category (~11) | 11 | 2,640 | 53% |
| Eco-Dex remaining (80) | 80 | 19,200 | ~4 months |
| Full Eco-Dex (102) | 102 | 24,480 | ~5 months |

Check current balance:

```bash
curl -s -H "Authorization: Bearer $RECRAFT_API_TOKEN" \
  https://external.api.recraft.ai/v1/users/me | python3 -m json.tool
```

## File Structure

```
scripts/art_pipeline/
  README.md                  # This file
  config.yaml                # Pipeline configuration
  generate_assets.py         # Interactive orchestrator
  generate.py                # Step 1: Recraft API generation
  validate.py                # Step 2: Quality validation
  review.py                  # Step 3: Contact sheet rendering
  optimize.py                # Step 5: SVGO + export
  requirements.txt           # Python dependencies
  candidates/                # (generated) Raw SVG candidates
  review_sheets/             # (generated) Contact sheet PNGs
  selections_<ts>.yaml       # (generated) Human selections
```

## Dependencies

Installed in `conda seed` env:
- `pillow`, `cairosvg`, `lxml`, `pyyaml`, `requests`

Available via npm (used by optimize.py):
- `svgo` (run as `npx svgo`)

Optional (for CLIP validation):
- `open_clip_torch`, `torch`
